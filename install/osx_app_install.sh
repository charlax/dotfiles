declare -a apps=("crashplan" "calibre" "cyberduck" "flux" "vlc" "typora" "iterm2" "google-chrome" "firefox")

set -x

for app in "${apps[@]}"
do
    brew cask install --appdir="/Applications" $app
done