all: build run logs

run:
	docker stop blockdx-x11; \
	 docker run --rm \
		--name blockdx-x11 \
		--volumes-from x11-bridge \
		-e DISPLAY=:14 \
		-d dexpops/docker-x11-blockdx:latest

stop:
	docker stop blockdx-x11

logs:
	docker logs -f blockdx-x11

build:
	docker build -t dexpops/docker-x11-blockdx:latest .