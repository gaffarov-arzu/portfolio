# oz private keyimizi yaratmaq
```bash
openssl genrsa -out ca.key 4096
```
# sertifikat yaratmaq
```bash
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt
```
# sorusulan hisselere yazilacaqlar
- Country Name --AZ
- State or Province --Baku
- Locality --Seherde bir yer
- Organization Name --Sirketin adi
- Organizational Unit --Sirketde departament(It, DevOps)
- Common Name --Musluck Root Ca
# silib yeniden yazmaq
```bash
rm ca.key ca.crt
```
# Root Ca dan sonra server sertifikasi yaratmaq
## evvelce private keyini yazmaq
```bash
openssl genrsa -out server.key 2048
```
## csr yaradiriq
```bash
openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
```
## amma csr yaradanda serverin hostnamenini domain adini yaziriq -- musluck.com
# csr i ca.crt ile imzalayiriq
```bash
openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
```
