#!/bin/sh
xprop | grep -i -E '(_NET_WM_NAME|WM_CLASS|_NET_WM_WINDOW_TYPE)'
