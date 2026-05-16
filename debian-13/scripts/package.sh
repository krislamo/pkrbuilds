#!/usr/bin/env bash
set -x

err() {
	printf "[ERROR]: %s\n" "$1" >&2
	exit 1
}

IMG_DIR="./builds/qemu/debian-13-64-vagrant"
if [[ ! -f "$IMG_DIR/debian-13-64-vagrant" ]]; then
	err "debian-13-64-vagrant doesn't exist"
fi

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
	cp -l "$IMG_DIR/debian-13-64-vagrant" "$IMG_DIR/box.img" ||
		err "failed to hardlink 'debian-13-64-vagrant' to 'box.img' file"
fi

if [[ ! -f ./builds/vagrant/debian-13-64-vagrant.box ]]; then
	tar -C "$IMG_DIR" -cvzf ./builds/vagrant/debian-13-64-vagrant.box \
		box.img metadata.json Vagrantfile || err "failed to create .box file"
	exit 0
fi

err "debian-13-64-vagrant.box already exists"
