FROM golang:1.16-alpine as builder

RUN apk add build-base

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download
RUN go mod verify

COPY . .
RUN go build

FROM alpine:latest as app

COPY --from=builder /app/panoramix /bin

ENTRYPOINT ["panoramix"]
