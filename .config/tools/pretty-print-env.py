#! /usr/bin/env python3
import os


def hex_to_rgb(hex_color):
    hex_color = hex_color.replace("#", "")
    rgb = tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4))
    return "{};{};{}".format(str(rgb[0]), str(rgb[1]), str(rgb[2]))


def display_var(key):
    blacklist = [
        "LS_COLORS",
        "LSCOLORS",
        "LESS_TERMCAP_mb",
        "LESS_TERMCAP_md",
        "LESS_TERMCAP_me",
        "LESS_TERMCAP_se",
        "LESS_TERMCAP_so",
        "LESS_TERMCAP_ue",
        "LESS_TERMCAP_us",
        "PATH",
        "PS1",
        "_",
    ]

    return key not in blacklist


color_mapping = {
    False: hex_to_rgb("#f8f8f2"),
    True: hex_to_rgb("#b0b0b0"),
}

if __name__ == "__main__":
    keys = sorted(os.environ, key=lambda x: x)
    maxlength = len(max(keys, key=len)) + 2
    previous_letter = ""
    color_mapping_key = True

    for key in keys:
        if not display_var(key):
            continue

        current_letter = key[0]
        if current_letter != previous_letter:
            color_mapping_key = not color_mapping_key
            previous_letter = current_letter

        print(
            "\033[0;38;2;{}m{}{}".format(
                color_mapping[color_mapping_key],
                key.ljust(maxlength, " "),
                os.environ[key],
            )
        )
