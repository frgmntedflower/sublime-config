# sublime-config

My Sublime Text IDE setup for C/C++, Rust, Python, JS/TS.

## Fresh install

```bash
git clone git@github.com:frgmntedflower/sublime-config.git ~/dev/sublime-config
cd ~/dev/sublime-config
./install.sh
```

Then open Sublime Text — Package Control will auto-install all packages.

## Packages

- LSP + LSP-clangd — C/C++ language server
- CMake + CMakeBuilder — CMake support
- Fmt — auto-format on save
- SublimeDebugger — GDB/LLDB GUI
- SideBarEnhancements — right-click file operations
- A File Icon — file icons in sidebar
- Rosé Pine — theme

## Manual steps after install

- Set color scheme: `Preferences → Color Scheme → Rosé Pine`
- Per-project: add `compile_flags.txt` to project root for clangd

## Dependencies

Installed automatically by `install.sh`:
- `clangd`, `clang-format` — C/C++ tooling
- `fonts-jetbrains-mono` — editor font
- `black` — Python formatter
- `prettier` — JS/TS formatter (requires npm)
- `rustfmt` — Rust formatter (requires rustup)
