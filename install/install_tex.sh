brew cask install basictex
sudo tlmgr update --self
sudo tlmgr install latexmk

declare -a packages=("secsty" "marvosym" "enumitem")

# Or just (1.4G download):
brew cask install mactex
