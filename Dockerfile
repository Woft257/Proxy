# Dockerfile tối ưu cho MTProxy trên Fly.io với fix lỗi PCLMULQDQ
FROM ubuntu:22.04 AS builder

# Cài đặt các phụ thuộc build với công cụ tối ưu
RUN apt-get update && apt-get install -y \
    build-essential git wget libssl-dev libevent-dev libpcre3-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone source MTProxy với shallow clone
RUN git clone --depth=1 --branch master https://github.com/TelegramMessenger/MTProxy.git /mtproxy

WORKDIR /mtproxy

# Build với các cờ tối ưu hóa CPU và fix lỗi
RUN make CFLAGS="-fcommon -mpclmul -msse2 -msse4.2 -maes -O3" objs/bin/mtproto-proxy

# --------------------------------------------
# Giai đoạn runtime tối ưu
FROM ubuntu:22.04

# Cài đặt runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl3 libevent-2.1-7 libpcre3 zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Copy binary từ giai đoạn builder
COPY --from=builder /mtproxy/objs/bin/mtproto-proxy /usr/local/bin/

# Thư mục làm việc và cấu hình
WORKDIR /config
COPY proxy-secret proxy-multi.conf ./

# Port mặc định và healthcheck
EXPOSE 8888 443
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:8888/ || exit 1

# Lệnh khởi chạy với biến môi trường
CMD ["mtproto-proxy", \
    "-u", "nobody", \
    "-p", "8888", \
    "-H", "443", \
    "-S", "${SECRET}", \
    "--aes-pwd", "proxy-secret", \
    "proxy-multi.conf", \
    "-M", "1"]
