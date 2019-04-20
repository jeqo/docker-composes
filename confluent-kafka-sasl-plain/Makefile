.PHONY:all
all:

.PHONY: producer
producer:
	KAFKA_OPTS="-Djava.security.auth.login.config=/home/jeqo/src/github.com/jeqo/docker-composes/confluent-kafka-sasl-plain/secrets/client_jaas.conf" kafka-console-producer --broker-list localhost:29093 --topic test1 --producer.config=secrets/client.properties

.PHONY: docker
docker:
	docker-compose up -d

