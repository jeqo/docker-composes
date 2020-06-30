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

```bash
make all_4
```

## Scenario 5: Client-Server SASL/SCRAM Authentication with ACL

```bash
make all_5
```

## Scenario 6: Inter-Broker SASL/SCRAM Authentication with ACL

```bash
make all_6
```

## Scerario 7: Client-Server SSL Encryption

```bash
make pre_tls
make all_7
```

## Scenario 8: Inter-Broker SSL Encryption

```bash
make pre_tls
make all_8
```

## Scerario 9: Client-Server SSL Authentication

```bash
make pre_tls
make all_9
```

## Scerario 10: Client-Server SSL Authentication with ACL

```bash
make pre_tls
make all_10
```

## Scerario 11: Cluster SSL Authentication with ACL

```bash
make pre_tls_cluster
make all_11
```
