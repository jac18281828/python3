ARG VERSION=stable-slim

FROM debian:${VERSION} 

RUN export DEBIAN_FRONTEND=noninteractive && \
        apt update && \
        apt install -y -q --no-install-recommends \
        python3 python3-pip

RUN rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip
RUN pip3 install virtualenv
RUN pip3 install autopep8
RUN pip3 install pylint


CMD echo "Python3 Dev"

