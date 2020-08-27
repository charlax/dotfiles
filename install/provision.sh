# Provision a new machine

sudo apt update
sudo apt upgrade
sudo apt install git curl file build-essential

# Install homebrew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

DOTFILES="$HOME/.dotfiles"
git clone https://github.com/charlax/dotfiles.git $DOTFILES

python3 $DOTFILES/install.py --with-all

~/.dotfiles/install/install-apps-all.sh
