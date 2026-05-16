#!/usr/bin/env bash
set -x

err() {
	printf "[ERROR]: %s\n" "$1" >&2
	exit 1
}

export DEBIAN_FRONTEND=noninteractive
apt-get update || err "failed to update APT cache"
apt-get install -y systemd-resolved || err "failed to install systemd-resolved"

install -d -m 755 -o root -g root /etc/systemd/network ||
	err "failed to create /etc/systemd/network"

cat >/etc/systemd/network/lan0.network <<'EOF' || err "failed to write lan0"
[Match]
Name=e*
Type=ether

[Network]
DHCP=ipv4
EOF

chown root:root /etc/systemd/network/lan0.network || err "failed to chown"
chmod 644 /etc/systemd/network/lan0.network || err "failed to chmod 644"

systemctl enable systemd-networkd || err "failed to enable networkd"
systemctl enable systemd-resolved || err "failed to enable resolved"
systemctl disable networking || err "failed to disable networking service"
apt-get purge -y ifupdown || err "failed to purge ifupdown"
