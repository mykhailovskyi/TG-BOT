# APP=$(basename $(shell git remote get-url origin))
APP=kbot
# REGISTRY=mykhailovskyi
REGISTRY=gcr.io/devops-prometheus-386204
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
windows: TARGETOS = windows
macos: TARGETOS = darwin
linux: TARGETOS = linux
push-windows: TARGETOS = windows
push-macos: TARGETOS = darwin
push-linux: TARGETOS = linux
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

# push:
# docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

push:
	for i in $$(docker images | grep ${VERSION} | awk {' print $$1,$$2 '} | tr ' ' ':'); do docker push $${i}; done


clean:
	rm -rf kbot
	docker rmi $$(docker images | grep ${VERSION} | tr -s ' ' | cut -d ' ' -f 3 | head -1) -f