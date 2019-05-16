PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
DOCKER_IMAGE ?= lambci/lambda-base-2:build
MOUNTS = -v $(PROJECT_ROOT)src:/var/task/src \
	-v $(PROJECT_ROOT)vendor:/var/task/vendor \
	-v $(PROJECT_ROOT)build:/var/task/build \
	-v $(PROJECT_ROOT)opt:/opt
DOCKER = docker run -it --rm

vendor build opt: 
	mkdir $@

vendor/ImageMagick.tar.gz: vendor
	cd vendor && curl -O https://imagemagick.org/download/ImageMagick.tar.gz

clean:
	rm -rf vendor build opt

all: vendor/ImageMagick.tar.gz build opt
	$(DOCKER) $(MOUNTS) --entrypoint /bin/bash -t $(DOCKER_IMAGE) /var/task/src/run.sh

identify: 
	$(DOCKER) $(MOUNTS) --entrypoint /opt/imagemagick/bin/identify -t $(DOCKER_IMAGE) /var/task/src/test.jpg


