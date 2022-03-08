FROM confluentinc/cp-kafka-connect-base:7.0.1

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:latest
RUN confluent-hub install --no-prompt debezium/debezium-connector-mysql:latest
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-oracle-cdc:latest