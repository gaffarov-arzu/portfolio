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
# kafkada terminalda mesaj yazib topice gondermek
 ```bash
 /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic my-topic
 ```
# kafkada topicdeki mesajlari gormek 
```bash
/opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic --from-beginning
```
# kafkada partition topicin nece yere bolunmesidir, her partitionda coxlu mesaj ola biler,  replica ise o partitionun kopasidir
# kafkada acl elave edilmesi ucun evvelce adagidaki fayldaki setrler kommente alinir diger sasl setrler elave
```bash
/opt/kafka/config/kraft/server.properties
#listeners=PLAINTEXT://0.0.0.0:9092
#inter.broker.listener.name=PLAINTEXT

listeners=SASL_PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
advertised.listeners=SASL_PLAINTEXT://localhost:9092
inter.broker.listener.name=SASL_PLAINTEXT
listener.security.protocol.map=CONTROLLER:PLAINTEXT,SASL_PLAINTEXT:SASL_PLAINTEXT
security.inter.broker.protocol=SASL_PLAINTEXT
sasl.mechanism.inter.broker.protocol=PLAIN
sasl.enabled.mechanisms=PLAIN
```
# daha sonra adagidaki fayla diger setrler de elave edilir
```bash
/opt/kafka/config/kraft/server.properties
authorizer.class.name=org.apache.kafka.metadata.authorizer.StandardAuthorizer
super.users=User:admin
```
# daha sonra hansi userler var onlari asagidaki fayla elave edirik
```bash
/opt/kafka/config/kafka_server_jaas.conf

KafkaServer {
 org.apache.kafka.common.security.plain.PlainLoginModule required
 username="admin"
 password="admin-pass"
 user_admin="admin-pass"
 user_alice="alice-pass";
};
```

# kafka servisinde deyisiklik edilir
```bash
/etc/systemd/system/kafka.service
Environment="KAFKA_OPTS=-Djava.security.auth.login.config=/opt/kafka/config/kafka_server_jaas.conf"
```

# kafkada hanzi user acl elave edib sile biler
```bash
/opt/kafka/config/client.properties
security.protocol=SASL_PLAINTEXT
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \
 username="admin" \
 password="admin-pass";
```

# kafkada acl kimi configler deyisenler sonra yeni id alib clusteri yeniden basladiriq
```bash
KAFKA_CLUSTER_ID=$(/opt/kafka/bin/kafka-storage.sh random-uuid)
/opt/kafka/bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c /opt/kafka/config/kraft/server.properties
```
