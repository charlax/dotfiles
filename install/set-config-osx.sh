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
# vimdiff before after
# Google the name

# shellcheck source=./helpers/setup.sh
. "$(dirname "$0")/../helpers/setup.sh" # Load helper script from dotfiles/helpers.


# Close any open System Settings panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Settings" to quit'

# Ask for the administrator password upfront and keep-alive until script finishes
sudo -v

# ==============================================================================
# System
# ==============================================================================

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Enable Dark mode system-wide (commented out - set manually in System Settings instead)
# defaults write NSGlobalDomain AppleInterfaceStyle -string Dark

# Disable all user interface sound effects (clicking, dragging, etc.)
defaults write com.apple.systemsound 'com.apple.sound.uiaudio.enabled' -int 0

# Disable sound feedback when volume is changed
defaults write -g com.apple.sound.beep.feedback -int 0

# Set alert/beep volume to 0 (mute system alert sounds)
defaults write NSGlobalDomain com.apple.sound.beep.volume -float 0

# Disable the system alert sound entirely
defaults write NSGlobalDomain com.apple.sound.beep.flash -int 0

# Disable Finder sounds (empty trash, drag, etc.)
defaults write com.apple.finder FinderSounds -bool false

# ==============================================================================
# Screen
# ==============================================================================

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
# Set password delay to 0 seconds (immediate)
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Set screen saver to start after 300 seconds (5 minutes) of inactivity
defaults -currentHost write com.apple.screensaver idleTime 300

# ==============================================================================
# Finder
# ==============================================================================

# Show all file extensions in Finder (e.g., .txt, .jpg, .pdf)
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show hidden files by default (files starting with .)
# defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show status bar at bottom of window (shows item count, disk space)
defaults write com.apple.finder ShowStatusBar -bool true

# Show the ~/Library folder (hidden by default on macOS)
chflags nohidden ~/Library

# Keep folders on top when sorting by name in Finder windows
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Use list view (Nlsv) in all Finder windows by default (icnv=icon, clmv=column, Nlsv=list)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Prevent Finder from opening folders in new tabs instead of new windows
defaults write com.apple.Finder FinderSpawnTab -bool false

# ==============================================================================
# Mac App Store
# ==============================================================================

# Enable the WebKit Developer Tools in the Mac App Store (right-click to inspect elements)
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store (appears in menu bar for troubleshooting)
defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable automatic checking for macOS and app updates (still requires manual install)
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# ==============================================================================
# Dock
# ==============================================================================

# Automatically hide and show the Dock when cursor moves away/towards screen edge
defaults write com.apple.dock autohide -bool true

# Remove the delay before Dock appears (0 = instant, default is 0.5 seconds)
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation duration when hiding/showing Dock (0 = instant, default is 0.5 seconds)
defaults write com.apple.dock autohide-time-modifier -float 0

# ==============================================================================
# Keyboard
# ==============================================================================

# Key symbol mappings for keyboard shortcuts:
# Command:  @
# Control:  ^
# Option:   ~
# Shift:    $

# Set keyboard shortcut for switching input sources to cmd-option-a
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Select the previous input sources" '@~a'

# Set keyboard shortcut for "Paste and Match Style" to cmd-shift-v (standard across apps)
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Paste and Match Style" "@\$v"

# Disable press-and-hold for accented characters, enable key repeat instead (good for vim)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set keyboard repeat rate to fastest (2 = 30ms between repeats, lower is faster)
defaults write NSGlobalDomain KeyRepeat -int 2
# Set delay before key repeat starts (15 = 225ms, lower is shorter delay)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Enable full keyboard access for all controls (use Tab to navigate all UI elements)
# Mode 3 = all controls (buttons, tabs, etc), Mode 0 = text boxes and lists only
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# ==============================================================================
# Sound
# ==============================================================================

# Disable sounds in iMessages
defaults write com.apple.iChat 'PlaySoundsKey' -bool false

# Disable Mail sound effects (requires manually setting in Mail preferences)
# Mail is sandboxed and preferences can't be written via defaults command
# defaults write com.apple.mail PlayMailSounds -bool false

# Disable screenshot sound effect
defaults write com.apple.screencapture disable-sound -bool true

# ==============================================================================
# Full cleanup
# ==============================================================================

# Register which apps have custom keyboard shortcuts (makes them appear in System Settings)
# This setting no longer works on modern macOS - keyboard shortcuts appear automatically
# defaults write com.apple.universalaccess com.apple.custommenu.apps -array "NSGlobalDomain" "com.apple.finder" "com.apple.Terminal" "com.apple.mail"

# Restart affected applications to apply changes immediately
# cfprefsd: Configuration preference daemon (manages defaults system)
# Dock: The application dock
# Finder: File manager
# Messages: iMessage app
# SystemUIServer: Status bar and menu extras
# Terminal: Terminal app
# Photos: Photos app
for app in "cfprefsd" "Dock" "Finder" "Messages" "SystemUIServer" "Terminal" "Photos";
do
	killall "$app" > /dev/null 2>&1
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
