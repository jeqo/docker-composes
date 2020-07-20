# Zookeeper deployment

## Single

```bash
make up-single
```

## Ensemble

```bash
make up-ensemble
```

## Observers

Scale Zookeeper nodes to handle a higher load without increasing the number of nodes required to form quorum.

Useful when enabling clients to access ensemble on different Datacenters.

```bash
make up-observers
```

Reference: <https://zookeeper.apache.org/doc/current/zookeeperObservers.html>

## Hierarchical

When deploying Zookeeper in 2 Data Centers, deploying an ensemble becomes difficult as Quorum ends up leaning into one of the datacenters.

Hierarchical deployment makes the weights even between DCs by paying the cost of adding an additional nodes.

The challenge is that quorum has to be maintained inside and outside the groups, so inside a group at least 3 nodes will be required, leading to a cluster with 6 nodes.

Reference: <https://zookeeper.apache.org/doc/current/zookeeperHierarchicalQuorums.html>