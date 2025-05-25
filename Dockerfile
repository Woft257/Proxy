FROM ubuntu:22.04

RUN apt-get update && apt-get install -y libssl-dev libevent-dev libpcre3-dev zlib1g-dev ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /mtproxy

COPY mtproto-proxy ./objs/bin/mtproto-proxy
COPY proxy-secret ./proxy-secret
COPY proxy-multi.conf ./proxy-multi.conf

EXPOSE 8888

CMD ["./objs/bin/mtproto-proxy", "-u", "nobody", "-p", "8888", "-H", "8888", "-S", "8f488ba3563ea55f982af9746fb950f2", "--aes-pwd", "proxy-secret", "proxy-multi.conf", "-M", "1"]
