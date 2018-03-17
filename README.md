# dotfiles

Uses [box](https://github.com/AndrewVos/box) to build
my dev machines.

## Installing Arch Linux

Use [Etcher](https://etcher.io/) to make a bootable Arch Linux USB.

### Connect to wireless

`wifi-menu`

### Partitioning

#### Creating partitions

To create partitions use `cfdisk /device/nvme0n1`.

- `Efi system` partition of 500M
- `Linux swap` partition of 16G
- `Linux filesystem` partition using the rest of the disk space

#### Formatting partitions

```bash
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3
```

#### Mounting partitions

```bash
mount /dev/nvme0n1p3 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
swapon /dev/nvme0n1p2
```

### Installing required packages

```bash
pacstrap /mnt base base-devel sudo wpa_supplicant dialog iw wpa_actiond
```

### Setting up fstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

### Chroot

```bash
arch-chroot /mnt
```

### Time and timezone

Uncomment en_US.UTF-8 UTF-8 and any localizations you need in `/etc/locale.gen`.

```bash
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
echo 'LANG=en_US.UTF-8' >> /etc/locale.conf
hwclock --systohc
locale-gen
```

### Setting up hostname

```bash
echo "YOUR_HOST_NAME" > /etc/hostname
echo '127.0.0.1	localhost' >> /etc/hosts
echo '::1 localhost' >> /etc/hosts
echo '127.0.1.1	YOUR_HOST_NAME.localdomain YOUR_HOST_NAME' >> /etc/hosts
```

### Setting the root password

```bash
passwd
```

### Creating your user

```bash
useradd -mg users -G wheel,storage,power -s /bin/bash YOUR_USER_NAME
passwd YOUR_USER_NAME

```

### Allowing your user to sudo

Edit `/etc/sudoers` like this:

```bash
EDITOR=vi visudo
```

Then add this line to it:

```
%wheel ALL=(ALL) ALL
```

### Make netctl automatically connect to your wireless networks

Make sure to use the correct wireless interface name by looking at `ip link`.
In this case my interface is `wlp58s0`.

```
sudo systemctl enable netctl-auto@wlp58s0.service
```

### Install a bootloader

```
bootctl install
```

Create a boot entry in `/boot/loader/entries/arch.conf`:

```
title          Arch Linux
linux          /vmlinuz-linux
initrd         /initramfs-linux.img
options        root=/dev/nvme0n1p3 rw
```

Change `/boot/loader/loader.conf` to:

```
timeout 3
default arch
```

### Rebooting

Exit the chroot:

`exit`

Then reboot:

`reboot`

## Provisioning the machine with box

```bash
bash <(wget -o /dev/null -qO- https://raw.githubusercontent.com/AndrewVos/box-vos/master/box.sh)
```
