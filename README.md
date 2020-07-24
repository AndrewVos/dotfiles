# dotfiles

Some scripts to fully provision ubuntu machines with my dotfiles and applications.

## Install

```bash
sudo apt install -y git
git clone https://github.com/AndrewVos/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
```

## Upgrade

```bash
cd ~/.dotfiles
./install --upgrade
```

## Test

```bash
sudo snap install docker
./test
```
