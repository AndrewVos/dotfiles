# dotfiles

Some scripts to fully provision my machines with my dotfiles and applications.

## Setup Arch Linux

First, write the image to a USB stick with Etcher.

Connect to the internet:

```
iwctl station list
iwctl station <DEVICE> scan
iwctl station <DEVICE> get-networks
iwctl station <DEVICE> connect <SSID>
```

Create the following partitions with `cfdisk /dev/sda`:

```
/dev/sda1  | Efi system       | 500M
/dev/sda2  | Linux swap       | 8GB (optional)
/dev/sda3  | Linux filesystem | (use the rest of the space on the disk)
```

```bash
# Format
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3

# Mount
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/sda2

# Install essentials
pacstrap /mnt base linux linux-firmware vi iwd sudo base-devel

# For Intel CPUs:
pacstrap /mnt intel-ucode

# For AMD CPUs:
pacstrap /mnt amd-ucode

# For Intel GPUs
pacstrap /mnt xf86-video-intel

# Set up fstab:
genfstab -U /mnt >> /mnt/etc/fstab

# Switch to chroot
arch-chroot /mnt

# Timezones
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

# Locales
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'LANG=en_GB.UTF-8' > /etc/locale.conf
locale-gen

# Hostname
echo 'YOUR_HOST_NAME' > /etc/hostname
echo '127.0.0.1	localhost' >> /etc/hosts
echo '::1 localhost' >> /etc/hosts
echo '127.0.1.1	YOUR_HOST_NAME.localdomain YOUR_HOST_NAME' >> /etc/hosts

# Set a root password
passwd

# Create your user account
useradd -mg users -G wheel,storage,power,video -s /bin/bash YOUR_USER_NAME
passwd YOUR_USER_NAME

# Allow all users to sudo
echo '%wheel ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

# Bootloader
bootctl install

# Choose a CPU
MICROCODE='intel-ucode'
MICROCODE='amd-ucode'

# Add a boot entry
echo "title   Arch Linux"           >> /boot/loader/entries/arch.conf
echo "linux   /vmlinuz-linux"       >> /boot/loader/entries/arch.conf
echo "initrd  /$MICROCODE.img"     >> /boot/loader/entries/arch.conf
echo "initrd  /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options root=/dev/sda3 rw"    >> /boot/loader/entries/arch.conf

# Exit the chroot and reboot
exit
reboot

# Login and setup wifi
echo '[Match]'    >> /etc/systemd/network/25-wireless.network
echo 'Name=wlan0' >> /etc/systemd/network/25-wireless.network
echo '[Network]'  >> /etc/systemd/network/25-wireless.network
echo 'DHCP=yes'   >> /etc/systemd/network/25-wireless.network
systemctl start systemd-resolved.service
systemctl enable systemd-resolved.service
systemctl start systemd-networkd.service
systemctl enable systemd-networkd.service
systemctl start iwd.service
systemctl enable iwd.service
```

## Install dotfiles

```bash
sudo apt install -y git
git clone https://github.com/AndrewVos/dotfiles ~/.dotfiles
cd ~/.dotfiles

./install --help
```

## Test

```bash
sudo snap install docker
./test
```
