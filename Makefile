# include setup.mk

.PHONY: draft container push run all

leftover=$(shell docker ps -a -q -f status=exited)
leftover-image=$(shell docker images -a -q)
username=mjethanandani
image=$(username)/ietf-ni-extensions

all: container

container:
	-docker rm test
	docker build -t $(image) .; docker run -it --name test \
	--mount type=bind,src="$(PWD)",dst=/app \
	$(image)

push:
	docker push $(image):$(VER)

debug:
	docker run \
	--mount type=bind,src="$(PWD)",dst=/app \
        -it $(image) bash

clean:
	make -C draft clean
	-docker rm $(leftover)
	-docker rmi $(leftover-image)
