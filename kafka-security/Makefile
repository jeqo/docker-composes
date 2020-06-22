all:

wait:
	sleep 5

up_0:
	docker-compose -f single-no-auth.yml up -d

test_0:
	kafkacat -b localhost:9092 -L
	echo 'test' | kafkacat -b localhost:9092 -P -t t1
	kafkacat -b localhost:9092 -C -t t1 -c 1

down_0:
	docker-compose -f single-no-auth.yml down

all_0: up_0 wait test_0 down_0

up_1:
	docker-compose -f single-sasl-plain.yml up -d

test_1:
	kafkacat -b localhost:9093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=admin -X sasl.password=admin-secret
	echo 'test' | kafkacat -b localhost:9093 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=producer -X sasl.password=producer-secret
	kafkacat -b localhost:9093 -C -t t1 -c 1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=PLAIN -X sasl.username=consumer -X sasl.password=consumer-secret

down_1:
	docker-compose -f single-sasl-plain.yml down

all_1: up_1 wait test_1 down_1