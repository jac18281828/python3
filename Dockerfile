FROM debian:stable-slim

RUN export DEBIAN_FRONTEND=noninteractive && \
        apt update && \
        apt install -y -q --no-install-recommends \
        sudo ca-certificates curl git \
        python3 python3-pip ripgrep
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

RUN useradd --create-home -s /bin/bash jac
RUN usermod -a -G sudo jac
RUN echo '%jac ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN python3 -m pip install --upgrade pip
RUN pip3 install autopep8
RUN pip3 install pylint

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="pythondev" \
    org.label-schema.description="Python Development Container" \
    org.label-schema.url="https://github.com/jac18281828/pythondev" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="git@github.com:jac18281828/pythondev.git" \
    org.label-schema.vendor="John Cairns" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"


