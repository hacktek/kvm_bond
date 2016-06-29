#!/bin/bash

ip route del default
ip route del default



echo "Enabling modules..."
modprobe bonding mode=4 xmit_hash_policy=1 miimon=100 lacp_rate=fast
modprobe tun

echo "Downing interfaces..."
ifconfig tap0 down
ifconfig tap1 down

echo "Creating persistent interfaces..."
tunctl -u root -g root -t tap0
tunctl -u root -g root -t tap1

echo "Upping interfaces..."
ifconfig tap0 up
ifconfig tap1 up

echo "Starting openvpn..."
openvpn --config /etc/openvpn/client.conf  &
openvpn --config /etc/openvpn/client2.conf  &
sleep 30

echo "Creating bond interface..."
ifconfig bond0 hw ether 22:33:44:55:66:77
ifconfig bond0 10.10.0.2 netmask 255.255.255.252 broadcast 10.10.0.3 up

echo "Enslaving tunnels..."
ifenslave bond0 tap0 tap1

echo "Setting tunnel IP addresses..."
ip addr add 10.8.0.2/30 dev tap0 scope link
ip addr add 10.9.0.2/30 dev tap1 scope link

ip route add default via 10.10.0.1 dev bond0 initcwnd 16
echo "Optimizing bond..."
ifconfig bond0 mtu 6000
ifconfig bond0 txqueuelen 10000
echo 3000 > /proc/sys/net/core/netdev_max_backlog
sleep 10
