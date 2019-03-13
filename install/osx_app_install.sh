# Spectacle: window manager
declare -a apps=("skype" "spotify" "calibre" "cyberduck" "flux" "vlc" "typora" "iterm2" "google-chrome" "caskroom/versions/google-chrome-canary" "firefox" "docker" "sequel-pro" "alfred" "whatsapp" "adobe-acrobat-reader" "visual-studio-code" "postman" "spectacle")

set -x

for app in "${apps[@]}"
do
    brew cask install --appdir="/Applications" $app
done
