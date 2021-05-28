# Security Group
## 1. Overview
- `Security Group` là một bộ các quy tắc để filter các IP, nó được áp dụng cho tất cả các instance để định nghĩa mạng và truy cập các máy ảo.
- Group rules được xác định cho các project cụ thể, các user thuộc vào project nào thì có thể chỉnh sửa, thêm, xóa các rule của group tương ứng.
- Tất cả các project đều có một security-groups, mặc định là **default** được áp dụng cho bất kì một instance nào không được định nghĩa một security group nào khác. 
- Mặc định security group sẽ chặn các `incoming traffic` tới instance.
- Có thể sử dụng option **allow_same_net_traffic** trong `nova.conf` để kiểm soát toàn bộ nếu các rules áp dụng cho host được chia sẻ mạng.
  + **True**(default): Host nằm trên cùng 1 subnets không được filter và được phép đi qua đối với tất cả các loại traffic giữa chúng.
  + **False**: security group sẽ bắt buộc áp dụng cho tất cả các kết nối, kể cả các kết nối cùng mạng.

![](https://i.ibb.co/Vq7ktZ6/Screenshot-from-2021-05-28-10-49-43.png)

## 2. Tạo security group WebServer
![](https://i.ibb.co/yQ0QHGr/Screenshot-from-2021-05-28-10-57-58.png)

![](https://i.ibb.co/LzL6TRx/Screenshot-from-2021-05-28-11-00-36.png)

![](https://i.ibb.co/yhGt55R/Screenshot-from-2021-05-28-11-02-17.png)

![](https://i.ibb.co/KyQwcJQ/Screenshot-from-2021-05-28-11-04-53.png)

![](https://i.ibb.co/jJ0TsYH/Screenshot-from-2021-05-28-11-06-41.png)

![](https://i.ibb.co/2sZwP07/Screenshot-from-2021-05-28-11-10-07.png)

![](https://i.ibb.co/zNqw2Xp/Screenshot-from-2021-05-28-11-10-43.png)

![](https://i.ibb.co/6srL3FL/Screenshot-from-2021-05-28-11-48-36.png)

![](https://i.ibb.co/NYDv3FT/Screenshot-from-2021-05-28-13-06-04.png)