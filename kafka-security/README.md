# Kafka Security

## Scenario 0: No Authentication

```bash
make all_0
```

## Scenario 1: Client-Server SASL/Plain Authentication

```bash
make all_1
```

## Scenario 2: Client-Server SASL/Plain Authentication with ACL

```bash
make all_2
```

## Scenario 3: Inter-Broker SASL/Plain Authentication with ACL

```bash
make all_3
```

## Scenario 4: Client-Server SASL/SCRAM Authentication

//TODO not working yet.

```bash
make test_4
# kafkacat -b localhost:9093 -L -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=SCRAM-SHA-256 -X sasl.username=admin -X sasl.password=admin-secret
echo 'test' | kafkacat -b localhost:9092 -P -t t1 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanism=SCRAM-SHA-256 -X sasl.username=producer -X sasl.password=producer-secret
%3|1593003094.302|FAIL|rdkafka#producer-1| [thrd:sasl_plaintext://localhost:9092/bootstrap]: sasl_plaintext://localhost:9092/bootstrap: SASL SCRAM-SHA-256 mechanism handshake failed: Broker: Request not valid in current SASL state: broker's supported mechanisms:  (after 3ms in state AUTH_HANDSHAKE)
% ERROR: Local: Authentication failure: sasl_plaintext://localhost:9092/bootstrap: SASL SCRAM-SHA-256 mechanism handshake failed: Broker: Request not valid in current SASL state: broker's supported mechanisms:  (after 3ms in state AUTH_HANDSHAKE)
% ERROR: Local: All broker connections are down: 1/1 brokers are down : terminating
make: *** [test_4] Error 1
```

```bash
kafka1_1  | [2020-06-24 12:50:21,159] INFO [SocketServer brokerId=1] Failed authentication with /192.168.144.1 (Unsupported SASL mechanism SCRAM-SHA-512) (org.apache.kafka.common.network.Selector)
kafka1_1  | [2020-06-24 12:51:18,542] WARN [SocketServer brokerId=1] Unexpected error from /192.168.144.1; closing connection (org.apache.kafka.common.network.Selector)
kafka1_1  | java.lang.NullPointerException
kafka1_1  |     at org.apache.kafka.common.security.authenticator.SaslServerAuthenticator.handleSaslToken(SaslServerAuthenticator.java:432)
kafka1_1  |     at org.apache.kafka.common.security.authenticator.SaslServerAuthenticator.authenticate(SaslServerAuthenticator.java:269)
kafka1_1  |     at org.apache.kafka.common.network.KafkaChannel.prepare(KafkaChannel.java:177)
kafka1_1  |     at org.apache.kafka.common.network.Selector.pollSelectionKeys(Selector.java:547)
kafka1_1  |     at org.apache.kafka.common.network.Selector.poll(Selector.java:485)
kafka1_1  |     at kafka.network.Processor.poll(SocketServer.scala:893)
kafka1_1  |     at kafka.network.Processor.run(SocketServer.scala:792)
kafka1_1  |     at java.lang.Thread.run(Thread.java:748)
```

```bash
make all_4
```

## Scenario 5: Client-Server SASL/SCRAM Authentication with ACL

//TODO

## Scenario 6: Inter-Broker SASL/SCRAM Authentication with ACL

//TODO

## Scerario 6: Client-Server SSL Authentication

//TODO

## Scenario 7: Inter-Broker SSL Authentication

//TODO

## Scerario 8: Client-Server SASL SCRAM with SSL Authentication

//TODO

## Scenario 9: Inter-Broker SASL SCRAM with SSL Authentication

//TODO

## Scenario 10: Client-Server SASL/OAUTHBEARER Authentication

//TODO

## Scenario 11: Inter-Broker SASL/OAUTHBEARER Authentication

//TODO