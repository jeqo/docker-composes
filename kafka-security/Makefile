all:

up_zk:
	docker-compose -f zk.yml up -d zk1

logs_kafka:
	docker logs -f kafka-security_kafka1_1

logs_kafka_2:
	docker logs -f kafka-security_kafka2_1

logs_kafka_3:
	docker logs -f kafka-security_kafka3_1

wait:
	sleep 15

acl:
	docker exec kafka-security_kafka-client_1 /bin/sh -c " \
		kafka-acls --bootstrap-server kafka1:19093 --command-config /etc/kafka/super.properties \
		--add --allow-principal User:admin --topic t1 --operation ALL --cluster"
	docker exec kafka-security_kafka-client_1 /bin/sh -c " \
		kafka-acls --bootstrap-server kafka1:19093 --command-config /etc/kafka/super.properties \
		--add --allow-principal User:producer --topic t1 --producer"
	docker exec kafka-security_kafka-client_1  /bin/sh -c " \
		kafka-acls --bootstrap-server kafka1:19093 --command-config /etc/kafka/super.properties \
		--add --allow-principal User:consumer --topic t1 --consumer --group g1"

scram_brokers:
	docker exec kafka-security_zk1_1  /bin/sh -c "EXTRA_ARGS='' \
		kafka-configs --zookeeper localhost:2181 \
		--alter --entity-type users --entity-name kafkabroker \
		--add-config 'SCRAM-SHA-256=[iterations=8192,password=kafkabroker-secret],SCRAM-SHA-512=[iterations=8192,password=kafkabroker-secret]'"

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

test:
	docker exec kafka-security_kafka-client_1 /bin/sh -c " \
		kafka-producer-perf-test --producer-props bootstrap.servers=kafka1:19093 --topic t1 --num-records 100 --record-size 1000 --throughput 10 \
		--producer.config /etc/kafka/producer.properties"
	docker exec kafka-security_kafka-client_1 /bin/sh -c " \
		kafka-consumer-perf-test --bootstrap-server kafka1:19093 --topic t1 --messages 10 --group g1 \
		--consumer.config /etc/kafka/consumer.properties"
	docker exec kafka-security_kafka-client_1 /bin/sh -c " \
		kafka-topics --bootstrap-server kafka1:19093 --describe --topic t1 \
		--command-config /etc/kafka/admin.properties"

down:
	docker-compose -f zk.yml down --remove-orphans

up_no_auth:
	docker-compose -f zk.yml -f single-no-auth.yml up -d

test_no_auth:
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

all_no_auth: up_no_auth wait test_no_auth down

up_single_sasl_plain:
	docker-compose -f zk.yml -f single-sasl-plain.yml up -d


test_kafkacat_single_sasl_plain:
	kafkacat -b localhost:9093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:9093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:9093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=consumer -X sasl.password=consumer-secret

all_single_sasl_plain: up_single_sasl_plain wait test down

up_single_sasl_plain_acl:
	docker-compose -f zk.yml -f single-sasl-plain-acl.yml up -d

test_kafkacat_single_sasl_plain_acl:
	kafkacat -b localhost:9093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:9093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:9093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=consumer -X sasl.password=consumer-secret

all_single_sasl_plain_acl: up_single_sasl_plain_acl wait acl test down

up_cluster_sasl_plain_acl:
	docker-compose -f zk.yml -f cluster-sasl-plain-acl.yml up -d

test_kafkacat_cluster_sasl_plain_acl:
	kafkacat -b localhost:19093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:29093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:39093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=consumer -X sasl.password=consumer-secret

all_cluster_sasl_plain_acl: up_cluster_sasl_plain_acl wait acl test down

up_single_sasl_scram:
	docker-compose -f zk.yml -f single-sasl-scram.yml up -d

test_kafkacat_single_sasl_scram:
	kafkacat -b localhost:9093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=SCRAM-SHA-256 -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:9093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=SCRAM-SHA-256 -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:9093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=SCRAM-SHA-256 -X sasl.username=consumer -X sasl.password=consumer-secret

all_single_sasl_scram: up_single_sasl_scram wait scram_clients test down

up_single_sasl_scram_acl:
	docker-compose -f zk.yml -f single-sasl-scram-acl.yml up -d

all_single_sasl_scram_acl: up_single_sasl_scram_acl wait scram_brokers scram_clients acl test down

up_cluster_sasl_scram_acl:
	docker-compose -f zk.yml -f cluster-sasl-scram-acl.yml up -d

all_cluster_sasl_scram_acl: up_zk wait scram_brokers up_cluster_sasl_scram_acl wait scram_clients acl test down

PASSWORD=test1234
CA_PASSPHRASE=${PASSWORD}

.PHONY: ca
ca:
	rm -rf ./ca
	mkdir -p ./ca/private
	openssl req -new -x509 -keyout ca/private/ca.key -out ca/ca.crt -days 365 -nodes -subj "/C=GB/ST=London/L=London/O=Example/CN=ca.example.org" -passin pass:${CA_PASSPHRASE} -passout pass:${CA_PASSPHRASE}

TRUSTSTORE_PASSWORD=${PASSWORD}

truststore:
	rm -rf ./tls
	mkdir -p ./tls
	keytool -keystore ./tls/truststore.p12 -storetype PKCS12 -alias CARoot -import -file ./ca/ca.crt -storepass ${TRUSTSTORE_PASSWORD} -noprompt
	echo ${TRUSTSTORE_PASSWORD} > ./tls/truststore_credential

NODE=kafka1
KEYSTORE_PASSWORD=${PASSWORD}
KEY_PASSWORD=${PASSWORD}

keystore:
	rm -f ./tls/${NODE}.keystore.p12
	keytool -keystore ./tls/${NODE}.keystore.p12 -storetype PKCS12 -alias ${NODE} -dname "C=GB, ST=London, L=London, O=Example, CN=${NODE}.example.org" -genkey -keyalg RSA -storepass ${KEYSTORE_PASSWORD} -keypass ${KEY_PASSWORD} -noprompt
	echo ${KEYSTORE_PASSWORD} > ./tls/${NODE}_keystore_credential
	keytool -keystore ./tls/${NODE}.keystore.p12 -alias ${NODE} -certreq -file tls/${NODE}.csr -storepass ${KEYSTORE_PASSWORD} -keypass ${KEY_PASSWORD} -noprompt
	openssl x509 -req -CA ./ca/ca.crt -CAkey ./ca/private/ca.key -in ./tls/${NODE}.csr -out ./tls/${NODE}.crt -days 7 -CAcreateserial -passin pass:${KEY_PASSWORD}
	echo ${KEY_PASSWORD} > ./tls/${NODE}_key_credential
	keytool -keystore ./tls/${NODE}.keystore.p12 -alias CARoot -import -file ./ca/ca.crt -storepass ${KEYSTORE_PASSWORD} -noprompt
	keytool -keystore ./tls/${NODE}.keystore.p12 -alias ${NODE} -import -file ./tls/${NODE}.crt -storepass ${KEYSTORE_PASSWORD} -noprompt

keystore_cluster:
	make NODE=kafka2 keystore
	make NODE=kafka3 keystore

test_tls:
	openssl s_client -debug -connect localhost:9093 -tls1_2

pre_tls: ca truststore keystore

up_single_tls:
	docker-compose -f zk.yml -f single-one-way-tls.yml up -d

all_single_tls: pre_tls up_single_tls wait test down

pre_tls_cluster: pre_tls keystore_cluster

up_cluster_tls:
	docker-compose -f zk.yml -f cluster-one-way-tls.yml up -d

all_cluster_tls: pre_tls_cluster up_cluster_tls wait test down

keystore_clients:
	make NODE=admin keystore
	make NODE=consumer keystore
	make NODE=producer keystore

pre_mtls: ca truststore keystore keystore_clients

up_single_mtls:
	docker-compose -f zk.yml -f single-mutual-tls.yml up -d

all_single_mtls: pre_mtls up_single_mtls wait test down

acl_mtls:
	docker exec kafka-security_kafka-client_1 /bin/sh -c " \
		kafka-acls --bootstrap-server kafka1:19093 --command-config /etc/kafka/super.properties \
		--add --allow-principal User:C=GB,ST=London,L=London,O=Example,CN=admin.example.org --topic t1 --operation ALL --cluster"
	docker exec kafka-security_kafka-client_1 /bin/sh -c " \
		kafka-acls --bootstrap-server kafka1:19093 --command-config /etc/kafka/super.properties \
		--add --allow-principal User:C=GB,ST=London,L=London,O=Example,CN=producer.example.org --topic t1 --producer"
	docker exec kafka-security_kafka-client_1  /bin/sh -c " \
		kafka-acls --bootstrap-server kafka1:19093 --command-config /etc/kafka/super.properties \
		--add --allow-principal User:C=GB,ST=London,L=London,O=Example,CN=consumer.example.org --topic t1 --consumer --group g1"

up_single_mtls_acl:
	docker-compose -f zk.yml -f single-mutual-tls-acl.yml up -d

all_single_mtls_acl: pre_mtls up_single_mtls_acl wait acl_mtls test down

pre_mtls_cluster: pre_mtls keystore_cluster

up_cluster_mtls_acl: 
	docker-compose -f zk.yml -f cluster-mutual-tls-acl.yml up -d

all_cluster_mtls_acl: pre_mtls_cluster up_cluster_mtls_acl wait acl_mtls test down

up_cluster_sasl_plain_tls_acl: 
	docker-compose -f zk.yml -f cluster-sasl-plain-ssl-acl.yml up -d

all_cluster_sasl_plain_tls_acl: pre_tls_cluster up_cluster_sasl_plain_tls_acl wait acl test down

up_cluster_sasl_scram_tls_acl: 
	docker-compose -f zk.yml -f cluster-sasl-scram-ssl-acl.yml up -d

all_cluster_sasl_scram_tls_acl: pre_tls_cluster up_zk scram_brokers up_cluster_sasl_scram_tls_acl wait scram_clients acl test down

up_cluster_sasl_scram_mtls_acl: 
	docker-compose -f zk.yml -f cluster-sasl-scram-mtls-acl.yml up -d

all_cluster_sasl_scram_mtls_acl: pre_mtls_cluster up_zk scram_brokers up_cluster_sasl_scram_mtls_acl wait scram_clients acl test down