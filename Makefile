SHELL := bash

.PHONY: init build test format lint deps build-packages test-packages build-all test-all

init:
	git submodule update --init --recursive
	dotnet tool restore

build:
	./scripts/build.sh

test:
	./scripts/test.sh

format:
	./scripts/format.sh

lint:
	./scripts/lint.sh

deps:
	./scripts/deps.sh

build-packages:
	$(MAKE) -C src/nfw build-packages

test-packages:
	$(MAKE) -C src/nfw test-packages

build-all: build build-packages

test-all: test test-packages
