<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Prerequisites](#prerequisites)
  - [Mac Os X](#mac-os-x)
  - [Linux Debian/Ubuntu/Arch](#linux-debianubuntuarch)
- [Installation](#installation)
- [Post-install checklist on a fresh installation - Mac Os X](#post-install-checklist-on-a-fresh-installation---mac-os-x)
  - [Initialization](#initialization)
  - [Mac Os X Settings](#mac-os-x-settings)
  - [Apps to install](#apps-to-install)
- [Misc](#misc)
  - [Profiling ZSH](#profiling-zsh)
- [Useful software (not installed by default)](#useful-software-not-installed-by-default)
- [Checklist before reinstall](#checklist-before-reinstall)
- [Contributing](#contributing)
- [Inspiration](#inspiration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Prerequisites

### Mac Os X

See fresh install below.

### Linux Debian/Ubuntu/Arch

```bash
curl https://raw.githubusercontent.com/charlax/dotfiles/master/install/provision.sh -o ./provision.sh
chmod a+x provision.sh

./provision.sh
# full install:
./provision.sh --full
```

Use this script to fully automate a new machine setup (e.g. with Vagrant):

```bash
install/provision.sh
```

Otherwise, see Installation section below.

## Installation

```bash
DOTFILES="$HOME/.dotfiles"
git clone https://github.com/charlax/dotfiles.git $DOTFILES
# or
git clone git@github.com:charlax/dotfiles.git $DOTFILES

# If you want only dotfiles
python3 $DOTFILES/install.py

# On a fresh install
python3 $DOTFILES/install.py --with-all
```

To install all the required software, run:

```bash
~/.dotfiles/install/install-apps-all.sh
```

## Post-install checklist on a fresh installation - Mac Os X

### Initialization

1. Install any OS upgrade
2. Start with installing XCode from the App Store - it takes quite a long time. Open it and accept the T&C.
3. Install [Homebrew](https://brew.sh/) (see above)
4. Run the steps below in the terminal:

```bash
# Make sure the account name is correct:
whoami
# If it needs to be changed, create a new temporary admin. Follow this guide:
# https://support.apple.com/en-us/HT201548

# Install dependencies
brew install git python3

# Create an SSH key and add it to Github
ssh-keygen -t ed25519 -C "youremail@example.com"
pbcopy < ~/.ssh/id_rsa.pub
# Then add it to Github

# Verify you can connect to github:
ssh -T git@github.com

# Install local git settings
cp $DOTFILES/git/gitconfig.local.template $DOTFILES/git/.gitconfig.local
```

Once this is done, follow the instruction above (Installation).

### Mac Os X Settings

- Change the computer name
- Add French input source
- Set keyboard shortcuts
  - Set the change input source shortcuts

### Apps to install

Manually (see the script in `install/` for automatically installed apps):

- Annotate (App Store)
- Grammarly
- Keynote (App Store)
- Kindle (App Store)
- Numbers (App Store)
- Pages (App Store)
- Pixelmator (App Store)
- Things (App Store)
- Time Out (App Store)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (better to install manually as it requires Max Os X permissions)
- iA Writer (App Store)

Setup the following apps:

- Password application
- Backup application
- Chrome
- Rectangle (give permissions)
- Things cloud
- Printers
- Open [UTC Time](https://apps.apple.com/us/app/utc-time/id1538245904?mt=12) at login
- Setup [MeetingBar](https://github.com/leits/MeetingBar) (`brew install meetingbar`)

## Misc

- You can copy the dotfiles in the current directory through `copy-dotfiles-here.sh`

### Profiling ZSH

Use `zprof`:

```
# At the beginning of your file, e.g. zshrc
zmodload zsh/zprof

...

# At the end:
zprof
```

## Useful software (not installed by default)

See [Awesome tools](./doc/awesome-tools.md)

## Checklist before reinstall

- Run `ncdu`
- Backup local configuration (`find $DOTFILES -iname "*.local.*"`)
- Backup SSH keys (`ls ~/.ssh`)
- Backup GPG keys
  - Check keys: `gpg --list-secret-keys --keyid-format LONG`
  - Export: `gpg -o ~/Downloads/private.gpg --export-options backup --export-secret-keys 120501+charlax@users.noreply.github.com`
- Check each app for backup, go through list in `Applications/`
  - Anki
- Backup hidden files in repo
  - Check `git status --ignored` in dotfiles
- Check folders listed below
- Make sure branches in repo are pushed (use `clean-up-weekly`)
- Search the Internet for "what folders to backup"
- Search the Internet for "checklist before factory reset"
- Backup photos (too important)
- Make sure iCloud sync is finished (check status bar in Finder)
- What's most important? Is it backed up?
  - Pictures
- Empty Bin
- Check VirtualMachines
- [Check Apple's advices](https://support.apple.com/en-us/HT201065)

Before factory reset:

- [ ] Sign out of iCloud account
- [ ] Disconnect Bluetooth devices
- [ ] Sign out of iMessages

Folders to check:

```text
/Library
~
~/CodePerso
~/Library
```

## Contributing

Checkout [CONTRIBUTING.md](./CONTRIBUTING.md)

## Inspiration

- [holman](https://github.com/holman/dotfiles)
- [dotfiles.github.io](https://dotfiles.github.io/inspiration/)
