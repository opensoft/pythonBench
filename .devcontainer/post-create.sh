#!/bin/bash

echo "🐍 Setting up Python DevBench environment..."

# Update package lists
sudo apt update

# Install additional development tools that might have been missed
sudo apt install -y \
    curl \
    wget \
    unzip \
    zip \
    tree \
    jq \
    httpie \
    htop \
    neofetch \
    build-essential \
    cmake \
    ninja-build \
    pkg-config \
    libssl-dev \
    sqlite3 \
    postgresql-client \
    redis-tools \
    net-tools \
    nmap \
    telnet \
    netcat \
    dnsutils \
    vim \
    nano \
    tmux \
    screen \
    fish \
    zoxide \
    ripgrep \
    fd-find \
    bat \
    eza \
    fzf

# Install additional Python tools that might need updating
echo "🔧 Installing additional Python tools..."

# Ensure pipx is available and install some useful Python applications
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# Install useful Python CLI tools via pipx
pipx install black
pipx install isort
pipx install ruff
pipx install mypy
pipx install pytest
pipx install pre-commit
pipx install cookiecutter
pipx install poetry
pipx install pipenv
pipx install httpie
pipx install youtube-dl
pipx install speedtest-cli
pipx install thefuck

# Install Jupyter extensions
echo "📓 Setting up Jupyter Lab extensions..."
jupyter labextension install @jupyterlab/git --no-build
jupyter labextension install @jupyterlab/toc --no-build
jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
jupyter lab build

# Download NLTK data
echo "📚 Downloading NLTK data..."
python3 -c "import nltk; nltk.download('punkt'); nltk.download('stopwords'); nltk.download('wordnet'); nltk.download('averaged_perceptron_tagger')"

# Download spaCy models
echo "🗣️ Downloading spaCy models..."
python3 -m spacy download en_core_web_sm

# Install additional package managers and tools
echo "📦 Installing additional package managers..."

# Install Homebrew alternative for Linux
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Install k6 for load testing
if command -v brew &> /dev/null; then
    brew install k6
fi

# Install kubectl (if not already installed)
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
fi

# Install Helm (if not already installed)
if ! command -v helm &> /dev/null; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Install Dapr CLI
if ! command -v dapr &> /dev/null; then
    wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash
fi

# Install Pulumi (if not already installed)
if ! command -v pulumi &> /dev/null; then
    curl -fsSL https://get.pulumi.com | sh
    echo 'export PATH=$PATH:$HOME/.pulumi/bin' >> ~/.zshrc
fi

# Install Rust and Cargo (for additional tooling)
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
    echo 'source ~/.cargo/env' >> ~/.zshrc
fi

# Install additional Rust tools
if command -v cargo &> /dev/null; then
    cargo install tokei      # Code statistics
    cargo install hyperfine  # Benchmarking tool
    cargo install just       # Command runner
    cargo install starship   # Cross-shell prompt
    cargo install dust       # Better du
    cargo install procs      # Better ps
fi

# Configure Starship prompt (if not already configured)
if command -v starship &> /dev/null; then
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

# Install Oh My Zsh plugins (if not already installed)
if [ -d ~/.oh-my-zsh ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
fi

# Set up pre-commit hooks for Python projects
echo "🔒 Setting up pre-commit configuration..."
cat > ~/.pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict
  - repo: https://github.com/psf/black
    rev: 23.9.1
    hooks:
      - id: black
  - repo: https://github.com/pycqa/isort
    rev: 5.12.0
    hooks:
      - id: isort
        args: ["--profile", "black"]
  - repo: https://github.com/charliermarsh/ruff-pre-commit
    rev: v0.0.292
    hooks:
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.5.1
    hooks:
      - id: mypy
        additional_dependencies: [types-all]
EOF

# Create common project structure directories
mkdir -p ~/workspace/{src,tests,docs,scripts,tools,data,models,notebooks,requirements}

# Set up Git configuration template
git config --global init.defaultBranch main
git config --global pull.rebase false

# Create a sample Python .gitignore
cat > ~/workspace/.gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDEs
.vscode/
.idea/
*.swp
*.swo

# Jupyter
.ipynb_checkpoints

# Data
data/
*.csv
*.json
*.parquet
*.h5
*.hdf5

# Models
models/
*.pkl
*.joblib
*.model

# Logs
logs/
*.log

# OS
.DS_Store
Thumbs.db
EOF

# Install useful VS Code extensions via CLI if code is available
if command -v code &> /dev/null; then
    echo "🔧 Installing additional VS Code extensions..."
    code --install-extension ms-python.python
    code --install-extension ms-toolsai.jupyter
    code --install-extension charliermarsh.ruff
    code --install-extension GitHub.copilot
    code --install-extension ms-azuretools.vscode-docker
fi

echo "✅ Python DevBench environment setup complete!"
echo "🎉 Available tools:"
echo "   - Python 3.12/3.11/3.10 with pyenv"
echo "   - Data Science: numpy, pandas, jupyter, sklearn"
echo "   - ML/AI: tensorflow, pytorch, transformers"
echo "   - Web: FastAPI, Django, Flask, Streamlit"
echo "   - Tools: poetry, black, ruff, mypy, pytest"
echo "   - Docker & Docker Compose"
echo "   - Kubernetes tools (kubectl, helm)"
echo "   - Cloud CLIs (AWS, Azure, GCP)"
echo "   - Modern shell tools (exa, bat, ripgrep, fd, fzf)"
echo "   - Load testing (k6)"
echo "   - Infrastructure as Code (Terraform, Pulumi)"
echo "   - And 200+ more Python packages!"