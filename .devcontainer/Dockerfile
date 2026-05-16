FROM debian:bookworm-slim

COPY install.sh /app/install.sh
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash git curl wget unzip tzdata openssl ca-certificates \
    kmod procps iproute2 \
    && rm -rf /var/lib/apt/lists/*

COPY config.json /etc/config.json

RUN chmod +x /app/install.sh && /app/install.sh

CMD ["/usr/local/bin/xray", "-c", "/etc/config.json"]
