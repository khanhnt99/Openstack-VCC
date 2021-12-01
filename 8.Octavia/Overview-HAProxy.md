# Tổng quan về cân bằng tải trong HAProxy
## 1.Tổng quan
- Cân bằng tải là việc phân bố đồng đều lưu lượng truy cập giữa hai hay nhiều máy chủ có cùng chức năng trong cùng một hệ thống. Bằng cách đó sẽ giúp cho hệ thống giảm thiểu tối đa tình trạng một máy chủ bị quá tải và ngừng hoạt động. Hoặc một khi server gặp sự cố, cân bằng tải sẽ chỉ đạo phân phối công việc của server đó cho các server còn lại, đẩy thời gian uptime của hệ thống lên cao nhất và cải thiện năng suất hoạt động tổng thể.
- HAProxy là viết tắt của High Availability Proxy, là công cụ mã nguồn mở cho giải pháp cân bằng tải TCP/HTTP cũng như giải pháp Proxy Server.
- Proxy là một internet server làm nhiệm vụ chuyển tiếp, kiểm soát thông tin giữa client và server. Tất cả các yêu cầu từ client đến server trước hết sẽ phải thông qua proxy, proxy kiểm tra yêu cầu nếu được phép sẽ gửi đến server.
  + `Forward Proxy:` đây là server nhằm nhiệm vụ chuyển tiếp các packet từ client đến các server khác.
  + `Reverse Proxy:` đây là server đứng trước một hoặc nhiều server, lắng nghe và kiểm soát các kết nối từ client đến.



## 2. Các thuật ngữ trong HAProxy
- **Access Control List (ACL)** sử dụng để kiểm tra một số điều kiện và thực hiện hành động tiếp theo dựa trên kết quả kiểm tra.
- **Backend** là tập các server nhận các request đã được điều tiết (HAProxy điều tiết các request tới backend).
  - Các backend được định nghĩa trong mục backend khi cấu hình HAProxy.
  - 2 cấu hình thường được định nghĩa trong mục backend
    + Thuật toán cân bằng tải (Round Robin, Least Connection, IP Hash)
    + Danh sách các server, port (Nhận, xử lý các request)
  - Backend có thể chứa một hoặc nhiều server. Việc thêm nhiều server sẽ cải thiện tải, hiệu năng, tăng độ tin cậy dịch vụ. Khi một server backend không khả dụng, các server khác thuộc backend sẽ chịu tải thay cho server xảy ra vấn đề.
- **Frontend** định nghĩa các request điều tiết tới backend. Các cấu hình frontend được định nghĩa trong mục frontend khi cấu hình HAProxy.
  - Cấu hình frontend gồm các thành phần:
    + IP và port (192.168.10.1:80, *:443)
    + Các ACL
    + Các backend nhận, xử lý request
- **Health check** được sử dụng để phát hiện các backend server sẵn sàng xử lý các request. 
   + Kỹ thuật này tránh việc phải loại bỏ server khỏi backend thủ công khi backend server không sẵn sàng.

## 3. Các loại cân bằng tải
### 3.1 Layer 4 Load Balancing
- Cách đơn giản nhất để cân bằng tải các request tới nhiều server là sử dụng cân bằng tải mức layer 4 TCP (Transport layer).
- Phương pháp điều hướng này sẽ dựa trên IP và Port.


![](https://blog.cloud365.vn/images/img-tongquan-haproxy/pic2.png)

### 3.2 Layer 7 Load Balancing
- Cân bằng tải ở Layer 7 (Application Layer) sử dụng bộ cân bằng tải tại layer 7 điều hướng tới các backend khác nhau dựa trên nội dung của request.
- Chế độ cho phép triển khai nhiều web server khác nhau dựa trên cùng 1 domain.
![](https://blog.cloud365.vn/images/img-tongquan-haproxy/pic3.png)

## 4. Các thuật toán cân bằng tải
- Thuật toán cân bằng tải được sử dụng nhằm định nghĩa các request được điều hướng tới các server nằm trong backend trong quá trình loadbalancing. 
- `roundrobin:` Các request sẽ chuyển đến server theo lượt. Đây là thuật toán mặc định sử dụng tới HAProxy.
- `leastconn:` Các request sẽ được chuyển đến server nào có ít kết nối đến nó nhất.
- `source:` Các request sẽ được chuyển đến server bằng hash của IP user

__Docs__
- https://blog.cloud365.vn/linux/tong-quan-haproxy/
- https://github.com/hungnt1/Openstack_Research/blob/master/High-availability/1.HA-Proxy---KeepAlive/1.Intro.md