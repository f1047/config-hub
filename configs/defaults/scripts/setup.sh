#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"

. "$project_root"/utils/header.sh

printf "$(header info) Applying macOS defaults...\n"

###############################################################################
# System Appearance
###############################################################################

# Always show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Set appearance to auto (switches between light/dark based on system)
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# Blur menu bar (Set menu bar background)
defaults write -g SLSMenuBarUseBlurredAppearance -bool true

###############################################################################
# Desktop & Window Manager
###############################################################################

# Disable double-click to minimize window
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false

# Disable click desktop to show/hide windows
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

###############################################################################
# Keyboard
###############################################################################

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set key repeat rate (1 = fastest)
defaults write NSGlobalDomain KeyRepeat -int 1

# Set initial key repeat delay (15 = shorter delay)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Functions keys as standard function keys (F1, F2, etc.) without needing to hold Fn
defaults write -g com.apple.keyboard.fnState -bool true

# Set keyboard shortcut for Lock Screen: Ctrl+Option+Cmd+L
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Lock Screen" "@~^l"

###############################################################################
# Trackpad
###############################################################################

# Enable tap-to-click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Use traditional (non-natural) scroll direction
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

###############################################################################
# Dock
###############################################################################

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Show Dock on the left
defaults write com.apple.dock orientation -string "left"

# Set Dock icon size
defaults write com.apple.dock tilesize -int 77

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Clear all default app icons from the Dock
defaults write com.apple.dock persistent-apps -array

###############################################################################
# Finder
###############################################################################

# Use list view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Set new Finder window target to All My Files
defaults write com.apple.finder NewWindowTarget -string "PfAF"

printf "$(header info) macOS defaults applied. Some changes require logout/restart to take effect.\n"
