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
