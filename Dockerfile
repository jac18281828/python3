FROM debian:stable-slim

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt install -y -q --no-install-recommends \
    sudo ca-certificates curl git gnupg2 build-essential \
    python3 python3-pip python3-venv ripgrep && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd --create-home -s /bin/bash jac
RUN usermod -a -G sudo jac
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN python3 -m pip install --break-system-packages --upgrade pip
RUN pip3 install --break-system-packages autopep8
RUN pip3 install --break-system-packages pylint

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="pythondev" \
    org.label-schema.description="Python Development Container" \
    org.label-schema.url="https://github.com/jac18281828/pythondev" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="git@github.com:jac18281828/pythondev.git" \
    org.label-schema.vendor="John Cairns" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0" \
    org.opencontainers.image.description="Python 3 development container"


