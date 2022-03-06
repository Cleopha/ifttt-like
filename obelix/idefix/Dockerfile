FROM golang:1.16-alpine as builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download
RUN go mod verify

COPY . .
RUN go build

FROM alpine:latest as app

COPY --from=builder /app/idefix /bin

ENTRYPOINT ["idefix"]
