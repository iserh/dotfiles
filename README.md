# dotfiles
Development environment configuration via dotfiles.


# Getting started
## Requirements
- git
- zsh
- tmux
- vim (with `+python3` support)

## Installation
1. Run these commands
```sh
git clone git@github.com:iserh/dotfiles.git ~/dotfiles
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.editorconfig ~/.editorconfig
```
```sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
Go into a vim session and type `:PluginInstall`

## Tmux
Install tpm
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
Then go into a tmux session and type `C-b I`


# Troubleshooting
## If powerline symbols are weird
```
git clone https://github.com/powerline/fonts.git --depth=1
fonts/install.sh
rm -rf fonts
```


## Oh-my-zsh
Run the following command to install oh-my-zsh and setup the default `.zshrc`:
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp ~/dotfiles/.zshrc_default ~/.zshrc
cp -r ~/dotfiles/conda-zsh-completion ~/.oh-my-zsh/custom/plugins/conda-zsh-completion
```


## Bash scripts
```sh
mkdir -p ~/bin
ln -s ~/dotfiles/bin/* ~/bin/
```

## justfile for python
```sh
ln -s ~/dotfiles/python/justfile ~/dev/justfile
```

## If no zsh available
- Install zsh from conda-forge
- Add to your `.profile`:
```sh
if [ -t 0 ] ; then
    # run zsh as default shell
    # export SHELL=`which zsh`
    export SHELL=<path-to-shell>
    [ -z "$ZSH_VERSION" ] && exec "$SHELL" -l
fi
```
Add this to you .zshrc
```sh
export PATH="$HOME/miniconda3/envs/shell/bin:$PATH"
```
