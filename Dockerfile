# Dockerfile hoàn chỉnh cho MTProxy trên Fly.io

FROM ubuntu:22.04

# Cài đặt build tools và thư viện cần thiết
RUN apt-get update && apt-get install -y \
    build-essential git wget libssl-dev libevent-dev libpcre3-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone source MTProxy mới nhất
RUN git clone --depth=1 https://github.com/TelegramMessenger/MTProxy.git /mtproxy

WORKDIR /mtproxy

# Build MTProxy với CFLAGS thêm -fcommon để fix lỗi multiple definitions
RUN make CFLAGS="-fcommon" objs/bin/mtproto-proxy

# Expose port proxy dùng (thường là 8888)
EXPOSE 8888

# Copy các file cấu hình, secret (bạn cần tạo 2 file này cùng folder với Dockerfile)
COPY proxy-secret /mtproxy/proxy-secret
COPY proxy-multi.conf /mtproxy/proxy-multi.conf

# Chạy proxy với các tham số tiêu chuẩn
CMD ["./objs/bin/mtproto-proxy", "-u", "nobody", "-p", "8888", "-H", "8888", "-S", "8f488ba3563ea55f982af9746fb950f2", "--aes-pwd", "proxy-secret", "proxy-multi.conf", "-M", "1"]
