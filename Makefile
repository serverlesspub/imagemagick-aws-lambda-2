PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

DOCKER_IMAGE ?= lambci/lambda-base-2:build
TARGET ?=/opt/

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
	$(DOCKER) $(MOUNTS) --entrypoint /usr/bin/make -t $(DOCKER_IMAGE) TARGET_DIR=$(TARGET) -f ../Makefile_ImageMagick $@


STACK_NAME ?= imagemagick-layer 

result/bin/identify: all

layer.zip: result/bin/identify
	# imagemagick has a ton of symlinks, and just using the source dir in the template
	# would cause all these to get packaged as individual files. 
	# (https://github.com/aws/aws-cli/issues/2900) 
	#
	# This is why we zip outside, using -y to store them as symlinks
	
	cd result && zip -ry ../layer.zip *

output.yaml: template.yaml result/bin/identify
	aws cloudformation package --template $< --s3-bucket $(DEPLOYMENT_BUCKET) --output-template-file $@

deploy: output.yaml
	aws cloudformation deploy --template $< --stack-name $(STACK_NAME)
