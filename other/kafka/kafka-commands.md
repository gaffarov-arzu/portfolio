# kafkada topiclerin siyahisi
```bash
/opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list
```
# kafkada clusterin statusu
```bash
/opt/kafka/bin/kafka-broker-api-versions.sh --bootstrap-server localhost:9092
```
# kafkada topic yaratmaq
```bash
/opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic my-topic --partitions 1 --replications-factor 1
```
# kafkada topicin contentini gormek 
```bash
/opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic my-topic
```
# kafkada topic silmek
```bash
/opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic my-topic
```
# topicde partition sayini artirmaq
```bash
/opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --alter --topic my-topic --partitions 3
```
# kafkada topic configini deyismek 
```bash
/opt/kafka/bin/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name my-topic --alter --add-config retention.ms=3600000
```
# kafkada topic ucun edilen konfigleri(retention-policy) gormek
```bash
/opt/kafka/bin/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name my-topic --describe
```
# kafkada topic ucun config edilmis max message bytes gormek
```bash
 /opt/kafka/bin/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name my-topic --describe
```
# kafkada topicde mesajin olcusunu deyismek 
```bash
/opt/kafka/bin/kafka-configs.sh  --bootstrap-server localhost:9092 --entity-type topics --entity-name my-topic --alter --add-config max.message.bytes=5242880
```
# kafkada mesajin olcusun broker seviyesinde deyismek
```bash
/opt/kafka/bin/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --alter --add-config message.max.bytes=5242880
```
# kafkada broker seviyesinde add edilen configleri gormek
  ```bash
 /opt/kafka/bin/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --describe
```
