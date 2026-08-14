# dotfiles

Development environment for macOS and Linux, managed with [chezmoi](https://chezmoi.io).

Shell is zsh + oh-my-zsh, editor is Neovim running [LazyVim](https://lazyvim.github.io),
multiplexer is tmux + [tpm](https://github.com/tmux-plugins/tpm), packages come from Homebrew.

## Install on a new machine

Install [Homebrew](https://brew.sh) first — everything else follows from it. Then:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply --source="$HOME/dotfiles" git@github.com:iserh/dotfiles.git
```

That clones this repo to `~/dotfiles`, writes the config that points chezmoi back at it,
applies every managed file, and runs the bootstrap scripts in `.chezmoiscripts/`:

| Script | Does |
|---|---|
| `run_once_before_20-oh-my-zsh` | Installs oh-my-zsh (`--keep-zshrc`, so it cannot overwrite the managed `.zshrc`) |
| `run_onchange_after_30-brew-bundle` | `brew bundle --global` against `~/.Brewfile` |
| `run_once_after_40-tpm` | Clones tpm and installs the tmux plugins |
| `run_onchange_after_50-nvim-plugins` | `Lazy! sync` to the latest plugin versions, compiles the Treesitter parsers, then installs the Mason tools |
| `run_once_after_60-zshrc-local` | Scaffolds an empty `~/.zshrc.local` |

Then finish by hand:

- Fill in `~/.zshrc.local` — see [Shell layout](#shell-layout).
- Install a Nerd Font and point the terminal at it — see [Fonts](#fonts).
- `chsh -s $(which zsh)` if zsh is not already the login shell.

## Day to day

chezmoi copies files rather than symlinking them, so edits in `$HOME` have to be pushed back
into the repo explicitly.

```sh
chezmoi diff            # what would change in $HOME
chezmoi status          # short form
chezmoi update -v       # git pull, then apply
chezmoi re-add          # pull local edits back into the repo
chezmoi cd              # drop into ~/dotfiles to commit and push
```

The usual loop after changing something locally:

```sh
chezmoi re-add && chezmoi cd && git add -A && git commit -m "..." && git push
```

Neovim rewrites `lazyvim.json` on every `:LazyExtras` toggle, so
`chezmoi re-add ~/.config/nvim` is the one to remember. `lazy-lock.json` is deliberately
untracked — see [Neovim](#neovim).

Alternatively edit through chezmoi and skip the re-add: `chezmoi edit --apply ~/.zshrc`.

## What's managed

```
dot_zshenv                    → ~/.zshenv
dot_zshrc                     → ~/.zshrc
dot_tmux.conf                 → ~/.tmux.conf
dot_editorconfig              → ~/.editorconfig
dot_Brewfile                  → ~/.Brewfile
dot_config/ghostty/config     → ~/.config/ghostty/config
dot_config/tuicr/config.toml  → ~/.config/tuicr/config.toml
dot_config/nvim/              → ~/.config/nvim/    (LazyVim)
private_dot_claude/skills/    → ~/.claude/skills/  (Claude Code skills)
.chezmoiscripts/              bootstrap, not applied to $HOME
```

Source names are positional: `dot_` becomes a leading dot, `private_` means mode 0700.
chezmoi ignores any source file that starts with a literal `.`, which is why
`~/.config/nvim/.neoconf.json` is stored as `dot_config/nvim/dot_neoconf.json`. `.chezmoiignore`
holds the two things that must not be managed: `README.md`, which would otherwise land in
`$HOME`, and `~/.config/nvim/lazy-lock.json`, which would reintroduce plugin pinning.

Add something new with `chezmoi add ~/.config/foo`, then commit.

## Shell layout

zsh reads different files depending on how it was started, and only `.zshenv` is read by all
of them. Splitting along that line is what makes `git commit` hooks, cron and scripts see the
same toolchain an interactive shell does.

| File | Read by | Holds |
|---|---|---|
| `.zshenv` | every zsh | `PATH`: brew, `~/.local/bin`, nvm's default `bin` |
| `.zshrc` | interactive only | oh-my-zsh |
| `.zshrc.local` | interactive only, untracked | tokens, functions, aliases |

`~/.zshrc` ends with `[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"`.

Anything a non-interactive shell needs — a binary on `PATH`, an env var a hook reads — has to
go in `.zshenv`; putting it in `.zshrc` will appear to work in a terminal and fail everywhere
else. `.zshenv` runs on every shell, so keep it cheap: the `brew shellenv` call is guarded on
`$HOMEBREW_PREFIX` so nested shells skip the fork, and `typeset -U path` stops `PATH` growing.

No secret ever reaches the repo. Before pushing, a cheap sanity check:

```sh
chezmoi cd && git diff --cached | grep -iE 'token|secret|password|glpat-|api[_-]key'
```

## Packages

`dot_Brewfile` is the package list. Install, then snapshot:

```sh
brew install <pkg>
brew bundle dump --force --file="$HOME/dotfiles/dot_Brewfile"
chezmoi apply
```

`brew bundle dump` writes every on-request formula, so prune the result to what actually
belongs in a fresh machine. `chezmoi apply` then refreshes `~/.Brewfile` and, because the file
changed, re-runs the `brew bundle` script.

## Fonts

LazyVim's UI uses Nerd Font glyphs unconditionally, so without one the statusline, file tree
and completion menu render tofu boxes. This setup uses **JetBrainsMono Nerd Font**.

Either install it from Homebrew:

```sh
brew install --cask font-jetbrains-mono-nerd-font
```

or download it from <https://www.nerdfonts.com/font-downloads>, pick *JetBrainsMono*, and drop
the `.ttf` files into `~/Library/Fonts` (macOS) or `~/.local/share/fonts` + `fc-cache -f`
(Linux).

Installing the font is only half of it: Neovim is a terminal application and never selects a
font itself, so the terminal has to be told.

Ghostty is covered — `dot_config/ghostty/config` sets `font-family` and is applied with
everything else. Ghostty takes the rest of the line literally, so the family name is unquoted;
bold and italic faces are derived automatically. Check what it resolved with:

```sh
ghostty +validate-config && ghostty +show-config | grep font-family
```

iTerm2 is not managed — its settings only export as a plist, so set the font through the GUI:
Settings → Profiles → Text → Font. Either way, verify by opening `:Lazy`; a correct font shows
icons in the header rather than boxes.

## Neovim

Stock LazyVim plus these extras (`lazyvim.json`): docker, json, markdown, python, toml,
typescript.

Nothing here is version-pinned. `lazy-lock.json` is untracked and `.chezmoiignore`d, the
bootstrap script runs `Lazy! sync`, and `brew "neovim"` floats too, so a fresh machine and
`:Lazy update` both land on whatever is current. Update with `:Lazy update`, then `:TSUpdate`
if a parser stops matching its queries.

The tradeoff is deliberate. Pinning plugins while Homebrew keeps moving Neovim is the one
combination nobody upstream tests, and it fails in proportion to how long the two have been
apart: an 18-month gap once surfaced as `attempt to call method 'range' (a nil value)` from a
Treesitter query directive, because Neovim 0.12 had changed a query API that the pinned
nvim-treesitter still called the old way. Floating both trades reproducibility across machines
and one-command rollback for breakage that arrives in small, attributable increments while the
two halves stay in a combination upstream actually tests. It also means an update can break the
editor at a moment of its choosing rather than yours, and that two machines provisioned weeks
apart are not guaranteed to match.

nvim-treesitter tracks its `main` branch, which compiles parsers on demand rather than shipping
them, so `tree-sitter-cli` is in the Brewfile — without it every parser build fails. Parsers land
in `~/.local/share/nvim/lazy/nvim-treesitter/parser/`, outside the repo; only the plugin pin is
tracked. Rebuild them by hand with `:TSUpdate`.

`mason-sync.lua` installs the LSP servers, formatters and linters those extras imply. It exists
because Mason normally resolves its `ensure_installed` list off nvim-lspconfig, which loads on
`BufReadPre` and therefore never fires in the headless session a bootstrap script gets; the
script derives the same list directly and exits when the last download closes. Run it by hand
any time with:

```sh
nvim --headless -c "luafile ~/.config/nvim/mason-sync.lua"
```

Both headless steps arm a timeout before anything that can throw. A headless nvim has no UI to
return to, so an uncaught error there hangs the bootstrap run instead of failing it.

Mason spawns `npm` as a child process, so npm has to be a real binary on `PATH`. If node comes
from nvm and `~/.zshrc.local` only defines lazy-loading shell functions, every npm-based server
(`pyright`, `vtsls`, `json-lsp`, the docker servers) fails with `npm is not executable`. Put
nvm's default `bin` directory on `PATH` directly.

LazyVim binds `gd`, `gr`, `gI`, `gy` and `K` per-buffer on LSP attach, so if they appear dead in
a file, no server attached: check `:LspInfo`, add the language extra with `:LazyExtras`, then
`chezmoi re-add ~/.config/nvim`.

## Code review

[tuicr](https://github.com/agavra/tuicr) is a code review TUI with vim keybindings: read a diff
in the terminal, leave PR-style comments on it, then export them to GitHub, GitLab, Bitbucket or
the clipboard. It comes from homebrew-core, so it installs with everything else; full option
reference is in the upstream [`docs/CONFIG.md`](https://github.com/agavra/tuicr/blob/main/docs/CONFIG.md).

`leader` is `,` rather than the stock `;`, which frees `;` for its vim meaning (repeat `f`/`t`
forward) inside the diff view. `comment_vim` stays off: the comment box keeps readline bindings,
so `Esc` is not overloaded while typing prose.

`comment_types` sets the classification cycle to [Conventional
Comments](https://conventionalcomments.org). The list is a full replacement rather than an
addition — the configured types plus the always-available `None` are all that exist — and the
first entry becomes the default, so the array is ordered by how often each label gets used, not
alphabetically. Tab cycles through it in that same order. `[forge] comment_type_prefix` is left at
its default `true`, so submitted comments carry the `[ISSUE]`/`[SUGGESTION]` tag in the body — the
label survives in the forge's own UI, in notification emails, and for anyone reading the thread
without the legend to hand.

`theme` is pinned to `catppuccin-mocha` instead of the `theme_dark`/`theme_light` pair, so tuicr
stays dark even when Ghostty follows the system into light mode — a deliberate difference from
the terminal, which does track appearance. `transparent_background = false` goes with it: panels
paint the theme's own background rather than letting the terminal's show through, which keeps the
diff gutters readable against Mocha.

## Agent setup

`~/.claude/skills/setup-workstation/SKILL.md` documents all of the above for Claude Code. With
it in place, "set up this machine from my dotfiles" or "add this file to my dotfiles" is enough
instruction.
