#!/bin/bash

echo Hello World!

sudo hciconfig hci0 up
sudo hciconfig hci0 leadv 3
sudo hcitool -i hci0 cmd 0x08 0x0008 1E 02 01 06 1A FF 4C 00 02 15 05 C1 31 00 10 2B 42 CF BA BB AC E7 DD 99 C4 E3 00 00 00 00 C8 00

python /home/pi/trittstufe/Raspberry/MQTTClient.py
