declare -a apps=("crashplan" "calibre" "cyberduck" "flux" "vlc" "typora")

set -x

for app in "${apps[@]}"
do
    brew cask install --appdir="/Applications" $app
done
