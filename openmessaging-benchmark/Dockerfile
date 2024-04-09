# Benchmark client image
# TODO: (based on the ansible playbook)
# - [x] Install base packages
# - [x] Add Kafka binaries
# - [x] Change locale to en_US.utf-8
# - [ ] Setup Chrony
# - [x] Add benchmark binaries
# - [ ] Tune for latency-performance
# - [ ] Configure Bootstrap Servers
# - [ ] Configure memory
# - [ ] Setup Service (SystemD)
FROM fedora:39

RUN dnf install -y \
	wget \
	java-11-openjdk \
	sysstat \
	vim \
	chrony
ENV KAFKA_VERSION=3.6.1
ENV KAFKA_SCALA_VERSION=2.13

ADD https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}.tgz /
RUN mkdir /kafka && tar -xzf /kafka_*.tgz -C /kafka --strip=1
RUN rm /kafka_*.tgz

ENV BENCHMARK_VERSION=0.0.1-SNAPSHOT
COPY ./openmessaging-benchmark-${BENCHMARK_VERSION}-bin.tar.gz /
RUN ls / && mkdir /benchmark && tar -xzf /openmessaging-benchmark-*-SNAPSHOT-bin.tar.gz -C /benchmark --strip=1
RUN rm /openmessaging-benchmark-*-SNAPSHOT-bin.tar.gz

# RUN tuned-adm profile latency-performance
ENV BENCHMARK_PORT=8080
ENV BENCHMARK_STATS_PORT=8081
WORKDIR /benchmark
CMD bin/benchmark-worker -p ${BENCHMARK_PORT} \
	-sp ${BENCHMARK_STATS_PORT}

