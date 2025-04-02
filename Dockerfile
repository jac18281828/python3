# Stage 1: Build yamlfmt
FROM golang:1 AS go-builder
# defined from build kit
# DOCKER_BUILDKIT=1 docker build . -t ...
ARG TARGETARCH

# Install yamlfmt
WORKDIR /yamlfmt
RUN go install github.com/google/yamlfmt/cmd/yamlfmt@v0.16.0 && \
    strip $(which yamlfmt) && \
    yamlfmt --version

# Stage 2: Build Python 3
FROM debian:stable-slim AS py-builder
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y -q --no-install-recommends \
        build-essential \
        ca-certificates \
        checkinstall \
        curl \
        libbz2-dev \
        libc6-dev \
        libffi-dev \
        libgdbm-dev \
        libncursesw5-dev \
        libsqlite3-dev \
        libssl-dev \
        pkg-config \ 
        zlib1g-dev \
    && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG PY_VERSION=3.11.9

# Install Python 3
WORKDIR /python3
RUN curl -sSL  https://www.python.org/ftp/python/${PY_VERSION}/Python-${PY_VERSION}.tgz | tar xzf -
WORKDIR /python3/Python-${PY_VERSION}
RUN ./configure --enable-optimizations --with-lto --with-ensurepip=install --enable-shared && \
    make -j LDFLAGS="-s -w"

# Stage 2: Python Development Container
FROM debian:stable-slim

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y -q --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      ed \
      git \
      gnupg2 \
      pkg-config \
      ripgrep \
      sudo \
      unzip \
    && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV USER=py3    
RUN useradd --create-home -s /bin/bash ${USER}
RUN usermod -a -G sudo ${USER}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY --chown=${USER}:${USER} --from=go-builder /go/bin/yamlfmt /go/bin/yamlfmt
COPY --chown=${USER}:${USER} --from=py-builder /python3 /python3

ARG PY_VERSION=3.11.9
WORKDIR /python3/Python-${PY_VERSION}
RUN sudo make install && \
    sudo strip $(which python3)

ENV PATH=${PATH}:/go/bin

WORKDIR /home/py3
RUN sudo rm -rf /python3

USER py3

LABEL \
    org.label-schema.name="python3" \
    org.label-schema.description="Python Development Container" \
    org.label-schema.url="https://github.com/jac18281828/python3" \
    org.label-schema.vcs-url="git@github.com:jac18281828/python3.git" \
    org.label-schema.vendor="John Cairns" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0" \
    org.opencontainers.image.description="Python 3 development container"
