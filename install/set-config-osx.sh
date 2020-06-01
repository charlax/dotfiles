#!/usr/bin/env bash

# Inspired by:
# https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# https://github.com/gibfahn/dot/blob/master/setup/mac.sh
# https://github.com/kevinSuttle/macOS-Defaults/blob/master/.macos
# https://github.com/pawelgrzybek/dotfiles/blob/master/setup-macos.sh

# To check what setting change what
# defaults read > before
# -- change setting
# defaults read > after
# diff before after
# Google the name

# shellcheck source=../helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh" # Load helper script from dotfiles/helpers.


# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# ==============================================================================
# System
# ==============================================================================

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Use Dark mode.
defaults write NSGlobalDomain AppleInterfaceStyle -string Dark

# Sound > Play user interface sound effects = false
defaults write com.apple.systemsound 'com.apple.sound.uiaudio.enabled' -int 0

# Sound > Play feedback when volume is changed = false
defaults write -g com.apple.sound.beep.feedback -int 0

# ==============================================================================
# Screen
# ==============================================================================

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# System Preferences > Desktop & Screen Saver > Start after: Never
defaults -currentHost write com.apple.screensaver idleTime -int 5

# ==============================================================================
# Finder
# ==============================================================================

# Show all extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show hidden files by default
# defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.Finder FXPreferredViewStyle -string "Nlsv"

# Do not spawn tabs
defaults write com.apple.Finder FinderSpawnTab -bool false

# ==============================================================================
# Mac App Store
# ==============================================================================

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# ==============================================================================
# Dock
# ==============================================================================

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# ==============================================================================
# Keyboard
# ==============================================================================

# Command:  @
# Control:  ^
# Option:   ~
# Shift:    $

# Set change input sources
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Select the previous input sources" '@~a'

# cmd-shift-v
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Paste and Match Style" "@\$v"

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a fast keyboard repeat rate (needs relogin).
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# ==============================================================================
# Sound
# ==============================================================================

# Show sound icon in menu bar
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -bool true

# Disable all user interface sound effects
defaults write com.apple.systemsound 'com.apple.sound.uiaudio.enabled' -int 0

# ==============================================================================
# Spectacle
# ==============================================================================

# Setup spectacle config.
spectacle_config="$HOME/Library/Application Support/Spectacle/Shortcuts.json"
if [ ! -L "$spectacle_config" ]; then
  log_info "Overwriting Spectacle shortcuts with link to dotfiles ones."
  mkdir -p "$(dirname "$spectacle_config")"
  [ -e "$spectacle_config" ] && mv "$spectacle_config" "$HOME/Downloads/SpectacleShortcuts.bak.json"
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
