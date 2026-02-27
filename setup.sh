#!/bin/bash
USER=$(whoami)
docker image inspect "python-bench:$USER" >/dev/null 2>&1 || { echo "Build image first: ./scripts/build-layer.sh"; exit 1; }
docker-compose -f .devcontainer/docker-compose.yml up -d
