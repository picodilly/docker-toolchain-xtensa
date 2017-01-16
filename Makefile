all: build history

IMAGE_TAG:="docker.io/picodilly/xtensa-lx106-elf"

build:
	docker build -t $(IMAGE_TAG) .

history:
	docker history $(IMAGE_TAG)

run:
	docker run --rm -ti -v ${PWD}:/home/picodilly/build:Z $(IMAGE_TAG)

publish: build
	docker push $(IMAGE_TAG)

clean:
	-docker rm  $(shell docker ps -a -q --filter ancestor=$(IMAGE_TAG))
	-docker rmi $(shell docker images -q $($IMAGE_TAG))
