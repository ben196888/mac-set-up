#!/bin/sh

# Update the repos
brew update

# Check the health
brew doctor

# Install fish
brew install fish

# Install developing tools
brew install node
brew install nvm
brew install yarn
brew install watchman
brew install python3

# Install golang
mkdir $HOME/Go
mkdir -p $HOME/Go/src/github.com/ben196888
brew install go
brew install glide

# Install xhyve & docker-machine-driver-xhyve
brew install --HEAD xhyve
brew install docker-machine-driver-xhyve
# docker-machine-driver-xhyve need root owner and uid
sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve

# Install envsubt tool
brew install gettext

# Install optimized tools
brew install ripgrep

# Install security tools
brew install gpg2

# Install internet tools
brew install nmap

# Install deployment tools/otherCLI
brew install kubectl
brew install kompose
brew install heroku
