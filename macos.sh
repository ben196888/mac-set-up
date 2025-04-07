#!/bin/bash
set -e

echo "Configuring macOS system preferences..."

# Dock: auto-hide and move to the left
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock orientation -string "left"
killall Dock

# Trackpad: enable three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.Accessibility MouseDriver -dict-add TrackpadThreeFingerDragEnabled -bool true

# Trackpad speed: set to max
defaults write -g com.apple.trackpad.scaling -float 3.0

# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Keyboard: set faster key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Expand save and print dialogs by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Remap Caps Lock to Control
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}'

echo "macOS system preferences configured. Some changes may require a logout or reboot to fully apply."
