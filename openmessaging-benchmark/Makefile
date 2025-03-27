all: build

get_omb:
	wget https://github.com/jeqo/openmessaging-benchmark/releases/download/2024-12-20/openmessaging-benchmark-0.0.1-SNAPSHOT-bin.tar.gz
	tar -xvf openmessaging-benchmark-0.0.1-SNAPSHOT-bin.tar.gz

build: get_omb
	docker compose build
