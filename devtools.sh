#!/bin/bash
set -e

echo "Installing developer tools..."

# OrbStack (Docker + Linux VM)
brew install --cask orbstack

# kubectl (Kubernetes CLI)
brew install kubectl

# Postman
brew install --cask postman

# Google Cloud SDK
brew install --cask google-cloud-sdk

# ChatGPT desktop app (OpenAI)
brew install --cask chatgpt

# Claude Code (AI coding assistant)
echo "Installing Claude Code..."
curl -fsSL https://claude.ai/install.sh | bash

# Playwright CLI (browser automation)
if ! command -v playwright >/dev/null 2>&1; then
  echo "Installing Playwright..."
  npm install -g playwright
  npx playwright install
else
  echo "Playwright already installed — skipping"
fi

echo "Developer tools installation complete."
