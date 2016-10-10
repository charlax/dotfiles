declare -a apps=("chrome" "crashplan" "dropbox" "iterm2" "things" "calibre" "cyberduck" "firefox" "flux" "vlc" "typora")

set -x

for app in "${apps[@]}"
do
    brew cask install --appdir="/Applications" $app
done
