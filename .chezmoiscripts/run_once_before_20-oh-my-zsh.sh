#!/usr/bin/env bash
set -euo pipefail

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "==> oh-my-zsh already installed"
    exit 0
fi

# --keep-zshrc: the installer would otherwise move ~/.zshrc aside and drop in its
# own template. This runs before chezmoi writes ~/.zshrc, so there is usually
# nothing to keep, but the flag also stops it clobbering an existing one.
echo "==> Installing oh-my-zsh"
RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended --keep-zshrc
