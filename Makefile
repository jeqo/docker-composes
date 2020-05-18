.PHONY: all
all:

PROM_JMX_EXPORTER_VERSION := 0.12.0

.PHONY: get_jmx_exporter
get_jmx_exporter:
	wget -O ./prometheus-jmx-exporter/jmx_prometheus_javaagent.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${PROM_JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${PROM_JMX_EXPORTER_VERSION}.jar

