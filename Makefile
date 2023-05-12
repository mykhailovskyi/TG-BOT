# APP=$(basename $(shell git remote get-url origin))
APP=app
REGISTRY=mykhailovskyi
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

TARGETOS=linux #linux
TARGETARCH ?= arm64

windows: TARGETOS = windows
macos: TARGETOS = darwin

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

linux: format get build

# TARGETOS=windows
windows: format get
	$(MAKE) build

# TARGETOS=darwin
macos: format get
	$(MAKE) build

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/mykhailovskyi/TG-BOT/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot