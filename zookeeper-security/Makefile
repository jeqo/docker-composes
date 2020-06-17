all:

run-0:
	docker-compose up -d

zk-shell-0:
	${CONFLUENT_HOME}/bin/zookeeper-shell localhost:2181 ls /zookeeper

run-1:
	docker-compose -f single-sasl-digest-md5.yml up -d

run-1-logs:
	docker-compose -f single-sasl-digest-md5.yml logs -f

run-1-down:
	docker-compose -f single-sasl-digest-md5.yml docs

zk-shell-1:
	KAFKA_OPTS="-Djava.security.auth.login.config=./single-sasl-digest-md5/client.conf" ${CONFLUENT_HOME}/bin/zookeeper-shell localhost:2181 ls /zookeeper

zk-shell-1-bad:
	KAFKA_OPTS="-Djava.security.auth.login.config=./single-sasl-digest-md5/client-bad.conf" ${CONFLUENT_HOME}/bin/zookeeper-shell localhost:2181 ls /zookeeper