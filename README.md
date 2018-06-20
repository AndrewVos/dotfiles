# dotfiles

Uses [box](https://github.com/AndrewVos/box) to build
my dev machines.

## Installing Arch Linux

Use [Etcher](https://etcher.io/) to make a bootable Arch Linux USB.

### Connect to the internet

If you're using a wired connection then it should be working already,
otherwise just use `wifi-menu`.

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
pacstrap /mnt base base-devel intel-ucode sudo ifplugd wpa_supplicant dialog iw wpa_actiond alsa-utils
```

### Setting up fstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

### Chroot

```bash
arch-chroot /mnt
```

### Timezone

```bash
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
```

### Locale

Uncomment en_US.UTF-8 UTF-8 and any localizations you need in `/etc/locale.gen`.

```bash
locale-gen
echo 'LANG=en_US.UTF-8' >> /etc/locale.conf
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

### Automatic network connections

#### Wireless

Make sure to use the correct wireless interface name by looking at `ip link`.
In this case my interface is `wlp58s0`.

```bash
sudo systemctl enable netctl-auto@wlp58s0.service
```

#### Wired

Get the name of your wired interface with `ip link`.

```bash
cp /etc/netctl/examples/ethernet-dhcp /etc/netctl/ethernet-<interface_name>
```

Edit `/etc/netctl/ethernet-<interface_name>` and change the interface to whatever
the name of your interface is.

Remember to add DNS config to the profile.

For CloudFlare:

```
DNS=('1.1.1.1')
```

```bash
sudo netctl enable ethernet-<interface_name>
```

### Bluetooth

```bash
sudo pacman -S bluez bluez-utils
```

Press the pair button on your device and then inside `bluetoothctl`:

```bash
power on
scan on
pair <TAB_COMPLETE_DEVICE_ID>
trust <TAB_COMPLETE_DEVICE_ID>
connect <TAB_COMPLETE_DEVICE_ID>
```

To automatically start bluetooh add the following to `/etc/bluetooth/main.conf`:

```
AutoEnable=true
```

### Install a bootloader

```
bootctl install
```

Create a boot entry in `/boot/loader/entries/arch.conf`:

```
title          Arch Linux
linux          /vmlinuz-linux
initrd         /intel-ucode.img
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
bash <(wget -o /dev/null -qO- https://raw.githubusercontent.com/AndrewVos/dotfiles/master/box.sh)
```
