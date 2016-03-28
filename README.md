# kvm_bond2
Script to set up a two tap interface bond on a KVM VPS. Should probably replace code for openvpn static key to dynamically generate a new key each time the script is run but lazy for now and this'll do.

OpenVPN servers are set up for maximum performance so there's no authentication or ciphering, you can change this to your heart's content if you wish to add a security layer.

All of this has of course, some dependencies:

- KVM VPS (Xen might work)
- Root access
- A machine on the other side to run the openvpn clients/client bonding script and forward traffic from other devices

Other notables (change as needed):

- tap0 -> 10.8.0.1
- tap1 -> 10.9.0.1
- bond0 -> 10.10.0.1
- Remote (client) subnet -> 192.168.3.x/24
- Bond mode -> IEEE 802.3ad Dynamic link aggregation
