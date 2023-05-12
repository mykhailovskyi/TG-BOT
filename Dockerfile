FROM golang:latest as builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /go/src/app
COPY . .
RUN make build
# RUN make build-${TARGETOS}-${TARGETARCH}

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/cets/
ENTRYPOINT ["./kbot"]