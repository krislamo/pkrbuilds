#!/usr/bin/env bash
set -xu

IMG_DIR="./builds/qemu/debian-13-64-vagrant"
if [ ! -f "$IMG_DIR/debian-13-64-vagrant" ]; then
	echo "[ERROR]: debian-13-64-vagrant doesn't exist"
	exit 1
fi

cat > "$IMG_DIR/metadata.json" <<EOF
{"provider":"libvirt","format":"qcow2","virtual_size":100}
EOF

cat > "$IMG_DIR/Vagrantfile" <<'EOF'
Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_version: 4
end
EOF

mkdir -p ./builds/vagrant

if [ ! -f ./builds/vagrant/box.img ]; then
	cp -l $IMG_DIR/debian-13-64-vagrant \
		$IMG_DIR/box.img
fi

if [ ! -f ./builds/vagrant/debian-13-64-vagrant.box ]; then
	tar -C "$IMG_DIR" -cvzf ./builds/vagrant/debian-13-64-vagrant.box \
		box.img metadata.json Vagrantfile
	exit 0
fi

echo "[ERROR]: debian-13-64-vagrant.box already exists"
exit 1
