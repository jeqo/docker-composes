# Zookeeper Security

## Scenario 0: No security

Start a standalone Zookeeper server:

```bash
make run-0
```

And run a Zookeeper Shell:

```bash
make zk-shell-0
# ...
WatchedEvent state:SyncConnected type:None path:null
[config, quota]
```

## Scenario 1: SASL/Digest-MD5 Authentication between client and server

Start a Zookeeper with SASL-enabled:

```bash
make run-1
```

Run Zookeeper client with SASL Auth:

```bash
make zk-shell-1
# ...
WatchedEvent state:SyncConnected type:None path:null
[config, quota]
```

Then try with a wrong username/password:

```bash
make zk-shell-1-bad
# ...
WatchedEvent state:Disconnected type:None path:null
KeeperErrorCode = ConnectionLoss for /zookeeper
```

To avoid an `anonymous` user is able to connect, this variable forces clients to authenticate with SSL:

```
      ZOOKEEPER_REQUIRE_CLIENT_AUTH_SCHEME: sasl
```

## Scenario 2: SASL/Digest-MD5 Authentication between ensemble


