all: build run logs

run:
	docker stop blockdx-x11; \
	 docker run --rm \
		--name blockdx-x11 \
		--volumes-from x11-bridge \
		-v "/Users/kj/utxo/BlocknetDX.zip:/BlocknetDX.zip" \
		-e DISPLAY=":14" \
		-e BLOCKNETDX_SNAPSHOT="/BlocknetDX.zip" \
		-e BLOCKNETDX_RPC_USER="test" \
		-e BLOCKNETDX_RPC_PASSWORD="1234" \
		-e BITCOIN_ADDRESS = "172.17.0.4"
		-e BITCOIN_PORT = "8332"
		-e BITCOIN_RPC_USER = "test"
		-e BITCOIN_RPC_PASSWORD = "1234"
		-d dexpops/docker-x11-blockdx:latest

stop:
	docker stop blockdx-x11

logs:
	docker logs -f blockdx-x11

build:
	docker build -t dexpops/docker-x11-blockdx:latest .