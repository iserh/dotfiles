# dotfiles
Development environment configuration via dotfiles.


# Getting started
## Requirements
- git
- vim (with `+python3` support)
- zsh
- tmux

## Installation
1. Run these commands
```sh
git clone git@github.com:iserh/dotfiles.git ~/dotfiles
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.editorconfig ~/.editorconfig
```

### Conda
```sh
mkdir -p ~/miniconda3
wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
```
*(Optional)*: If some requirements are missing, create a conda environment for your shell:
```sh
conda create -n shell -y
~/miniconda3/bin/conda init
```

## Vim
Check if vim supports `+python3`:
```sh
vim --version
```
If not, install vim via conda:
```sh
conda 
```

```sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

## Tmux
Install tpm
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Go into a vim session and type `:PluginInstall`

# Troubleshooting
## If powerline symbols are weird
```
git clone https://github.com/powerline/fonts.git --depth=1
fonts/install.sh
rm -rf fonts
```




Then go into a tmux session and type `C-a I`


## GNOME terminal
This section is following the instructions on https://github.com/0xcomposure/monokai-gnome-terminal:

You need the dconf command (if you run a recent Gnome version).
```sh
sudo apt-get install dconf-cli
```

```sh
git clone https://github.com/0xComposure/monokai-gnome-terminal
./monokai-gnome-terminal/install.sh
rm -rf monokai-gnome-terminal
```


## Apple terminal
Make sure your on `osx` branch of this repo. After installing vim plugins run the following command to match the terminal background:
```sh
cp ~/dotfiles/monokai_pro.vim ~/.vim/bundle/vim-monokai-pro/colors
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
