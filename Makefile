# Information about meta
NAME := mygoapp
VERSION := $(gobump show -r)
REVISION := $(shell git rev-parse --short HEAD)
LDFLAGS := "-X main.revision=$(REVISION)"

## Install dependencies
.PHONY: deps
deps:
	go get -v -d

# Setup
.PHONY: deps
devel-deps: deps
	go get \
		github.com/golang/lint/golint \
		github.com/motemen/gobump/cmd/gobump \
		github.com/Songmu/make2help/cmd/make2help

# Run tests
.PHONY: test
test: deps
	go test ./...

## Lint
.PHONY: lint
lint: devel-deps
	go vet ./...
	golint -set_exit_status ./...

## Build binaries ex. make bin/mygoapp
bin/%: cmd/%/main.go deps
	go build -ldflags "$(LDFLAGS)" -o $@ $<

## Build binary
.PHONY: build
build: bin/myprof

## Show help
.PHONY: help
help:
	@make2help $(MAKEFILE_LIST)
