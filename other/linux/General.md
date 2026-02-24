# eyni versiyani yeni serverde de yaziriq 
```bash
wget https://www.python.org/ftp/python/3.10.12/Python-3.10.12.tgz
tar xvf Python-3.10.12.tgz
cd Python-3.10.12
./configure --prefix=/opt/python3.10
# yuxaridaki command islemeye biler source koddan yazmaq ucun lazimi paket ve librariler yuklenir
sudo apt update
sudo apt install build-essential libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev \
libreadline-dev libsqlite3-dev libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev \
liblzma-dev tk-dev libffi-dev uuid-dev

```
# broken paketleri duzeltmek
```bash
apt --fix-broken install
dpkg --configure -a
sudo apt update
sudo apt upgrade
```


# Clone edilecek serverde apache python-pip ve privacyidea yazilir ve hemin fayl orada yaradilir
```bash
apt update
apt install apache2

#apt install python3-pip
#apt install python3.12-venv
#pip install privacyidea


vim /etc/apache2/sites-enabled/privacyidea.conf
```
# Server de virtual env yaradilir

```bash
python3 -m venv /opt/privacyidea-venv
```

# virtual env alinmasa docker ile 
```bash
apt install -y docker.io docker-compose
systemctl start docker
systemctl enable docker
usermod -aG docker $USER 
docker --version
docker-compose --version
mkdir -p /home/ubuntu/privacyidea
cd /home/ubuntu/privacyidea 
```
# privacy ida docker-compose fayli docker-compose.yml
```yaml
version: '3'
services:
  privacyidea:
    image: privacyidea/privacyidea:latest
    container_name: privacyidea
    restart: always
    ports:
      - "5000:5000"  # Web arayüzü
    environment:
      PI_ADMIN_PASSWORD: "YourStrongPassword"
      PI_SECRET_KEY: "randomsecretkey"
    volumes:
      - ./data:/data
```
# docker compose faylini qaldirmaq 
```bash 
docker-compose up -d
```
# docker enginele docker-compose uygun gelmeye biler compose pluginini  yazib yoxlaya bilerik
```bash
sudo apt install docker-compose-plugin
```
apt remove docker-compose
# Clone edilen serverde script faylini yaradiriq hansiki 80 ve 443 portuna gelenler yonlendirilecek
```bash
vim /etc/privacyidea/privacyideaapp.wsgi
import sys
sys.stdout = sys.stderr
from privacyidea.app import create_app
# Now we can select the config file:
application = create_app(config_name="production", config_file="/etc/privacyidea/pi.cfg")
```
# asagidaki privacy idea configini de hazirlayiriq
```bash
vim /etc/privacyidea/pi.cfg 
import logging
# The realm, where users are allowed to login as administrators
SUPERUSER_REALM = ['super']
# Your database
#SQLALCHEMY_DATABASE_URI = 'sqlite:////etc/privacyidea/data.sqlite'
# This is used to encrypt the auth_token
#SECRET_KEY = 't0p s3cr3t'
# This is used to encrypt the admin passwords
#PI_PEPPER = "Never know..."
# This is used to encrypt the token data and token passwords
PI_ENCFILE = '/etc/privacyidea/enckey'
# This is used to sign the audit log
# This is the dummy base class
#PI_AUDIT_MODULE = 'privacyidea.lib.auditmodules.base'
# This is the default
#PI_AUDIT_MODULE = 'privacyidea.lib.auditmodules.sqlaudit'
# This is used to sign the audit log
PI_AUDIT_KEY_PRIVATE = '/etc/privacyidea/private.pem'
PI_AUDIT_KEY_PUBLIC = '/etc/privacyidea/public.pem'
PI_AUDIT_SQL_TRUNCATE = True
# The Class for managing the SQL connection pool
PI_ENGINE_REGISTRY_CLASS = "shared"
PI_AUDIT_POOL_SIZE = 20

PI_LOGFILE = '/var/log/privacyidea/privacyidea.log'
PI_LOGLEVEL = logging.INFO
PI_PEPPER = '*************'
SECRET_KEY = '***********'
SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://pi:TP0dxSax3CD7@localhost/pi?charset=utf8'
```

