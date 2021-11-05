ARG VERSION=stable-slim

FROM debian:${VERSION} 

RUN export DEBIAN_FRONTEND=noninteractive && \
        apt update && \
        apt install -y -q --no-install-recommends \
        python3 python3-pip

RUN rm -rf /var/lib/apt/lists/*

CMD echo "Python3 Dev"

