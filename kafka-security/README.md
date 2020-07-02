# Kafka Security

## Scenario 0: No Authentication

```bash
make all_no_auth
```

## Scenario 1: Client-Server SASL/Plain Authentication

```bash
make all_single_sasl_plain
```

## Scenario 2: Client-Server SASL/Plain Authentication with ACL

```bash
make all_single_sasl_plain_acl
```

## Scenario 3: Inter-Broker SASL/Plain Authentication with ACL

```bash
make all_cluster_sasl_plain_acl
```

## Scenario 4: Client-Server SASL/SCRAM Authentication

```bash
make all_single_sasl_scram
```

## Scenario 5: Client-Server SASL/SCRAM Authentication with ACL

```bash
make all_single_sasl_scram_acl
```

## Scenario 6: Inter-Broker SASL/SCRAM Authentication with ACL

```bash
make all_cluster_sasl_scram_acl
```

## Scerario 7: Client-Server SSL Encryption

```bash
make all_single_tls
```

## Scenario 8: Inter-Broker SSL Encryption

```bash
make all_cluster_tls
```

## Scerario 9: Client-Server SSL Authentication

```bash
make all_single_mtls
```

## Scerario 10: Client-Server SSL Authentication with ACL

```bash
make all_single_mtls_acl
```

## Scerario 11: Cluster SSL Authentication with ACL

```bash
make all_cluster_mtls_acl
```

## Scerario 12: Cluster SASL/Plain SSL-encrypted Authentication with ACL

```bash
make all_cluster_plain_ssl_acl
```

## Scerario 13: Cluster SASL/SCRAM SSL-encrypted Authentication with ACL

```bash
make all_cluster_scram_ssl_acl
```

## Scerario 14: Cluster SASL/SCRAM mutual-TLS-encrypted Authentication with ACL

```bash
make all_cluster_scram_mtls_acl
```