.PHONY: all
all: network up-basic

.PHONY: network
network:
	docker network create composes 

.PHONY: stop-all
stop-all: ## Stop all docker- running
    # List directories in  and run stop docker compose
	for dir in $(shell find $(CURDIR)/ -mindepth 1 -maxdepth 1 -type d); do \
		cd $$dir; \
	    docker-compose stop; \
	done

.PHONY: up-basic
up-basic: up-vector up-jenkins up-consul

.PHONY: up-all
up-all: ## Stop all docker- running
    # List directories in  and run stop docker compose
	for dir in $(shell find $(CURDIR)/ -mindepth 1 -maxdepth 1 -type d); do \
		cd $$dir; \
	    docker-compose up -d; \
	done

.PHONY: up-confluent-ksql
up-confluent-ksql: up-confluent-schema-registry
	## Start confluent-platform ksql compose
	cd $(CURDIR)/confluent-ksql; \
	docker-compose up -d

.PHONY: up-confluent-kafka-connect
up-confluent-connect: up-confluent-schema-registry
	## Start confluent-platform kafka connect distributed compose
	cd $(CURDIR)/confluent-kafka-connect; \
	docker-compose up -d

.PHONY: up-confluent-schema-registry
up-confluent-schema-registry: up-confluent-core
	## Start confluent-platform schema registry compose
	cd $(CURDIR)/confluent-schema-registry; \
	docker-compose up -d

.PHONY: up-zipkin
up-zipkin: up-confluent-kafka up-prometheus up-grafana
	## Start grafana compose
	cd $(CURDIR)/zipkin; \
	docker-compose up -d

.PHONY: up-confluent-kafka
up-confluent-core: ## Start confluent-platform core compose
	cd $(CURDIR)//confluent-kafka; \
	docker-compose up -d

.PHONY: up-grafana
up-grafana: up-prometheus
	## Start grafana compose
	cd $(CURDIR)/grafana; \
	docker-compose up -d

.PHONY: up-prometheus
up-prometheus: ## Start prometheus compose
	cd $(CURDIR)/prometheus; \
	docker-compose up -d

.PHONY: up-vector
up-vector: ## Start netflix oss vector compose
	cd $(CURDIR)/vector; \
	docker-compose up -d

.PHONY: up-consul
up-consul: ## Start consul compose
	cd $(CURDIR)/consul; \
	docker-compose up -d

.PHONY: up-jenkins
up-jenkins: ## Up jenkins compose
	cd $(CURDIR)/jenkins; \
	docker-compose up -d
