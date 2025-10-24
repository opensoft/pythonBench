#!/bin/bash

# Python DevContainer Project Creation Script
# Creates a new Python project with development container setup

set -e

PROJECT_NAME=$1
TARGET_DIR=$2

# Validate project name is provided
if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: ./new-python-project.sh <project-name> [target-directory]"
    echo "Examples:"
    echo "  ./new-python-project.sh myapp                    # Creates ~/projects/myapp"
    echo "  ./new-python-project.sh myapp ../../MyProjects  # Creates ../../MyProjects/myapp"
    echo ""
    echo "This script will:"
    echo "  1. Create a new Python project structure"
    echo "  2. Copy DevContainer and VS Code configurations"
    echo "  3. Set up virtual environment and requirements"
    echo "  4. Configure Docker for development"
    echo ""
    exit 1
fi

# If no target directory specified, default to ~/projects/<project-name>
if [ -z "$TARGET_DIR" ]; then
    TARGET_DIR="$HOME/projects"
    PROJECT_PATH="$TARGET_DIR/$PROJECT_NAME"
    
    # Check if project already exists
    if [ -d "$PROJECT_PATH" ]; then
        echo "❌ Error: Project already exists at $PROJECT_PATH"
        echo "Please choose a different project name or remove the existing project."
        exit 1
    fi
    
    # Create the target directory if it doesn't exist
    if [ ! -d "$TARGET_DIR" ]; then
        echo "📁 Creating projects directory: $TARGET_DIR"
        mkdir -p "$TARGET_DIR"
    fi
else
    PROJECT_PATH="$TARGET_DIR/$PROJECT_NAME"
    
    # Check if project already exists in specified directory
    if [ -d "$PROJECT_PATH" ]; then
        echo "❌ Error: Project already exists at $PROJECT_PATH"
        echo "Please choose a different project name or remove the existing project."
        exit 1
    fi
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/../templates/python-devcontainer-template"

# Validate template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "❌ Error: Template directory not found at $TEMPLATE_DIR"
    echo "Please ensure the python-devcontainer-template exists."
    exit 1
fi

# Validate target directory exists (only if explicitly provided)
if [ ! -z "$2" ] && [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Target directory $TARGET_DIR does not exist"
    echo "Please create the directory first or use a valid path."
    exit 1
fi

echo "🐍 Creating Python project: $PROJECT_NAME"
echo "📍 Project path: $PROJECT_PATH"

# Create project directory
mkdir -p "$PROJECT_PATH"
cd "$PROJECT_PATH"

# Create basic Python project structure
echo "📋 Creating Python project structure..."

# Create directories
mkdir -p src tests docs

# Create basic Python files
cat > src/__init__.py << 'EOF'
"""
Python project package.
"""

__version__ = "0.1.0"
EOF

cat > src/main.py << 'EOF'
"""
Main module for the Python project.
"""

def main():
    """Main entry point."""
    print("Hello from Python project!")

if __name__ == "__main__":
    main()
EOF

cat > tests/__init__.py << 'EOF'
"""
Test package.
"""
EOF

cat > tests/test_main.py << 'EOF'
"""
Tests for main module.
"""

import sys
import os

# Add src to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from main import main

def test_main():
    """Test main function runs without error."""
    try:
        main()
        assert True
    except Exception as e:
        assert False, f"main() raised an exception: {e}"
EOF

# Create requirements.txt
cat > requirements.txt << 'EOF'
# Core dependencies
requests>=2.31.0
python-dotenv>=1.0.0

# Development dependencies
pytest>=7.4.0
pytest-cov>=4.1.0
black>=23.7.0
flake8>=6.0.0
mypy>=1.5.0
EOF

# Create setup.py
cat > setup.py << 'EOF'
"""
Setup script for the Python project.
"""

from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

with open("requirements.txt", "r", encoding="utf-8") as fh:
    requirements = [line.strip() for line in fh if line.strip() and not line.startswith("#")]

setup(
    name="PROJECT_NAME",
    version="0.1.0",
    author="Your Name",
    author_email="your.email@example.com",
    description="A Python project",
    long_description=long_description,
    long_description_content_type="text/markdown",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
    ],
    python_requires=">=3.8",
    install_requires=requirements,
)
EOF

# Create README.md
cat > README.md << 'EOF'
# PROJECT_NAME

A Python project with development container setup.

## Getting Started

This project uses VS Code DevContainers for a consistent development environment.

### Prerequisites

- Docker Desktop
- VS Code with Remote-Containers extension

### Development Setup

1. Open this project in VS Code
2. When prompted, click "Reopen in Container"
3. Wait for the container to build (first time: ~5-10 minutes)
4. Start developing!

### Project Structure

```
├── src/                 # Source code
│   ├── __init__.py
│   └── main.py
├── tests/               # Test files
│   ├── __init__.py
│   └── test_main.py
├── docs/                # Documentation
├── requirements.txt     # Python dependencies
├── setup.py            # Package setup
└── README.md           # This file
```

### Available Commands

- `python src/main.py` - Run the main application
- `pytest` - Run tests
- `pytest --cov=src` - Run tests with coverage
- `black src tests` - Format code
- `flake8 src tests` - Lint code
- `mypy src` - Type check code

## Development

This project follows Python best practices:

- Code formatting with Black
- Linting with flake8
- Type checking with mypy
- Testing with pytest
- Dependency management with requirements.txt

## License

This project is licensed under the MIT License.
EOF

# Copy template files if they exist
if [ -d "$TEMPLATE_DIR" ]; then
    echo "📋 Copying DevContainer configuration..."
    
    if [ -d "$TEMPLATE_DIR/.devcontainer" ]; then
        cp -r "$TEMPLATE_DIR/.devcontainer" .
    fi
    
    if [ -d "$TEMPLATE_DIR/.vscode" ]; then
        cp -r "$TEMPLATE_DIR/.vscode" .
    fi
    
    if [ -f "$TEMPLATE_DIR/docker-compose.yml" ]; then
        cp "$TEMPLATE_DIR/docker-compose.yml" .
    fi
    
    if [ -f "$TEMPLATE_DIR/Dockerfile" ]; then
        cp "$TEMPLATE_DIR/Dockerfile" .
    fi
    
    if [ -f "$TEMPLATE_DIR/.gitignore" ]; then
        cp "$TEMPLATE_DIR/.gitignore" .
    else
        # Create a basic .gitignore for Python
        cat > .gitignore << 'EOF'
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
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

# PyInstaller
#  Usually these files are written by a python script from a template
#  before PyInstaller builds the exe, so as to inject date/other infos into it.
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/
cover/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
.pybuilder/
target/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
#   For a library or package, you might want to ignore these files since the code is
#   intended to run in multiple environments; otherwise, check them in:
# .python-version

# pipenv
#   According to pypa/pipenv#598, it is recommended to include Pipfile.lock in version control.
#   However, in case of collaboration, if having platform-specific dependencies or dependencies
#   having no cross-platform support, pipenv may install dependencies that don't work, or not
#   install all needed dependencies.
#Pipfile.lock

# poetry
#   Similar to Pipfile.lock, it is generally recommended to include poetry.lock in version control.
#   This is especially recommended for binary packages to ensure reproducibility, and is more
#   commonly ignored for libraries.
#   https://python-poetry.org/docs/basic-usage/#commit-your-poetrylock-file-to-version-control
#poetry.lock

# pdm
#   Similar to Pipfile.lock, it is generally recommended to include pdm.lock in version control.
#pdm.lock
#   pdm stores project-wide configurations in .pdm.toml, but it is recommended to not include it
#   in version control.
#   https://pdm.fming.dev/#use-with-ide
.pdm.toml

# PEP 582; used by e.g. github.com/David-OConnor/pyflow and github.com/pdm-project/pdm
__pypackages__/

# Celery stuff
celerybeat-schedule
celerybeat.pid

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# pytype static type analyzer
.pytype/

# Cython debug symbols
cython_debug/

# PyCharm
#  JetBrains specific template is maintained in a separate JetBrains.gitignore that can
#  be added to the global gitignore or merged into this project gitignore.
#  For PyCharm Community Edition, use 'PyCharm CE' in the .gitignore template
.idea/

# DevContainer
.devcontainer/docker-compose.override.yml
EOF
    fi
fi

# Replace PROJECT_NAME placeholders
echo "🔧 Configuring project..."

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/PROJECT_NAME/$PROJECT_NAME/g" setup.py
    sed -i '' "s/PROJECT_NAME/$PROJECT_NAME/g" README.md
else
    # Linux
    sed -i "s/PROJECT_NAME/$PROJECT_NAME/g" setup.py
    sed -i "s/PROJECT_NAME/$PROJECT_NAME/g" README.md
fi

echo ""
echo "✅ Python project created successfully: $PROJECT_PATH"
echo ""
echo "📝 Next steps:"
echo "   1. cd $PROJECT_PATH"
echo "   2. code ."
echo "   3. When prompted, click 'Reopen in Container'"
echo "   4. Wait for container build (first time: ~5-10 minutes)"
echo "   5. Container will automatically:"
echo "      - Install Python dependencies"
echo "      - Set up development environment"
echo "      - Configure linting and formatting tools"
echo ""
echo "🔧 Project structure:"
echo "   - src/          : Source code"
echo "   - tests/        : Test files"
echo "   - docs/         : Documentation"
echo "   - requirements.txt : Dependencies"
echo ""
echo "🐍 Development commands:"
echo "   - python src/main.py    : Run application"
echo "   - pytest               : Run tests"
echo "   - black src tests      : Format code"
echo "   - flake8 src tests     : Lint code"
echo ""
echo "🎯 Happy Python Development with Spec-Driven Development!"