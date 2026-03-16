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

echo "Developer tools installation complete."
