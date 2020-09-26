PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

DOCKER_IMAGE ?= lambci/lambda-base-2:build
TARGET ?=/opt/imagemagick

MOUNTS = -v $(PROJECT_ROOT):/var/task \
	-v $(PROJECT_ROOT)imagemagick:$(TARGET)

DOCKER = docker run -it --rm -w=/var/task/build
build result:
	mkdir $@

clean:
	rm -rf build result

list-formats:
	$(DOCKER) $(MOUNTS) --entrypoint /opt/bin/convert -t $(DOCKER_IMAGE) -list format

bash:
	$(DOCKER) $(MOUNTS) --entrypoint /bin/bash -t $(DOCKER_IMAGE)

all libs:
	$(DOCKER) $(MOUNTS) --entrypoint /usr/bin/make -t $(DOCKER_IMAGE) TARGET_DIR=$(TARGET) -f ../Makefile_ImageMagick $@


STACK_NAME ?= lambda-layer-imagemagick

result/bin/identify: all

prep-binaries:
	# imagemagick has a ton of symlinks, and just using the source dir in the template
	# would cause all these to get packaged as individual files.
	# (https://github.com/aws/aws-cli/issues/2900)

	mv imagemagick/bin/magick imagemagick/bin/convert || true
	rm imagemagick/bin/animate || true
	rm imagemagick/bin/compare || true
	rm imagemagick/bin/composite || true
	rm imagemagick/bin/conjure || true
	rm imagemagick/bin/display || true
	rm imagemagick/bin/import || true
	rm imagemagick/bin/magick-script || true
	rm imagemagick/bin/mogrify || true
	rm imagemagick/bin/montage || true
	rm imagemagick/bin/stream || true
	rm imagemagick/bin/identify || true
	rm -rf imagemagick/share || true
	zip -r $(PROJECT_ROOT)build/layer.zip imagemagick

build/output.yaml: template.yaml
	aws cloudformation package --template $< --s3-bucket pco-sam-pipeline-artifacts --output-template-file $@

deploy: prep-binaries build/output.yaml
	aws cloudformation deploy --template build/output.yaml --stack-name $(STACK_NAME)
	aws cloudformation describe-stacks --stack-name $(STACK_NAME) --query Stacks[].Outputs --output table
