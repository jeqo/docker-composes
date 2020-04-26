.PHONY:all
all:

.PHONY: producer
producer:
	KAFKA_OPTS="-Djava.security.auth.login.config=/home/jeqo/src/github.com/jeqo/docker-composes/confluent-kafka-sasl-plain/secrets/client_jaas.conf" kafka-console-producer --broker-list localhost:29093 --topic test1 --producer.config=secrets/client.properties

.PHONY: up
up:
	docker-compose up -d

.PHONY: down
down:
	docker-compose down

.PHONY: ps
ps:
	docker-compose ps

.PHONY: print-listener
print-listener:
	docker-compose logs kafka-broker | grep -e 'Registered broker'
