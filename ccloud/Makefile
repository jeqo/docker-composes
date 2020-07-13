all:

environment:

CLUSTER_ID=lkc-212oy

sr_service_account:
	ccloud service-account create test-cp-sr --description "Cluster: test-cp, Schema Registry account"
sr_get_service_account:
	ccloud service-account list -o json | jq -r '.[] | select(.name=="test-cp-sr") | .id'

SR_SA_ID = 88591
sr_acls:
	ccloud kafka acl create --allow --service-account "${SR_SA_ID}" --operation "READ" --operation "WRITE" --operation "CREATE" --operation "DESCRIBE" --prefix --topic "_schemas_cp"
	ccloud kafka acl create --allow --service-account "${SR_SA_ID}" --operation "READ" --operation "DESCRIBE" --consumer-group "schema-registry"

sr_api_keys:
	ccloud api-key create --service-account "${SR_SA_ID}" --resource "${CLUSTER_ID}"

rest_topics:
	ccloud kafka topic create proxy --partitions 12

rest_service_account:
	ccloud service-account create test-cp-rest --description "Cluster: test-cp, REST Proxy account"
rest_get_service_account:
	ccloud service-account list -o json | jq -r '.[] | select(.name=="test-cp-rest") | .id'

REST_SA_ID = 88608
rest_acls:
	ccloud kafka acl create --allow --service-account "${REST_SA_ID}" --operation "WRITE" --operation "DESCRIBE" --topic "proxy"
	ccloud kafka acl create --allow --service-account "${REST_SA_ID}" --operation "READ" --operation "DESCRIBE" --topic "proxy"
	ccloud kafka acl create --allow --service-account "${REST_SA_ID}" --operation "READ" --consumer-group "rest-proxy"

rest_api_keys:
	ccloud api-key create --service-account "${REST_SA_ID}" --resource "${CLUSTER_ID}"

rest_produce:
	curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" \
      -H "Accept: application/vnd.kafka.v2+json" \
      --data '{"value_schema": "{\"type\": \"record\", \"name\": \"User\", \"fields\": [{\"name\": \"name\", \"type\": \"string\"}]}", "records": [{"value": {"name": "testUser"}}]}' \
      "http://localhost:8082/topics/proxy"

rest_consumer_instance:
	curl -X POST  -H "Content-Type: application/vnd.kafka.v2+json" \
      --data '{"name": "rest-proxy-instance", "format": "avro", "auto.offset.reset": "earliest"}' \
      http://localhost:8082/consumers/rest-proxy

rest_consumer_subscription:
	curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["proxy"]}' \
      http://localhost:8082/consumers/rest-proxy/instances/rest-proxy-instance/subscription

rest_consumer_poll:
	curl -X GET -H "Accept: application/vnd.kafka.avro.v2+json" \
      http://localhost:8082/consumers/rest-proxy/instances/rest-proxy-instance/records