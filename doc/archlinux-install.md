<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Install Arch Linux](#install-arch-linux)
  - [Setup BIOS](#setup-bios)
  - [Boot](#boot)
  - [Wifi](#wifi)
  - [Partition the disk](#partition-the-disk)
  - [Install](#install)
    - [Bootloader](#bootloader)
  - [Reboot](#reboot)
  - [After reboot](#after-reboot)
  - [SSHD](#sshd)
  - [Time NTP](#time-ntp)
  - [Window manager](#window-manager)
  - [Install Chrome](#install-chrome)
  - [Dotfiles](#dotfiles)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Install Arch Linux

Links:

- https://wiki.archlinux.org/index.php/installation_guide
- https://github.com/angristan/arch-linux-install
- https://gist.github.com/eltonvs/d8977de93466552a3448d9822e265e38

## Setup BIOS

For NUC, checkout notes (Linux suspend can brick the NUC), "Setting Intel NUC".

Upgrade to latest BIOS version.

## Boot

Get into bios with F2.

## Wifi

```bash
$ iwctl station wlan0 scan  # optional
$ iwctl station wlan0 get-networks  # optional
$ iwctl station wlan0 connect "network name"
$ iwctl station wlan0 show

# password are stored in /var/lib/iwd

# Clock
timedatectl set-ntp true
timedatectl status
```

## Partition the disk

```bash
$ parted -l  # or fdisk -l  : show devices

# clean up the disk
$ cat /sys/block/nvme0n1/queue/physical_block_size
512
$ cat /sys/block/nvme0n1/queue/logical_block_size
512
$ dd if=/dev/zero of=/dev/nvme0n1 bs=512 count=10000

$ parted /dev/nvme0n1
(parted) mklabel gpt
(parted) mkpart "EFI system partition" fat32 1MiB 261MiB
(parted) set 1 esp on
(parted) mkpart "root partition" ext4 261MiB 100%

# Root partition
# https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system

# grub does not support luks2, see https://wiki.archlinux.org/title/GRUB
$ cryptsetup -y -v luksFormat /dev/nvme0n1p2
$ cryptsetup open /dev/nvme0n1p2 cryptroot
$ mkfs.ext4 /dev/mapper/cryptroot
$ mount /dev/mapper/cryptroot /mnt

# Boot partition
# https://wiki.archlinux.org/title/EFI_system_partition

$ mkfs.fat -F32 /dev/nvme0n1p1
$ mkdir /mnt/boot
$ mount /dev/nvme0n1p1 /mnt/boot

# Swap
dd if=/dev/zero of=/mnt/swapfile bs=1G count=8 status=progress
chmod 600 /mnt/swapfile
mkswap /mnt/swapfile
swapon /mnt/swapfile
```

## Install

```bash
pacman -Sy
pacstrap /mnt base linux linux-firmware vim nano base-devel grub efibootmgr intel-ucode dhclient networkmanager

# chroot
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

vim /etc/locale.gen  # uncomment en_US.UTF-8 UTF-8
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

echo nuc > /etc/hostname

$ vim /etc/hosts  # add localhost
127.0.0.1	localhost
::1		localhost

passwd
```

### Bootloader

Get the UUID for the partition:

```bash
blkid /dev/nvme0n1p2 -s UUID -o value > /tmp/cryptuuid
```

Edit `/etc/mkinitcpio.conf`:

```text
# Add encrypt to HOOKS (order matter)
HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt filesystems fsck)
```

Then run:

```bash
mkinitcpio -P
bootctl install

mkdir -p /boot/loader/entries/
```

Edit `/boot/loader/loader.conf`:

```text
default arch.conf
editor no
auto-entries 0
```

Edit `/boot/loader/entries/arch.conf`:

```text
title Arch
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options cryptdevice=UUID=REPLACE-ME-WITH-UUID:cryptroot root=/dev/mapper/cryptroot rw
```

## Reboot

```bash
exit
swapoff /mnt/swapfile
umount -R /mmt

# if device is busy:
fuser -mv /mnt
```

## After reboot

```bash
systemctl start NetworkManager
systemctl enable NetworkManager

nmcli device wifi connect BSSID_OR_SSID password THEPASSWORD
nmcli d  # check connection

# Update everything
pacman -Syu

# Bluetooth keyboard
pacman -S usbutils bluez bluez-utils

systemctl start bluetooth
systemctl enable bluetooth
bluetoothctl
[bluetooth]# agent KeyboardOnly
default-agent
power on
scan on
pair ADDRESS
connect ADDRESS

# User
useradd -m $USERNAME
passwd $USERNAME
EDITOR=vim visudo  # uncomment wheel
gpasswd -a $USERNAME wheel

# Update systemd-boot
sudo mkdir /etc/pacman.d/hooks/
cat << EOF | sudo tee -a /etc/pacman.d/hooks/100-systemd-boot.hook
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
EOF
```

## SSHD

```bash
pacman -S openssh

systemctl start sshdgenkeys
systemctl start sshd
systemctl enable sshd

# edit /etc/ssh/sshd_config
# PermitRootLogin no
sudo sshd -t  # configuration is valid if no output

ip addr  # equivalent of ifconfig

ssh-copy-id -i ~/.ssh/mykey $USERNAME@host

# edit /etc/ssh/sshd_config
# disable password auth, change port, restart ssh
# PasswordAuthentication no
systemctl restart sshd
```

## Time NTP

```bash
pacman -S ntp
systemctl enable ntpd
systemctl start ntp

# Check status
ntpq -p
```

## Window manager

```bash
pacman -S xfce4 lightdm lightdm-gtk-greeter xfce4-screensaver
systemctl enable lightdm
```

## Install Chrome

```bash
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -is
```

## Dotfiles

```bash
pacman -S zsh zsh-completions
```
