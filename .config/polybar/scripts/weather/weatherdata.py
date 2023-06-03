import json
from datetime import datetime
from collections import namedtuple


class WeatherData:
    Info = namedtuple("Info", ["icon", "label", "value", "color"], defaults=(None,))

    def __init__(self, path) -> None:
        self.json = self.load_json(path)
        temp_hour_range = 12

        high_temp = self.find_high_temp(self.json["hourly"][:temp_hour_range])
        low_temp = self.find_low_temp(self.json["hourly"][:temp_hour_range])

        current = self.json["current"]
        isdaytime = current["dt"] >= current["sunrise"] and current["dt"] <= current["sunset"]
        weather_icon = self.get_weather_icon(current["weather"][0]["id"], isdaytime)

        self.name = self.Info("", "City", "Seattle")
        self.weather = self.Info(weather_icon, "Weather", current["weather"][0]["main"])
        self.temp = self.Info("", "Temp", self.format_temp(current["temp"]))
        self.temp_high = self.Info("", "High", self.format_temp(high_temp), "#d30000")
        self.temp_low = self.Info("", "Low", self.format_temp(low_temp), "#0080ff")
        self.humidity = self.Info("", "Humidity", self.format_percentage(current["humidity"]))
        self.date = self.Info("", "Date", self.format_date(current["dt"]))
        self.sunrise = self.Info(" ", "Sunrise", self.format_time(current["sunrise"]))
        self.sunset = self.Info(" ", "Sunset", self.format_time(current["sunset"]))

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

    def find_high_temp(self, hourly) -> int:
        return max(map(lambda x: int(x["temp"]), hourly))

    def find_low_temp(self, hourly) -> int:
        return min(map(lambda x: int(x["temp"]), hourly))

    def get_weather_icon(self, weathercode: int, isdaytime: bool) -> str:
        # Clear
        if weathercode in [800]:
            return " " if isdaytime else " "
        # Cloudy
        if weathercode in [801, 802, 803, 804]:
            return " " if isdaytime else " "
        # Rain
        if weathercode in [500, 501, 502, 503, 504, 511, 520, 521, 522, 531]:
            return " " if isdaytime else " "
        # Showers
        if weathercode in [300, 301, 302, 310, 311, 312, 313, 314, 321]:
            return " " if isdaytime else " "
        # Thunder and Lightning
        if weathercode in [200, 201, 202, 210, 211, 212, 221, 230, 231, 232]:
            return " " if isdaytime else " "
        # Snow
        if weathercode in [600, 601, 602, 611, 612, 613, 615, 616, 620, 621, 622]:
            return ""
        # Foggy
        if weathercode in [701, 741]:
            return " " if isdaytime else " "
        # Needs icons
        # 721-haze|731-dust|751-sand|761-dust|762-volcanic-ash|771-squall
        if weathercode in [721, 731, 751, 761, 762, 771]:
            return weathercode
        # Tornado
        if weathercode in [781]:
            return "󰼸"
        # Smoke
        if weathercode in [711]:
            return "󱞙"

        return weathercode

    def get_polybar_label(self):
        current = self.json["current"]
        isdaytime = current["dt"] >= current["sunrise"] and current["dt"] <= current["sunset"]
        icon = self.get_polybar_weather_icon(current["weather"][0]["id"], isdaytime)
        return f"%{{F#555}}{icon}%{{F-}} {self.temp.value}"

    def get_polybar_weather_icon(self, weathercode: int, isdaytime: bool) -> str:
        # https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2
        # Clear
        if weathercode in [800]:
            return "" if isdaytime else ""
        # Cloudy
        if weathercode in [801, 802, 803, 804]:
            return "" if isdaytime else ""
        # Rain
        if weathercode in [500, 501, 502, 503, 504, 511, 520, 521, 522, 531]:
            return ""
        # Showers
        if weathercode in [300, 301, 302, 310, 311, 312, 313, 314, 321]:
            return ""
        # Thunder and Lightning
        if weathercode in [200, 201, 202, 210, 211, 212, 221, 230, 231, 232]:
            return ""
        # Snow
        if weathercode in [600, 601, 602, 611, 612, 613, 615, 616, 620, 621, 622]:
            return ""
        # Foggy
        if weathercode in [701, 741]:
            return ""
        # Needs icons
        # 721-haze|731-dust|751-sand|761-dust|762-volcanic-ash|771-squall
        if weathercode in [721, 731, 751, 761, 762, 771]:
            return weathercode
        # Tornado
        if weathercode in [781]:
            return "󰼸"
        # Smoke
        if weathercode in [711]:
            return "󱞙"

        return weathercode
