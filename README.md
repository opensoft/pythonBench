# 🐍 THE BIG HEAVY PYTHON DEVELOPMENT MONSTER

## Ubuntu 24.04 Python Development Container with Perfect UID/GID Matching

This is the **ultimate Python development container** - a massive, comprehensive Ubuntu 24.04-based devcontainer that includes **EVERYTHING** you could possibly need for modern Python development, data science, machine learning, web development, and more, with perfect user ID matching to your host system.

## 🎯 **Key Features**

### ✅ **Perfect User Management**
- **UID/GID matching** with your host system (crucial for WSL file permissions)
- No more permission issues with files created in the container
- Proper sudo access without password prompts

### 🏗️ **Based on Ubuntu 24.04**
- Latest Ubuntu LTS with all the newest packages
- Built from scratch as a custom Dockerfile (not a pre-built image)
- Full control over every component

## 🐍 **THE PYTHON MONSTER INCLUDES**

### **Core Python Stack**
- **Multiple Python Versions** (3.12, 3.11, 3.10) with pyenv
- **Package Managers**: pip, poetry, pipenv, conda/mamba
- **Virtual Environment Tools**: venv, virtualenv, pipenv, conda
- **Python Build Tools**: setuptools, wheel, build, twine, cython
- **Code Quality**: black, isort, flake8, pylint, mypy, bandit, ruff
- **Testing Frameworks**: pytest, unittest, tox, nox, hypothesis

### **Data Science & Machine Learning**
- **Core Libraries**: numpy, pandas, matplotlib, seaborn, plotly
- **Machine Learning**: scikit-learn, tensorflow, pytorch, xgboost, lightgbm
- **Deep Learning**: keras, transformers, huggingface, accelerate
- **Computer Vision**: opencv, pillow, skimage, albumentations
- **NLP**: spacy, nltk, gensim, textblob
- **Jupyter Stack**: jupyterlab, notebook, ipywidgets, voila
- **Data Processing**: dask, polars, pyarrow, h5py, zarr

### **Web Development Frameworks**
- **FastAPI** + uvicorn + gunicorn
- **Django** + Django REST Framework
- **Flask** + extensions ecosystem
- **Streamlit** for data apps
- **Dash** for analytics dashboards
- **Celery** for distributed task processing
- **SQLAlchemy** + Alembic for database work

### **Cloud & Infrastructure Tools**
- **AWS CLI** + boto3 + CDK
- **Azure CLI** + azure-sdk-for-python
- **Google Cloud SDK** + client libraries
- **Docker & Docker Compose** 
- **Kubernetes** (kubectl, helm, tilt)
- **Terraform** + **Pulumi** 

### **Development & DevOps Tools**
- **Version Control**: git + pre-commit hooks
- **CI/CD**: GitHub Actions tools, GitLab CI tools
- **Monitoring**: prometheus-client, grafana tools
- **Logging**: loguru, structlog, rich
- **API Tools**: httpx, requests, aiohttp, pydantic
- **Database Tools**: psycopg2, pymongo, redis-py, sqlite3

### **Modern CLI Experience**
- **Zsh with Oh My Zsh** + plugins (autosuggestions, syntax highlighting)
- **Starship prompt** for beautiful shell
- **Modern alternatives**: `eza`, `bat`, `ripgrep`, `fd`, `fzf`, `zoxide`
- **Python-specific tools**: `pipx`, `pyenv`, `poetry`, `ruff`, `uv`
- **50+ useful aliases** pre-configured

### **Additional Language Runtimes**
- **Node.js 20.x** + npm (for web frontend, Jupyter extensions)
- **Go** (for performance tools)
- **Rust** (for performance tools, ruff, etc.)
- **Java 21** (for big data tools like Spark)

### **VS Code Integration**
- **20+ pre-installed extensions** including Python, Jupyter, Copilot, Docker
- **Optimized settings** for Python development with intelligent code completion
- **Port forwarding** for all common development servers
- **Integrated debugging** for Python, Django, FastAPI, etc.

## 🚀 **Getting Started**

### **Option 1: VS Code (Recommended)**
1. Open this folder in VS Code
2. When prompted, click **"Reopen in Container"**
3. ☕ Grab coffee (first build takes 15-20 minutes - it's a MONSTER!)
4. 🎉 Start coding in your Python monster environment!

### **Option 2: Manual Docker Compose**
```bash
# Run the helper script to get your UID/GID
./start-monster.sh

# Or manually with docker-compose
export UID=$(id -u) GID=$(id -g) USER=$(whoami)
docker-compose -f .devcontainer/docker-compose.yml up -d --build
```

## 📦 **What Gets Installed**

### **Python Versions & Package Managers**
```bash
Python 3.12 (default)      # Latest Python
Python 3.11                # Stable version
Python 3.10                # LTS support
pyenv                      # Python version management
pip                        # Standard package manager
poetry                     # Modern dependency management
pipenv                     # Virtual environments
conda/mamba                # Data science ecosystem
pipx                       # Install Python applications
uv                         # Ultra-fast Python package installer
```

### **Data Science & ML Stack**
```bash
# Core Data Science
numpy pandas matplotlib seaborn plotly
jupyterlab notebook ipywidgets voila
scipy statsmodels sympy

# Machine Learning
scikit-learn xgboost lightgbm catboost
tensorflow pytorch keras
transformers accelerate datasets
huggingface-hub wandb mlflow

# Computer Vision & NLP
opencv-python pillow scikit-image
spacy nltk gensim textblob
albumentations torchvision

# Big Data & Performance
dask polars pyarrow
numba cupy (if GPU available)
spark (pyspark)
```

### **Web Development Stack**
```bash
# Web Frameworks
fastapi uvicorn gunicorn
django djangorestframework
flask flask-restful flask-sqlalchemy
streamlit dash gradio

# Database & ORM
sqlalchemy alembic
psycopg2 pymongo redis
sqlite3 clickhouse-driver

# API & HTTP
httpx requests aiohttp
pydantic marshmallow
celery dramatiq
```

### **Development Tools**
```bash
# Code Quality
black isort ruff
flake8 pylint mypy
bandit safety
pre-commit

# Testing
pytest unittest
tox nox
hypothesis factory-boy
coverage pytest-cov

# Debugging & Profiling
ipdb pdbpp
memory-profiler py-spy
line-profiler
```

### **Cloud & DevOps Tools**
```bash
# Cloud SDKs
aws-cli boto3 aws-cdk-lib
azure-cli azure-sdk-for-python
google-cloud-sdk

# Container & Orchestration
docker docker-compose
kubectl helm kubernetes
terraform pulumi

# Monitoring & Logging
prometheus-client grafana
loguru structlog rich
opentelemetry-api
```

### **Modern CLI Tools**
```bash
eza          # Better ls
bat          # Better cat with syntax highlighting  
ripgrep      # Faster grep
fd           # Better find
fzf          # Fuzzy finder
zoxide       # Smarter cd
starship     # Beautiful prompt
hyperfine    # Benchmarking
tokei        # Code statistics
just         # Command runner
gh           # GitHub CLI
```

## 🎯 **Perfect for**
- **Data Science** & **Machine Learning** projects
- **Web Development** (FastAPI, Django, Flask)
- **Scientific Computing** & research
- **Automation** & scripting
- **ETL/Data Engineering** pipelines
- **API Development** & microservices
- **Cloud-native applications**
- **Jupyter-based** data analysis
- **MLOps** & model deployment

## ⚡ **Pre-configured Aliases**

```bash
# Python shortcuts
py / py3 / python            # python3
pip / pip3                   # python -m pip
jupyter / lab                # jupyterlab
notebook / nb               # jupyter notebook

# Package management
poetry-install / pi         # poetry install
poetry-add / pa             # poetry add
poetry-shell / ps           # poetry shell

# Code quality
black-check / bc            # black --check
isort-check / ic            # isort --check
mypy-check / mc             # mypy .
flake8-check / fc           # flake8 .
test / t                    # pytest
coverage / cov              # pytest --cov

# Docker & Kubernetes  
d / dc / k                  # docker/docker-compose/kubectl
dps / kgp / kgs            # docker ps / kubectl get pods/services

# Modern CLI
ll / la / ls               # eza variants (better ls)
cat                        # bat (syntax highlighted)
find / grep                # fd / ripgrep (faster)
cd                         # zoxide (smarter)
```

## 🌐 **Port Forwarding**
Auto-forwarded ports: `3000`, `5000`, `8000`, `8080`, `8888`, `8501`, `9000`

## 📁 **Workspace Structure**
```
~/workspace/
├── notebooks/       # Jupyter notebooks
├── src/            # Source code
├── data/           # Data files
├── models/         # ML models
├── tests/          # Test files
├── docs/           # Documentation
├── scripts/        # Utility scripts
├── docker/         # Docker files
├── kubernetes/     # K8s manifests
├── terraform/      # Infrastructure code
├── requirements/   # Requirements files
├── .env.example    # Environment template
└── pyproject.toml  # Project configuration
```

## 🔧 **Container Specs**
- **Base**: Ubuntu 24.04 LTS
- **Size**: ~12GB (it's a MONSTER!)
- **Build time**: 15-20 minutes first time
- **Subsequent starts**: <45 seconds
- **User mapping**: Perfect UID/GID match with host
- **Python versions**: 3.12 (default), 3.11, 3.10
- **GPU support**: CUDA-ready (if host GPU available)

## ⚠️ **System Requirements**
- **Docker Desktop** with WSL 2 backend
- **12GB+ RAM** allocated to Docker (recommended 16GB)
- **30GB+ disk space** for the image
- **VS Code** with Remote-Containers extension
- **Optional**: NVIDIA GPU + Docker GPU support for ML workloads

## 🎉 **Why This Python Monster?**

1. **Everything Included** - Stop installing packages, start coding
2. **Perfect Permission Mapping** - No more `chown` headaches in WSL
3. **Multiple Python Versions** - Test across versions with pyenv
4. **Data Science Ready** - All major ML/DS libraries pre-installed
5. **Web Development Complete** - FastAPI, Django, Flask, all ready
6. **Cloud Native** - AWS, Azure, GCP tools included
7. **Modern Tooling** - Latest formatters, linters, and CLI tools
8. **Jupyter Integration** - Full JupyterLab setup with extensions
9. **WSL Optimized** - Built specifically for WSL workflows
10. **Team Consistency** - Same environment for everyone

This is the Python container you use when you want **EVERYTHING** for Python development and don't want to think about setup ever again! 🐍🚀
