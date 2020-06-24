all:

wait:
	sleep 5

acl:
	docker-compose -f single-sasl-plain-acl.yml exec kafka1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-acls --bootstrap-server localhost:9093 --command-config /etc/kafka/super.properties \
		--add --allow-principal User:admin --topic t1 --operation Describe"
	docker-compose -f single-sasl-plain-acl.yml exec kafka1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-acls --bootstrap-server localhost:9093 --command-config /etc/kafka/super.properties \
		--add --allow-principal User:producer --topic t1 --producer"
	docker-compose -f single-sasl-plain-acl.yml exec kafka1 /bin/sh -c "KAFKA_OPTS='' \
		kafka-acls --bootstrap-server localhost:9093 --command-config /etc/kafka/super.properties \
		--add --allow-principal User:consumer --topic t1 --consumer --group g1"

scram_clients:
	docker-compose -f single-sasl-scram.yml exec zk1 /bin/sh -c "EXTRA_ARGS='' \
		kafka-configs --zookeeper localhost:2181 \
		--alter --entity-type users --entity-name admin \
		--add-config 'SCRAM-SHA-256=[iterations=8192,password=admin-secret],SCRAM-SHA-512=[iterations=8192,password=admin-secret]'"
	docker-compose -f single-sasl-scram.yml exec zk1 /bin/sh -c "EXTRA_ARGS='' \
		kafka-configs --zookeeper localhost:2181 \
		--alter --entity-type users --entity-name producer \
		--add-config 'SCRAM-SHA-256=[iterations=8192,password=producer-secret],SCRAM-SHA-512=[iterations=8192,password=producer-secret]'"
	docker-compose -f single-sasl-scram.yml exec zk1 /bin/sh -c "EXTRA_ARGS='' \
		kafka-configs --zookeeper localhost:2181 \
		--alter --entity-type users --entity-name consumer \
		--add-config 'SCRAM-SHA-256=[iterations=8192,password=consumer-secret],SCRAM-SHA-512=[iterations=8192,password=consumer-secret]'"

up_0:
	docker-compose -f single-no-auth.yml up -d

test_0:
	kafkacat -b localhost:9092 -L
	echo 'test' | kafkacat -b localhost:9092 -P -t t1
	kafkacat -b localhost:9092 -C -t t1 -c 1

down_0:
	docker-compose -f single-no-auth.yml down

all_0: up_0 wait test_0 down_0

up_1:
	docker-compose -f single-sasl-plain.yml up -d

test_1:
	kafkacat -b localhost:9093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:9093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:9093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=consumer -X sasl.password=consumer-secret

down_1:
	docker-compose -f single-sasl-plain.yml down

all_1: up_1 wait test_1 down_1

up_2:
	docker-compose -f single-sasl-plain-acl.yml up -d

test_2:
	kafkacat -b localhost:9093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:9093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:9093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=consumer -X sasl.password=consumer-secret

down_2:
	docker-compose -f single-sasl-plain-acl.yml down

all_2: up_2 wait acl test_2 down_2

up_3:
	docker-compose -f cluster-sasl-plain-acl.yml up -d

test_3:
	kafkacat -b localhost:19093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:29093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:39093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=consumer -X sasl.password=consumer-secret

down_3:
	docker-compose -f cluster-sasl-plain-acl.yml down

all_3: up_3 wait acl test_3 down_3

up_4:
	docker-compose -f single-sasl-scram.yml up -d

test_4:
	# kafkacat -b localhost:9093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=SCRAM-SHA-256 -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:9093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=SCRAM-SHA-256 -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:9093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=SCRAM-SHA-256 -X sasl.username=consumer -X sasl.password=consumer-secret

down_4:
	docker-compose -f single-sasl-scram.yml down

all_4: up_4 wait scram_clients test_4 down_4

