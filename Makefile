build:
	docker build -t flutter .

build-x11:
	docker build -t flutter:x11 -f Dockerfile.x11 .

doctor:
	docker run --rm -it flutter /opt/flutter/bin/flutter doctor

rm:
	docker-compose rm -f

up:
	docker-compose up

logs:
	docker-compose logs -f