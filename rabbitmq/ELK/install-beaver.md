- `apt install python-pip`
- `pip install beaver==36.2.0`
- `mkdir /etc/beaver`
- `touch /etc/beaver/beaver.conf`
- `touch /lib/systemd/system/beaver.service`
```
[Unit]
Description=beaver - python daemon that munches on logs and sends their contents to logstash

[Service]
Type=simple
ExecStart=/usr/local/bin/beaver -c /etc/beaver/beaver.conf -C /etc/beaver/conf.d -t redis -l /var/log/beaver.log
Restart=on-abort

[Install]
WantedBy=multi-user.target
```
- `mkdir /etc/beaver/conf.d/`
- `touch /etc/beaver/conf.d/rabbitmq.conf`
```
[/var/log/rabbitmq/*.log, /var/log/rabbitmq/startup_err]
type: rabbitmq
```
