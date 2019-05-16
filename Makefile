PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
DOCKER_IMAGE ?= lambci/lambda-base-2:build
ENTRYPOINT ?= /bin/bash
RUN:=docker run -it --rm -v $(PROJECT_ROOT)src:/src --entrypoint $(ENTRYPOINT) -t $(DOCKER_IMAGE)

run:
	$(RUN) /src/run.sh

