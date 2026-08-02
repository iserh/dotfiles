#!/usr/bin/env bash
set -euo pipefail

LOCAL="$HOME/.zshrc.local"

if [ -f "$LOCAL" ]; then
    exit 0
fi

echo "==> Scaffolding $LOCAL"
cat > "$LOCAL" <<'EOF'
# Machine-local setup, sourced at the end of ~/.zshrc.
# Never tracked in ~/dotfiles.

# -------------------- PATH --------------------

# eval "$(/opt/homebrew/bin/brew shellenv)"
# export PATH="$HOME/.local/bin:$PATH"

# -------------------- secrets --------------------

# export GITLAB_HOST=
# export GITLAB_TOKEN=
# export JIRA_API_TOKEN=
EOF
chmod 600 "$LOCAL"
