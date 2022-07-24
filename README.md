# dotfiles
1. Run these commands
```sh
git clone git@github.com:iserh/dotfiles.git ~/dotfiles
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.editorconfig ~/.editorconfig
```

If not already done you also have to install Vundle
```sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
and tpm
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Finally got into a vim session and type
```sh
:PluginInstall
```
