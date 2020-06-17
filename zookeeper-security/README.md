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

## Scenario 1: SASL/Digest-MD5 Authentication

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

**But** when authenticating without username/password, i.e. anonymous:

```bash
make zk-shell-0
# ...
WatchedEvent state:SyncConnected type:None path:null
[config, quota]
```

Based on this issue, this is the expected behaviour: <https://issues.apache.org/jira/browse/ZOOKEEPER-1736>. ACLs are suppose to fix this.