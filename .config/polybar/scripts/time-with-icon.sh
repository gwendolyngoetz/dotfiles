#! /bin/sh

HOUR=$(date "+%I")
TIME=$(date "+%-I:%M %p")

case $HOUR in 
    1)
        TIMEICON=🕐
        ;;
    2)
        TIMEICON=🕑
        ;;
    3)
        TIMEICON=🕒
        ;;
    4)
        TIMEICON=🕓
        ;;
    5)
        TIMEICON=🕔
        ;;
    6)
        TIMEICON=🕕
        ;;
    7)
        TIMEICON=🕖
        ;;
    8)
        TIMEICON=🕗
        ;;
    9)
        TIMEICON=🕘
        ;;
    10)
        TIMEICON=🕙
        ;;
    11)
        TIMEICON=🕚
        ;;
    12)
        TIMEICON=🕛
        ;;
    *)
        TIMEICON=Z
        ;;
esac 

echo $TIMEICON $TIME
