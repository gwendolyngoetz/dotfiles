#! /usr/bin/env python3
import os
import pathlib
import pwd

def get_owner(path: str):
    path_info = pathlib.Path(path)
    return path_info.owner() if path_info.exists() else 'missing'

def get_username():
    return pwd.getpwuid(os.getuid())[0]

color_mapping = {
    'root':         '98;214;232',
    get_username(): '90;71;153',
    'missing':      '255;0;0'
}

if __name__ == '__main__':
    for i, path in enumerate(os.environ['PATH'].split(':'), start = 1):
        owner = get_owner(path)
        color = color_mapping[owner]

        if owner == 'missing':
            path += ' => ***no_such_directory***'

        print('\033[0m{}\t\033[1;38;2;{}m{}'.format(i, color, path))
