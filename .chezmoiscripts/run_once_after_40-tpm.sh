#!/usr/bin/env bash
set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
    echo "==> tpm already installed"
else
    echo "==> Installing tpm"
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# install_plugins talks to a running server, and only a server that has read
# ~/.tmux.conf knows about tpm at all.
echo "==> Installing tmux plugins"
session=$(tmux new-session -dP -F '#{session_id}')
tmux source-file "$HOME/.tmux.conf"
"$TPM_DIR/bin/install_plugins"
tmux kill-session -t "$session"
