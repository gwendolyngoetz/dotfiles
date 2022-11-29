#!/usr/bin/env python
import sys
import customtkinter
import json
from datetime import datetime
from collections import namedtuple
from customtkinter import CTk, CTkLabel

customtkinter.set_appearance_mode("Dark")
customtkinter.set_default_color_theme("blue")


class WeatherData:
    Info = namedtuple("Info", ["icon", "label", "value"])

    def __init__(self, path) -> None:
        json = self.load_json(path)

        self.name = self.Info("", "City", json["name"])
        self.weather = self.Info("", "Weather", json["weather"][0]["main"])
        self.temp = self.Info("", "Temp", self.format_temp(json["main"]["temp"]))
        self.temp_high = self.Info("", "High", self.format_temp(json["main"]["temp_max"]))
        self.temp_low = self.Info("", "Low", self.format_temp(json["main"]["temp_min"]))
        self.humidity = self.Info("", "Humidity", self.format_percentage(json["main"]["humidity"]))
        self.date = self.Info("", "Date", self.format_date(json["dt"]))
        self.sunrise = self.Info(" ", "Sunrise", self.format_time(json["sys"]["sunrise"]))
        self.sunset = self.Info(" ", "Sunset", self.format_time(json["sys"]["sunset"]))

    def load_json(self, path: str) -> json:
        with open(path, "r") as file:
            return json.loads(file.read())

    def format_date(self, value: str) -> str:
        return datetime.fromtimestamp(value).strftime("%b-%d")

    def format_time(self, value: str) -> str:
        return datetime.fromtimestamp(value).strftime("%-I:%M %p")

    def format_temp(self, value: str) -> str:
        return f"{round(value)}°F"

    def format_percentage(self, value: str) -> str:
        return f"{value}%"


class MenuPopupWidget(CTk):
    COLOR_LIGHT = "#3a3c4e"
    DEFAULT_FONT = "Cousine Nerd Font"

    def __init__(self, title: str, width: int, height: int) -> None:
        super().__init__()

        self.title(title)
        self.set_geometry(width, height)
        self.bind("<FocusOut>", self.on_focusout)
        self.resizable(0, 0)

    def set_geometry(self, width: int, height: int) -> None:
        x = self.winfo_pointerx() - 20
        y = 28
        self.geometry(f"{width}x{height}+{x}+{y}")

    def on_focusout(self, event) -> None:
        if event.widget == self:
            self.destroy()

    def get_next_row(self) -> int:
        (_, row) = self.grid_size()
        return row

    def add_separator(self, columnspan: int = 3) -> None:
        row = self.get_next_row()
        font = (self.DEFAULT_FONT, 1)
        separator = CTkLabel(master=self, text="", text_font=font, padx=0, pady=0, height=3, fg_color=self.COLOR_LIGHT)
        separator.grid(row=row, column=0, columnspan=columnspan, sticky="we")


class WeatherWidget(MenuPopupWidget):
    def __init__(self, path: str) -> None:
        super().__init__(title="WeatherWidget", width=246, height=264)
        data = WeatherData(path)
        self.add_rows(data)

    def add_rows(self, data: WeatherData) -> None:
        self.add_row(data.name)
        self.add_sep()
        self.add_row(data.weather)
        self.add_sep()
        self.add_row(data.temp)
        self.add_row(data.temp_high)
        self.add_row(data.temp_low)
        self.add_sep()
        self.add_row(data.humidity)
        self.add_sep()
        self.add_row(data.date)
        self.add_row(data.sunrise)
        self.add_row(data.sunset)

    def add_row(self, info: WeatherData.Info) -> None:
        font = (self.DEFAULT_FONT, 14)
        icon = CTkLabel(master=self, text=info.icon, text_font=font, padx=8, width=40, fg_color=self.COLOR_LIGHT)

        font = (self.DEFAULT_FONT, 13)
        label = CTkLabel(master=self, text=info.label, text_font=font, anchor="w", padx=8, width=112)
        text = CTkLabel(master=self, text=info.value, text_font=font, anchor="w", padx=8, width=100)

        row = self.get_next_row()
        icon.grid(row=row, column=0)
        label.grid(row=row, column=1)
        text.grid(row=row, column=2)

    def add_sep(self) -> None:
        self.add_separator(columnspan=3)


if __name__ == "__main__":
    path = sys.argv[1]
    widget = WeatherWidget(path)
    widget.mainloop()
