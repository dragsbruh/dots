#!/usr/bin/bash

# no not you you damned linker.sh

set -euo pipefail

packages=("fish" "ghostty" "helix" "rofi" "swappy" "waybar")
cfg_dirs=("fish" "ghostty" "helix" "hypr" "rofi" "swappy" "waybar")

sudo pacman -Sy ${packages[@]}

for cfg_dir in "${cfg_dirs[@]}"; do
    ln -s $(pwd)/$cfg_dir ~/.config/$cfg_dir
done
