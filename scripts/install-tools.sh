#!/bin/bash

uv tool install pyright
uv tool install ruff

wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.25.3/tree-sitter-linux-x64.gz -O $HOME/.local/bin/tree-sitter
