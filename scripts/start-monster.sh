#!/bin/bash

# Get current user info
export UID=$(id -u)
export GID=$(id -g) 
export USER=$(whoami)

echo "🐍 Starting the Python DevBench Monster Container"
echo "   User: $USER (UID: $UID, GID: $GID)"

# Validate we have the required info
if [ -z "$USER" ] || [ -z "$UID" ] || [ -z "$GID" ]; then
    echo "❌ Error: Could not determine user info"
    echo "   USER=$USER, UID=$UID, GID=$GID"
    exit 1
fi

echo "🔧 Building container with user mapping..."

# Start the container with proper user mapping
docker-compose -f .devcontainer/docker-compose.yml up -d --build

if [ $? -eq 0 ]; then
    echo "✅ Container started successfully!"
    echo ""
    echo "🎯 Next steps:"
    echo "   - Open VS Code and select 'Reopen in Container'"
    echo "   - Or run: docker exec -it python_bench zsh"
    echo ""
    echo "🔍 To check container status:"
    echo "   docker ps | grep python_bench"
    echo ""
    echo "🐍 Python Monster includes:"
    echo "   - Python 3.12/3.11/3.10 with pyenv"
    echo "   - Data Science: numpy, pandas, jupyter, sklearn"
    echo "   - ML/AI: tensorflow, pytorch, transformers"
    echo "   - Web: FastAPI, Django, Flask, Streamlit"
    echo "   - Tools: poetry, black, ruff, mypy, pytest"
    echo "   - Cloud: AWS CLI, Azure CLI, GCP SDK"
    echo "   - And 200+ more packages!"
else
    echo "❌ Container failed to start. Check Docker logs:"
    echo "   docker-compose -f .devcontainer/docker-compose.yml logs"
fi