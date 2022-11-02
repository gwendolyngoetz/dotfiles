#!/bin/sh

# Unzip into a folder the same name as the file without the .zip extension

file="$1";
dirname="$(basename "$file" .zip)";

#echo "$file";
#echo "$dirname";

unzip "$file" -d "$dirname"
