# Keepalived
## 1. Tổng quan
- Keepalived là một chương trình dịch vụ trên Linux cung cấp khả năng tạo độ sẵn sàng cao (High Availability) cho hệ thống dịch vụ và khả năng load balancing.
- Keepalive cung cấp các bộ framework cho 2 chức năng chính là: 
  + Load balancing cùng cơ chế health checking sử dụng Linux Virtual Server (IPVS) module kernel trên Linux. 
  + High availability với VRRP (Virtual Redundancy Routing Protocol).

![](https://static.cuongquach.com/resources/images/2018/02/keepalived-1.png)

- Keepalived sẽ gom các nhóm server tham gia cụm HA, tạo một Virtual server đại diện cho một nhóm các server đó với một `virtual IP (VIP)` và một địa MAC vật lý máy chủ đang giữ Virtual IP đó.
- Vào mỗi thời điểm nhất định, chỉ có một server dịch vụ dùng địa chỉ MAC này tương ứng với virtual IP. Khi đó ARP request gửi tới virtual IP thì server dịch vụ đó sẽ trả về địa chỉ MAC này.
- Các máy chủ sử dụng chung virtual IP phải liên lạc với nhau bằng địa chỉ multicast 224.0.0.18 bằng giao thức `VRRP`. 
- Các máy chủ sẽ có độ ưu tiên (priority) trong khoảng từ 1 - 254 và máy chủ nào có độ ưu tiên cao nhất sẽ thành `Master/Active` các máy còn lại sẽ thành các `Slave/Backup` hoạt động tại chế độ chờ.
- Cơ chế `failover` được sử lý bởi giao thức VRRP, khi khởi động dịch vụ, toàn bộ các server cấu hình dùng chung VIP sẽ gia nhập vào nhóm `multicast`. Nhóm multicast này sẽ để gửi và nhận các gói tin quảng bá VRRP. Các server sẽ quảng bá độ ưu tiên (priority), server có độ ưu tiên cao nhất sẽ được làm `Master`. Master sẽ chịu trách nhiệm gửi các gói tin quảng bá VRRP định kì cho nhóm multicast.
- Nếu server `backup` không nhận được các gói tin quảng bá từ Master trong một khoảng thời gian nhất định thì cả nhóm sẽ bầu ra một Master mới. Master mới này sẽ tiếp quản địa chỉ `VIP` của nhóm và gửi các gói tin ARP báo là nó đang giữ VIP này. 

## 2. Các thuật ngữ
- `VIP:` Virtual IP, sử dụng để cho các client truy cập.
- Keepalived sử dụng 4 module kernel chính:
  + `LVS Framework:` dùng để giao tiếp sockets.
  + `Netfilter Framework:` hỗ trợ hoạt động IP Virtual Server (IPVS) NAT và Masquerading.
  + `Netlink Interface:` điều khiển thêm và xáo các VRRP Virtual IP trên card mạng.
  + `Multicast:` VRRP advertisement packet được gủi đên lớp địa chỉ mạng VRRP Multicast (224.0.0.18)
__Docs__
- https://github.com/hungnt1/Openstack_Research/blob/master/High-availability/1.HA-Proxy---KeepAlive/1.Intro.md
- https://cuongquach.com/keepalive-la-gi-tim-hieu-ki-thuat-keepalive-trong-thong-ha.html
- https://cuongquach.com/keepalived-la-gi-tim-hieu-dich-vu-keepalived-high-availability.html