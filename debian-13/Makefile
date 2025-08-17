.PHONY: install clean

HEADLESS ?= true

default: install

install:
	PKR_VAR_headless="$(HEADLESS)" packer build .

clean:
	rm -rf ./builds
