#!/bin/bash

#Update and install dependencies
apt-get update
apt-get -y upgrade
apt-get -y install uml-utilities openvpn ifenslave

#Super awful way of getting VPS IP, just picks one of valid public IP and doesn't care about others
ip=`ifconfig | grep -A1 eth0 | tail -1 | awk -F ":" '{print $2}' | awk '{print $1}'`

#Copy openvpn server config files to root directory for manipulation
cp openvpn/server.conf /root/
cp openvpn/server2.conf /root/

#Modify openvpn server config file IP
sed -i s/IP/$ip/g /root/server.conf /root/server2.conf

#Move config files to openvpn directory
mv /root/server.conf /etc/openvpn/
mv /root/server2.conf /etc/openvpn/
mv openvpn/ca.crt /etc/openvpn/
mv openvpn/dh2048.pem /etc/openvpn/
mv openvpn/static.key /etc/openvpn/

#Disable openvpn startup
update-rc.d openvpn disable

#Copy bonding and cleanup scripts to /root and make them executable
cp bonding.sh /root/
cp cleanup.sh /root/
chmod +x /root/bonding.sh
chmod +x /root/cleanup.sh

#Allow ipv4 forwarding
cp /etc/sysctl.conf /etc/sysctl.conf.bak
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

#Some iptables shenanigans
iptables -A FORWARD -o eth0 -i bond0 -s 192.0.0.0/8 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A POSTROUTING -t nat -o eth0 -j MASQUERADE