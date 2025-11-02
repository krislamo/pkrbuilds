packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "iso_url" {
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.0.0-amd64-netinst.iso"
}

variable "iso_hash" {
  default = "sha256:e363cae0f1f22ed73363d0bde50b4ca582cb2816185cf6eac28e93d9bb9e1504"
}

variable "disk_size" {
  default = 102400
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

source "qemu" "debian-13-64-base" {
  iso_url           = var.iso_url
  iso_checksum      = "${var.iso_hash}"
  output_directory  = "builds/qemu/debian-13-64-base"
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
  vm_name           = "debian-13-64-base"
  net_device        = "virtio-net"
  boot_wait         = "5s"
  boot_command      = [
    "<down>",
    "<tab>",
    " auto=true",
    " priority=critical",
    " passwd/root-password=${var.ssh_password}",
    " passwd/root-password-again=${var.ssh_password}",
    " hostname=trixie",
    " domain=",
    " url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
    "<enter>"
  ]
}

build {
  name = "debian-base"
  sources = ["source.qemu.debian-13-64-base"]

  provisioner "shell" {
    scripts = [
      "scripts/upgrade.sh",
      "scripts/networkd.sh",
      "scripts/clean.sh"
    ]
  }
}
