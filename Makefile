PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

DOCKER_IMAGE ?= lambci/lambda-base-2:build
TARGET ?=/opt/imagemagick

MOUNTS = -v $(PROJECT_ROOT):/var/task \
	-v $(PROJECT_ROOT)result:$(TARGET)

DOCKER = docker run -it --rm -w=/var/task/build
build result: 
	mkdir $@

clean:
	rm -rf build result

list-formats:
	$(DOCKER) $(MOUNTS) --entrypoint /opt/imagemagick/bin/identify -t $(DOCKER_IMAGE) -list format

bash:
	$(DOCKER) $(MOUNTS) --entrypoint /bin/bash -t $(DOCKER_IMAGE)

all libs: 
	$(DOCKER) $(MOUNTS) --entrypoint /usr/bin/make -t $(DOCKER_IMAGE) TARGET_DIR=$(TARGET) -f ../src/Makefile $@
