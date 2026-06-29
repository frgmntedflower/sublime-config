#!/bin/bash
set -e

echo "==> Installing system dependencies..."
sudo apt update
sudo apt install -y \
    clangd \
    clang-format \
    fonts-jetbrains-mono \
    curl \
    git

echo "==> Installing Python formatter..."
pip install black --break-system-packages

echo "==> Installing JS/TS formatter..."
if command -v npm &> /dev/null; then
    npm install -g prettier
else
    echo "WARNING: npm not found, skipping prettier. Install Node.js then run: npm install -g prettier"
fi

echo "==> Installing rustfmt..."
if command -v rustup &> /dev/null; then
    rustup component add rustfmt
else
    echo "WARNING: rustup not found, skipping rustfmt. Install rustup then run: rustup component add rustfmt"
fi

echo "==> Installing Sublime Text..."
if ! command -v subl &> /dev/null; then
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sublimehq-archive.gpg
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt update
    sudo apt install -y sublime-text
else
    echo "Sublime Text already installed, skipping."
fi

echo "==> Linking config..."
SUBLIME_USER="$HOME/.config/sublime-text/Packages/User"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/Packages/User"

mkdir -p "$HOME/.config/sublime-text/Packages"

if [ -d "$SUBLIME_USER" ] && [ ! -L "$SUBLIME_USER" ]; then
    echo "Backing up existing config to $SUBLIME_USER.bak"
    mv "$SUBLIME_USER" "$SUBLIME_USER.bak"
fi

ln -sf "$REPO_DIR" "$SUBLIME_USER"
echo "Linked $REPO_DIR -> $SUBLIME_USER"

echo ""
echo "==> Done! Open Sublime Text and Package Control will auto-install all packages."
echo "    NOTE: If rustup/npm were missing, install them and re-run the relevant commands above."
