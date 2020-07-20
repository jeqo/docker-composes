all:
down:
	docker-compose -f monitor.yml down --remove-orphans
up-single:
	docker-compose -f single.yml -f monitor.yml up -d
up-ensemble:
	docker-compose -f ensemble.yml -f monitor.yml up -d
up-observers:
	docker-compose -f observers.yml -f monitor.yml up -d
up-hierarchical:
	docker-compose -f hierarchical.yml -f monitor.yml up -d