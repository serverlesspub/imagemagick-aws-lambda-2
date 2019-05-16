PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
DOCKER_IMAGE ?= lambci/lambda-base-2:build
MOUNTS = -v $(PROJECT_ROOT)src:/var/task/src \
	-v $(PROJECT_ROOT)vendor:/var/task/vendor \
	-v $(PROJECT_ROOT)build:/var/task/build \
	-v $(PROJECT_ROOT)opt:/opt
DOCKER = docker run -it --rm
BASH = $(DOCKER) $(MOUNTS) --entrypoint /bin/bash -t $(DOCKER_IMAGE)
IDENTIFY = $(DOCKER) $(MOUNTS) --entrypoint /opt/imagemagick/bin/identify -t $(DOCKER_IMAGE)

vendor build opt: 
	mkdir $@

vendor/ImageMagick.tar.gz: vendor
	cd vendor && curl -O https://imagemagick.org/download/ImageMagick.tar.gz

vendor/jpegsrc.v9c.tar.gz:
	cd vendor && curl -O http://ijg.org/files/jpegsrc.v9c.tar.gz

clean:
	rm -rf vendor build opt

opt/imagemagick/lib/libjpeg.a: vendor/jpegsrc.v9c.tar.gz build opt
	$(BASH) /var/task/src/make-libjpeg.sh

all: vendor/ImageMagick.tar.gz opt/imagemagick/lib/libjpeg.a build opt
	$(BASH) /var/task/src/make-imagemagick.sh

list-formats:
	$(IDENTIFY) -list format

identify: 
	$(IDENTIFY) /var/task/src/test.jpg

bash:
	$(BASH)
