.DEFAULT: help

.PHONY: help clean build build-docker build-bin install-bin

SUDO := $(shell docker info > /dev/null 2> /dev/null || echo "sudo")

ifeq ($(ARCH),)
	ARCH=amd64
endif

CURRENT_OS=$(shell go env GOOS)
CURRENT_OS_ARCH=$(shell echo $(CURRENT_OS)-`go env GOARCH`)
GOBIN?=$(shell echo `go env GOPATH`/bin)

godeps=$(shell go list -deps -f '{{if not .Standard}}{{ $$dep := . }}{{range .GoFiles}}{{$$dep.Dir}}/{{.}} {{end}}{{end}}' $(1) | sed "s%${PWD}/%%g")

DEPS:=$(call godeps,./cmd/macaddresstool/...)

IMAGE_TAG:=$(shell ./hack/tools image-tag)
VCS_REF:=$(shell git rev-parse HEAD)
BUILD_DATE:=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

clean:
	go clean ./cmd/... ./pkg/...
	rm -rf ./build

build: clean build-bin build-docker

build-docker:
	mkdir -p ./build/docker
	cp -pr ./build/bin/* ./build/docker/
	cp ./Dockerfile ./build/docker/
	$(SUDO) docker build \
		-t docker.io/rtluckie/macaddresstool:latest \
		-t docker.io/rtluckie/macaddresstool:$(IMAGE_TAG) \
		--build-arg VCS_REF="$(VCS_REF)" \
		--build-arg BUILD_DATE="$(BUILD_DATE)" \
		-f build/docker/Dockerfile ./build/docker/

build-bin: $(DEPS) cmd/macaddresstool/*.go
	CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} go build -o ./build/bin/macaddresstool $(LDFLAGS) -ldflags "-s -w -X main.version=$(shell ./hack/tools image-tag)" ./cmd/macaddresstool

install-bin: $(DEPS)
	go install ./cmd/macaddresstool

test:
	go test ./cmd/macaddresstool ./pkg/macaddressio

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  cut -d ":" -f1- | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'