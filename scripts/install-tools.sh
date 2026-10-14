#!/bin/bash

uv tool install pyright
uv tool install ruff

# nvim-treesitter (main branch) builds parsers with the tree-sitter CLI (>= 0.26.1).
# Install it from your package manager, e.g. `brew install tree-sitter` or `cargo install tree-sitter-cli`.
if ! command -v tree-sitter >/dev/null 2>&1; then
  echo "warning: tree-sitter CLI not found; nvim-treesitter parsers will not build until it is installed" >&2
fi
