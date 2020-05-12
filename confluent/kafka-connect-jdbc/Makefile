.PHONY: all
all:

.PHONY: get_jmx_exporter
get_jmx_exporter:
	wget -O ./prometheus-jmx-exporter/jmx_prometheus_javaagent.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.12.0/jmx_prometheus_javaagent-0.12.0.jar

.PHONY: install_connector
install_connector:
	curl -XPUT -H "Content-type:application/json" -d @source.json http://localhost:8083/connectors/jdbc_source/config