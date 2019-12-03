#!/usr/bin/env bash

# Inspired by:
# ~/.macos — https://mths.be/macos
# https://github.com/gibfahn/dot

. "$(dirname "$0")/../helpers/setup.sh" # Load helper script from dotfiles/helpers.


# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# ==============================================================================
# Finder
# ==============================================================================

# Show all extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# ==============================================================================
# Dock
# ==============================================================================

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# ==============================================================================
# Keyboard
# ==============================================================================

# Command:  @
# Control:  ^
# Option:   ~
# Shift:    $

# Set change input sources
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Select the previous input sources" "@~a"

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate (needs relogin).
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# ==============================================================================
# Spectacle
# ==============================================================================

# Setup spectacle config.
spectacle_config="$HOME/Library/Application Support/Spectacle/Shortcuts.json"
if [ ! -L "$spectacle_config" ]; then
  log_get "Overwriting Spectacle shortcuts with link to dotfiles ones."
  mkdir -p "$HOME/.backup"
  [ -e "$spectacle_config" ] && mv "$spectacle_config" "$HOME/.backup/Shortcuts.json"
  ln -s "$DOTFILES/spectacle/Shortcuts.json" "$spectacle_config"
fi


# ==============================================================================
# full cleanup
# ==============================================================================

# Fill keyboard shortcuts GUI with custom defined shortcuts
defaults write com.apple.universalaccess com.apple.custommenu.apps -array "NSGlobalDomain" "com.apple.finder" "com.apple.Terminal" "com.apple.mail"

# Kill affected applications
for app in "Address Book" "cfprefsd" "Dashboard" "Dock" "Finder" "iTunes" "Messages" "SystemUIServer" "Terminal" "Photos";
do
	killall "$app" > /dev/null 2>&1
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
