# kvm_bond

Disclaimer: I created this for myself to it's not meant to be a tutorial. You need to know what you're doing network wise. If you don't know what a linux bond is or why you would use it then this script is not for you. It also has some things that are specific to my network that you can change before running.

Script to set up a two tap interface bond on a KVM VPS. Should probably replace code for openvpn static key to dynamically generate a new key each time the script is run but lazy for now and this'll do. You can change the key yourself after the fact by running "openvpn --genkey --secret /etc/openvpn/static.key"

OpenVPN servers are set up for maximum performance so there's no authentication or ciphering, you can change this to your heart's content if you wish to add a security layer.

All of this has of course, some dependencies:

- KVM VPS (Xen might work). Vultr or Digital Ocean are great for testing: http://bit.ly/22XZ26Z or http://bit.ly/22WFy62
- Root access
- A machine on the other side to run the openvpn clients/client bonding script and forward traffic from other devices

Other notables (change as needed):

- tap0 -> 10.8.0.1:10.8.0.2
- tap1 -> 10.9.0.1:10.8.0.2
- bond0 -> 10.10.0.1:10.10.0.2
- Remote (client) subnet -> 192.168.3.x/24
- Bond mode -> IEEE 802.3ad Dynamic link aggregation
- Tested on Ubuntu 14.04 x64

Usage:

- Clone repo
- Back up your systems and preferably start with a clean install
- Change any network specific values to match your networks
- Run bonding_install.sh on VPS
- Run bonding_install_client.sh on client machine
