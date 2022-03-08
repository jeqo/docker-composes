FROM confluentinc/cp-kafka-connect-base:7.0.1
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:0.5.2
RUN confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:1.6.1
RUN confluent-hub install --no-prompt jcustenborder/kafka-config-provider-aws:0.1.1