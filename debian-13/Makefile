.PHONY: base vagrant clean

HEADLESS ?= true

default:
	@echo "Please run 'make base' or 'make vagrant'"

base:
	PKR_VAR_headless="$(HEADLESS)" packer build x86_64-qemu-base.pkr.hcl

vagrant:
	PKR_VAR_headless="$(HEADLESS)" packer build x86_64-qemu-vagrant.pkr.hcl

clean:
	rm -rf ./builds
