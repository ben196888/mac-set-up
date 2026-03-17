#!/bin/sh -e

# Install OpenSSL
brew install openssl

# Install optimized tools
#########################
# Install rg to replace grep
brew install ripgrep
# Install ast-grep for structural code search
brew install ast-grep
# Install tree
brew install tree
# Install ack
brew install ack
