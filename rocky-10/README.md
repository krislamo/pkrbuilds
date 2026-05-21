# Rocky Red Quartz Builds

This directory contains Packer configuration for building Rocky 10 (Red Quartz)

### Overview

These builds use a multi-stage Packer workflow:

- The first stage creates a minimal base image from the installer ISO
- The second stage reuses that base image to produce a Vagrant-ready box

### Usage

Build the base qemu image:

    make base

Build vagrant image:

    make vagrant

Package vagrant box:

    make package

Build with visible console:

    make base HEADLESS=false

### Publishing

Built boxes from this configuration are published at
[krislamo.org/rocky10](https://portal.cloud.hashicorp.com/vagrant/discover/krislamo.org/rocky10)
on Vagrant Cloud
