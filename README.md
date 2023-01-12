# dotfiles
1. Run these commands
```sh
git clone git@github.com:iserh/dotfiles.git ~/dotfiles
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.editorconfig ~/.editorconfig
```

## Vim
If not already done you also have to install Vundle
```sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Go into a vim session and type `:PluginInstall`


## Tmux
Install tpm
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then go into a tmux session and type `C-a I`


## GNOME terminal
Adjust your GNOME terminal by following the instructions on https://github.com/0xcomposure/monokai-gnome-terminal

