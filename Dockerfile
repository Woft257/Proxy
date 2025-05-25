FROM ubuntu:22.04

# Cài các package cần thiết
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    libssl-dev \
    libevent-dev \
    libpcre3-dev \
    zlib1g-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone source MTProxy (chọn repo chính hoặc fork ổn định)
RUN git clone --depth=1 https://github.com/TelegramMessenger/MTProxy.git /mtproxy

WORKDIR /mtproxy

# Build mtproto-proxy
RUN make

# Copy proxy secret file (bạn cần tạo file này trong folder build context cùng Dockerfile)
COPY proxy-secret /mtproxy/proxy-secret

# Copy proxy-multi.conf nếu bạn dùng multi config (tùy chọn)
COPY proxy-multi.conf /mtproxy/proxy-multi.conf

# Mở port proxy
EXPOSE 8888

# Chạy mtproto-proxy với tham số
CMD ["./objs/bin/mtproto-proxy", "-u", "nobody", "-p", "8888", "-H", "8888", "-S", "8f488ba3563ea55f982af9746fb950f2", "--aes-pwd", "proxy-secret", "proxy-multi.conf", "-M", "1"]
