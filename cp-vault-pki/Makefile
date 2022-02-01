VAULT_ADDR := http://localhost:8200
VAULT_ADDR_INTERNAL := http://vault:8200
VAULT_TOKEN := root
export VAULT_ADDR
export VAULT_TOKEN

DEFAULT_PASSWORD := changeme

all:

clean:
	rm -rf ./pki
	mkdir -p ./pki

root_ca:
	echo "Configuring Root CA @ ${VAULT_ADDR}"
	vault secrets enable -path root-ca pki
	vault secrets tune -max-lease-ttl=8760h root-ca
	vault write -field certificate root-ca/root/generate/internal \
		common_name="Acme Root CA" \
		ttl=8760h > ./pki/root-ca.pem

	vault write root-ca/config/urls \
		issuing_certificates="${VAULT_ADDR_INTERNAL}/v1/root-ca/ca" \
		crl_distribution_points="${VAULT_ADDR_INTERNAL}/v1/root-ca/crl"

intermediate_ca:
	echo "Configuring Intermediary CA @ ${VAULT_ADDR}"
	vault secrets enable -path kafka-int-ca pki
	vault secrets tune -max-lease-ttl=8760h kafka-int-ca

	vault write -field=csr kafka-int-ca/intermediate/generate/internal \
		common_name="Acme Kafka Intermediate CA" ttl=43800h > ./pki/kafka-int-ca.csr

	vault write -field=certificate root-ca/root/sign-intermediate csr=@./pki/kafka-int-ca.csr \
		format=pem_bundle ttl=43800h > ./pki/kafka-int-ca.pem

	vault write kafka-int-ca/intermediate/set-signed certificate=@./pki/kafka-int-ca.pem
	vault write kafka-int-ca/config/urls \
		issuing_certificates="${VAULT_ADDR_INTERNAL}/v1/kafka-int-ca/ca" \
		crl_distribution_points="${VAULT_ADDR_INTERNAL}/v1/kafka-int-ca/crl"

pki_roles:
	echo "Configuring kafka-client PKI role"
	vault write kafka-int-ca/roles/kafka-client \
		allowed_domains=clients.kafka.acme.com \
		allow_subdomains=true max_ttl=1h

	echo "---> Configuring kafka-server PKI role"
	vault write kafka-int-ca/roles/kafka-server \
		allowed_domains=servers.kafka.acme.com \
		allow_subdomains=true max_ttl=72h

token_roles:
	echo "---> Configuring kafka-client token role"
	vault policy write kafka-client ./vault/kafka-client.hcl
	vault write auth/token/roles/kafka-client \
		allowed_policies=kafka-client period=24h
	echo "---> Configuring kafka-server token role"
	vault policy write kafka-server ./vault/kafka-server.hcl
	vault write auth/token/roles/kafka-server \
		allowed_policies=kafka-server period=24h

truststore:
	if [ -f ./pki/kafka-truststore.jks ]; then rm ./pki/kafka-truststore.jks; fi
	keytool -import -alias root-ca -trustcacerts -file ./pki/root-ca.pem \
		-keystore ./pki/kafka-truststore.jks -storepass ${DEFAULT_PASSWORD} -noprompt
	keytool -import -alias kafka-int-ca -trustcacerts -file ./pki/kafka-int-ca.pem \
		-keystore ./pki/kafka-truststore.jks -storepass ${DEFAULT_PASSWORD} -noprompt
	echo "${DEFAULT_PASSWORD}" > ./pki/kafka_truststore_credential

broker_keystore:
	echo "---> Configuring Kafka broker"
	vault write -field certificate kafka-int-ca/issue/kafka-server \
		common_name=broker-1.servers.kafka.acme.com alt_names=localhost \
		format=pem_bundle > ./pki/kafka-broker-1.pem
	openssl pkcs12 -inkey ./pki/kafka-broker-1.pem -in ./pki/kafka-broker-1.pem -name kafka-broker-1 \
		-export -out ./pki/kafka-broker-1.p12 -passin pass:${DEFAULT_PASSWORD} -passout pass:${DEFAULT_PASSWORD}
	echo "${DEFAULT_PASSWORD}" > ./pki/kafka_broker_1_key_credential

	keytool -importkeystore -deststorepass ${DEFAULT_PASSWORD} \
		-destkeystore ./pki/kafka-broker-1-keystore.jks -srckeystore ./pki/kafka-broker-1.p12 \
		-srcstoretype PKCS12 -srcstorepass ${DEFAULT_PASSWORD} -noprompt
	echo "${DEFAULT_PASSWORD}" > ./pki/kafka_broker_1_keystore_credential

client_token:
	vault token create -field=token -role kafka-client

producer_keystore:
	vault write -field certificate kafka-int-ca/issue/kafka-client \
		common_name=console-producer.clients.kafka.acme.com format=pem_bundle > ./pki/console-producer.pem
	cat ./pki/console-producer.pem |openssl x509 -text |grep -a10 Certificate:
	openssl pkcs12 -inkey ./pki/console-producer.pem -in ./pki/console-producer.pem -name console-producer -export \
		-out ./pki/console-producer.p12 -passin pass:${DEFAULT_PASSWORD} -passout pass:${DEFAULT_PASSWORD}

consumer_keystore:
	vault write -field certificate kafka-int-ca/issue/kafka-client \
		common_name=console-consumer.clients.kafka.acme.com format=pem_bundle > ./pki/console-consumer.pem
	cat ./pki/console-consumer.pem |openssl x509 -text |grep -a10 Certificate:
	openssl pkcs12 -inkey ./pki/console-consumer.pem -in ./pki/console-consumer.pem -name console-consumer -export \
		-out ./pki/console-consumer.p12 -passin pass:${DEFAULT_PASSWORD} -passout pass:${DEFAULT_PASSWORD}

KAFKA_TOPIC := test

kafka_topic:
	${KAFKA_HOME}/bin/kafka-topics.sh --topic ${KAFKA_TOPIC} --bootstrap-server localhost:9092 --create

consumer_run:
	${KAFKA_HOME}/bin/kafka-console-consumer.sh --topic ${KAFKA_TOPIC} --bootstrap-server localhost:9093 \
		--consumer.config ./config/consumer.properties

producer_run:
	${KAFKA_HOME}/bin/kafka-console-producer.sh --topic ${KAFKA_TOPIC} --bootstrap-server localhost:9093 \
		--producer.config ./config/producer.properties

destroy:
	docker-compose down --remove-orphans
	make clean

vault_up:
	docker-compose up -d vault

kafka_up:
	docker-compose up -d zookeeper kafka

wait_5:
	sleep 5

vault_pki_and_keys: vault_up wait_5 root_ca intermediate_ca pki_roles token_roles truststore broker_keystore

kafka_and_topics: kafka_up wait_5 wait_5 wait_5 kafka_topic

prep: clean vault_pki_and_keys kafka_and_topics
