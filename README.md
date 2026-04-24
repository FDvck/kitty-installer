# Kitty Terminal Installer

A simple bash script to install and configure the Kitty terminal emulator.

## Features
* Installs the latest version of Kitty using the official pre-compiled Linux binaries.
* Adds Kitty to the system `PATH` and creates necessary symlinks.
* Sets Kitty as the default terminal emulator (`xdg-terminals.list`).
* Generates the default `kitty.conf` file and applies custom settings:
  * Font size: `11.0`
  * Background opacity: `0.74`
  * Terminal audio bell: `Disabled`

## Compatibility
This script is designed for **Linux** environments. Because it uses the official binary installer, it is compatible with most modern distributions (e.g., Debian, Ubuntu, Kali Linux, Arch Linux, Mint, etc.).

## Prerequisites
Ensure you have `curl` installed on your system before running the script.

## Usage
1. Clone the repository or download the script.
2. Make it executable: 
   ```bash
   chmod +x install_kitty.sh
   ```
3. Run the script:
   ```bash
   ./install_kitty.sh
   ```
