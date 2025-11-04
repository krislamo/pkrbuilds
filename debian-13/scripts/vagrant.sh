#!/usr/bin/env bash
set -eu

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y \
	qemu-guest-agent \
	nfs-common \
	openssl \
	curl \
	sudo \
	vim \
	python3-apt

useradd -m -s /bin/bash -p "$(openssl passwd -1 vagrant)" vagrant

echo "vagrant ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/vagrant
chmod 440 /etc/sudoers.d/vagrant

install -d -m 0700 -o vagrant -g vagrant /home/vagrant/.ssh
BASE_GH_URL="https://raw.githubusercontent.com/hashicorp/vagrant/refs/heads"
curl -fsSL "${BASE_GH_URL}/main/keys/vagrant.pub" \
	-o /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys

sed -i 's/PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
passwd -d root
