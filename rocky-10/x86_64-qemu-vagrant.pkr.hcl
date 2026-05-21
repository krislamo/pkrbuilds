packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/qemu"
    }
  }
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

variable "disk_size" {
  default = 102400
}

source "qemu" "rocky-10-64-vagrant" {
  iso_url           = "builds/qemu/rocky-10-64-base/rocky-10-64-base"
  disk_image        = true
  iso_checksum      = "none"
  output_directory  = "builds/qemu/rocky-10-64-vagrant"
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
  vm_name           = "rocky-10-64-vagrant"
  net_device        = "virtio-net"
  boot_wait         = "5s"
}

build {
  name = "rocky-base"
  sources = ["source.qemu.rocky-10-64-vagrant"]

  provisioner "shell" {
    scripts = [
      "scripts/vagrant.sh",
      "scripts/clean.sh"
    ]
  }
}
