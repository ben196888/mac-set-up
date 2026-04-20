#!/bin/bash
set -e

echo "Installing pyenv..."
brew install pyenv

# Ensure pyenv is initialized for this script
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

echo "Installing latest stable Python via pyenv..."
LATEST=$(pyenv install --list | grep -E "^\s*3\.[0-9]+\.[0-9]+$" | tail -1 | tr -d ' ')
pyenv install -s "$LATEST"
pyenv global "$LATEST"
pyenv rehash

echo "Upgrading pip..."
python -m pip install --upgrade pip

echo "Installing Poetry..."
curl -fsSL https://install.python-poetry.org | python3 -

echo "Python setup complete using pyenv + poetry."
