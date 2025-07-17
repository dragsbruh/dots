#!/bin/bash

src_dir="$HOME/.dotfiles/wallpapers"
cache_dir="/dev/shm/wallpapers_ram_cache"

mkdir -p "$cache_dir"
rm -rf "$cache_dir"/*

cp "$src_dir"/* "$cache_dir"/

mapfile -t wallpapers < <(find "$cache_dir" -type f | grep peruere)

[ ${#wallpapers[@]} -eq 0 ] && echo "no peruere images, L" && exit 1

i=0
while true; do
    feh --bg-max --image-bg black "${wallpapers[$i]}"

    ((i++))
    if [ $i -ge ${#wallpapers[@]} ]; then
        wallpapers=( $(printf "%s\n" "${wallpapers[@]}" | shuf) )
        i=0
    fi

    sleep $(shuf -i 20-120 -n 1)
done
