# Openstack Octavia - architecture and installation
## Octavia components
- Khi thiết kế virtual load balancer, một trong những quyết định quan trọng là quyết định nơi đặt các chức năng cân bằng tải.
- Một lựa chọn rõ ràng là tạo ra các bộ cân bằng tải phần mềm như `HAProxy` hoặc `NGINX` trên một trong các node controllers hoặc node network và định tuyến tất cả các lưu lượng thông qua các node đó.
- Tuy nhiên cách tiếp cận này dẫn đến tải trọng lên các giao diện mạng chỉ ở node controller và node network -> Giải pháp này không mở rộng quy mô tốt khi số lượng bộ `virtual loadbalancer` hoặc `endpoint` tăng lên.
- **Octavia** tạo một cách tiếp cận khác:\
    + Các `load balancer` được thực hiện bởi các máy ảo là các Openstack instances chạy trên các compute nodes. 
    + Openstack instance được sử dụng một image chuyên dụng có chứa bộ cân bằng tải bằng phần mềm `HAProxy` và một `agent` được để kiểm soát cấu hình của HAProxy instance.
    + Những instances này được gọi là `amphorae`, các amphora này được scheduler bởi Nova như bất kì instance nào khác -> Mở rộng quy mô vì có thể xuất hiện trên bất kì compute node nào khác.
- Để điều khiển `amphorae`, Octavia sử dụng một control plane bao gồm: 
    + `Octavia worker` để tạo, cập nhật, xóa bộ cân bằng tải.
    + `Health manager` để giám sát amphorae.
    + `House Keeping` thực hiện dọn dẹp và quản lý pool `amphorae` dự phòng để tối ưu hóa thời gian cần thiết để `spin up` 1 bộ cân bằng tải mới.
    + Ngoài ra như bất kì project Openstack nào, Octavia exposes chức năng của nó thông qua `API server`.

![](https://camo.githubusercontent.com/9911328167bc37523fb0a85f63897279df6161399296109f92073a85772e70b3/68747470733a2f2f696d672d626c6f672e6373646e2e6e65742f323031383037333030393233323634343f77617465726d61726b2f322f746578742f6148523063484d364c7939696247396e4c6d4e7a5a473475626d56304c307074615778722f666f6e742f3561364c354c32542f666f6e7473697a652f3430302f66696c6c2f49304a42516b46434d413d3d2f646973736f6c76652f3730)

- **API serrver** và các control plane giao tiếp với nhau bằng các `RPC call` (tức là rabbitmq). Tuy nhiên các thành phần `control plane` cũng cần giao tiếp với `amphorae`.
    + `Agent` chạy trên mỗi amphorae sẽ hiển thị REST API mà `control plane` cần có để tiếp cận.
    + `Health Manager` sẽ lắng nghe các thông báo về `heath status` do amphorae phát ra -> do đó control plane cũng cần được tiếp cận từ `amphorae`.
- Để thực hiện giao tiếp 2 chiều này, **Octavia** giả định có một virtual network (Neutron) được gọi là `load balancer management network`:
    + **Octavia** sẽ gắn tất cả các `amphorae` vào `load balancer management network`.
    + Thông qua mạng này, các thành phần `control plane` có thể tiếp cận `REST API` do `agent` chạy trên mỗi `amphorae` và ngược lại `agent` có thể tiếp cận `control plane` thông qua mạng này.

![](https://i.ibb.co/vvxWjcB/2021-12-23-10-14.png)


## 2. Octavia installation
### 2.1 Creating and connecting the load balancer management network
- `load balancer network` là một virtual netwrok mà amphore được gắn vào, cho phép truy cập `amphora` từ control plane và cho phép truy cập từ `amphora` đến `healthmanager`.
- Sử dụng mạng VXLAN làm `load balancer management network` và kết nối với nó từ network node bằng cách thêm một thiết bị mạng bổ sung vào `integration bridge` (hiển thị dưới dạng thiết bị mạng ảo).
- Để kết nối `load balancer management network` từ controller cần phải gắn một interal port vào `br-int (integration bridge)`

![](https://i.ibb.co/Bg3z1v6/2021-12-23-10-34.png)

- Các bước tạo `load balancer management network:`
    + Tạo Virtual network và add subnet.
    + Tạo `security group` cho phép traffic truy cập cổng TCP 9443 `(amphora agent expose REST API)`, cho phép truy cập health manager `(UDP, port 5555)`.
    + Tạo port trên `load balancer management network` -> dành ra 1 địa chỉ IP để dành cho port để tránh xung đột IP với neutron.
    + Tạo 1 cổng truy cập OVS bằng cách sử dụng VLAN ID, gán địa chỉ này cho virtual network device và đưa thiết bị này lên.

### 2.2 Certificates, keys and configuration
- Các `control plane` của Octavia sử dụng REST API `(được expose bởi các agent trên mỗi amphora)` để thực hiện các thay đổi cấu hình HAProxy -> Những kết nối này cần được bảo mật -> Octavia sử dụng `SSL certificate` để làm việc này.
- Đầu tiên là `client certificate` -> Control plane sẽ sử dụng `client certificate` tự xác thực khi kết nối tới agent. `client certificate` và `key` cần được tạo trong quá trình cài đặt. 
- Vì `CA certificate` được sử dụng để ký `client certificate` nên `CA certificate` cũng cần có trên mọi amphora (để `agent` xác thực `client certificate`), Octavia cũng cần biết có chứng chỉ này và Octavia sẽ phân phối cho các Octavia mới được tạo.
- Tiếp theo mỗi agent có `server certificate`. Các `server certificate` này là duy nhất trên mỗi agent và được tạo ra tự động trong thời gian chạy bởi trình tạo chứng chỉ trong `control plane` Octavia. Trong thời gian cài đặt, chúng ta chỉ cần cung cấp `CA certificate` và `private key` mà sau đó Octavia sẽ sử dụng để cấp `server certificate`.

![](https://i.ibb.co/8bG6Fbp/2021-12-23-11-20.png)

__Docs__
- https://leftasexercise.com/2020/05/01/openstack-octavia-architecture-and-installation/