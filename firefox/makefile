all: build run logs

run:
	docker stop firefox-x11; \
	 docker run --rm \
		--name firefox-x11 \
		--volumes-from x11-bridge \
		-e DISPLAY=":14" \
		-d dexpops/firefox:latest .

stop:
	docker stop firefox-x11

logs:
	docker logs -f firefox-x11

build:
	docker build -t dexpops/firefox:latest .