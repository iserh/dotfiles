#!/usr/bin/env bash
set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
    echo "==> tpm already installed"
    exit 0
fi

echo "==> Installing tpm"
git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
"$TPM_DIR/bin/install_plugins"
