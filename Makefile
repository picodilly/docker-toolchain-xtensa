all: build history

SERIAL_PORT:=/dev/ttyUSB0
IMAGE_TAG:="docker.io/picodilly/xtensa-esp32-elf"

build:
	docker build -t $(IMAGE_TAG) .

history:
	docker history $(IMAGE_TAG)

run:
	docker run --rm -ti -v ${PWD}:/home/picodilly/esp32:Z $(IMAGE_TAG)

run_serial:
	docker run --rm -ti --device $(SERIAL_PORT):/dev/ttyUSB0 -v ${PWD}:/home/picodilly/esp32:Z $(IMAGE_TAG)

publish: build
	docker push $(IMAGE_TAG)

clean:
	-docker rm  $(shell docker ps -a -q --filter ancestor=$(IMAGE_TAG))
	-docker rmi $(shell docker images -q $($IMAGE_TAG))
