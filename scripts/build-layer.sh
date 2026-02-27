#!/bin/bash
USER=$(whoami)
docker build --build-arg BASE_IMAGE="devbench-base:$USER" --build-arg USERNAME="$USER" -t "python-bench:$USER" -f Dockerfile.layer2 .
