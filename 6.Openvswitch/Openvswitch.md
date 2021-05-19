# Tìm hiểu OpenvSwitch
## 1. SDN - Software define network 
- Software define network hay mạng điều khiển bằng phần mềm được dựa trên cơ chế tách riêng 2 chức năng là quản lí và truyền tải dữ liệu (control plane và data plane).
- SDN dựa trên giao thức Openflow. SDN tách định tuyến và chuyển dữ liệu riêng rẽ.
- SDN có 3 đặc điểm nổi bật chính:
  + Tách biệt data plane và control plane.
  + Các thành phần trong network có thể được quản lí bởi các phần mềm được lập trình riêng biệt.
  + Tập trung vào kiểm soát và quản lí network.

![](https://github.com/khanhnt99/Timhieu_Openstack/raw/master/img/28.png)

### Kiến trúc của SDN
- **Lớp ứng dụng:** là ứng dụng kinh doanh được triển khai trên mạng, được kết nối tới lớp điều khiển thông qua các API, cung cấp khả năng cho phép lớp ứng dụng lập trình lại mạng thông qua lớp điều khiển.
- **Lớp điều khiển:** Là nơi tập trung các bộ điều khiển thực hiện việc điều khiển cấu hình mạng theo các yêu cầu từ lớp ứng dụng và khả năng của mạng. Các bộ điều khiển này có thể là các phần mềm được lập trình.
- **Lớp cơ sở hạ tầng:** là các thiết bị mạng thực tế (có thể là vật lí hoặc ảo hóa) thực hiện việc chuyển tiếp các gói tin theo sự điều khiển của lớp điều khiển.

### Giao thức Openflow 
- **Openflow** là tiêu chuẩn cung cấp khả năng truyền thông giữa các giao diện của lớp điều khiển và lớp infrastructure trong kiến trúc SDN.
- Các quyết định về các luồng traffic sẽ được quyết định tập trung tại Openflow controller.

![](https://camo.githubusercontent.com/14b5b6b91429c5a677d5a6e7808704b402a1165ca77201c358a7a0040efa369c/687474703a2f2f692e696d6775722e636f6d2f7434534f5236332e706e67)

- Một thiết bị Openflow gồm ít nhất 3 thành phần:
  + Secure channel: Kênh kết nối thiết bị tới controller, cho phép các lệnh và gói tin được gửi giữa controller và thiết bị.
  + OpenFlow Protocol: Giao thức cung cấp phương thức tiêu chuẩn.
  + Flow table: Liên kết hành động với luồng, giúp thiết bị xử lí các luồng.

## 2. Openvswitch
- **Openvswitch** là switch ảo mã nguồn mở theo giao thức Openflow.

### Các thành phần và kiến trúc Openvswitch
![](https://camo.githubusercontent.com/f52a116828821afcff6f31dc4b47fb35f83b9a7845eeeb2b27f86e6db759d890/687474703a2f2f692e696d6775722e636f6d2f427665695245592e6a7067)

- ovs-vswitchd: daemon tạo ra switch.
- ovsdb-server: Nơi ovs-vswitchd truy cập để có được cấu hình.
- ovs-dpctl: công cụ để cấu hình switch kernel module.
- ovs-vsctl: truy vấn và cập nhật cấu hình cho ovs-vswitchd.

### Cơ chế hoạt động
- Openvswitch chia làm 2 phần: Openvswitch kernel module (data plane) và user space tools (control plane).
