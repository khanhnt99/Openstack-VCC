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

![](https://camo.githubusercontent.com/9911328167bc37523fb0a85f63897279df6161399296109f92073a85772e70b3/68747470733a2f2f696d672d626c6f672e6373646e2e6e65742f323031383037333030393233323634343f77617465726d61726b2f322f746578742f6148523063484d364c7939696247396e4c6d4e7a5a473475626d56304c307074615778722f666f6e742f3561364c354c32542f666f6e7473697a652f3430302f66696c6c2f49304a42516b46434d413d3d2f646973736f6c76652f3730)

- **API serrver** và các control plane giao tiếp với nhau bằng các `RPC call` (tức là rabbitmq). Tuy nhiên các thành phần `control plane` cũng cần giao tiếp với `amphorae`.
    + `Agent` chạy trên mỗi amphorae sẽ hiển thị REST API mà `control plane` cần có để tiếp cận.
    + `Health Manager` sẽ lắng nghe các thông báo về `heath status` do amphorae phát ra -> do đó control plane cũng cần được tiếp cận từ `amphorae`.
- Để thực hiện giao tiếp 2 chiều này, **Octavia** giả định có một virtual network (Neutron) được gọi là `load balancer management network`:
    + **Octavia** sẽ gắn tất cả các `amphorae` vào `load balancer management network`.
    + Thông qua mạng này, các thành phần `control plane` có thể tiếp cận `REST API` do `agent` chạy trên mỗi `amphorae` và ngược lại `agent` có thể tiếp cận `control plane` thông qua mạng này.

![](https://leftasexercise.files.wordpress.com/2020/02/octaviaarchitecture-1.png?w=782)

## 2. Octavia installation
### 2.1 Creating and connecting the load balancer management network
- Sử dụng mạng VXLAN làm `load balancer management network` và kết nối với nó từ network node bằng cách thêm một thiết bị mạng bổ sung vào `integration bridge` (hiển thị dưới dạng thiết bị mạng ảo).
__Docs__
- https://leftasexercise.com/2020/05/01/openstack-octavia-architecture-and-installation/