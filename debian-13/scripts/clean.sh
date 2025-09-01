#!/usr/bin/env bash
set -eux

export DEBIAN_FRONTEND=noninteractive
apt-get clean -y
apt-get autoclean -y
rm -f /var/lib/dhcpcd/*
rm -rf /var/cache/apt/archives/*
rm -rf /var/lib/apt/lists/*
rm -rf /var/tmp/* /var/tmp/.[!.]*

truncate -s 0 /var/log/wtmp

dd if=/dev/zero of=/EMPTY bs=1M || true
sync
rm -rf /EMPTY
