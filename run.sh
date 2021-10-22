#!/usr/bin/env bash

VERSION=$(date +%s)

docker build . -t pythondev:${VERSION} && \
	docker run --rm -i -t pythondev:${VERSION}
