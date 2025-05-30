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

# Expand save and print dialogs by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Remap Caps Lock to Control
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}'

# Disable spotlight hotkey
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 64 "{ enabled = 0; value = { parameters = (65535, 49, 1048576); type = 'sprt'; }; }"

# Hide Spotlight icon from menu bar
defaults write com.apple.Spotlight MenuBarExtrasEnabled -bool false

# Show language input menu in menu bar
defaults write com.apple.TextInputMenu visible -bool true
defaults write com.apple.TextInputMenu.preferences TextInputMenuEnabled -bool true

# Disable Fn key functionality
defaults write com.apple.HIToolbox AppleFnUsageType -int 0

# Disable default input source shortcut (Command+Space)
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 60 "{ enabled = 0; value = { parameters = (65535, 49, 1048576); type = 'sprt'; }; }"

# Set up custom global shortcut for input source (Option+Space)
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 60 "{ enabled = 1; value = { parameters = (65535, 49, 786432); type = 'sprt'; }; }"

echo "macOS system preferences configured. Some changes may require a logout or reboot to fully apply."
