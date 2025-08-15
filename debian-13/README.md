# Debian Trixie Builds

This directory contains Packer configuration for building Debian 13 (Trixie)
images

## Usage

Build the image:

```
make
```

Remove build artifacts:

```
make clean
```

Build with a visible VM console for debugging:

```
make HEADLESS=false
```
