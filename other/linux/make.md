# make ile servis qurulmasi
```bash
# gcc, g++, make ve diger lazimi paketlerin yuklenmesi
sudo apt install build-essential
```
# pythonu /opt/python directorisine qur deyir
```bsh
./configure --prefix=/opt/python3.12
```
# kodu compile etmek
```bash
make -j$(nproc)
```
# pythonu teyin olunan directoriye qurmaq
```bash
make install
```
