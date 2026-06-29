#!/bin/bash
set -e

echo "==> Installing system dependencies..."
sudo apt update
sudo apt install -y \
    clangd \
    clang-format \
    fonts-jetbrains-mono \
    golang \
    curl \
    git

echo "==> Setting up npm global directory..."
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
export PATH=$HOME/.npm-global/bin:$PATH
if ! grep -q 'npm-global' ~/.bashrc; then
    echo 'export PATH=$HOME/.npm-global/bin:$PATH' >> ~/.bashrc
fi

echo "==> Installing Node.js global packages..."
if command -v npm &> /dev/null; then
    npm install -g pyright typescript typescript-language-server prettier
else
    echo "WARNING: npm not found, skipping Node.js packages. Install Node.js then re-run."
fi

echo "==> Installing Python formatter..."
pip install black --break-system-packages

echo "==> Installing Rust + components..."
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "rustup already installed"
    source "$HOME/.cargo/env"
fi
rustup component add rust-analyzer rustfmt

echo "==> Installing gopls..."
go install golang.org/x/tools/gopls@latest

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
echo "    You may need to restart your shell or run: source ~/.bashrc"
