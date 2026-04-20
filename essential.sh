#!/bin/bash
set -euo pipefail

# Create WebPrjcts directory if not exists
mkdir -p ~/WebPrjcts

# Install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install

  # Wait for the installation to complete
  echo "Waiting for Xcode Command Line Tools to finish installing..."
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  echo "Xcode Command Line Tools installed successfully."
else
  echo "Xcode Command Line Tools already installed."
fi

# Switch to Command Line Tools to avoid node-gyp issues
sudo xcode-select --switch /Library/Developer/CommandLineTools

# Install Rosetta 2 (for Apple Silicon Macs)
if [[ $(uname -m) == "arm64" ]]; then
  if pkgutil --pkg-info com.apple.pkg.RosettaUpdateAuto >/dev/null 2>&1; then
    echo "Rosetta 2 already installed."
  else
    echo "Installing Rosetta 2..."
    softwareupdate --install-rosetta --agree-to-license
  fi
fi

# Install Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Determine the brew prefix based on architecture
  if [[ $(uname -m) == "arm64" ]]; then
    BREW_PREFIX="/opt/homebrew"
  else
    BREW_PREFIX="/usr/local"
  fi
  echo "Adding Homebrew to PATH..."
  echo "eval \"$($BREW_PREFIX/bin/brew shellenv)\"" >> ~/.zprofile
else
  BREW_PREFIX="$(brew --prefix)"
  echo "Homebrew already installed."
fi

# Export Homebrew environment variables for the current shell
eval "$($BREW_PREFIX/bin/brew shellenv)"
