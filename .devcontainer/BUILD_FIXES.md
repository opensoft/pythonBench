# Python DevBench Container - Build Fixes & Troubleshooting

## Common Build Issues and Solutions

### 1. Python 3.12 Distutils Issue

**Problem**: Python 3.12 removed the `distutils` module, causing build failures.

**Solution**: The Dockerfile has been updated to:
- Remove `python3.12-distutils` package (doesn't exist)
- Use `setuptools` instead of `distutils` for Python 3.12
- Install `python3-build` for modern Python packaging

If you encounter distutils-related errors:
```bash
# Use setuptools instead
python3.12 -m pip install --upgrade setuptools

# For legacy packages that need distutils
python3.12 -m pip install setuptools-distutils
```

### 2. Package Installation Failures

**Problem**: Some Python packages fail to install due to missing system dependencies.

**Solution**: The Dockerfile includes extensive system dependencies for data science, machine learning, and computer vision libraries. If a specific package still fails:

```bash
# Install missing system dependencies
sudo apt update
sudo apt install -y <missing-package>

# Rebuild the specific Python package
pip install --force-reinstall --no-cache-dir <package-name>
```

### 2. PyTorch GPU Support

**Problem**: PyTorch is installed with CPU-only support by default.

**Solution**: If you have NVIDIA GPU support, modify the Dockerfile to install GPU versions:

```dockerfile
# Replace the PyTorch installation section with:
RUN python3.12 -m pip install \
    torch \
    torchvision \
    torchaudio \
    --index-url https://download.pytorch.org/whl/cu118
```

### 3. TensorFlow GPU Support

**Problem**: TensorFlow is installed with CPU-only support.

**Solution**: Install TensorFlow GPU version:

```dockerfile
# Replace tensorflow-cpu with:
RUN python3.12 -m pip install tensorflow[and-cuda]
```

### 4. Large Container Size

**Problem**: The container image is very large (~12GB).

**Solution**: This is expected due to the comprehensive nature of the Python ecosystem. To reduce size:

1. Remove unused language runtimes (Go, Java) from the Dockerfile
2. Remove unused Python packages from Phase 4 sections
3. Use multi-stage builds to separate build dependencies

### 5. Long Build Times

**Problem**: Initial build takes 15-20 minutes.

**Solutions**:
- Use Docker layer caching
- Build during off-peak hours
- Consider using pre-built base images for specific components

### 6. Memory Issues During Build

**Problem**: Docker runs out of memory during package installation.

**Solution**: Increase Docker memory allocation to at least 8GB, preferably 12GB.

### 7. Network Timeouts

**Problem**: Package downloads timeout during build.

**Solution**: The Dockerfile includes retry logic for most external downloads. If issues persist:

```bash
# Increase Docker daemon timeout
echo '{"max-concurrent-downloads": 3}' | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker
```

### 8. Permission Issues

**Problem**: Files created in container have wrong permissions.

**Solution**: The container uses proper UID/GID mapping. Ensure your host user has UID/GID 1000, or modify the docker-compose.yml:

```yaml
args:
  USER_UID: ${UID:-1000}
  USER_GID: ${GID:-1000}
```

### 9. Python Version Issues

**Problem**: Some packages don't work with Python 3.12.

**Solution**: The container includes Python 3.10, 3.11, and 3.12. Use pyenv to switch versions:

```bash
pyenv install 3.11.0
pyenv global 3.11.0
```

### 10. Jupyter Lab Extensions

**Problem**: Some Jupyter Lab extensions don't install properly.

**Solution**: Install extensions manually after container starts:

```bash
jupyter labextension install <extension-name>
jupyter lab build
```

## Optimization Tips

### Faster Rebuilds

1. Use BuildKit for parallel builds:
```bash
export DOCKER_BUILDKIT=1
docker-compose build --parallel
```

2. Use build cache from CI/CD:
```dockerfile
# Add to top of Dockerfile
# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM ubuntu:24.04
```

### Smaller Images

1. Use pip's `--no-cache-dir` flag (already included)
2. Remove package caches between RUN commands (already done)
3. Use Alpine Linux base (not recommended for data science due to library compatibility)

### Custom Builds

To customize the container for specific use cases:

1. **Data Science Only**: Remove web development frameworks from Phase 4h
2. **Web Development Only**: Remove ML/AI libraries from Phase 4d-4g
3. **Minimal Python**: Keep only Phase 4k (development tools) and essential packages

## Performance Notes

- **Build Time**: 15-20 minutes first build, <1 minute incremental
- **Image Size**: ~12GB compressed, ~20GB uncompressed
- **Memory Usage**: ~2GB idle, 4-8GB under load
- **Startup Time**: 30-45 seconds from cold start

## Environment Variables

Key environment variables that affect behavior:

- `DEBUG=true`: Enable verbose build logging
- `PYTHONDONTWRITEBYTECODE=1`: Prevent .pyc files
- `PYTHONUNBUFFERED=1`: Force stdout/stderr to be unbuffered
- `JUPYTER_ENABLE_LAB=yes`: Start JupyterLab by default
- `PYTHONPATH=/workspace/src`: Add src to Python path

## Post-Build Validation

After successful build, verify key components:

```bash
# Python versions
python3.12 --version
python3.11 --version
python3.10 --version

# Key packages
python3 -c "import numpy, pandas, matplotlib, sklearn, torch, transformers"

# Jupyter
jupyter --version
jupyter lab --version

# Development tools
black --version
ruff --version
mypy --version
pytest --version
```

## Getting Help

If you encounter issues not covered here:

1. Check Docker logs: `docker-compose logs python_bench`
2. Enable debug mode: Set `DEBUG=true` in .env file
3. Check system resources: Ensure adequate RAM and disk space
4. Update Docker Desktop to latest version