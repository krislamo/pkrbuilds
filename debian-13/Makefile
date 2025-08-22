.PHONY: install clean

HEADLESS ?= true

default: install

install: base

base:
	PKR_VAR_headless="$(HEADLESS)" packer build x86_64-qemu-base.pkr.hcl

vagrant:
	PKR_VAR_headless="$(HEADLESS)" packer build x86_64-qemu-vagrant.pkr.hcl

clean:
	rm -rf ./builds
