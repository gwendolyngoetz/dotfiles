#!/bin/sh

# Extract archive into a folder named after the file (without extension)

file="$1"

case "$file" in
*.tar.gz | *.tgz)
    dirname="$(basename "$file" .tar.gz)"
    [ "$dirname" = "$(basename "$file")" ] && dirname="$(basename "$file" .tgz)"
    mkdir -p "$dirname"
    tar xzf "$file" -C "$dirname"
    ;;
*.tar.bz2)
    dirname="$(basename "$file" .tar.bz2)"
    mkdir -p "$dirname"
    tar xjf "$file" -C "$dirname"
    ;;
*.tar.xz)
    dirname="$(basename "$file" .tar.xz)"
    mkdir -p "$dirname"
    tar xJf "$file" -C "$dirname"
    ;;
*.tar)
    dirname="$(basename "$file" .tar)"
    mkdir -p "$dirname"
    tar xf "$file" -C "$dirname"
    ;;
*.zip)
    dirname="$(basename "$file" .zip)"
    unzip "$file" -d "$dirname"
    ;;
*.7z)
    dirname="$(basename "$file" .7z)"
    mkdir -p "$dirname"
    7z x "$file" -o"$dirname"
    ;;
*.rar)
    dirname="$(basename "$file" .rar)"
    mkdir -p "$dirname"
    unrar x "$file" "$dirname/"
    ;;
*)
    echo "Unsupported format: $file" >&2
    exit 1
    ;;
esac
