vimfiles
========

Installation
------------
```
git clone git://github.com/AndrewVos/vimfiles.git
git clone git://github.com/AndrewVos/dotfile-symlinker.git
mkdir -p vimfiles/.vim.symlink/bundle
git clone http://github.com/gmarik/vundle.git vimfiles/.vim.symlink/bundle/vundle

dotfile-symlinker/symlink --really
vim -c :BundleInstall -c :q -c :q
```
