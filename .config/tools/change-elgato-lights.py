#!/usr/bin/python3
import leglight


def get_light(ip):
    colortemp = 4200
    light = leglight.LegLight(ip, 9123)
    light.brightness(25)
    light.color(colortemp)
    return light


def toggle_light(light):
    light.off() if light.isOn == 1 else light.on()


light1 = get_light("10.1.1.144")
light2 = get_light("10.1.1.135")

toggle_light(light1)
toggle_light(light2)
