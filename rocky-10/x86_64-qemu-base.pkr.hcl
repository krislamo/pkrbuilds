packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "iso_url" {
  default = "https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.1-x86_64-boot.iso"
}

variable "iso_hash" {
  default = "sha256:18543988d9a1a5632d142c3dc288136dcc48ab71628f92ebcd40ada7f4ecd110"
}

variable "disk_size" {
  default = 102400
}

variable "memory" {
  default = 4096
}

variable "ssh_password" {
  default = "rocky"
}

variable "headless" {
  default = true
}

source "qemu" "rocky-10-64-base" {
  iso_url           = var.iso_url
  iso_checksum      = "${var.iso_hash}"
  output_directory  = "builds/qemu/rocky-10-64-base"
  shutdown_command  = "/usr/bin/systemctl poweroff"
  disk_interface    = "virtio"
  cpu_model         = "host"
  disk_size         = var.disk_size
  memory            = var.memory
  headless          = var.headless
  format            = "qcow2"
  accelerator       = "kvm"
  http_directory    = "http"
  ssh_username      = "root"
  ssh_password      = var.ssh_password
  ssh_timeout       = "60m"
  vm_name           = "rocky-10-64-base"
  net_device        = "virtio-net"
  boot_wait         = "5s"
  boot_command = [
    "c<wait2>",
    "linux /images/pxeboot/vmlinuz",
    " inst.stage2=https://download.rockylinux.org/pub/rocky/10/BaseOS/x86_64/os/",
    " inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg ip=dhcp",
    "<enter><wait>",
    "initrd /images/pxeboot/initrd.img<enter><wait15>",
    "boot<enter><wait>"
  ]
}

build {
  name = "rocky-base"
  sources = ["source.qemu.rocky-10-64-base"]

  provisioner "shell" {
    scripts = [
      "scripts/upgrade.sh",
      "scripts/clean.sh"
    ]
  }
}
