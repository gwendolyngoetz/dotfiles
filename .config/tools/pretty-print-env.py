#! /usr/bin/env python3
import os
import sys


class EnvironmentInfo:
    def __init__(self):
        self.color_mapping = {
            False: self.hex_to_rgb("#f8f8f2"),
            True: self.hex_to_rgb("#b0b0b0"),
        }

    def run(self, search: str):
        keys = self.search_keys(search)
        maxlength = self.calc_maxlength(keys)
        previous_letter = ""
        color_mapping_key = True

        for key in keys:
            if not self.display_var(key):
                continue

            current_letter = key[0]
            if current_letter != previous_letter:
                color_mapping_key = not color_mapping_key
                previous_letter = current_letter

            print(
                "\033[0;38;2;{}m{}{}".format(
                    self.color_mapping[color_mapping_key],
                    key.ljust(maxlength, " "),
                    os.environ[key],
                )
            )

    def search_keys(self, search: str):
        keys = sorted(os.environ, key=lambda x: x)

        if search is not None:
            keys = list(filter(lambda x: search.lower() in x.lower(), keys))

        return keys

    def calc_maxlength(self, keys: list):
        maxlength = 2  # Padding to the right of the first column

        if len(keys) > 0:
            maxlength = maxlength + len(max(keys, key=len))

        return maxlength

    def display_var(self, key: str):
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

    def hex_to_rgb(self, hex_color: str):
        hex_color = hex_color.replace("#", "")
        rgb = tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4))
        return "{};{};{}".format(str(rgb[0]), str(rgb[1]), str(rgb[2]))


if __name__ == "__main__":
    search = None if len(sys.argv) <= 1 else sys.argv[1]
    EnvironmentInfo().run(search)
