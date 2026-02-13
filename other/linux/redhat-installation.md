#version=RHEL8
# System authorization information
auth --enableshadow --passalgo=sha512

########### grep ENCRYPT_METHOD /etc/login.defs -----------password algoritmasini check etmek-----------
########### authselect apply-changes   -----------------paswword deyisenden sonra pamin o metodu istifade etmesi ucun------------
########### cat /etc/shadow | grep test -------------$6$ ile baslayirsa sha512 aktivdir demeli-------------

#repo --name="Server-HighAvailability" --baseurl=file:///run/install/repo/addons/HighAvailability
#repo --name="Server-ResilientStorage" --baseurl=file:///run/install/repo/addons/ResilientStorage

# Use graphical install
graphical
#text

# Keyboard layouts



keyboard --vckeymap=us --xlayouts='us'
############# localectl status     -----------keyboardin us oldugunu check etmek-------------
############# us deyilse us-e deyismek localectl set-keymap us 2) localectl set-x11-keymap us--------------
#cdrom
#url --url=http://192.168.0.87/RHEL81

# Disable Security
firewall --disabled                            #######            systemctl disable firewalld
authconfig --enableshadow --enablemd5          #######            depreceted
selinux	 --disabled                            #######            /etc/selinux/config ----- SELINUX=disabled

# System language
lang en_US.UTF-8             ##############     keyboard hissesinde edildi

# License agreement
eula --agreed            ############ install oland

# Network information
network  --hostname=kaveri12

network --bootproto=static  --noipv4 --noipv6 --device=eno1 --onboot=off --no-activate
network --bootproto=static  --noipv4 --noipv6 --device=eno2 --onboot=off --no-activate
network --device=bond0  --bootproto=static --bondslaves=eno1,eno2 --bondopts=mode=active-backup;primary=eno1 --ip=192.168.0.21 --netmask=255.255.255.0 --onboot=on --noipv6

# Root password is Kata6f123
rootpw --iscrypted $6$p4Ou1AK9P.Efs9SK$p4P0mKhN5X7DBJr/6R8qoJkPpderV0sHKw/DiVCJmtXUqfQ1Fiwn2SJgm.RJVRxMl/MNtCEVqLHu2Bv3xTRXY1     ########### /etc/shadow -da cat edende bele gorsenir
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


# Partition clearing information
clearpart --all --drives=sda --initlabel                   ############ teze serverde ehtiyac yoxdur kohnede temizlik ucun lazimdir

zerombr                                                    ############   kohne boot melumatlarini silir

# Disk partitioning information
#autopart

part /boot --fstype="xfs" --ondisk=sda --size=512
part /boot/efi --fstype="efi" --ondisk=sda --size=819 --fsoptions="umask=0077,shortname=winnt"
part pv.1 --fstype="lvmpv" --size=1 --grow --ondisk=sda
volgroup vg_system --pesize=4096 pv.1
logvol / --fstype="xfs" --size=40960 --name=lv-root --vgname=vg_system
logvol /var/tmp --fstype="xfs" --size=30720 --name=lv-tmp --vgname=vg_system
logvol swap --fstype="swap" --size=8192 --name=lv-swap --vgname=vg_system
logvol /home --fstype="xfs" --size=204800 --name=lv-home --vgname=vg_system
logvol /home/kaveri/segments --fstype="xfs" --size=1740800 --name=lv_kaveri --vgname=vg_system

%packages                            
@^graphical-server-environment   #    subscription need                         # sudo dnf groupinstall "Server with GUI"       
@development                     #    subscription need                         # sudo dnf groupinstall "Development Tools"
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

# hosts
cat <<EOF >> /etc/hosts
# Production System #
# Global IP

10.13.8.1  lbs01-pub
10.13.8.2  lbs02-pub
10.13.8.4  iesb01-pub
10.13.8.5  iesb02-pub
10.13.8.3  iesb-pub-vip
10.13.8.6  gtw01-pub
10.13.8.7  gtw02-pub
10.13.8.8  gtw03-pub

# Private IP  (Segment A)
192.168.0.1    lbs01
192.168.0.2    lbs02
192.168.0.3    iesb01
192.168.0.4    iesb02
192.168.0.5    megha01
192.168.0.6    megha02
192.168.0.7    dbs01
192.168.0.8    dbs02
192.168.0.9    bks01
192.168.0.10   kaveri01
192.168.0.11   kaveri02
192.168.0.12   kaveri03
192.168.0.13   kaveri04
192.168.0.14   kaveri05
192.168.0.15   kaveri06
192.168.0.16   kaveri07
192.168.0.17   kaveri08
192.168.0.18   kaveri09
192.168.0.19   kaveri10
192.168.0.20   kaveri11
192.168.0.21   kaveri12

# Virtual IP
192.168.0.100  megha-vip
192.168.0.101  iesb-vip
192.168.0.103  dbs01-vip
192.168.0.104  dbs02-vip
192.168.0.105  dbsscan-vip

# Private IP (Segment B)
192.168.1.1    dbs01-pub
192.168.1.2    dbs02-pub

# Test System #
# Global IP
10.13.8.11     iesbt01-pub

# Private IP
192.168.0.50   iesbt01
192.168.0.51   aimxmt01
192.168.0.52   dbst01
EOF               ---->         #  done

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
