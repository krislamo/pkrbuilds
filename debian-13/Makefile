.PHONY: install clean

HEADLESS ?= true

default: install

install:
	packer build -var 'headless=$(HEADLESS)' .

clean:
	rm -rf ./builds
