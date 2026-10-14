#!/usr/bin/env bash
# Installs the pinned Neovim release under ~/.local (no root needed) and links
# ~/.local/bin/nvim to it. Re-run after bumping NVIM_VERSION.
set -euo pipefail

NVIM_VERSION="v0.12.6"
PREFIX="${PREFIX:-$HOME/.local}"

case "$(uname -s)" in
    Linux) os=linux ;;
    Darwin) os=macos ;;
    *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac
case "$(uname -m)" in
    x86_64) arch=x86_64 ;;
    aarch64 | arm64) arch=arm64 ;;
    *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

name="nvim-$os-$arch"
url="https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/$name.tar.gz"
dest="$PREFIX/opt/nvim-$NVIM_VERSION"

if [[ -x "$dest/bin/nvim" ]]; then
    echo "Neovim $NVIM_VERSION is already installed in $dest"
else
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    echo "Downloading $url"
    curl -fsSL -o "$tmp/$name.tar.gz" "$url"
    if [[ "$os" == macos ]]; then
        xattr -c "$tmp/$name.tar.gz" # drop the quarantine attribute, see Neovim's install docs
    fi
    tar -xzf "$tmp/$name.tar.gz" -C "$tmp"
    mkdir -p "$PREFIX/opt" "$PREFIX/bin"
    rm -rf "$dest"
    mv "$tmp/$name" "$dest"
fi

ln -sfn "$dest/bin/nvim" "$PREFIX/bin/nvim"
echo "$PREFIX/bin/nvim -> $dest/bin/nvim"
"$PREFIX/bin/nvim" --version | head -1
