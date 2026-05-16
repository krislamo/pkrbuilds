#!/usr/bin/env bash
set -x
export DEBIAN_FRONTEND=noninteractive
apt-get update || exit 1
apt-get upgrade -y || exit 1
