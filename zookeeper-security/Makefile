all:

wait:
	sleep 5

# Scenario 0: Single-Cluster no Auth.
all_0: up_0 wait test_0 down_0

up_0:
	docker-compose -f single-no-auth.yml up -d

logs_0:
	docker-compose -f single-no-auth.yml logs -f

down_0:
	docker-compose -f single-no-auth.yml down

test_0:
	${CONFLUENT_HOME}/bin/zookeeper-shell localhost:2181 create /test data
	${CONFLUENT_HOME}/bin/zookeeper-shell localhost:2181 get /test

# Scenario 1: Single Cluster, SASL Auth w/Digest-MD5
all_1: up_1 wait test_1 test_1_acl test_1_bad down_1

up_1:
	docker-compose -f single-sasl-digest-md5.yml up -d

logs_1:
	docker-compose -f single-sasl-digest-md5.yml logs -f

down_1:
	docker-compose -f single-sasl-digest-md5.yml down

test_1:
	KAFKA_OPTS="-Djava.security.auth.login.config=./single-sasl-digest-md5/client.conf" ${CONFLUENT_HOME}/bin/zookeeper-shell localhost:2181 create /test data
	KAFKA_OPTS="-Djava.security.auth.login.config=./single-sasl-digest-md5/client.conf" ${CONFLUENT_HOME}/bin/zookeeper-shell localhost:2181 create /test-acl data sasl:kafka:cdrwa
	KAFKA_OPTS="-Djava.security.auth.login.config=./single-sasl-digest-md5/client-bad.conf" ${CONFLUENT_HOME}/bin/zookeeper-shell localhost:2181 ls /zookeeper

# Scenario 2: Ensemble, No Auth.
all_2: up_2 wait test_2 down_2

up_2:
	docker-compose -f cluster-no-auth.yml up -d
	
down_2:
	docker-compose -f cluster-no-auth.yml down

logs_2:
	docker-compose -f cluster-no-auth.yml logs -f

# Scenario 2: Ensemble, No Auth.
all_2: up_2 wait test_2 down_2
test_2:
	${CONFLUENT_HOME}/bin/zookeeper-shell localhost:12181 ls /
	${CONFLUENT_HOME}/bin/zookeeper-shell localhost:22181 create /test data
	${CONFLUENT_HOME}/bin/zookeeper-shell localhost:32181 get /test

# Scenario 3: Ensemble, SASL Auth w/Digest-MD5
all_2: up_2 wait test_2 down_2
all_3: up_3 wait test_3 down_3 
up_3:
	docker-compose -f cluster-sasl-digest-md5.yml up -d
	
down_3:
	docker-compose -f cluster-sasl-digest-md5.yml down

logs_3:
	docker-compose -f cluster-sasl-digest-md5.yml logs -f

test_3:
	KAFKA_OPTS="-Djava.security.auth.login.config=./single-sasl-digest-md5/client.conf" ${CONFLUENT_HOME}/bin/zookeeper-shell localhost:12181 ls /
	KAFKA_OPTS="-Djava.security.auth.login.config=./single-sasl-digest-md5/client.conf" ${CONFLUENT_HOME}/bin/zookeeper-shell localhost:22181 create /test-acl data sasl:kafka:cdrwa
	KAFKA_OPTS="-Djava.security.auth.login.config=./single-sasl-digest-md5/client.conf" ${CONFLUENT_HOME}/bin/zookeeper-shell localhost:32181 get /test
	KAFKA_OPTS="-Djava.security.auth.login.config=./single-sasl-digest-md5/client-bad.conf" ${CONFLUENT_HOME}/bin/zookeeper-shell localhost:12181 ls /zookeeper
	KAFKA_OPTS="-Djava.security.auth.login.config=./single-sasl-digest-md5/client.conf" ${CONFLUENT_HOME}/bin/zookeeper-shell localhost:42181 get /test