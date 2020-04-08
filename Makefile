# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
.PHONY: docs help test

# Use bash for inline if-statements in arch_patch target
SHELL:=bash
REGISTRY := quay.io
OWNER:=jupyter-notebooks-arm
ARCH:=$(shell uname -m)
DIFF_RANGE?=master...HEAD

# Need to list the images in build dependency order
ifeq ($(ARCH),ppc64le)
ALL_STACKS:=base-notebook
else
ALL_STACKS:=base-notebook \
        minimal-notebook \
        r-notebook \
        scipy-notebook \
        tensorflow-notebook \
        datascience-notebook \
        pyspark-notebook \
        all-spark-notebook
endif

ALL_IMAGES:=$(ALL_STACKS)

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@echo "jupyter/docker-stacks"
	@echo "====================="
	@echo "Replace % with a stack directory name (e.g., make build/minimal-notebook)"
	@echo
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build/%: DARGS?=
build/%: ## build the latest image for a stack
	buildah bud $(DARGS) --rm --force-rm --no-cache -t $(REGISTRY)/$(OWNER)/$(notdir $@):latest -f $(notdir $@)/Dockerfile.rhel ./$(notdir $@)

