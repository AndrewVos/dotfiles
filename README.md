# dotfiles

Some scripts to fully provision my machines with my dotfiles and applications.

## Install Arch Linux

First, write the image to a USB stick with Etcher.

If you're using a wireless device then you need to connect to the internet:

```
iwctl station list
iwctl station <DEVICE> scan
iwctl station <DEVICE> get-networks
iwctl station <DEVICE> connect <SSID>
```

Then install:

```
# matebook13

python -m archinstall --config https://raw.githubusercontent.com/AndrewVos/dotfiles/master/archinstall-mb13.json
```

## Reboot

```
reboot
```

## Setup mDNS

Add this to your network config in `/etc/systemd/network/20-{wlan,ethernet}.network`.

```
[Network]
MulticastDNS=yes
```

## Install pj

https://github.com/AndrewVos/pj

## Install dotfiles

```bash
git clone https://github.com/AndrewVos/dotfiles ~/.dotfiles
cd ~/.dotfiles

pj apply
```

## Upgrading packages

```
./upgrade
```
