# Kafka Full dokumentasya
## Kafka yuklenmesi ver qurasdirilmasi
### Yuklenmesi

```bash
sudo apt update 
sudo apt install openjdk-17-jdk -y
sudo wget https://dlcdn.apache.org/kafka/4.0.0/kafka_2.13-4.0.0.tgz
sudo tar -xvf kafka_2.13-4.0.0.tgz
sudo mv kafka_2.13-4.0.0 /opt
sudo ln -s /opt/kafka_2.13-4.0.0 /opt/kafka
sudo echo 'export PATH=/opt/kafka/bin:$PATH' >> /root/.profile && source /root/.profile
sudo mkdir -p /var/log/kafka
sudo chown -R root:root /var/log/kafka
sudo chmod -R 755 /var/log/kafka
sudo mkdir -p /opt/kafka/config/kraft
sudo cp /opt/kafka/config/server.properties /opt/kafka/config/kraft/server.properties
```

### Properties fayli-1ci nod ucun
```
#/opt/kafka/config/kraft/server.properties

# Role and Node Configuration
process.roles=broker,controller
node.id=1
controller.quorum.voters=1@192.168.1.10:9093,2@192.168.1.11:9093

# Listeners and Network Configuration
listeners=SASL_PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
advertised.listeners=SASL_PLAINTEXT://192.168.1.10:9092
controller.listener.names=CONTROLLER

# Security (SASL/PLAIN)
listener.security.protocol.map=CONTROLLER:SASL_PLAINTEXT,SASL_PLAINTEXT:SASL_PLAINTEXT
sasl.enabled.mechanisms=PLAIN
security.inter.broker.protocol=SASL_PLAINTEXT
sasl.mechanism.inter-broker.protocol=PLAIN
sasl.mechanism.controller.protocol=PLAIN

listener.name.sasl_plaintext.plain.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \
    username="admin" \
    password="admin-password" \
    user_admin="admin-password";

listener.name.controller.plain.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \
    username="admin" \
    password="admin-password" \
    user_admin="admin-password";

authorizer.class.name=org.apache.kafka.metadata.authorizer.StandardAuthorizer
super.users=User:admin

# Storage
log.dirs=/var/log/kafka1
num.partitions=1
default.replication.factor=2
offsets.topic.replication.factor=2
transaction.state.log.replication.factor=2
transaction.state.log.min.isr=1
group.initial.rebalance.delay.ms=0
```

### Properties fayli-2ci nod ucun

```bash
# Role and Node Configuration
process.roles=broker,controller
node.id=2
controller.quorum.voters=1@192.168.1.10:9093,2@192.168.1.11:9093

# Listeners and Network Configuration
listeners=SASL_PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
advertised.listeners=SASL_PLAINTEXT://192.168.1.11:9092
controller.listener.names=CONTROLLER

# Security (SASL/PLAIN)
listener.security.protocol.map=CONTROLLER:SASL_PLAINTEXT,SASL_PLAINTEXT:SASL_PLAINTEXT
sasl.enabled.mechanisms=PLAIN
security.inter.broker.protocol=SASL_PLAINTEXT
sasl.mechanism.inter-broker.protocol=PLAIN
sasl.mechanism.controller.protocol=PLAIN

listener.name.sasl_plaintext.plain.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \
    username="admin" \
    password="admin-password" \
    user_admin="admin-password";

listener.name.controller.plain.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \
    username="admin" \
    password="admin-password" \
    user_admin="admin-password";

authorizer.class.name=org.apache.kafka.metadata.authorizer.StandardAuthorizer
super.users=User:admin

# Storage
log.dirs=/var/log/kafka2
num.partitions=1
default.replication.factor=2
offsets.topic.replication.factor=2
transaction.state.log.replication.factor=2
transaction.state.log.min.isr=1
group.initial.rebalance.delay.ms=0
```

### Kafka service fayli

```bash
#/etc/systemd/system/kafka.service
[Unit]
Description=Apache Kafka Server (KRaft mode)
After=network.target

[Service]
Type=simple
Environment="JAVA_HOME=/usr/lib/jvm/java-1.17.0-openjdk-amd64"
# Directly starting with the properties file
ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties
ExecStop=/opt/kafka/bin/kafka-server-stop.sh
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target

```

### Kafka cluster id yaradib ayaga qaldirmaq

```bash
KAFKA_CLUSTER_ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo "Using cluster ID: $KAFKA_CLUSTER_ID"
sudo /opt/kafka/bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c /opt/kafka/config/kraft/server.properties
sudo systemctl daemon-reload
sudo systemctl enable kafka 
sudo systemctl start kafka 
sudo systemctl status kafka
```

## Kafka komandalar

### Kafkada topiclerin siyahisi

```bash
/opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list
```

### Kafkada clusterin statusu

```bash
/opt/kafka/bin/kafka-broker-api-versions.sh --bootstrap-server localhost:9092
```

### Kafkada topic yaratmaq

```bash
/opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic my-topic --partitions 1 --replications-factor 1
```

### Kafkada topicin contentini gormek 

```bash
/opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic my-topic
```

### Kafkada topic silmek

```bash
/opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic my-topic
```

### Topicde partition sayini artirmaq

```bash
/opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --alter --topic my-topic --partitions 3
```

### Kafkada topic configini deyismek 

```bash
/opt/kafka/bin/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name my-topic --alter --add-config retention.ms=3600000
```

### Kafkada topic ucun edilen konfigleri(retention-policy) gormek

```bash
/opt/kafka/bin/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name my-topic --describe
```

### Kafkada topic ucun config edilmis max message bytes gormek

```bash
 /opt/kafka/bin/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name my-topic --describe
```

### Kafkada topicde mesajin olcusunu deyismek 

```bash
/opt/kafka/bin/kafka-configs.sh  --bootstrap-server localhost:9092 --entity-type topics --entity-name my-topic --alter --add-config max.message.bytes=5242880
```

### Kafkada mesajin olcusun broker seviyesinde deyismek

```bash
/opt/kafka/bin/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --alter --add-config message.max.bytes=5242880
```

### Kafkada broker seviyesinde add edilen configleri gormek

  ```bash
 /opt/kafka/bin/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --describe
```

### Kafkada terminalda mesaj yazib topice gondermek

 ```bash
 /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic my-topic
 ```

### Kafkada topicdeki mesajlari gormek 

```bash
/opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic --from-beginning
```

## Notelar

### Kafkada partition topicin nece yere bolunmesidir, her partitionda coxlu mesaj ola biler,  replica ise o partitionun kopasidir

## Kafkada acl elave edilenden sonra umumi properties fayli-bir node ucun

```bash
#vim /opt/kafka/config/kraft/server.properties
# Role and Node Configuration
process.roles=broker,controller
node.id=1
controller.quorum.voters=1@127.0.0.1:9093

# Listeners and Network Configuration
listeners=SASL_PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
advertised.listeners=SASL_PLAINTEXT://127.0.0.1:9092
controller.listener.names=CONTROLLER

# Security Mapping and Protocols
listener.security.protocol.map=CONTROLLER:SASL_PLAINTEXT,SASL_PLAINTEXT:SASL_PLAINTEXT
sasl.enabled.mechanisms=PLAIN
security.inter.broker.protocol=SASL_PLAINTEXT
sasl.mechanism.inter.broker.protocol=PLAIN
sasl.mechanism.controller.protocol=PLAIN

# JAAS Configuration - Inline Credentials
# Using backslashes for multi-line readability
listener.name.sasl_plaintext.plain.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \
    username="admin" \
    password="admin-password" \
    user_admin="admin-password" \
    user_alice="alice-password";

listener.name.controller.plain.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \
    username="admin" \
    password="admin-password" \
    user_admin="admin-password";

# Authorization (ACLs)
authorizer.class.name=org.apache.kafka.metadata.authorizer.StandardAuthorizer
super.users=User:admin

# Log and Storage Management
log.dirs=/var/log/kafka
num.partitions=1
default.replication.factor=1
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
group.initial.rebalance.delay.ms=0


```

### Admin accessler vermek ucun

```bash
#/opt/kafka/config/admin-client.conf
# Full administrative access
security.protocol=SASL_PLAINTEXT
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="admin" password="admin-password";
```

### Diger elave user ucun

```
#/opt/kafka/config/alice-client.conf

# Restricted user access
security.protocol=SASL_PLAINTEXT
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="alice" password="alice-password";
```

### Kafkada acl kimi configler deyisenler sonra asagidaki emeliyyatlari edirik *yeni id alib clusteri yeniden basladiriq

```bash
rm -rf /var/log/kafka/*
sudo rm -rf /opt/kafka/data/*
KAFKA_CLUSTER_ID=$(/opt/kafka/bin/kafka-storage.sh random-uuid)
/opt/kafka/bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c /opt/kafka/config/kraft/server.properties
sudo systemctl daemon-reload
sudo systemctl restart kafka
```


### Kafkanin log yazacagi yerleri yarat

```bash
sudo mkdir -p /var/log/kafka
sudo chown -R root:root /var/log/kafka
sudo chmod -R 755 /var/log/kafka
```

### Permission verdiyimiz userin icazelerine baxmaq ucun 

```bash
/opt/kafka/bin/kafka-acls.sh --bootstrap-server localhost:9092 --command-config /opt/kafka/config/admin-client.conf --list
```

### Yeni bir user ucun server.prpertiesde user_bob="bob-password" yaradiriq diger userin altina

```bash
/opt/kafka/config/kraft/server.properties
```

### Sonra o user ucun /opt/kafka/config/bob-client.conf fayli yaradiriq

```bash
security.protocol=SASL_PLAINTEXT
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="bob" password="bob-password";
```

### Bu user ucun oz topicine full access ucun 

```bash
/opt/kafka/bin/kafka-acls.sh --bootstrap-server localhost:9092 \
--command-config /opt/kafka/config/admin-client.conf \
--add --allow-principal User:bob --operation All --topic bob-topic
```

### Bu usere topice yazmaqdan elave asagidaki group useri veririk oxumasi ucun 

```bash
/opt/kafka/bin/kafka-acls.sh --bootstrap-server localhost:9092 \
--command-config /opt/kafka/config/admin-client.conf \
--add --allow-principal User:bob --operation Read --group "*"
```

### Userin oz topicine yazmasini yoxlamaq ucun

```bash
echo "test bob" | /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 \
--topic bob-topic \
--producer.config /opt/kafka/config/bob-client.conf
```

### Userin oxumagini test etmek

```bash
/opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 \
--topic bob-topic --from-beginning \
--consumer.config /opt/kafka/config/bob-client.conf
```

### Userin mesaji oxumasi ucun

```bash
/opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 \
--topic bob-topic --from-beginning \
--consumer-property security.protocol=SASL_PLAINTEXT \
--consumer-property sasl.mechanism=PLAIN \
--consumer-property sasl.jaas.config='org.apache.kafka.common.security.plain.PlainLoginModule required username="bob" password="bob-password";'
```

### Developere vermek ucun lazim olanlar

- ip ve port
- username
- password
- mechanism(PLAIN)
- security protocol (SASL_PLAINTEXT)
- topic adi
