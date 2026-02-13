# version=RHEL8 installation 
## System authorization information
#### password algoritmasini check etmek
```bash
 grep ENCRYPT_METHOD /etc/login.defs
```
### paswword deyisenden sonra pamin o metodu istifade etmesi ucun
```bash
authselect apply-changes
```
### $6$ ile baslayirsa sha512 aktivdir demeli
```bash
 cat /etc/shadow | grep test
```
## keyboardin us oldugunu check etmek
```bash
 keyboard --vckeymap=us --xlayouts='us'
```
## keyboardin us oldugunu check etmek
```bash
localectl status
```
## us deyilse us-e deyismek
``` bash
localectl set-keymap
localectl set-x11-keymap us
```

## Disable Security
``` bash
systemctl disable firewalld
/etc/selinux/config ---- > SELINUX=disabled
```
## Disable chronyd
``` bash
systemctl disable chronyd
```
## Set timezone and check
``` bash
timedatectl set-timezone Asia/Baku
timedatectl
```
## crash olanda datani yaddasa yazmaq
``` bash
vi /etc/default/grub ------- GRUB_CMDLINE_LINUX="crashkernel=auto"
grub2-install /dev/sda
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
grep crashkernel /boot/grub2/grub.cfg  ->>>> check etmek ucun
```

## packages at graphical-server-environment
``` bash
sudo dnf groupinstall "Server with GUI"
sudo dnf groupinstall "Development Tools"
sudo dnf install chrony
sudo dnf install dstat
sudo dnf install sysstat
```

## disable kdump
``` bash
sudo systemctl disable kdump.service 
```
## Linuxda manual ip verilmese Zeroconf ile ozune ip vermesin deye disable etmek


```bash
cat >> /etc/sysconfig/network << EOF
NOZEROCONF=yes
EOF
bash         
```
## ipv6 disable etmek
```bash

cat >> /etc/sysctl.conf << EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOF
```

## Repo yaratmaq 
``` bash
#cat <<YUMEOF >> /etc/yum.repos.d/local_dvd.repo
#[local_dvd]
#name=RHEL7.5 DVD
#baseurl=file:///media/RHEL83/BaseOS
#baseurl=http://192.168.0.87/RHEL83/BaseOS
#enable=1
#gpgcheck=0
##gpgkey=http://192.168.0.87/RHEL75/RPM-GPG-KEY-redhat-release

#[InstallMedia-AppStream]
#name=Red Hat Enterprise Linux 8 - AppStream
#metadata_expire=-1
#gpgcheck=1
#enabled=1
#baseurl=file:///media/RHEL83/AppStream/
#baseurl=http://192.168.0.87/RHEL83/AppStream/
#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
#YUMEOF
```
