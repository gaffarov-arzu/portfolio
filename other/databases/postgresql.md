# qurasdirilmasi
```bash
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt install postgresql-client-15
```
# postgresqle schemalarin siyahisi ve icazesi
```sql
\dn
\dn+ pi
```

# databaseda schemaya user ucun konkret set etmek olur ki user birbasa o schema ile baglansin
# databasede komanda isledende dirnaqlara fikir vermek lazimdir
# userlerin siyahisi
```sql
\du
```
# databaselerin siyahisi
```sql
\l
```
# databaseya baglanmaq ucun
```sql
\c musluckdb
```
# databaseda hansi tablelar var baxmaq ucun
```sql
\dp
```
