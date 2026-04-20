#!/bin/bash
set -euo pipefail

echo "Installing Node.js via n..."
brew install n

# Keep n inside the user home directory instead of mutating /usr/local.
export N_PREFIX="$HOME/.n"
mkdir -p "$N_PREFIX"
export PATH="$N_PREFIX/bin:$PATH"

# Install Node LTS
n lts

# Install global JS tools via npm
npm install -g npm yarn pnpm

echo "Installing Deno..."
curl -fsSL https://deno.land/install.sh | sh -s -- -y --no-modify-path

echo "JavaScript environment setup complete."
