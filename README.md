vimfiles
========

Installation
------------
```
git clone git://github.com/AndrewVos/vimfiles.git
cd vimfiles
git submodule init
git submodule update
ruby install.rb
cd ~/.vim/bundle/Command-T/ruby/command-t
ruby extconf.rb
make
vim -c :BundleInstall -c :q
```
