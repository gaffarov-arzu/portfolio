# databaseye qosulmaq postgresql useri ile olsa password istemir amma root userinde ola ola basqa bir -U user ile qosulsan password isteyecek -h ile edende ise kenardan baglanmis kimi olur, socket uzerinden baglanmir. 
# database de authentication md3 ve peer formatinda olur 
- md5 sifre ile qosulmadir
- peer ise mesele root userindese amma basqa bir user ile qosulursansa alinmayacaq
# database iki cur backup alinir 
- burada sade dump almaqdir commandalar oxunur
```bash
pg_dump -h localhost  -U muser -d musluckdb > musluckdb.dump
```
- binary dump burada ise sixisdirilmis ve oxunmaz halda olur
```bash
vim musluckdb.dump pg_dump -U muser -h localhost -F c -b -v -f backup.dump musluckdb
```
