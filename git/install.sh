#!/bin/bash
set -e

# Install required tools
brew install git-delta gh

# Define variables
BASEDIR=$(dirname "$0")
SSH_KEY="$HOME/.ssh/id_github"
SSH_CONFIG="$HOME/.ssh/config"
GITCONFIG="$HOME/.gitconfig"
GITIGNORE="$HOME/.gitignore_global"
MAC_NAME=$(hostname)

mkdir -p "$HOME/.ssh"

# Copy Git configuration files if they don't already exist
echo "Setting up Git configuration..."
[ ! -f "$GITCONFIG" ] && cp "$BASEDIR/.gitconfig" "$GITCONFIG"
[ ! -f "$GITIGNORE" ] && cp "$BASEDIR/.gitignore_global" "$GITIGNORE"

# Generate SSH key if it doesn't exist
if [ ! -f "$SSH_KEY" ]; then
  echo "SSH key not found at $SSH_KEY. Generating a new one..."
  echo "Generating SSH key..."
  ssh-keygen -t ed25519 -C "ben196888@gmail.com" -f "$SSH_KEY"
  echo "SSH key generated successfully."

else
  echo "SSH key already exists at $SSH_KEY"
fi

# Configure SSH
echo "Configuring SSH..."
touch "$SSH_CONFIG"
if ! grep -q "IdentityFile $SSH_KEY" "$SSH_CONFIG"; then
  cat <<EOF >> "$SSH_CONFIG"
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $SSH_KEY
EOF
  ssh-add --apple-use-keychain "$SSH_KEY"
else
  echo "SSH configuration already exists."
fi

# Add SSH key to GitHub using gh CLI
echo "Adding SSH key to GitHub..."
if ! gh auth status &>/dev/null; then
  echo "You are not logged into GitHub CLI. Logging in now..."
  gh auth login --hostname github.com --git-protocol ssh --web --skip-ssh-key -s admin:public_key
fi

if gh auth status &>/dev/null; then
  gh ssh-key add "$SSH_KEY.pub" --title "$MAC_NAME SSH Key"
  echo "SSH key added to GitHub successfully."
else
  echo "Failed to log in to GitHub CLI. Please try logging in manually using 'gh auth login'."
fi

# Commented out GPG-related parts (optional)
# brew install gpg2
# echo "==== Generate RSA key ===="
# gpg --full-generate-key
# echo "=========================="
# echo "====== List GPG RSA key ======"
# gpg --list-secret-keys --keyid-format=long
# echo "=============================="
# gh gpg-key add ~/.gnupg/pubring.kbx
