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
# schemalarin siyahisi ve privilegesi olanlari gormek ucun
```sql
\dn+
```
# table secib icinden sutunlari gormek
 ```sql
 SELECT * FROM users;
```
# tableda sutundaki basliqi secib sutunu gostermek meselen users tablesinden username stunu
```sql
SELECT username  FROM users;
```
# users tablesinden username stunundan test-user silmek
```sql
 DELETE FROM users WHERE username = 'test-user';
```
# tablenin icine baxmaq 
```sql
\d users
```
## postrgresql
### qurulmasi 
```bash
sudo apt install postgresql postgresql-contrib
```
### qosulmaq
```bash
 sudo -u postgresql psql
```
### db yaratmaq
```sql
CREATE DATABASE musluckdb;
```
### userle password yaratmaq ve ya deyismek
```sql
CREATE USER muser WITH ENCRYPTED PASSWORD 'mypassword';
ALTER USER postgres WITH PASSWORD 'postgres123';
```

### hansisa usere hansisa db ucun access vermek - tek dbe access bes etmir schemaya da access verilir schema ise databsesin altindadir
```sql
GRANT ALL PRIVILEGES ON DATABASE musluckdb to muser;
GRANT ALL PRIVILEGES ON SCHEMA public TO muser;
```
### permission islemese 
```sql
GRANT USAGE, CREATE ON SCHEMA public TO muser;
```
### sql dbs-inden postgresqle migrasya ucun pgloader istifade edilir
```bash
pgloader sqlite:///life-balance.db postgresql://muser:mypassword@localhost:5432/musluckdb
```
### 
### postgresql de heryerden acmaq ucun
```bash
vim /etc/postgresql/14/main/postgresql.conf
listen_addresses = '*'          
vim /etc/postgresql/14/main/pg_hba.conf
host all all 0.0.0.0/0 md5

```
