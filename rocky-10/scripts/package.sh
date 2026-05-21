#!/usr/bin/env bash
set -x

err() {
	printf "[ERROR]: %s\n" "$1" >&2
	exit 1
}

IMG_NAME="rocky-10-64-vagrant"
IMG_DIR="./builds/qemu/$IMG_NAME"
[[ ! -f "$IMG_DIR/$IMG_NAME" ]] && err "$IMG_NAME doesn't exist"

cat >"$IMG_DIR/metadata.json" <<'EOF' || err "failed to write metadata.json"
{"provider":"libvirt","format":"qcow2","virtual_size":100}
EOF

cat >"$IMG_DIR/Vagrantfile" <<'EOF' || err "failed to write Vagrantfile"
Vagrant.configure("2") do |config|
	config.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_version: 4
end
EOF

mkdir -p ./builds/vagrant || err "failed to mkdir ./builds/vagrant"
if [[ ! -f "$IMG_DIR/box.img" ]]; then
	cp -l "$IMG_DIR/$IMG_NAME" "$IMG_DIR/box.img" ||
		err "failed to hardlink '$IMG_NAME' to 'box.img' file"
fi

if [[ ! -f "./builds/vagrant/$IMG_NAME.box" ]]; then
	tar -C "$IMG_DIR" -cvzf "./builds/vagrant/$IMG_NAME.box" \
		box.img metadata.json Vagrantfile || err "failed to create .box file"
	exit 0
fi

err "$IMG_NAME.box already exists"
