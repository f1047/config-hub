#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"

. "$project_root"/utils/header.sh

printf "$(header info) Applying macOS defaults...\n"

###############################################################################
# General UI/UX
###############################################################################

# Always show file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

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

# Disable double-click to minimize window
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false

# Set appearance to auto (switches between light/dark based on system)
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# Set keyboard shortcut for Lock Screen: Ctrl+Option+Cmd+L
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Lock Screen" "@~^l"

###############################################################################
# Dock
###############################################################################

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Show Dock on the left
defaults write com.apple.dock orientation -string "left"

# Set Dock icon size
defaults write com.apple.dock tilesize -int 77

# Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Finder
###############################################################################

# Use list view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Set new Finder window target to All My Files
defaults write com.apple.finder NewWindowTarget -string "PfAF"

###############################################################################
# Trackpad
###############################################################################

# Enable tap-to-click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Use traditional (non-natural) scroll direction
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

###############################################################################
# Desktop & Window Manager
###############################################################################

# Disable click desktop to show/hide windows
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

printf "$(header info) macOS defaults applied. Some changes require logout/restart to take effect.\n"
