#!/usr/bin/env python
import sys
from weatherdata import WeatherData

if __name__ == "__main__":
    path = sys.argv[1]
    widget = WeatherData(path)
    label = widget.get_polybar_label()

    print(label)
