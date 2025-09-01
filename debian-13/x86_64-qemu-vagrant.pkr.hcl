packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "memory" {
  default = 2048
}

variable "ssh_password" {
  default = "debian"
}

variable "headless" {
  default = true
}

variable "disk_size" {
  default = 102400
}

source "qemu" "debian-13-64-vagrant" {
  iso_url           = "builds/qemu/debian-13-64-base/debian-13-64-base"
  disk_image        = true
  iso_checksum      = "none"
  output_directory  = "builds/qemu"
  shutdown_command  = "/usr/bin/systemctl poweroff"
  disk_interface    = "virtio"
  disk_size         = var.disk_size
  memory            = var.memory
  headless          = var.headless
  format            = "qcow2"
  accelerator       = "kvm"
  http_directory    = "http"
  ssh_username      = "root"
  ssh_password      = var.ssh_password
  ssh_timeout       = "60m"
  vm_name           = "debian-13-64-vagrant"
  net_device        = "virtio-net"
  boot_wait         = "5s"
}

build {
  name = "debian-base"
  sources = ["source.qemu.debian-13-64-vagrant"]

  provisioner "shell" {
    scripts = [
      "scripts/vagrant.sh",
      "scripts/clean.sh"
    ]
  }
}
