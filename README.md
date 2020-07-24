# dotfiles

Some scripts to fully provision ubuntu machines with my dotfiles and applications.

## Install

```bash
sudo apt install -y git
git clone https://github.com/AndrewVos/dotfiles ~/.dotfiles
cd ~/.dotfiles

./install # Full desktop install
./install --server # Lightweight server install
./install --upgrade # Upgrade all packages
```

## Test

```bash
sudo snap install docker
./test
```
