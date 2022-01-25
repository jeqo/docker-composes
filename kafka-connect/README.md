# Kafka Connect

## Commands

### Deploy Connector

```shell
curl -XPOST -H "Content-Type: application/json" \
  --data @connectors/datagen-source.json \
  http://localhost:8083/connectors
```

### List Connectors

```shell
curl http://localhost:8083/connectors
```

### Delete Connector

```shell
curl -XDELETE http://localhost:8083/connectors/datagen-users
```
