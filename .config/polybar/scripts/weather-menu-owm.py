#!/usr/bin/env python
import sys
from datetime import datetime
import customtkinter as c
import json
import tkinter

c.set_appearance_mode("Dark")  # Modes: "System" (standard), "Dark", "Light"
c.set_default_color_theme("blue")  # Themes: "blue" (standard), "green", "dark-blue"


class WeatherWidget(c.CTk):
    WIDTH = 236
    HEIGHT = 260
    DEFAULT_EXIT_TIMER = 100

    def __init__(self, url):
        super().__init__()
        self._current_row = 0
        self._url = url
        self._exit_timer = WeatherWidget.DEFAULT_EXIT_TIMER
        self._configure_window()
        self._add_rows()

    def _configure_window(self):
        self.geometry(f"{WeatherWidget.WIDTH}x{WeatherWidget.HEIGHT}+1500+100")
        self.title("WeatherWidget")
        self.resizable(0, 0)

        self.grid_rowconfigure(0, weight=1)
        self.grid_columnconfigure((0, 1), weight=3)

        self.frame = c.CTkFrame(master=self)
        self.frame.pack(fill="both", expand=True)

        self.bind("<FocusOut>", self._on_focus_out)

    def _add_rows(self):
        data = self._load_json()

        self._add_row(" City", data["name"])
        self._add_sep()
        self._add_row(" Weather", data["weather"][0]["main"])
        self._add_sep()
        self._add_row(" Temp", self._format_temp(data["main"]["temp"]))
        self._add_row(" Temp Max", self._format_temp(data["main"]["temp_max"]))
        self._add_row(" Temp Min", self._format_temp(data["main"]["temp_min"]))
        self._add_sep()
        self._add_row(" Humidity", f'{data["main"]["humidity"]}%')
        self._add_sep()
        self._add_row(" Date", self._format_date(data["dt"]))
        self._add_row(" Sunrise", self._format_time(data["sys"]["sunrise"]))
        self._add_row(" Sunset", self._format_time(data["sys"]["sunset"]))

    def _load_json(self):
        with open(self._url, "r") as file:
            return json.loads(file.read())

    def _add_row(self, label: str, value: str):
        font = ("Cousine Nerd Font", 13)
        lbl1 = c.CTkLabel(master=self.frame, text=label, text_font=font, anchor=c.W, padx=8)
        lbl2 = c.CTkLabel(master=self.frame, text=value, text_font=font, anchor=c.W, padx=8)

        row = self._get_next_row()
        lbl1.grid(row=row, column=0)
        lbl2.grid(row=row, column=1)

    def _add_sep(self):
        row = self._get_next_row()
        separator = tkinter.ttk.Separator(master=self.frame, orient="horizontal")
        separator.grid(row=row, column=0, columnspan=2, ipadx=140)

    def _get_next_row(self):
        row = self._current_row
        self._current_row = self._current_row + 1

        return row

    def _format_date(self, value):
        return datetime.fromtimestamp(value).strftime("%b-%d")

    def _format_time(self, value):
        return datetime.fromtimestamp(value).strftime("%-I:%M %p")

    def _format_temp(self, value):
        return f"{round(value)}°F"

    def _on_focus_out(self, event):
        if event.widget == self:
            self.destroy()


if __name__ == "__main__":
    url = sys.argv[1]
    widget = WeatherWidget(url)
    widget.mainloop()
