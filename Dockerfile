FROM seriyps/mtproxy

COPY proxy-secret /proxy-secret
COPY proxy-multi.conf /proxy-multi.conf

CMD ["/mtproxy/mtproto-proxy", "-u", "nobody", "-p", "8888", "-H", "8888", "-S", "8f488ba3563ea55f982af9746fb950f2", "--aes-pwd", "proxy-secret", "proxy-multi.conf", "-M", "1"]
