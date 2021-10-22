ARG VERSION=stable-slim

FROM debian:${VERSION} 

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
        apt -y install python3 python3-pip

CMD echo "Python3 Dev"

