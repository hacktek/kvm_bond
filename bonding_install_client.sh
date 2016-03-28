#!/bin/bash

#Update and install dependencies
apt-get update
apt-get -y upgrade
apt-get -y install uml-utilities openvpn ifenslave

#Copy openvpn client config files to root directory for manipulation
cp openvpn/client.conf /root/
cp openvpn/client2.conf /root/

#Modify openvpn client config file IP
echo "IP of the KVM VPS: "
read ip

echo "remote $ip" >> /root/client.conf
echo "remote $ip" >> /root/client2.conf

#Move config files to openvpn directory
mv /root/client.conf /etc/openvpn/
mv /root/client2.conf /etc/openvpn/
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