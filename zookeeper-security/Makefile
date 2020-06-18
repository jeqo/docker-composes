all:

run-0:
	docker-compose -f single-no-auth up -d

zk-shell-0:
	${CONFLUENT_HOME}/bin/zookeeper-shell localhost:2181 ls /
	${CONFLUENT_HOME}/bin/zookeeper-shell localhost:2181 create /test data
	${CONFLUENT_HOME}/bin/zookeeper-shell localhost:2181 get /test

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

run-2:
	docker-compose -f cluster-no-auth.yml up -d

zk-shell-2:
	${CONFLUENT_HOME}/bin/zookeeper-shell localhost:12181 ls /
	${CONFLUENT_HOME}/bin/zookeeper-shell localhost:22181 create /test data
	${CONFLUENT_HOME}/bin/zookeeper-shell localhost:32181 get /test