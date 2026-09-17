#!/usr/bin/env bash

# tmux-fzf's window menu plus a "reorder" action it does not have: insert the
# current window before another one and shift the rest up. Stock actions are
# handed straight to the plugin.

PLUGIN_DIR="$HOME/.tmux/plugins/tmux-fzf"
source "$PLUGIN_DIR/scripts/.envs"

action=$(printf "switch\nreorder\nlink\nmove\nswap\nrename\nkill\n[cancel]" |
    eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS")
[[ -z "$action" || "$action" == "[cancel]" ]] && exit
[[ "$action" != "reorder" ]] && exec "$PLUGIN_DIR/scripts/window.sh" "$action"

# The key binding passes the window it was pressed in; a client-less run-shell
# cannot work it out for itself.
current="${TMUX_FZF_WINDOW:-$(tmux display-message -p $TMUX_FZF_CLIENT_ARG '#S:#I')}"
session="${current%%:*}"

windows=$(tmux list-windows -t "$session" -F '#S:#{window_index}: #{window_name}' |
    grep -v "^$current: ")
[[ -z "$windows" ]] && exit

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --header='Move this window before which one?'"
target=$(printf "%s\n[cancel]" "$windows" |
    eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS $TMUX_FZF_PREVIEW_OPTIONS")
[[ -z "$target" || "$target" == "[cancel]" ]] && exit

tmux move-window -b -s "$current" -t "${target%%: *}"
tmux move-window -r -t "$session"
