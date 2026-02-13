# version=RHEL8 installation 
## System authorization information
auth --enableshadow --passalgo=sha512

#### password algoritmasini check etmek
```bash grep ENCRYPT_METHOD /etc/login.defs
```
-----------password algoritmasini check etmek-----------
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


# System services                 
services --disabled="chronyd"        ######### systemctl disable chronyd

# System timezone
timezone Asia/Baku --isUtc --nontp          ##### timedatectl set-timezone Asia/Baku
                                            ##### timedatect

# Run the Setup Agent on first boot
firstboot --disable     ############### setup wizar kimi birseydir 
                        ############### command systemctl disable firstboot.service 
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda         ###### crash olanda veziyyeti datani yaddas yazmaq ucun 
                                                                                ###### vi /etc/default/grub ------- GRUB_CMDLINE_LINUX="crashkernel=auto" 
                                                                                ###### grub2-install /dev/sda
                                                                                ###### sudo grub2-mkconfig -o /boot/grub2/grub.cfg
                                                                                ###### grep crashkernel /boot/grub2/grub.cfg  ->>>> check etmek ucun





%packages                            
@^graphical-server-environment   #    subscription need                           # sudo dnf groupinstall "Server with GUI"       
@development                     #    subscription need                           # sudo dnf groupinstall "Development Tools"
chrony                           ##   server install olunanda yuklenib            # sudo dnf install chrony
sysstat                          ##   server install olunanda yuklenib            # sudo dnf install sysstat
dstat                            ##   server install olunanda yuklenib            # sudo dnf install dstat
%end                             

%addon com_redhat_kdump --disable   #  sudo systemctl disable kdump.service
%end

%post --log=/root/ks-post.log       # hansisa paketi yukleyenden sonra oz yazdigimiz mesaji cixarmaq ucundur MƏS: ugurla yuklendi

systemctl disable kdump.service     #  sudo systemctl disable kdump.service

cat >> /etc/sysconfig/network << EOF
NOZEROCONF=yes
EOF              ---->         #  done

cat >> /etc/sysctl.conf << EOF
# nec
# Disable IPv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOF             ---->         #  done


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

%end

reboot
#poweroff
