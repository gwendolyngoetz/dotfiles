#!/usr/bin/env python
import sys
import customtkinter
from weatherwidget import WeatherWidget

customtkinter.set_appearance_mode("Dark")
customtkinter.set_default_color_theme("blue")


if __name__ == "__main__":
    path = sys.argv[1]
    widget = WeatherWidget(path)
    widget.mainloop()
