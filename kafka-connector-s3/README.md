# Demo Aiven Kafka Connector for S3

## Pre-requisites

- Kafka binaries (e.g. `kafka-topics.sh`)
- kfk-ctx (`brew install jeqo/tap/kfk-ctx`)
- kfk-producer-datagen (`brew install jeqo/tap/kfk-producer-datagen`)
- kcat
- curl

## How to run 

Start environment with `docker compose up -d`

Create a topic:

```
$KAFKA_HOME/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic t1
```

Write some data using producer datagen:

```
kfk-producer-datagen interval --kafka default -t t1 -n 10 -q TRANSACTIONS 
```

Check data being written with kcat:

```
kcat -b localhost:9092 -C -t t1 -f '%t-%p-%o: key=[%k] value=[%s]\n'
```

Deploy Connector:

```
curl -XPOST -H 'Content-type: application/json' http://localhost:8083/connectors --data @connector.json 
```

Check data is written to MinIO, accessing console: <http://localhost:9090> (minioadmin/minioadmin).
