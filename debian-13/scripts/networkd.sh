#!/usr/bin/env bash
set -eux

install -d -m 755 -o root -g root /etc/systemd/network
cat > /etc/systemd/network/lan0.network << 'EOF'
[Match]
Name=e*
Type=ether

[Network]
DHCP=ipv4
EOF

chown root:root /etc/systemd/network/lan0.network
chmod 644 /etc/systemd/network/lan0.network

mv /etc/network/interfaces /etc/network/interfaces.save
mv /etc/network/interfaces.d /etc/network/interfaces.d.save
systemctl enable systemd-networkd
systemctl disable networking

printf "nameserver %s\n" 9.9.9.9 8.8.8.8 >/etc/resolv.conf
cat /etc/resolv.conf
