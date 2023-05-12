# APP=$(basename $(shell git remote get-url origin))
APP=app
REGISTRY=mykhailovskyi
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
windows: TARGETOS = windows
macos: TARGETOS = darwin
linux: TARGETOS = linux
# TARGETOS=linux #linux
TARGETARCH ?= arm64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

linux: build image

macos: build image

windows: build image

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/mykhailovskyi/TG-BOT/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot