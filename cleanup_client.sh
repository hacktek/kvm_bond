#!/bin/bash

ip addr del 10.10.0.2/30 dev bond0
ip addr del 10.8.0.2/30 dev tap0
ip addr del 10.9.0.2/30 dev tap1

killall -9 openvpn

ip route add default via 192.168.3.3 dev eth0
ip route add default via 192.168.3.3 dev eth0

rmmod bonding
