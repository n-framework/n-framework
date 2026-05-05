SHELL := bash

.PHONY: help setup format test lint update-submodules

help:
	@echo "Available commands:"
	@echo "  make setup             - Initialize submodules and verify tools"
	@echo "  make format            - Run repository-wide formatters"
	@echo "  make test              - Run test suites"
	@echo "  make lint              - Run lint checks"
	@echo "  make update-submodules - Update all submodules to main branch"

setup:
	./scripts/setup.sh

format:
	./scripts/format.sh

test:
	./scripts/test.sh

lint:
	./scripts/lint.sh

update-submodules:
	./scripts/update-submodules.sh

run:
	@cd $(or $(CWD),.) && cargo run --manifest-path $(abspath src/nfw/Cargo.toml) --package n-framework-nfw-cli -- $(ARGS)
