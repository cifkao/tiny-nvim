# nvim config

Personal Neovim configuration, forked from [jellydn/tiny-nvim](https://github.com/jellydn/tiny-nvim):
lazy.nvim, snacks.nvim, blink.cmp, native LSP (`lsp/*.lua`), nvim-treesitter (`main` branch) and
LazyVim-style keymaps.

The goal is that a fresh clone behaves the same on every Linux or macOS machine:

- Plugin versions are pinned by `lazy-lock.json`.
- Treesitter parsers are built by the config itself; the `tree-sitter` CLI it needs is downloaded
  into `~/.local/share/nvim/tree-sitter` on demand (version pinned in `lua/utils/treesitter.lua`).
- Everything else is a prerequisite that the config checks and reports (`:checkhealth config`)
  rather than installs.

## Requirements

- **Neovim 0.12 or later.** `scripts/install-neovim.sh` installs the pinned release into `~/.local`
  without root; `brew install neovim` works as well.
- **A C compiler** (`cc`), used to build treesitter parsers: `xcode-select --install` on macOS,
  `gcc` on Linux.
- `git`, `curl`, `tar`, `gzip`.
- Optional: `rg`, `fd`, `lazygit`, `delta`, a [Nerd Font](https://www.nerdfonts.com/), and the LSP
  servers you use (`pyright`, `ruff`, `gopls`, ...). A server whose binary is missing is simply not
  started.

## Install

```sh
git clone git@github.com:cifkao/tiny-nvim.git ~/.config/nvim
nvim
```

The first start installs the plugins at the locked versions and builds the parsers in the
background. Run `:checkhealth config` afterwards (and `:checkhealth nvim-treesitter` for parser
details).

To do the same without opening the UI, e.g. from a provisioning script:

```sh
nvim --headless "+Lazy! restore" +qa
```

## Updating plugins

`lazy-lock.json` is the source of truth, so update on one machine and replicate elsewhere:

1. `:Lazy update` on one machine, then check `:checkhealth config` and `:checkhealth nvim-treesitter`.
2. Commit `lazy-lock.json`.
3. On other machines, pull and run `:Lazy restore`.

`:Lazy sync` ignores the lockfile; avoid it. Bumping `nvim-treesitter` is the one update that can
raise the required Neovim or `tree-sitter` CLI version; adjust `scripts/install-neovim.sh` and
`lua/utils/treesitter.lua` accordingly.

## Troubleshooting

- Parsers fail to load after upgrading Neovim (`ABI version mismatch`): `:TSUninstall all`, restart.
- Parsers fail to build: `:checkhealth config` lists what is missing.
- Formatting: `:ConformInfo`. LSP: `:checkhealth vim.lsp`.

## Features

<details>
<summary>Click to expand features</summary>

This configuration provides a minimal yet powerful development environment with carefully selected plugins organized by category:

### Core Development

- **LSP & Completion**

  - Built-in LSP support (Neovim 0.11+)
  - [blink.cmp](https://github.com/saghen/blink.cmp) (v1.\*): Enhanced completion menu
  - [conform.nvim](https://github.com/stevearc/conform.nvim): Code formatting
  - [nvim-lint](https://github.com/mfussenegger/nvim-lint): Linting support

- **AI & Code Assistance**

  - [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim): AI-powered coding assistant
  - [blink-copilot](https://github.com/fang2hou/blink-copilot): Copilot integration
  - [copilot.vim](https://github.com/github/copilot.vim): GitHub Copilot integration

- **Code Generation & Documentation**

  - [LuaSnip](https://github.com/L3MON4D3/LuaSnip) (v2.\*): Snippet engine
  - [friendly-snippets](https://github.com/rafamadriz/friendly-snippets): Snippet collection
  - [neogen](https://github.com/danymat/neogen): Documentation generator
  - [ts-comments.nvim](https://github.com/folke/ts-comments.nvim): Comment utilities
  - [mini.pairs](https://github.com/echasnovski/mini.pairs): Auto pairs
  - [mini.ai](https://github.com/echasnovski/mini.ai): Extend and create a/i textobjects

- **Git Integration**
  - [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim): Git signs in the sign column

### Testing & Debugging

- [neotest](https://github.com/nvim-neotest/neotest): Testing framework
- [vim-test](https://github.com/vim-test/vim-test): Testing framework
- [trouble.nvim](https://github.com/folke/trouble.nvim): Diagnostics and quickfix management

### UI & Theme

- [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim): Beautiful theme inspired by Kanagawa wave
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim): Enhanced buffer management
- [mini.statusline](https://github.com/echasnovski/mini.statusline): Lightweight statusline
- [mini.icons](https://github.com/echasnovski/mini.icons): Improved icon support
- [noice.nvim](https://github.com/folke/noice.nvim): Improved notifications and command-line UI
- [snacks.nvim](https://github.com/folke/snacks.nvim): Enhanced UI and utilities

### Navigation & Search

- [flash.nvim](https://github.com/folke/flash.nvim): Navigation and search enhancements
- [which-key.nvim](https://github.com/folke/which-key.nvim): Keybinding hints and management
- [better-escape.nvim](https://github.com/max397574/better-escape.nvim): Better escape functionality
- [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim): Advanced search and replace functionality

### Task Management & Productivity

- [hurl.nvim](https://github.com/jellydn/hurl.nvim): Run HTTP requests directly from `.hurl` files
- [overseer.nvim](https://github.com/stevearc/overseer.nvim): Task runner and job management
- [persistence.nvim](https://github.com/folke/persistence.nvim): Session management
- [quick-code-runner.nvim](https://github.com/jellydn/quick-code-runner.nvim): Quick code execution
- [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim): Code refactoring tools
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim): Highlight and search for todo comments

### File Type Support

- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim): Markdown rendering and preview
- [previm](https://github.com/previm/previm): Markdown preview in browser
- [ts-error-translator.nvim](https://github.com/dmmulroy/ts-error-translator.nvim): TypeScript error translation
- [typecheck.nvim](https://github.com/jellydn/typecheck.nvim): Type checking for TypeScript

### VSCode Integration

This configuration works seamlessly with VSCode through the [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim) extension. The configuration includes:

- [VSCode-specific keymaps](lua/plugins/vscode.lua) for enhanced productivity
- Integration with VSCode's built-in features
- Support for multiple cursors and fast cursor movement
- Git integration and file navigation
- Task running and debugging support

To use this configuration in VSCode:

1. Install the vscode-neovim extension
2. Set your Neovim configuration path to point to this config:

   ```json
    "vscode-neovim.NVIM_APPNAME": "tiny-nvim",
   ```

3. Restart VSCode

You'll get the same Neovim experience in VSCode, including all the plugins and keybindings.

### Language Support

The configuration includes specialized support for various programming languages in the `lua/langs` directory:

- **TypeScript**: Enhanced TypeScript development with type checking and error translation
- **Lua**: Lua development with syntax highlighting and completion
- **Go**: Go development with gopls LSP integration
- **Python**: Python development support with LSP integration
- **Markdown**: Markdown editing with preview support

Each language configuration is modular and can be customized according to your needs.

### Theme

This configuration uses [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) as the default theme. The theme is inspired by the Kanagawa wave and provides a beautiful, elegant color scheme that's easy on the eyes while maintaining good contrast and readability.

</details>

## Keymaps

<details>
<summary>Click to expand keymaps</summary>

### Buffer Management

| Key             | Description                 |
| --------------- | --------------------------- |
| `<leader>bp`    | Toggle Pin                  |
| `<leader>bP`    | Delete Non-Pinned Buffers   |
| `<leader>bo`    | Delete Other Buffers        |
| `<leader>br`    | Delete Buffers to the Right |
| `<leader>bl`    | Delete Buffers to the Left  |
| `<S-h>` or `[b` | Previous Buffer             |
| `<S-l>` or `]b` | Next Buffer                 |
| `[B`            | Move Buffer Left            |
| `]B`            | Move Buffer Right           |
| `<leader>bb`    | Switch to Other Buffer      |
| `<leader>`      | Switch to Other Buffer      |

### Window Management

| Key           | Description            |
| ------------- | ---------------------- |
| `<C-h>`       | Go to Left Window      |
| `<C-j>`       | Go to Lower Window     |
| `<C-k>`       | Go to Upper Window     |
| `<C-l>`       | Go to Right Window     |
| `<C-Up>`      | Increase Window Height |
| `<C-Down>`    | Decrease Window Height |
| `<C-Left>`    | Decrease Window Width  |
| `<C-Right>`   | Increase Window Width  |
| `<leader>ww`  | Other Window           |
| `<leader>wd`  | Delete Window          |
| `<leader>w-`  | Split Window Below     |
| `<leader>w\|` | Split Window Right     |
| `<leader>-`   | Split Window Below     |
| `<leader>\|`  | Split Window Right     |

### Tab Management

| Key              | Description      |
| ---------------- | ---------------- |
| `<leader><tab>l` | Last Tab         |
| `<leader><tab>o` | Close Other Tabs |
| `<leader><tab>f` | First Tab        |
| `<leader><tab>`  | New Tab          |
| `<leader><tab>]` | Next Tab         |
| `<leader><tab>d` | Close Tab        |
| `<leader><tab>[` | Previous Tab     |

### Movement & Editing

| Key     | Description                      |
| ------- | -------------------------------- |
| `j`     | Down (with gj for wrapped lines) |
| `k`     | Up (with gk for wrapped lines)   |
| `<A-j>` | Move Line Down                   |
| `<A-k>` | Move Line Up                     |
| `gl`    | Go to end of line                |
| `gh`    | Go to start of line              |
| `<A-h>` | Go to start of line              |
| `<A-l>` | Go to end of line                |
| `<A-a>` | Select all text                  |

### Git Operations

| Key           | Description         |
| ------------- | ------------------- |
| `]h`          | Next Hunk           |
| `[h`          | Previous Hunk       |
| `]H`          | Last Hunk           |
| `[H`          | First Hunk          |
| `<leader>ghs` | Stage Hunk          |
| `<leader>ghr` | Reset Hunk          |
| `<leader>ghS` | Stage Buffer        |
| `<leader>ghu` | Undo Stage Hunk     |
| `<leader>ghR` | Reset Buffer        |
| `<leader>ghp` | Preview Hunk Inline |
| `<leader>ghb` | Blame Line          |
| `<leader>ghB` | Blame Buffer        |
| `<leader>ghd` | Diff This           |
| `<leader>ghD` | Diff This ~         |
| `<leader>tb`  | Toggle Blame Line   |
| `<leader>gs`  | Git Status          |

### LSP & Code Actions

| Key          | Description                 |
| ------------ | --------------------------- |
| `<leader>ca` | Code Action                 |
| `<leader>cA` | Source Action               |
| `<leader>cr` | Rename                      |
| `<leader>cf` | Format Document             |
| `<leader>ck` | Run Type Check (TypeScript) |
| `<leader>cR` | Refactor                    |
| `<leader>.`  | Quick Fix                   |
| `gr`         | Find References             |
| `gd`         | Go to Definition            |
| `gi`         | Go to Implementation        |
| `go`         | Go to Type Definition       |
| `K`          | Show Documentation          |

### Copilot

| Key     | Description         |
| ------- | ------------------- |
| `<C-y>` | Accept Suggestion   |
| `<C-i>` | Accept Line         |
| `<C-j>` | Next Suggestion     |
| `<C-k>` | Previous Suggestion |
| `<C-d>` | Dismiss Suggestion  |

### Search & Replace

| Key          | Description                                   |
| ------------ | --------------------------------------------- |
| `<leader>sr` | Search and Replace (with file type filtering) |
| `n`          | Next Search Result                            |
| `N`          | Previous Search Result                        |
| `<leader>ur` | Redraw / Clear hlsearch / Diff Update         |

### Diagnostics & Quickfix

| Key          | Description                       |
| ------------ | --------------------------------- |
| `<leader>xx` | Toggle Diagnostics                |
| `<leader>xX` | Toggle Buffer Diagnostics         |
| `<leader>cs` | Toggle Symbols                    |
| `<leader>cl` | Toggle LSP Definitions/References |
| `<leader>xl` | Toggle Location List              |
| `<leader>xq` | Toggle Quickfix List              |
| `[q`         | Previous Quickfix                 |
| `]q`         | Next Quickfix                     |
| `<leader>cd` | Line Diagnostics                  |
| `]d`         | Next Diagnostic                   |
| `[d`         | Previous Diagnostic               |
| `]e`         | Next Error                        |
| `[e`         | Previous Error                    |
| `]w`         | Next Warning                      |
| `[w`         | Previous Warning                  |

### File Operations

| Key          | Description                      |
| ------------ | -------------------------------- |
| `<C-s>`      | Save File                        |
| `<leader>fn` | New File                         |
| `<leader>qq` | Quit All                         |
| `<C-c>`      | Copy whole file content          |
| `<leader>m`  | Markdown preview (Previm)        |
| `<leader>tm` | Toggle Markdown preview (Render) |

### UI & Formatting

| Key          | Description              |
| ------------ | ------------------------ |
| `<leader>ui` | Inspect Position         |
| `<leader>uI` | Inspect Tree             |
| `<leader>uf` | Toggle Autoformat        |
| `<leader>zz` | Open Lazy Plugin Manager |
| `<leader>?`  | Show Buffer Keymaps      |

### Todo Comments

| Key          | Description                  |
| ------------ | ---------------------------- |
| `<leader>st` | Show all todo comments       |
| `<leader>sT` | Show todo/fix/fixme comments |

### Dashboard

| Key | Description     |
| --- | --------------- |
| `f` | Find File       |
| `g` | Find Text       |
| `r` | Recent Files    |
| `c` | Config          |
| `s` | Restore Session |
| `q` | Quit            |
| `l` | Lazy            |
| `u` | Update          |

### Zen Mode

| Key          | Description      |
| ------------ | ---------------- |
| `<leader>cz` | Toggle Zen Mode  |
| `<leader>tz` | Toggle Zoom Mode |

### Terminal

| Key          | Description        |
| ------------ | ------------------ |
| `<esc><esc>` | Enter Normal Mode  |
| `<C-h>`      | Go to Left Window  |
| `<C-j>`      | Go to Lower Window |
| `<C-k>`      | Go to Upper Window |
| `<C-l>`      | Go to Right Window |
| `<C-/>`      | Hide Terminal      |
| `<C-t>`      | Toggle Terminal    |

### Treesitter

| Key         | Description                          |
| ----------- | ------------------------------------ |
| `<C-space>` | Increment Selection                  |
| `<bs>`      | Decrement Selection (in visual mode) |

### Folding

| Key  | Description                                  |
| ---- | -------------------------------------------- |
| `zv` | Close all folds except the current one       |
| `zj` | Close current fold when open, open next fold |
| `zk` | Close current fold when open, open prev fold |

### Neovide Specific

| Key     | Description           |
| ------- | --------------------- |
| `<D-s>` | Save File             |
| `<D-c>` | Copy (in visual mode) |
| `<D-v>` | Paste (in all modes)  |

### AI (Copilot Chat)

| Key          | Description                                 |
| ------------ | ------------------------------------------- |
| `<leader>ap` | CopilotChat - Prompt actions                |
| `<leader>am` | CopilotChat - Generate commit message       |
| `<leader>af` | CopilotChat - Fix Diagnostic                |
| `<leader>al` | CopilotChat - Clear buffer and chat history |
| `<leader>av` | CopilotChat - Toggle                        |
| `<leader>a?` | CopilotChat - Select Models                 |
| `<leader>aa` | CopilotChat - Select Agents                 |

### Testing

| Key           | Description         |
| ------------- | ------------------- |
| `<leader>cjt` | Run Test Nearest    |
| `<leader>cjT` | Run Test File       |
| `<leader>cjS` | Run Test Suite      |
| `<leader>ctt` | Run File            |
| `<leader>ctT` | Run All Test Files  |
| `<leader>ctr` | Run Nearest         |
| `<leader>ctl` | Run Last            |
| `<leader>cts` | Toggle Summary      |
| `<leader>cto` | Show Output         |
| `<leader>ctO` | Toggle Output Panel |
| `<leader>ctS` | Stop                |
| `<leader>ctw` | Toggle Watch        |

### Task Runner & Code Execution

| Key          | Description           |
| ------------ | --------------------- |
| `<leader>ot` | Run Task              |
| `<leader>oq` | Quick Action          |
| `<leader>or` | Rerun Last Task       |
| `<leader>oo` | Toggle at bottom      |
| `<leader>cp` | Quick Code Runner/Pad |

### Hurl (API Testing)

| Key          | Description                       |
| ------------ | --------------------------------- |
| `<leader>hA` | Run All requests                  |
| `<leader>ha` | Run Api request                   |
| `<leader>he` | Run Api request to entry          |
| `<leader>hE` | Run Api request from entry to end |
| `<leader>hv` | Run Api in verbose mode           |
| `<leader>hV` | Run Api in very verbose mode      |
| `<leader>hr` | Rerun last command                |
| `<leader>hh` | Hurl Runner/Show Last Response    |
| `<leader>hg` | Add global variable               |
| `<leader>hG` | Manage global variable            |
| `<leader>tH` | Toggle Hurl Split/Popup           |
| `<leader>hd` | Debug Info                        |

</details>

## Neovide

```toml
# .config/neovide/config.toml
fork = true # Detach from the terminal instead of waiting for the Neovide process to terminate.
frame = "buttonless" # Transparent decorations including a transparent bar.
maximized = true # Maximize the window on startup, while still having decorations and the status bar of your OS visible.
title-hidden = true
```

# Fonts

<details>
<summary>Click to expand font recommendations</summary>

I recommend using the following repo to get a "Nerd Font" (Font that supports icons)

[getnf](https://github.com/ronniedroid/getnf)

</details>

## Project-Specific Configuration

<details>
<summary>Click to expand project configuration details</summary>

This configuration supports project-specific settings through `.nvim-config.lua` files. When Neovim starts, it will automatically look for a `.nvim-config.lua` file in the current working directory and load it if available.

### Quick Setup with ProjectSettings

You can quickly create a `.nvim-config.lua` file using the `:ProjectSettings` command. This interactive command will:

1. Show available plugins and LSP servers
2. Let you select which ones to enable
3. Create a `.nvim-config.lua` file with your selections

Example usage:

```vim
:ProjectSettings
```

Available options:

1. Plugins:

   - `no-neck-pain`: Additional UI plugin
   - `codecompanion`: AI code companion
   - `avante`: Alternative AI assistant
   - `mcphub`: Minecraft Plugin Hub

2. LSP Servers:
   - `eslint`: ESLint language server
   - `lua_ls`: Lua language server
   - `biome`: Biome = Eslint + Prettier
   - `json`: JSON language server
   - `pyright`: Python language server
   - `gopls`: Go language server
   - `tailwindcss`: Tailwind CSS language server

When prompted, enter your selections as comma-separated values:

```
Plugins: no-neck-pain,codecompanion
LSP: eslint,biome
```

### Manual Configuration

You can also manually create a `.nvim-config.lua` file:

```lua
-- Project-specific Neovim configuration

-- Set TypeScript LSP server
vim.g.lsp_typescript_server = "ts_ls"

-- Enable additional LSP servers
vim.g.lsp_on_demands = {
  "eslint",        -- ESLint language server
}

-- Enable extra plugins
vim.g.enable_extra_plugins = {
  "no-neck-pain",  -- Additional UI plugin
  "nvim-eslint"    -- ESLint integration
}

-- Set any other project-specific settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
```

This file is not tracked by git, making it perfect for project-specific customizations.

</details>

## Extra Plugins

<details>
<summary>Click to expand extra plugins</summary>

This configuration includes several extra plugins that can be enabled on demand through your project-specific configuration. These plugins provide additional functionality without bloating the core configuration.

### Available Extra Plugins

1. **[no-neck-pain.nvim](https://github.com/shortcuts/no-neck-pain.nvim)**

   - Distraction-free writing mode with customizable width
   - Alternative to zen-mode with a focus on reducing neck strain
   - Keymaps:
     - `<leader>cz`: Toggle No Neck Pain mode
     - `<leader>zu`: Increase width
     - `<leader>zd`: Decrease width

2. **[codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim)**

   - AI code companion with GitHub Copilot integration
   - Rich set of features including code explanation, refactoring, and inline documentation
   - Supports slash commands for context-aware actions
   - Keymaps prefix: `<leader>A`
   - Visual mode selections:
     - `<leader>Ae`: Explain selected code
     - `<leader>Af`: Fix selected code
     - `<leader>At`: Generate unit tests for selected code
     - `<leader>Ar`: Refactor selected code
     - `<leader>Ad`: Add inline documentation
     - `<leader>An`: Suggest better naming

3. **[avante.nvim](https://github.com/yetone/avante.nvim)**

   - Alternative AI code assistant using Copilot
   - Replaces the standard Copilot implementation
   - Provides a more streamlined interface

4. **[mcphub.nvim](https://github.com/ravitemer/mcphub.nvim)**
   - Minecraft Plugin Hub integration
   - Access Minecraft plugins directly from Neovim
   - Command: `:MCPHub`

### Enabling Extra Plugins

To enable any of these plugins, add them to your `.nvim-config.lua` file:

```lua
vim.g.enable_extra_plugins = {
  "no-neck-pain",
  "codecompanion",
  "avante",
  "mcphub"
}
```

Note that some plugins like `avante.nvim` will disable conflicting plugins (such as `copilot.vim`) when enabled.

</details>

