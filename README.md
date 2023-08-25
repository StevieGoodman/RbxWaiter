# Roblox Library Template
This repository is used to quickly set up a Roblox development environment suited for creating Roblox libraries.

## Toolchain
This project makes use of:
- Wally (package manager)
- Rojo (Studio-to-filesystem server)
- Moonwave (documentation)

## Packages
- Oxide (my own Rust types library)

## Setup
1. Clone project
2. Install Rust
3. Run `cargo install foreman`
4. Add tools to `foreman.toml`:
  - `rojo = { github = "rojo-rbx/rojo", version = "7.0.0" }`
5. Run `foreman install`
6. Ensure that Foreman `bin` directory is in PATH.
7. Install VS Code plugins:
  - Roblox LSP
  - Rojo - Roblox Studio Sync
8. Open in Roblox Studio
9. Open project in VS Code
10. Run `rojo serve`

🎉 Congratulations! You've set up the project.
