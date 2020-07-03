all:

keys:
	rm -rf conf
	mkdir -p conf
	openssl genrsa -out ./conf/keypair.pem 2048
	openssl rsa -in ./conf/keypair.pem -outform PEM -pubout -out ./conf/public.pem

down:
	docker-compose -f cp.yml down --remove-orphans

up:
	docker-compose -f ldap.yml -f cp.yml -f monitor.yml up -d
ps:
	docker-compose -f ldap.yml -f cp.yml -f monitor.yml ps

logs:
	docker-compose -f ldap.yml -f cp.yml -f monitor.yml logs -f ${SVC}