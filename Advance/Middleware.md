# Middleware architecture
## 1. Định nghĩa
- **Middleware architecture Keystone** - `Kiến trúc phần mềm trung gian Keystone` hỗ trợ một giao thức xác thực chung giữa các project Openstack.
- Bằng cách sử dụng **Keystone** làm cơ chế xác thực và ủy quyền chung.

## 2. Tổng quan
- `Authentication` là quá trình xác định các user.
- `Authentication Protocol` như `HTTP Basic Auth, Digest Access, public key, token,...` để định danh (Identity) user.
- Hiện nay, `Token` là giao thức xác thực phổ biến nhất trong Openstack.
- Quá trình `middleware` thực hiện
  + Xóa sạch toàn bộ sự ủy quyền ở trường header để chặn sự giả mạo.
  + Tổng hợp token trong trường header của HTTP request.
  + Xác nhận Token:
    - Nếu hợp lệ, thêm trong header đại diện cho danh tính được chứng thực và ủy quyền.
    - Nếu không hợp lệ, hoặc không có token thì từ chối request hoặc thông qua header cho biết request không được xác thực.
    - Nếu dịch vụ Keystone không có sẵn để xác thực token, sẽ từ chối request với `HTTP service Unavailable`.
### Authentication component
![](https://github.com/khanhnt99/thuctap012017/raw/master/DucPX/OpenStack/Keystone/images/authfolow.png)
- Việc từ chối hay chấp nhận yêu cầu xác thực thông qua Middeware (Phần mềm trung gian)
### Authentication component (Delegated Mode)
![](https://github.com/khanhnt99/thuctap012017/raw/master/DucPX/OpenStack/Keystone/images/delegate_mode.png)
- Reject hay Accept authentication được ủy quyền cho service Openstack.

__Docs__
- https://docs.openstack.org/keystonemiddleware/latest/middlewarearchitecture.html
- https://github.com/khanhnt99/thuctap012017/blob/master/DucPX/OpenStack/Keystone/docs/Middlewarearchitecture.md