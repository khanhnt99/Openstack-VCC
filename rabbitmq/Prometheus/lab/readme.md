# Lab Prometheus

![](https://i.ibb.co/NnpPTG2/Screenshot-from-2021-10-13-15-16-28.png)

### Mục tiêu:
- Monitoring RabbitMQ-server:
  + Monitoring các thông số CPU, RAM như bình thường.
  + Monitoring những thông số đặc biệt của RabbitMQ.
  + Đặt cảnh báo khi có thông số vượt quá mức cho phép.
  + Nhắn cảnh báo gửi lên Telegram.
  + Hiển thị đồ thị các thông số lên Grafana.

### Các bước thực hiện 
- Monitor các thông số bình thường.
- Gửi các thông số đó lên Grafana để vẽ đồ thị.
- Cảnh báo lên telegram lượng CPU và RAM nếu quá mức cho phép.
- Monitor các thông số của RabbitMQ server.
- Gửi các thông số Rabbimq-server lên Grafana để vẽ đồ thị -> Những thông số cần được monitoring.

## Thực hành
- Cài đặt Prometheus và node_exporter:
  + https://github.com/khanhnt99/RabbitMQ/blob/main/Prometheus/docs/2.install.md
- Cài đặt Grafana
  + https://grafana.com/grafana/download?edition=oss
  + https://hocchudong.com/huong-dan-cai-dat-grafana-hien-thi-du-lieu-giam-sat-vmware/


