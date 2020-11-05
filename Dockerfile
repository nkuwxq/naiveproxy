FROM golang:alpine as builder

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories; \
    apk add --no-cache git build-base; \
    go env -w GO111MODULE=on; \
    go env -w GOPROXY=https://goproxy.cn,direct; \
    go get -u github.com/caddyserver/xcaddy/cmd/xcaddy; \
    xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive

FROM alpine:latest

WORKDIR /tmp

COPY --from=builder /go/caddy  /usr/bin/caddy
COPY Caddyfile /tmp

EXPOSE 443

CMD ["caddy","start]
