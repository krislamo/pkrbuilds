#!/usr/bin/env bash
set -x

dnf clean all || exit 1
rm -rf /var/cache/libdnf5/*
rm -rf /var/tmp/* /var/tmp/.[!.]*
[[ -f /var/log/wtmp ]] && truncate -s 0 /var/log/wtmp

dd if=/dev/zero of=/EMPTY bs=1M
sync || exit 1
rm -f /EMPTY || exit 1
