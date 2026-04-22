#!/bin/bash

# Installs and configures the kitty terminal emulator

set -e # Exit immediately if a command exits with a non-zero status

# Variables
KITTY_URL="https://sw.kovidgoyal.net/kitty/installer.sh"
KITTY_DIR="$HOME/.local/kitty.app"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_PATH="$KITTY_DIR/share/icons/hicolor/256x256/apps/kitty.png"
KITTY_BIN="$KITTY_DIR/bin/kitty"
XDG_TERM_LIST="$HOME/.config/xdg-terminals.list"

echo "Downloading and installing kitty..."
curl -L "$KITTY_URL" | sh /dev/stdin

echo "Creating symlinks in  $BIN_DIR..."
mkdir -p "$BIN_DIR"
ln -sf "$KITTY_BIN" "$BIN_DIR/kitty"
ln -sf "$KITTY_DIR/bin/kitten" "$BIN_DIR/kitten"

echo "Copying .desktop files to  $DESKTOP_DIR..."
mkdir -p "$DESKTOP_DIR"
cp "$KITTY_DIR/share/applications/kitty.desktop" "$DESKTOP_DIR/"
cp "$KITTY_DIR/share/applications/kitty-open.desktop" "$DESKTOP_DIR/"

echo "Setting kitty as the default terminal..."
mkdir -p "$(dirname "$XDG_TERM_LIST")"
echo 'kitty.desktop' > "$XDG_TERM_LIST"

# Check if ~/.local/bin is in the PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Adding $HOME/.local/bin to PATH..."

    SHELL_RC=""
    if [[ -n "$ZSH_VERSION" ]]; then
        SHELL_RC="$HOME/.zshrc"
    elif [[ -n "$BASH_VERSION" ]]; then
        SHELL_RC="$HOME/.bashrc"
    else
        SHELL_RC="$HOME/.profile"
    fi

    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    echo "~/.local/bin has been added to PATH in $SHELL_RC"
    echo "Restart your terminal or run: source $SHELL_RC"
else
    echo "$HOME/.local/bin is already in your PATH"
fi
