#!/bin/bash
mkdir out
cp -r /sys/firmware/acpi out/acpi
./collect-pci > out/pci
./collect-usb > out/usb
