# THE BIG HEAVY PYTHON DEVELOPMENT MONSTER - Ubuntu 24.04 Edition
FROM ubuntu:24.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

USER root

# Accept build arguments for username, UID, and GID from docker-compose
ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG DEBUG=false

# Set DEBUG as an environment variable for runtime
ENV DEBUG=${DEBUG}

# Python-specific environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# In debug mode, show these values
RUN if [ "$DEBUG" = "true" ]; then \
        echo "🐍 THE BIG HEAVY PYTHON DEVELOPMENT MONSTER"; \
        echo "the passed arg USERNAME= ${USERNAME}"; \
        echo "the passed arg USER_UID= ${USER_UID}"; \
        echo "the passed arg USER_GID= ${USER_GID}"; \
        echo "the passed env DEBUG= ${DEBUG}"; \
    fi

# Always log the resolved values for debugging
RUN echo "Resolved USERNAME=${USERNAME}, USER_UID=${USER_UID}, USER_GID=${USER_GID}, DEBUG=${DEBUG}"

# ========================================
# PHASE 1: SYSTEM FOUNDATION & REPOSITORIES
# ========================================

# Update and install essential system packages
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    curl \
    wget \
    gpg \
    && rm -rf /var/lib/apt/lists/*

# Add deadsnakes PPA for multiple Python versions
RUN add-apt-repository ppa:deadsnakes/ppa

# Add Node.js 20.x repository (for Jupyter extensions and web dev)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

# Add Docker repository
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# ========================================
# PHASE 2: THE PYTHON MONSTER PACKAGE INSTALLATION
# ========================================

# Phase 2a: Core development tools
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    pkg-config \
    autoconf \
    automake \
    libtool \
    make \
    gcc \
    g++ \
    gdb \
    valgrind \
    clang \
    llvm \
    && rm -rf /var/lib/apt/lists/*

# Phase 2b: Python ecosystem - Multiple Python versions
# Note: Python 3.12 removed distutils, so we don't install it
RUN apt-get update && apt-get install -y \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3.11 \
    python3.11-dev \
    python3.11-venv \
    python3.11-distutils \
    python3.10 \
    python3.10-dev \
    python3.10-venv \
    python3.10-distutils \
    python3-pip \
    python-is-python3 \
    && rm -rf /var/lib/apt/lists/*

# Phase 2c: Python development libraries and headers
RUN apt-get update && apt-get install -y \
    libpython3.12-dev \
    libpython3.11-dev \
    libpython3.10-dev \
    python3-setuptools \
    python3-wheel \
    python3-tk \
    python3-build \
    && rm -rf /var/lib/apt/lists/*

# Phase 2d: Scientific computing and data science dependencies
RUN apt-get update && apt-get install -y \
    libblas-dev \
    liblapack-dev \
    gfortran \
    libatlas-base-dev \
    libopenblas-dev \
    libhdf5-dev \
    libnetcdf-dev \
    libfftw3-dev \
    && rm -rf /var/lib/apt/lists/*

# Phase 2e: Graphics and image processing libraries
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff5-dev \
    libwebp-dev \
    libopencv-dev \
    libcairo2-dev \
    libgirepository1.0-dev \
    && rm -rf /var/lib/apt/lists/*

# Phase 2f: Database libraries and clients
RUN apt-get update && apt-get install -y \
    libpq-dev \
    postgresql-client \
    mysql-client \
    sqlite3 \
    libsqlite3-dev \
    redis-tools \
    libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Phase 2g: Node.js and other languages
RUN apt-get update && apt-get install -y \
    nodejs \
    golang-go \
    && rm -rf /var/lib/apt/lists/*

# Phase 2h: Shell and development tools
RUN apt-get update && apt-get install -y \
    zsh \
    fish \
    tmux \
    screen \
    htop \
    neofetch \
    tree \
    vim \
    neovim \
    nano \
    jq \
    xmlstarlet \
    ripgrep \
    fd-find \
    fzf \
    bat \
    eza \
    net-tools \
    nmap \
    netcat-openbsd \
    telnet \
    dnsutils \
    traceroute \
    httpie \
    unzip \
    zip \
    p7zip-full \
    tar \
    gzip \
    bzip2 \
    xz-utils \
    git \
    git-lfs \
    subversion \
    mercurial \
    sudo \
    less \
    rsync \
    lsof \
    strace \
    ltrace \
    file \
    plocate \
    && rm -rf /var/lib/apt/lists/*

# Phase 2i: Docker and container tools
RUN apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# ========================================
# PHASE 3: PYTHON PACKAGE MANAGERS & TOOLS
# ========================================

# Remove the EXTERNALLY-MANAGED file to allow system-wide pip installs in container
RUN rm -f /usr/lib/python*/EXTERNALLY-MANAGED

# Ensure pip is up-to-date for Python 3.12 (default)
# Python 3.12 uses setuptools instead of distutils
RUN python3.12 -m pip install --upgrade --no-cache-dir --force-reinstall --ignore-installed pip setuptools wheel

# Ensure setuptools is available for all Python versions
RUN python3.11 -m pip install --upgrade --no-cache-dir --force-reinstall --ignore-installed pip setuptools wheel
RUN python3.10 -m pip install --upgrade --no-cache-dir --force-reinstall --ignore-installed pip setuptools wheel

# Install pipx for installing Python applications
RUN python3.12 -m pip install --no-cache-dir pipx

# Install uv (ultra-fast Python package installer)
RUN python3.12 -m pip install --no-cache-dir uv

# Install poetry (modern dependency management)
RUN curl -sSL https://install.python-poetry.org | python3.12 -

# Install pipenv
RUN python3.12 -m pip install --no-cache-dir pipenv

# ========================================
# PHASE 4: CORE PYTHON LIBRARIES
# ========================================

# Phase 4a: Core data science stack
RUN python3.12 -m pip install --no-cache-dir \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    plotly \
    scipy \
    statsmodels \
    sympy

# Phase 4b: Jupyter ecosystem
RUN python3.12 -m pip install --no-cache-dir \
    jupyterlab \
    jupyter \
    notebook \
    ipywidgets \
    voila

# Phase 4c: Machine learning core
RUN python3.12 -m pip install --no-cache-dir \
    scikit-learn \
    xgboost \
    lightgbm

# Phase 4d: Development and testing tools
RUN python3.12 -m pip install --no-cache-dir \
    black \
    isort \
    ruff \
    flake8 \
    pylint \
    mypy \
    bandit \
    safety \
    pre-commit \
    pytest \
    pytest-cov \
    pytest-xdist \
    pytest-mock

# Phase 4e: Web development frameworks
RUN python3.12 -m pip install --no-cache-dir \
    fastapi \
    uvicorn \
    gunicorn \
    django \
    djangorestframework \
    flask \
    streamlit

# Phase 4f: Database and API tools
RUN python3.12 -m pip install --no-cache-dir \
    sqlalchemy \
    alembic \
    psycopg2-binary \
    pymongo \
    redis \
    httpx \
    requests \
    aiohttp \
    pydantic

# Phase 4g: Cloud SDKs
RUN python3.12 -m pip install --no-cache-dir \
    boto3 \
    azure-sdk-for-python \
    google-cloud-storage

# Phase 4h: Additional useful packages
RUN python3.12 -m pip install --no-cache-dir \
    rich \
    typer \
    click \
    tqdm \
    loguru

# ========================================
# PHASE 5: EXTERNAL TOOL INSTALLATIONS
# ========================================

# Install starship (modern shell prompt)
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update && apt-get install gh -y \
    && rm -rf /var/lib/apt/lists/*

# ========================================
# PHASE 6: USER MANAGEMENT
# ========================================

# Remove container image user and group if they conflict with the host user
RUN if grep -q ":${USER_UID}:" /etc/passwd; then \
      userdel --force -r $(grep ":${USER_UID}:" /etc/passwd | cut -d: -f1); \
    fi && \
    if grep -q ":${USER_GID}:" /etc/group; then \
      groupdel $(grep ":${USER_GID}:" /etc/group | cut -d: -f1); \
    fi

# Create the user and group to match the host user
RUN set -eux && \
    if ! getent group "${USER_GID}" >/dev/null; then \
        groupadd --gid "${USER_GID}" "${USERNAME}"; \
    fi && \
    if ! id -u "${USERNAME}" >/dev/null 2>&1; then \
        useradd --uid "${USER_UID}" --gid "${USER_GID}" -m -s /bin/zsh "${USERNAME}"; \
    fi && \
    usermod -aG sudo,docker,www-data "${USERNAME}" && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

# Switch to the created user for user-specific configurations
USER ${USERNAME}

# Set up user home directory paths
ENV HOME=/home/${USERNAME}
ENV USER=${USERNAME}
WORKDIR ${HOME}

# ========================================
# PHASE 7: USER-SPECIFIC CONFIGURATIONS
# ========================================

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Oh My Zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Configure .zshrc with Python-specific settings
RUN echo 'export PATH="/home/'${USERNAME}'/.local/bin:$PATH"' >> ${HOME}/.zshrc && \
    echo 'export PATH="/home/'${USERNAME}'/.poetry/bin:$PATH"' >> ${HOME}/.zshrc && \
    echo 'eval "$(starship init zsh)"' >> ${HOME}/.zshrc && \
    sed -i 's/plugins=(git)/plugins=(git python pip poetry django docker docker-compose zsh-autosuggestions zsh-syntax-highlighting)/g' ${HOME}/.zshrc

# Add Python-specific aliases
RUN cat >> ${HOME}/.zshrc << 'EOF'

# Python-specific aliases
alias py='python3'
alias py3='python3'
alias python='python3'
alias pip='python3 -m pip'
alias pip3='python3 -m pip'
alias jupyter='jupyter lab'
alias lab='jupyter lab'

# Package management
alias poetry-install='poetry install'
alias poetry-shell='poetry shell'

# Code quality
alias test='pytest'
alias black-format='black .'
alias ruff-check='ruff check .'

# Modern CLI alternatives
alias ll='eza -la'
alias la='eza -la'
alias ls='eza'
alias cat='batcat'
alias grep='rg'
alias find='fd'

# Docker shortcuts
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
EOF

# Create common Python project structure
RUN mkdir -p ${HOME}/workspace/{notebooks,src,data,models,tests,docs,scripts,requirements}

# Set working directory
WORKDIR /workspace

# Final message
RUN echo "🐍 Python DevBench Monster setup complete! 🚀"