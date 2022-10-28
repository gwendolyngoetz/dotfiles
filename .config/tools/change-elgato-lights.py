#!/usr/bin/python3
import sys
import leglight

state = False
if len(sys.argv) > 1:
    state = sys.argv[1] == 'on'

light1 = leglight.LegLight('10.1.1.144',9123)
light2 = leglight.LegLight('10.1.1.135',9123)
colortemp = 4200

if state == True:
    light1.on()
    light1.brightness(25)
    light1.color(colortemp)

    light2.on()
    light2.brightness(25)
    light2.color(colortemp)
else:
    light1.off()
    light2.off()
