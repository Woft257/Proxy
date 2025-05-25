FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    build-essential git wget libssl-dev libevent-dev libpcre3-dev zlib1g-dev ca-certificates pkg-config libssl3 \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/TelegramMessenger/MTProxy.git /mtproxy

WORKDIR /mtproxy

RUN set -ex && make objs/bin/mtproto-proxy

COPY proxy-secret /mtproxy/proxy-secret
COPY proxy-multi.conf /mtproxy/proxy-multi.conf

EXPOSE 8888

CMD ["./objs/bin/mtproto-proxy", "-u", "nobody", "-p", "8888", "-H", "8888", "-S", "8f488ba3563ea55f982af9746fb950f2", "--aes-pwd", "proxy-secret", "proxy-multi.conf", "-M", "1"]
