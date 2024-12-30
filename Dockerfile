# Stage 1: Build yamlfmt
FROM golang:1 AS go-builder
# defined from build kit
# DOCKER_BUILDKIT=1 docker build . -t ...
ARG TARGETARCH

# Install yamlfmt
WORKDIR /yamlfmt
RUN go install github.com/google/yamlfmt/cmd/yamlfmt@latest && \
    strip $(which yamlfmt) && \
    yamlfmt --version

# Stage 2: Python Development Container
FROM debian:stable-slim

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y -q --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      git \
      gnupg2 \
      python3 \
      python3-pip \
      python3-venv \
      ripgrep \
      sudo \
      unzip \
    && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ENV USER=py3    
RUN useradd --create-home -s /bin/bash ${USER}
RUN usermod -a -G sudo ${USER}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY --chown=${USER}:${USER} --from=go-builder /go/bin/yamlfmt /go/bin/yamlfmt

ENV PATH=${PATH}:/go/bin

USER py3

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="python" \
    org.label-schema.description="Python Development Container" \
    org.label-schema.url="https://github.com/jac18281828/python" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="git@github.com:jac18281828/python.git" \
    org.label-schema.vendor="John Cairns" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0" \
    org.opencontainers.image.description="Python 3 development container"


