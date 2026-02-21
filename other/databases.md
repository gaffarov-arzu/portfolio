# databaselar
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
### tablolara baxmaq sutunlara baxmaq ve lazimi datani almaq
```sql
tablolara baxmaq .tables
tablodan SELECT * FROM history;
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
 sudo u postgresql psql
```
### db yaratmaq
```sql
CREATE DATABASE musluckdb;
```
### userle password yaratmaq
```sql
CREATE USER muser WITH ENCRYPTED PASSWORD 'mypassword';
```
### hansisa usere hansisa db ucun access vermek
```sql
GRANT ALL PRIVILEGES ON DATABASE musluckdb to muser;
```
