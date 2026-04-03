# systemd seviyesinde stop etmek
```bash
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```
# komanda isletmek
```bash
systemd-inhibit --what=sleep sleep infinity
```
# sservis yaradib permanent etmek
```bash
# /etc/systemd/system/no-suspend.service
[Unit]
Description=Disable suspend

[Service]
ExecStart=/usr/bin/systemd-inhibit --what=sleep sleep infinity
Restart=always

[Install]
WantedBy=multi-user.target
```
# servisi restart etmek
```bash
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now no-suspend.service
```
# yoxlamaq 
```bash
systemd-inhibit --list
```
