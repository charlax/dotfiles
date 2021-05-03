# Install Arch Linux

https://wiki.archlinux.org/index.php/installation_guide

## Wifi

```bash
$ iwctl station wlan0 scan
$ iwctl station wlan0 get-networks
$ iwctl station wlan0 connect "network name"
$ iwctl station wlan0 show

# password are stored in /var/lib/iwd

# Clock
timedatectl set-ntp true
timedatectl status
```

## Partition the disk

```bash
parted -l  # or fdisk -l  : show devices
parted /dev/nvme0n1
(parted) mklabel gpt
mkpart "EFI system partition" fat32 1MiB 261MiB
set 1 esp on
mkpart "swap partition" linux-swap 261MiB 8.2GiB
mkpart "root partition" ext4 8.2GiB 100%

# https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system

mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

# Mount
mount /dev/nvme0n1p3 /mnt
mkdir /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi
swapon /dev/nvme0n1p2
```

## Install

```bash
pacstrap /mnt base linux linux-firmware vim nano base-devel grub efibootmgr intel-ucode dhclient networkmanager

# chroot
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

vim /etc/locale.gen  # uncomment en_US.UTF-8 UTF-8
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

echo "nuc" > /etc/hostname
vim /etc/hosts  # add localhost

passwd

# bootloader
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
cat /boot/grub/grub.cfg | grep intel  # make sure intel-ucode shows up
```

## Reboot

```bash
exit
umount -R /mmt
```

## After reboot

```bash
pacman -S usbutils bluez bluez-utils

systemctl start NetworkManager
systemctl enable NetworkManager

nmcli device wifi connect BSSID_OR_SSID password THEPASSWORD

# Bluetooth keyboard
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
```

## SSHD

```bash
pacman -S openssh

systemctl start sshdgenkeys
# edit /etc/ssh/sshd_config
# PermitRootLogin no
# PasswordAuthentication no
sshd -t  # configuration is valid if no output

ip addr  # equivalent of ifconfig

ssh-copy-id -i ~/.ssh/mykey user@host

# disable password auth, change port, restart ssh
```
