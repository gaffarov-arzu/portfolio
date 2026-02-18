# servisin faylina baxmaq
```bash
systemctl cat kafka
[Unit]
Description=Apache Kafka Server
After=network.target

[Service]
Type=simple
User=admiral
Group=admiral
ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties
ExecStop=/opt/kafka/bin/kafka-server-stop.sh
Restart=on-failure
RestartSec=5

# Increase these if needed
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
```
# process id ile servisin statusuna baxmaq
```bash
systemctl status 4101283
```

# servislerin siyahisina baxmaq
```bash
systemctl list-units --type=service
```
# prosesi tam yolunu verir, nodejs dirse js pathi verir full, hansi user basladib verir 
```bash
ps -fp 3095506
```
