from customtkinter import CTkLabel
from weatherdata import WeatherData
from menupopupwidget import MenuPopupWidget


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
        text = CTkLabel(
            master=self, text=info.value, text_font=font, anchor="w", padx=8, width=100, text_color=info.color
        )

        row = self.get_next_row()
        icon.grid(row=row, column=0)
        label.grid(row=row, column=1)
        text.grid(row=row, column=2)

    def add_sep(self) -> None:
        self.add_separator(columnspan=3)
