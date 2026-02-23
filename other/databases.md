# databaselar
## novleri
- sql - table formatinda
- nosql - dokument seklinde, key-value seklinde, json fromatinda
## sqllite
### db fayli ile girmek
```bash
sqlite3 life_balance.db
```
### sqlliteden cixmaq 
```sql
quit
.exit
```
### tablolarin adina baxmaq siyahiya baxmaq
```
sqlite3 life_balance.db "SELECT name FROM sqlite_master WHERE type='table';"
```
### tablolara baxmaq sutunlara baxmaq ve lazimi datani almaq
```sql
.tables
SELECT * FROM history;
```
### sutunlarin listesine baxmaq ucun bir tableda birden cox sutun olur key kimi onun icinde ise setirler olur sqllite fayl ile qosulur
```sql
PRAGMA table_info(history);
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

```
