#!/usr/bin/env bash
set -x

apt-get clean || exit 1
rm -rf /var/cache/apt/archives/*
rm -rf /var/lib/apt/lists/*
rm -rf /var/tmp/* /var/tmp/.[!.]*
[[ -f /var/log/wtmp ]] && truncate -s 0 /var/log/wtmp

dd if=/dev/zero of=/EMPTY bs=1M
sync || exit 1
rm -f /EMPTY || exit 1
