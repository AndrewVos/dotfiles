echo "Deleting old backups..."
rm -R ~/.vim.old
rm ~/.vimrc.old

echo "Backing up..."
mv ~/.vim ~/.vim.old
mv ~/.vimrc ~/.vimrc.old

echo "Installing..."
cp -R .vim ~/
cp .vimrc ~/
