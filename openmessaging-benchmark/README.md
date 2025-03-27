# OpenMessaging Benchmark (OMB)

## How to run

Download OMB binaries (or build from source):

```bash
make get_omb
```

Build image:

```bash
docker compose build
```
or 
```bash
make build
```

Start compose:

```bash
docker compose up -d
```

Run OMB:

```bash
cd openmessaging-benchmark-0.0.1-SNAPSHOT
./bin/benchmark -wf ../workers.yml -d ../kafka.yml ../workloads/test.yml
```

This will run a simple workload on a small Kafka cluster included in the docker-compose file
by connecting to 2 OMB workers on their HTTP endpoints.

Sample output:

```text
00:04:29.937 [main] INFO Benchmark - Reading workers list from ../workers.yml
00:04:29.956 [main] INFO Benchmark - Starting benchmark with config: {
  "drivers" : [ "../kafka.yml" ],
  "workers" : [ "http://localhost:8080", "http://localhost:18080" ],
  "workersFile" : "/Users/jorge.quilcate/src/github.com/jeqo/docker-composes/openmessaging-benchmark/openmessaging-benchmark-0.0.1-SNAPSHOT/../workers.yml",
  "workloads" : [ "../workloads/test.yml" ],
  "output" : null
}
00:04:29.962 [main] INFO Benchmark - Workloads: {
  "test" : {
    "name" : "test",
    "topics" : 3,
    "partitionsPerTopic" : 1,
    "keyDistributor" : "NO_KEY",
    "messageSize" : 1024,
    "useRandomizedPayloads" : true,
    "randomBytesRatio" : 0.5,
    "randomizedPayloadPoolSize" : 1000,
    "payloadFile" : null,
    "subscriptionsPerTopic" : 1,
    "producersPerTopic" : 1,
    "consumerPerSubscription" : 1,
    "producerRate" : 1000,
    "consumerBacklogSizeGB" : 0,
    "backlogDrainRatio" : 1.0,
    "testDurationMinutes" : 5,
    "warmupDurationMinutes" : 1
  }
}
00:04:30.092 [main] INFO DistributedWorkersEnsemble - Workers list - producers: [http://localhost:8080]
00:04:30.092 [main] INFO DistributedWorkersEnsemble - Workers list - consumers: http://localhost:18080
00:04:30.094 [main] INFO Benchmark - --------------- WORKLOAD : test --- DRIVER : Kafka---------------
00:04:31.439 [main] INFO WorkloadGenerator - Created 3 topics in 62.076584 ms
00:04:31.456 [main] INFO WorkloadGenerator - Created 3 consumers in 13.450125 ms
00:04:31.475 [main] INFO WorkloadGenerator - Created 3 producers in 19.388125 ms
00:04:31.476 [main] INFO WorkloadGenerator - Waiting for consumers to be ready
00:04:31.493 [main] INFO WorkloadGenerator - Waiting for topics to be ready -- Sent: 0, Received: 0
00:04:33.497 [main] INFO WorkloadGenerator - Waiting for topics to be ready -- Sent: 3, Received: 0
00:04:35.506 [main] INFO WorkloadGenerator - Waiting for topics to be ready -- Sent: 3, Received: 3
00:04:35.507 [main] INFO WorkloadGenerator - All consumers are ready
00:04:35.558 [main] INFO WorkloadGenerator - ----- Starting warm-up traffic (1m) ------
00:04:45.929 [main] INFO WorkloadGenerator - Pub rate   966.4 msg/s /  0.9 MB/s | Pub err     0.0 err/s | Cons rate   966.7 msg/s /  0.9 MB/s | Backlog:  0.0 K | Pub Latency (ms) avg:  2.8 - 50%:  2.4 - 99%: 25.9 - 99.9%: 54.7 - Max: 59.6 | Pub Delay Latency (us) avg: 975.1 - 50%: 1043.0 - 99%: 1443.0 - 99.9%: 4014.0 - Max: 7198.0
00:04:56.297 [main] INFO WorkloadGenerator - Pub rate   999.6 msg/s /  1.0 MB/s | Pub err     0.0 err/s | Cons rate   999.2 msg/s /  1.0 MB/s | Backlog:  0.0 K | Pub Latency (ms) avg:  2.2 - 50%:  2.4 - 99%:  2.8 - 99.9%:  8.5 - Max: 18.9 | Pub Delay Latency (us) avg: 992.7 - 50%: 1057.0 - 99%: 1383.0 - 99.9%: 3019.0 - Max: 8506.0
00:05:06.685 [main] INFO WorkloadGenerator - Pub rate   998.0 msg/s /  1.0 MB/s | Pub err     0.0 err/s | Cons rate   998.0 msg/s /  1.0 MB/s | Backlog:  0.0 K | Pub Latency (ms) avg:  2.1 - 50%:  2.4 - 99%:  2.8 - 99.9%:  6.3 - Max: 10.6 | Pub Delay Latency (us) avg: 980.3 - 50%: 1056.0 - 99%: 1371.0 - 99.9%: 2170.0 - Max: 4037.0
00:05:17.040 [main] INFO WorkloadGenerator - Pub rate  1003.3 msg/s /  1.0 MB/s | Pub err     0.0 err/s | Cons rate  1004.3 msg/s /  1.0 MB/s | Backlog:  0.0 K | Pub Latency (ms) avg:  2.2 - 50%:  2.4 - 99%:  2.8 - 99.9%:  8.0 - Max: 13.4 | Pub Delay Latency (us) avg: 1010.4 - 50%: 1059.0 - 99%: 1425.0 - 99.9%: 3020.0 - Max: 11549.0
00:05:27.453 [main] INFO WorkloadGenerator - Pub rate   994.0 msg/s /  1.0 MB/s | Pub err     0.0 err/s | Cons rate   993.4 msg/s /  1.0 MB/s | Backlog:  0.0 K | Pub Latency (ms) avg:  2.1 - 50%:  2.4 - 99%:  2.8 - 99.9%:  7.5 - Max:  9.9 | Pub Delay Latency (us) avg: 997.1 - 50%: 1058.0 - 99%: 1435.0 - 99.9%: 3038.0 - Max: 6037.0
00:05:37.815 [main] INFO WorkloadGenerator - Pub rate  1005.1 msg/s /  1.0 MB/s | Pub err     0.0 err/s | Cons rate  1005.1 msg/s /  1.0 MB/s | Backlog:  0.0 K | Pub Latency (ms) avg:  2.1 - 50%:  2.4 - 99%:  2.8 - 99.9%:  7.1 - Max: 10.3 | Pub Delay Latency (us) avg: 994.4 - 50%: 1060.0 - 99%: 1425.0 - 99.9%: 2038.0 - Max: 4024.0
00:05:38.171 [main] INFO WorkloadGenerator - ----- Aggregated Pub Latency (ms) avg:  2.2 - 50%:  2.4 - 95%:  2.7 - 99%:  4.3 - 99.9%: 30.7 - 99.99%: 57.1 - Max: 59.6 | Pub Delay (us)  avg: 991.6 - 50%: 1056.0 - 95%: 1287.0 - 99%: 1418.0 - 99.9%: 3038.0 - 99.99%: 7514.0 - Max: 11549.0
00:05:39.334 [main] INFO WorkloadGenerator - ----- Starting benchmark traffic (5m)------
00:05:49.677 [main] INFO WorkloadGenerator - Pub rate  1148.4 msg/s /  1.1 MB/s | Pub err     0.0 err/s | Cons rate  1148.5 msg/s /  1.1 MB/s | Backlog:  0.0 K | Pub Latency (ms) avg:  2.2 - 50%:  2.4 - 99%:  2.8 - 99.9%:  9.2 - Max: 12.1 | Pub Delay Latency (us) avg: 984.9 - 50%: 1058.0 - 99%: 1347.0 - 99.9%: 2790.0 - Max: 4027.0
00:06:00.045 [main] INFO WorkloadGenerator - Pub rate   998.1 msg/s /  1.0 MB/s | Pub err     0.0 err/s | Cons rate   997.9 msg/s /  1.0 MB/s | Backlog:  0.0 K | Pub Latency (ms) avg:  2.2 - 50%:  2.4 - 99%:  2.8 - 99.9%:  7.1 - Max: 11.2 | Pub Delay Latency (us) avg: 970.1 - 50%: 1055.0 - 99%: 1338.0 - 99.9%: 1479.0 - Max: 3714.0
00:06:10.403 [main] INFO WorkloadGenerator - Pub rate  1001.3 msg/s /  1.0 MB/s | Pub err     0.0 err/s | Cons rate  1000.8 msg/s /  1.0 MB/s | Backlog:  0.0 K | Pub Latency (ms) avg:  2.2 - 50%:  2.4 - 99%:  2.8 - 99.9%:  8.1 - Max: 13.3 | Pub Delay Latency (us) avg: 985.0 - 50%: 1057.0 - 99%: 1348.0 - 99.9%: 1525.0 - Max: 3037.0
```
