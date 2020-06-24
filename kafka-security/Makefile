all:

wait:
	sleep 10

acl:
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-acls --bootstrap-server localhost:9093 --command-config /etc/kafka/super.properties \
		--add --allow-principal User:admin --topic t1 --operation ALL --cluster"
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-acls --bootstrap-server localhost:9093 --command-config /etc/kafka/super.properties \
		--add --allow-principal User:producer --topic t1 --producer"
	docker exec kafka-security_kafka1_1  /bin/sh -c "KAFKA_OPTS='' \
		kafka-acls --bootstrap-server localhost:9093 --command-config /etc/kafka/super.properties \
		--add --allow-principal User:consumer --topic t1 --consumer --group g1"

scram_clients:
	docker exec kafka-security_zk1_1  /bin/sh -c "EXTRA_ARGS='' \
		kafka-configs --zookeeper localhost:2181 \
		--alter --entity-type users --entity-name admin \
		--add-config 'SCRAM-SHA-256=[iterations=8192,password=admin-secret],SCRAM-SHA-512=[iterations=8192,password=admin-secret]'"
	docker exec kafka-security_zk1_1 /bin/sh -c "EXTRA_ARGS='' \
		kafka-configs --zookeeper localhost:2181 \
		--alter --entity-type users --entity-name producer \
		--add-config 'SCRAM-SHA-256=[iterations=8192,password=producer-secret],SCRAM-SHA-512=[iterations=8192,password=producer-secret]'"
	docker exec kafka-security_zk1_1 /bin/sh -c "EXTRA_ARGS='' \
		kafka-configs --zookeeper localhost:2181 \
		--alter --entity-type users --entity-name consumer \
		--add-config 'SCRAM-SHA-256=[iterations=8192,password=consumer-secret],SCRAM-SHA-512=[iterations=8192,password=consumer-secret]'"

down:
	docker-compose -f zk.yml down --remove-orphans

up_0:
	docker-compose -f zk.yml -f single-no-auth.yml up -d

test_0:
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-topics --bootstrap-server localhost:9092 --create --topic t1 --partitions 12 --replication-factor 1"
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-producer-perf-test --producer-props bootstrap.servers=localhost:9092 --topic t1 --num-records 100 --record-size 1000 --throughput 10"
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-consumer-perf-test --bootstrap-server localhost:9092 --topic t1 --messages 10"

test_kafkacat_0:
	kafkacat -b localhost:9092 -L
	echo 'test' | kafkacat -b localhost:9092 -P -t t1
	kafkacat -b localhost:9092 -C -t t1 -c 1

all_0: up_0 wait test_0 down

up_1:
	docker-compose -f zk.yml -f single-sasl-plain.yml up -d

test_1:
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-producer-perf-test --producer-props bootstrap.servers=localhost:9093 --topic t1 --num-records 100 --record-size 1000 --throughput 10 \
		--producer.config /etc/kafka/producer.properties"
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-consumer-perf-test --bootstrap-server localhost:9093 --topic t1 --messages 10 \
		--consumer.config /etc/kafka/consumer.properties"
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-topics --bootstrap-server localhost:9093 --describe --topic t1 \
		--command-config /etc/kafka/admin.properties"

test_kafkacat_1:
	kafkacat -b localhost:9093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:9093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:9093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=consumer -X sasl.password=consumer-secret

all_1: up_1 wait test_1 down

up_2:
	docker-compose -f zk.yml -f single-sasl-plain-acl.yml up -d

test_2:
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-producer-perf-test --producer-props bootstrap.servers=localhost:9093 --topic t1 --num-records 100 --record-size 1000 --throughput 10 \
		--producer.config /etc/kafka/producer.properties"
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-consumer-perf-test --bootstrap-server localhost:9093 --topic t1 --messages 10 --group g1 \
		--consumer.config /etc/kafka/consumer.properties"
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-topics --bootstrap-server localhost:9093 --describe --topic t1 \
		--command-config /etc/kafka/admin.properties"

test_kafkacat_2:
	kafkacat -b localhost:9093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:9093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:9093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=consumer -X sasl.password=consumer-secret

all_2: up_2 wait acl test_2 down

up_3:
	docker-compose -f zk.yml -f cluster-sasl-plain-acl.yml up -d

test_3:
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-producer-perf-test --producer-props bootstrap.servers=localhost:9093 --topic t1 --num-records 100 --record-size 1000 --throughput 10 \
		--producer.config /etc/kafka/producer.properties"
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-consumer-perf-test --bootstrap-server localhost:9093 --topic t1 --messages 10 --group g1 \
		--consumer.config /etc/kafka/consumer.properties"
	docker exec kafka-security_kafka1_1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-topics --bootstrap-server localhost:9093 --describe --topic t1 \
		--command-config /etc/kafka/admin.properties"

test_kafkacat_3:
	kafkacat -b localhost:19093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:29093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:39093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=consumer -X sasl.password=consumer-secret

all_3: up_3 wait acl test_3 down

up_4:
	docker-compose -f zk.yml -f single-sasl-scram.yml up -d

test_4:
	# kafkacat -b localhost:9093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=SCRAM-SHA-256 -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:9093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=SCRAM-SHA-256 -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:9093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=SCRAM-SHA-256 -X sasl.username=consumer -X sasl.password=consumer-secret

all_4: up_4 wait scram_clients test_4 down
