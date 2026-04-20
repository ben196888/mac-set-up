#!/bin/bash
set -euo pipefail

echo "Installing developer tools..."

# OrbStack (Docker + Linux VM)
brew install --cask orbstack

# Docker CLI
brew install docker

# kubectl (Kubernetes CLI)
brew install kubectl

# Helm (Kubernetes package manager)
brew install helm

# Postman
brew install --cask postman

# Google Cloud SDK
brew install --cask google-cloud-sdk

# ChatGPT desktop app (OpenAI)
brew install --cask chatgpt

# Claude Code (AI coding assistant)
if ! command -v claude >/dev/null 2>&1; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "Claude Code already installed — skipping"
fi

# Playwright CLI (browser automation)
if ! command -v playwright >/dev/null 2>&1; then
  echo "Installing Playwright..."
  if ! command -v npm >/dev/null 2>&1 || ! command -v npx >/dev/null 2>&1; then
    echo "Node.js/npm is required before installing Playwright."
    exit 1
  fi
  npm install -g playwright
  npx playwright install
else
  echo "Playwright already installed — skipping"
fi

echo "Developer tools installation complete."
