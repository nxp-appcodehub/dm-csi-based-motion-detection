#
# Copyright 2025 NXP
#
# SPDX-License-Identifier: BSD-3-Clause
#

killall -9 wpa_supplicant
killall -9 wpa_supplicant

killall -9 hostapd
killall -9 hostapd

modprobe moal mod_para=nxp/wifi_mod_para.conf

sleep 5

wpa_supplicant -i mlan0 -Dnl80211 -c ./wpa_supplicant_wpa2.conf &

sleep 10

udhcpc -i mlan0

sleep 5

ifconfig uap0 192.168.4.1 netmask 255.255.255.0 up
hostapd hostapd.conf &
udhcpd dhcp.conf

sleep 10

iw dev
