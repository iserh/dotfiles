---
name: setup-workstation
description: Provision or re-sync a machine from the iserh/dotfiles chezmoi repo — Homebrew packages, oh-my-zsh, tmux/tpm, and the LazyVim Neovim config. Use when setting up a new Mac or Linux box, restoring a wiped machine, adding a config file to the dotfiles repo, or reconciling local config drift against the repo.
---

# Set up a workstation from dotfiles

Everything lives in `git@github.com:iserh/dotfiles.git`, managed by
[chezmoi](https://chezmoi.io). The repo doubles as the chezmoi source directory at
`~/dotfiles` (set by `.chezmoi.toml.tmpl`, not chezmoi's default location).

## Which job is this?

| Situation | Go to |
|---|---|
| Fresh machine, nothing installed | [Bootstrap](#bootstrap-a-fresh-machine) |
| Machine already set up, repo has new commits | [Pull changes](#pull-changes-onto-a-machine) |
| Local config was edited, repo doesn't have it | [Capture changes](#capture-local-changes-into-the-repo) |
| A file should start being tracked | [Add a new file](#add-a-new-file) |

## Bootstrap a fresh machine

Prerequisites, none of which the scripts install: `git`, `curl`, [Homebrew](https://brew.sh),
and an SSH key registered with GitHub (otherwise clone over HTTPS and swap the remote
afterwards).

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply --source="$HOME/dotfiles" git@github.com:iserh/dotfiles.git
```

That clones the repo to `~/dotfiles`, writes `~/.config/chezmoi/chezmoi.toml`, and runs the
scripts in `.chezmoiscripts/` in order:

1. `20-oh-my-zsh` — installs oh-my-zsh with `--keep-zshrc` so it cannot clobber the managed one.
2. `30-brew-bundle` — `brew bundle --global` against `~/.Brewfile`; skipped if brew is absent.
3. `40-tpm` — clones tmux plugin manager and installs plugins.
4. `50-nvim-plugins` — `Lazy! restore` to the pinned `lazy-lock.json`, then `mason-sync.lua`
   for the LSP servers and formatters.
5. `60-zshrc-local` — scaffolds a commented-out `~/.zshrc.local`.

Then finish by hand:

- Fill in `~/.zshrc.local` — `GITLAB_TOKEN`, `JIRA_API_TOKEN`. See
  [Shell layout](#shell-layout).
- Install a Nerd Font and set it in the terminal. See [Fonts](#fonts).
- `chsh -s $(which zsh)` if zsh is not already the login shell.

Node, nvm, and anything else beyond the Brewfile are deliberately not automated. Install them
however that machine wants them.
- Open `nvim` once and check `:Lazy` and `:Mason` are clean.

## Pull changes onto a machine

```sh
chezmoi update -v      # git pull + apply, dry-run first with: chezmoi update --dry-run -v
```

Inspect before committing to it:

```sh
chezmoi diff           # what apply would change
chezmoi status         # short form; M = target differs from source
```

## Capture local changes into the repo

chezmoi copies files, so editing `~/.config/nvim/init.lua` directly does **not** update the
repo. Re-add after editing:

```sh
chezmoi re-add                       # re-add every managed file that changed
chezmoi re-add ~/.config/nvim        # or just one subtree
chezmoi cd && git status             # review, then commit and push
```

Neovim in particular writes `lazy-lock.json` and `lazyvim.json` whenever plugins are updated or
extras toggled, so `chezmoi re-add ~/.config/nvim` belongs in that habit.

To edit through chezmoi instead and skip the re-add, use `chezmoi edit --apply <target>`.

## Add a new file

```sh
chezmoi add ~/.config/foo/bar.toml
chezmoi cd && git add -A && git commit && git push
```

Naming in the source directory is positional, and chezmoi **ignores anything starting with a
literal dot** — a file must be named `dot_foo`, not `.foo`, or it will never be applied:

| Target | Source name |
|---|---|
| `~/.zshrc` | `dot_zshrc` |
| `~/.config/nvim/init.lua` | `dot_config/nvim/init.lua` |
| `~/.config/nvim/.neoconf.json` | `dot_config/nvim/dot_neoconf.json` |
| `~/.claude/` (mode 0700) | `private_dot_claude/` |

Repo files that are not home-directory files (`README.md`) are listed in `.chezmoiignore`.

## Shell layout

zsh reads different startup files depending on how it was started, and only `.zshenv` is read
by all of them:

| File | Read by | Holds |
|---|---|---|
| `.zshenv` | every zsh | `PATH`: brew, `~/.local/bin`, nvm's default `bin` |
| `.zshrc` | interactive only | oh-my-zsh |
| `.zshrc.local` | interactive only, untracked, 0600 | tokens, functions, aliases |

Anything a non-interactive shell needs belongs in `dot_zshenv` — a git hook, cron job or script
never sources `.zshrc`, so config placed there works in a terminal and nowhere else. Keep
`.zshenv` cheap: it runs for every shell.

New secrets go in `~/.zshrc.local`, never in a tracked file. Before committing, confirm the
diff is clean:

```sh
chezmoi cd && git diff --cached | grep -iE 'token|secret|password|glpat-|api[_-]key'
```

## Adding a package

Do not hand-edit `~/.Brewfile` on the machine — it is a managed copy. Install, then snapshot:

```sh
brew install <pkg>
brew bundle dump --force --file="$HOME/dotfiles/dot_Brewfile"
chezmoi apply          # refreshes ~/.Brewfile and re-runs 30-brew-bundle
```

`brew bundle dump` emits every on-request formula, so prune it back to what a fresh machine
actually needs before committing.

## Fonts

LazyVim uses Nerd Font glyphs unconditionally; without one its UI renders tofu boxes. This
setup uses **JetBrainsMono Nerd Font**:

```sh
brew install --cask font-jetbrains-mono-nerd-font
```

Or download from <https://www.nerdfonts.com/font-downloads>, pick *JetBrainsMono*, and install
the `.ttf` files to `~/Library/Fonts` (macOS) or `~/.local/share/fonts` + `fc-cache -f` (Linux).

Installing it is only half the job — Neovim is a terminal application and never picks a font, so
the terminal must be pointed at it. Ghostty takes a config file, iTerm2 needs the GUI
(Settings → Profiles → Text → Font):

```sh
# ~/.config/ghostty/config
font-family = "JetBrainsMono Nerd Font Mono"
```

Confirm with `ghostty +list-fonts | grep -i nerd` that the family is visible, and open `:Lazy`
to check icons render rather than boxes.

## Neovim tooling

`~/.config/nvim/mason-sync.lua` installs the LSP servers, formatters and linters implied by the
enabled LazyVim extras, and exits as soon as the last download closes:

```sh
nvim --headless -c "luafile ~/.config/nvim/mason-sync.lua"
```

Mason's own `ensure_installed` hangs off nvim-lspconfig, which loads on `BufReadPre` and so
never fires in a headless session — hence the separate script.

Mason spawns `npm` as a child process. If node comes from nvm and only the lazy-loading shell
functions exist, every npm-based package fails with `npm is not executable`; put nvm's default
`bin` directory on `PATH` in `~/.zshrc.local`.

## Troubleshooting

- **`chezmoi` uses the wrong source dir** — check `chezmoi source-path` prints `~/dotfiles`. If
  not, `~/.config/chezmoi/chezmoi.toml` is missing or stale; regenerate with `chezmoi init`.
- **A file in the repo never appears in `$HOME`** — it is dot-prefixed (chezmoi metadata) or
  matched by `.chezmoiignore`. Verify with `chezmoi managed | grep <name>`.
- **A `run_once_` script needs to run again** — chezmoi remembers it by content hash. Force it
  with `chezmoi state delete-bucket --bucket=scriptState`, then `chezmoi apply`.
- **Neovim LSP keymaps (`gd`, `gr`, `gI`) do nothing in a buffer** — LazyVim sets those
  buffer-locally on LSP attach. `:LspInfo` with zero clients means the language extra for that
  filetype is not enabled; add it with `:LazyExtras`, then `chezmoi re-add ~/.config/nvim`.
