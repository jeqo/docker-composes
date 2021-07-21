all: keys

keys:
	rm -rf conf
	mkdir -p conf
	openssl genrsa -out ./conf/keypair.pem 2048
	openssl rsa -in ./conf/keypair.pem -outform PEM -pubout -out ./conf/public.pem

up_ldap:
	docker-compose -f ldap.yml up -d

up_rbac_kafka:
	docker-compose -f rbac-kafka.yml -f monitor.yml up -d

up_rbac_sr:
	docker-compose -f ldap.yml -f rbac-kafka.yml -f rbac-sr.yml up -d

up_rbac_connect:
	docker-compose -f ldap.yml -f rbac-kafka.yml -f rbac-connect.yml up -d

down:
	docker-compose -f ldap.yml down --remove-orphans

get_cluster_id:
	curl -s http://localhost:8091/v1/metadata/id | jq -r ".id"

rbac_sr:
	${CONFLUENT_HOME}/bin/confluent iam rolebinding create \
		--principal User:schemaregistryUser \
		--role SecurityAdmin \
		--kafka-cluster-id ${KAFKA_CLUSTER_ID} \
		--schema-registry-cluster-id schema-registry
	${CONFLUENT_HOME}/bin/confluent iam rolebinding create \
		--principal User:schemaregistryUser \
		--role ResourceOwner \
		--kafka-cluster-id ${KAFKA_CLUSTER_ID} \
		--resource Group:schema-registry
	${CONFLUENT_HOME}/bin/confluent iam rolebinding create \
		--principal User:schemaregistryUser \
		--role ResourceOwner \
		--kafka-cluster-id ${KAFKA_CLUSTER_ID} \
		--resource Topic:_schemas
	${CONFLUENT_HOME}/bin/confluent iam rolebinding create \
		--principal User:schemaregistryUser \
		--role ResourceOwner \
		--kafka-cluster-id ${KAFKA_CLUSTER_ID} \
		--resource Topic:_confluent-license

rbac_connect:
	${CONFLUENT_HOME}/bin/confluent iam rolebinding create \
		--principal User:connectAdmin \
		--role SecurityAdmin \
		--kafka-cluster-id ${KAFKA_CLUSTER_ID} \
		--connect-cluster-id connect-cluster
	${CONFLUENT_HOME}/bin/confluent iam rolebinding create \
		--principal User:connectAdmin \
		--role ResourceOwner \
		--kafka-cluster-id ${KAFKA_CLUSTER_ID} \
		--resource Group:connect-cluster
	${CONFLUENT_HOME}/bin/confluent iam rolebinding create \
		--principal User:connectAdmin \
		--role ResourceOwner \
		--kafka-cluster-id ${KAFKA_CLUSTER_ID} \
		--resource Topic:connect-configs
	${CONFLUENT_HOME}/bin/confluent iam rolebinding create \
		--principal User:connectAdmin \
		--role ResourceOwner \
		--kafka-cluster-id ${KAFKA_CLUSTER_ID} \
		--resource Topic:connect-offsets
	${CONFLUENT_HOME}/bin/confluent iam rolebinding create \
		--principal User:connectAdmin \
		--role ResourceOwner \
		--kafka-cluster-id ${KAFKA_CLUSTER_ID} \
		--resource Topic:connect-status
ps:
	docker-compose -f ldap.yml -f rbac-kafka.yml -f rbac-sr.yml -f monitor.yml ps

logs:
	docker-compose -f ldap.yml -f kafka.yml -f monitor.yml logs -f ${SVC}