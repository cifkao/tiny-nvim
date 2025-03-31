# Welcome to My Tiny Neovim 👋

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](#)
[![Twitter: jellydn](https://img.shields.io/twitter/follow/jellydn.svg?style=social)](https://twitter.com/jellydn)
<a href="https://dotfyle.com/jellydn/tinynvim"><img src="https://dotfyle.com/jellydn/tinynvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/jellydn/tinynvim"><img src="https://dotfyle.com/jellydn/tinynvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/jellydn/tinynvim"><img src="https://dotfyle.com/jellydn/tinynvim/badges/plugin-manager?style=flat" /></a>

> Slim Neovim config for 0.11+ with minimal plugins.

[![Slim Neovim config for 0.11](https://i.gyazo.com/6e351d72c2f119f70dbc55d61e9452fd.png)](https://gyazo.com/6e351d72c2f119f70dbc55d61e9452fd)

## Motivation

This configuration is a migration from [my-nvim-ide](https://github.com/jellydn/my-nvim-ide) with two main goals:

1. **Leverage Neovim 0.11+ Built-in Features**:

   - Remove dependency on [`lspconfig`](https://github.com/neovim/nvim-lspconfig/pull/3659) by utilizing Neovim's built-in LSP support

   - Experience faster startup times and reduced complexity
   - Take advantage of the latest Neovim improvements

2. **Optimize Plugin Selection**:
   - Trim down the plugin list to only essential ones
   - Use `blink.cmp` for completion instead of built-in completion for better UX
   - Maintain a minimal yet powerful development environment

The result is a faster, more maintainable configuration that still provides all the necessary features for modern development.

### 🏠 [Homepage](itman.fyi)

## Quick Start

### One-liner Installation (Recommended)

```bash
# Install with default app name (tiny_nvim)
curl -s https://raw.githubusercontent.com/jellydn/tiny_nvim/main/install.sh | bash

# Or install with custom app name
curl -s https://raw.githubusercontent.com/jellydn/tiny_nvim/main/install.sh | bash -s -- --appname my_nvim
```

This will:

1. Backup your existing Neovim configuration (if any)
2. Clone the repository
3. Install all required tools
4. Install all plugins in headless mode
5. Set up your complete Neovim environment

After installation, you can start Neovim with:

```bash
# If using default app name
NVIM_APPNAME=tiny_nvim nvim

# If using custom app name
NVIM_APPNAME=my_nvim nvim
```

### Cleanup

To completely remove this configuration, run:

```bash
# Replace APPNAME with your chosen name (tiny_nvim or custom name)
rm -rf ~/.config/APPNAME
rm -rf ~/.local/share/APPNAME
rm -rf ~/.cache/APPNAME
rm -rf ~/.local/state/APPNAME
```

### Manual Installation

If you prefer to install manually:

1. Clone this repository:

```bash
git clone https://github.com/jellydn/tiny_nvim.git ~/.config/tiny_nvim
```

2. Run the installation script to set up all required tools:

```bash
cd ~/.config/tiny_nvim
./scripts/install-tools.sh
```

3. Launch Neovim with this configuration:

```bash
NVIM_APPNAME=tiny_nvim nvim
```

## Health Checks & Debugging

After installation, run the following commands to ensure everything is set up correctly:

1. Check overall Neovim health:

```vim
:checkhealth
```

2. Verify LSP configuration:

```vim
:check vim.lsp
```

3. For formatting issues, check conform.nvim status:

```vim
:ConformInfo
```

For more detailed debugging information, refer to [conform.nvim debugging guide](https://github.com/stevearc/conform.nvim/blob/master/doc/debugging.md#tools).

## Features

This configuration provides a minimal yet powerful development environment with carefully selected plugins organized by category:

### Core Development

- **LSP & Completion**

  - Built-in LSP support (Neovim 0.11+)
  - [blink.cmp](https://github.com/folke/blink.cmp): Enhanced completion menu
  - [conform.nvim](https://github.com/stevearc/conform.nvim): Code formatting
  - [nvim-lint](https://github.com/mfussenegger/nvim-lint): Linting support
  - [ts-error-translator.nvim](https://github.com/dmmulroy/ts-error-translator.nvim): TypeScript error translation

- **AI & Code Assistance**

  - [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim): AI-powered coding assistant
  - [blink-copilot](https://github.com/folke/blink-copilot): Copilot integration
  - [copilot.vim](https://github.com/zbirenbaum/copilot.vim): GitHub Copilot integration

- **Code Generation & Documentation**

  - [LuaSnip](https://github.com/L3MON4D3/LuaSnip): Snippet engine
  - [friendly-snippets](https://github.com/rafamadriz/friendly-snippets): Snippet collection
  - [neogen](https://github.com/danymat/neogen): Documentation generator
  - [ts-comments.nvim](https://github.com/folke/ts-comments.nvim): Comment utilities

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

### Task Management & Productivity

- [overseer.nvim](https://github.com/stevearc/overseer.nvim): Task runner and job management
- [persistence.nvim](https://github.com/folke/persistence.nvim): Session management
- [quick-code-runner.nvim](https://github.com/CRAG666/code_runner.nvim): Quick code execution
- [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim): Code refactoring tools

### File Type Support

- [hurl.nvim](https://github.com/ntbbloodbath/hurl.nvim): Hurl file support
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim): Markdown rendering and preview

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
    "vscode-neovim.NVIM_APPNAME": "nvim-ide",
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

## Neovide

```toml
# .config/neovide/config.toml
fork = true # Detach from the terminal instead of waiting for the Neovide process to terminate.
frame = "buttonless" # Transparent decorations including a transparent bar.
maximized = true # Maximize the window on startup, while still having decorations and the status bar of your OS visible.
title-hidden = true
```

# Fonts

I recommend using the following repo to get a "Nerd Font" (Font that supports icons)

[getnf](https://github.com/ronniedroid/getnf)

## Uninstall

```sh
  rm -rf ~/.config/nvim
  rm -rf ~/.local/share/nvim
  rm -rf ~/.cache/nvim
  rm -rf ~/.local/state/nvim
```

# Tips

- Improve key repeat on Mac OSX, need to restart

```sh
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 14
```

- VSCode on Mac

To enable key-repeating, execute the following in your Terminal, log out and back in, and then restart VS Code:

```sh
# For VS Code
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
# For VS Code Insider
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
# If necessary, reset global default
defaults delete -g ApplePressAndHoldEnabled
# For Cursor
defaults write com.todesktop.230313mzl4w4u92 ApplePressAndHoldEnabled -bool false
```

Also increasing Key Repeat and Delay Until Repeat settings in System Preferences -> Keyboard.

[![Key repeat rate](https://i.gyazo.com/e58be996275fe50bee31412ea5930017.png)](https://gyazo.com/e58be996275fe50bee31412ea5930017)

- Disable `full stop with double-space` if you see the delay with `<space>-<space>`

[![Which-key](https://i.gyazo.com/6403f6c57d2e54aca230589b2173eeb0.png)](https://gyazo.com/6403f6c57d2e54aca230589b2173eeb0)

## Resources

- [What's New in Neovim 0.11](https://gpanders.com/blog/whats-new-in-neovim-0-11/): A detailed overview of the latest features and improvements in Neovim 0.11.
- [Neovim 0.11 Built-in Completion Setup](https://gist.github.com/miroshQa/7c61292bc37070bb7606a29e07fe00e2): A comprehensive guide for setting up built-in completion in Neovim 0.11+.

[![IT Man - LazyVim Power User Guide](https://i.ytimg.com/vi/jveM3hZs_oI/hqdefault.jpg)](https://www.youtube.com/watch?v=jveM3hZs_oI)

[![IT Man - Talk #33 NeoVim as IDE [Vietnamese]](https://i.ytimg.com/vi/dFi8CzvqkNE/hqdefault.jpg)](https://www.youtube.com/watch?v=dFi8CzvqkNE)

[![IT Man - Talk #35 #Neovim IDE for Web Developer](https://i.ytimg.com/vi/3EbgMJ-RcWY/hqdefault.jpg)](https://www.youtube.com/watch?v=3EbgMJ-RcWY)

[![IT Man - Step-by-Step Guide: Integrating Copilot Chat with Neovim [Vietnamese]](https://i.ytimg.com/vi/By_CCai62JE/hqdefault.jpg)](https://www.youtube.com/watch?v=By_CCai62JE)

[![IT Man - Power up your Neovim with Gen.nvim](https://i.ytimg.com/vi/2nt_qcchW_8/hqdefault.jpg)](https://www.youtube.com/watch?v=2nt_qcchW_8)

[![IT Man - Boost Your Neovim Productivity with GitHub Copilot Chat](https://i.ytimg.com/vi/6oOPGaKCd_Q/hqdefault.jpg)](https://www.youtube.com/watch?v=6oOPGaKCd_Q)

[![IT Man - Get to know GitHub Copilot Chat in #Neovim and be productive IMMEDIATELY](https://i.ytimg.com/vi/sSih4khcstc/hqdefault.jpg)](https://www.youtube.com/watch?v=sSih4khcstc)

[![IT Man - Master Neovim with CopilotChat.nvim v3: Features, Demos, and Innovations](https://i.ytimg.com/vi/PfYnLcSVPh0/hqdefault.jpg)](https://www.youtube.com/watch?v=PfYnLcSVPh0)

[![IT Man - Enhance Your Neovim Experience with LSP Plugins](https://i.ytimg.com/vi/JwWNIQgL4Fk/hqdefault.jpg)](https://www.youtube.com/watch?v=JwWNIQgL4Fk)

[![IT Man - Bringing Zed AI Experience to Neovim with codecompanion.nvim](https://i.ytimg.com/vi/KbWI4ilHKv4/hqdefault.jpg)](https://www.youtube.com/watch?v=KbWI4ilHKv4)

## Author

👤 **Dung Huynh Duc**

- Website: https://productsway.com/
- Twitter: [@jellydn](https://twitter.com/jellydn)
- Github: [@jellydn](https://github.com/jellydn)

## Show your support

Give a ⭐️ if this project helped you!
