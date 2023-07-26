rsa:
	openssl genrsa -des3 -out plugins/private.pem 512
	openssl rsa -in plugins/private.pem -outform PEM -pubout -out plugins/public.pem
	openssl rsa -in plugins/private.pem -out plugins/private_unencrypted.pem -outform PEM

topic:
	${KAFKA_HOME}/bin/kafka-topics.sh \
		--bootstrap-server localhost:9092 \
		--create \
		--config segment.bytes=1000000 \
		--config retention.bytes=100000000 \
		--config remote.storage.enable=true \
		--config local.retention.bytes=5000000 \
		--partitions 6 \
		--topic t1
		
