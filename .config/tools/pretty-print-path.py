#! /usr/bin/env python3
import os
import pathlib
import pwd


class PathInfo:
    def __init__(self):
        self.color_mapping = {
            "root": self.hex_to_rgb("#62d6e8"),
            self.get_username(): self.hex_to_rgb("#5a4799"),
            "missing": self.hex_to_rgb("#ff0000"),
        }

    def get_owner(self, path: str):
        path_info = pathlib.Path(path)
        return path_info.owner() if path_info.exists() else "missing"

    def get_username(self):
        return pwd.getpwuid(os.getuid())[0]

    def hex_to_rgb(self, hex_color):
        hex_color = hex_color.replace("#", "")
        rgb = tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4))
        return "{};{};{}".format(str(rgb[0]), str(rgb[1]), str(rgb[2]))

    def run(self):
        for i, path in enumerate(os.environ["PATH"].split(":"), start=1):
            owner = self.get_owner(path)
            color = self.color_mapping[owner]

            if owner == "missing":
                path += " => ***no_such_directory***"

            print("\033[0m{}\t\033[1;38;2;{}m{}".format(i, color, path))


if __name__ == "__main__":
    PathInfo().run()
