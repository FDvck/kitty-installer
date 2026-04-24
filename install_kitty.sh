#!/bin/bash

# Installs the kitty terminal emulator and applies custom default settings
# (font size, background opacity, and disables the audio bell)

set -e # Exit immediately if a command exits with a non-zero status

# Variables
KITTY_URL="https://sw.kovidgoyal.net/kitty/installer.sh"
KITTY_DIR="$HOME/.local/kitty.app"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_PATH="$KITTY_DIR/share/icons/hicolor/256x256/apps/kitty.png"
KITTY_BIN="$KITTY_DIR/bin/kitty"
XDG_TERM_LIST="$HOME/.config/xdg-terminals.list"
KITTY_CONF_DIR="$HOME/.config/kitty"
KITTY_CONF_FILE="$KITTY_CONF_DIR/kitty.conf"

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



echo "Generating default kitty.conf..."

# Create the configuration directory if it doesn't exist
mkdir -p "$KITTY_CONF_DIR"

# 2. Extract the default configuration (commented out) and save it
"$KITTY_BIN" +runpy 'from kitty.config import *; print(commented_out_default_config())' > "$KITTY_CONF_FILE"

echo "Applying custom configurations to kitty.conf..."


# 3. Apply settings based on user preferences using sed
#
# Set font size to 11.0
sed -i 's/^# font_size .*/font_size 11.0/' "$KITTY_CONF_FILE"


# Set background opacity to 0.74
sed -i 's/^# background_opacity .*/background_opacity 0.74/' "$KITTY_CONF_FILE"


# Disable audio bell
sed -i 's/^# enable_audio_bell .*/enable_audio_bell no/' "$KITTY_CONF_FILE"

echo "Kitty installation and configuration finished successfully!"
