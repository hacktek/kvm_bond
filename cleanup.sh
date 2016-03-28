#!/bin/bash

ip addr del 10.10.0.1/32 dev lo

ip addr del 10.9.0.1/30 dev tap1

ip addr del 10.8.0.1/30 dev tap0



killall -9 openvpn



rmmod bonding



