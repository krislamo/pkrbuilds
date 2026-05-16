#!/usr/bin/env bash
set -x

err() {
	printf "[ERROR]: %s\n" "$1" >&2
	exit 1
}

export DEBIAN_FRONTEND=noninteractive
apt-get update || err "failed to update APT cache"
apt-get install -y \
	qemu-guest-agent \
	nfs-common \
	openssl \
	curl \
	sudo \
	vim \
	python3-apt || err "failed to install packages"

useradd -m -s /bin/bash -p "$(openssl passwd -1 vagrant)" vagrant ||
	err "failed to add vagrant user"
printf '%s\n' "vagrant ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/vagrant ||
	err "failed to write sudoers file"
chmod 440 /etc/sudoers.d/vagrant || err "failed to chmod sudoers file"
install -d -m 0700 -o vagrant -g vagrant /home/vagrant/.ssh ||
	err "failed to create vagrant .ssh dir"

BASE_GH_URL="https://raw.githubusercontent.com/hashicorp/vagrant/refs/heads"
curl -fsSL "${BASE_GH_URL}/main/keys/vagrant.pub" \
	-o /home/vagrant/.ssh/authorized_keys ||
	err "failed to download initial authorized_keys"
chmod 600 /home/vagrant/.ssh/authorized_keys || err "failed to chmod 600 authorized_keys"
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys ||
	err "failed to chown initial authorized_keys"

sed -i 's/PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config ||
	err "failed to disable root login via SSH"
passwd -d root || err "failed to delete root password"
passwd -l root || err "failed to lock root password"
