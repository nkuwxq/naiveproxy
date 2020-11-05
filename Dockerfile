FROM golang:alpine as builder

RUN apk add --no-cache git build-base wget; \
    go get -u github.com/caddyserver/xcaddy/cmd/xcaddy; \
    xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive

FROM alpine:latest

WORKDIR /tmp

RUN apk add --no-cache wget

COPY --from=builder /go/caddy  /usr/bin/caddy
COPY Caddyfile /tmp

EXPOSE 443

CMD ["caddy","start]
