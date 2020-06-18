# Zookeeper Security

## Scenario 0: No security

Start a standalone Zookeeper server:

```bash
make up_0
```

And run a Zookeeper Shell:

```bash
make test_0
# ...
WatchedEvent state:SyncConnected type:None path:null
data
```

Or run all:

```bash
make -k all_1
```

Clean all:

```bash
make down_0
```

## Scenario 1: SASL/Digest-MD5 Authentication between client and server

Start a Zookeeper with SASL-enabled:

```bash
make up_1
```

Run Zookeeper client with SASL Auth:

```bash
make test_1
# ...
WatchedEvent state:SyncConnected type:None path:null
data
# ...
KeeperErrorCode = ConnectionLoss for /zookeeper
```

To avoid an `anonymous` user is able to connect, this variable forces clients to authenticate with SSL:

```
      ZOOKEEPER_REQUIRE_CLIENT_AUTH_SCHEME: sasl
```

To run all:

```bash
make -k all_1
```

Clean all:

```bash
make down_1
```

## Scenario 2: Ensemble with No Authentication

To run all:

```bash
make -k all_2
```

Clean all:

```bash
make down_2
```

## Scenario 3: Ensemble with SASL/Digest-MD5 Authentication

To run all:

```bash
make -k all_3
```

Clean all:

```bash
make down_3
```
