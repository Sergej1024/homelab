resource "proxmox_vm_qemu" "k8s_server" {
  count       = 1
  name        = "${var.proxmox_host}-master-${count.index + 1}"
  target_node = var.proxmox_host

  clone = var.template_name

  agent    = 1
  os_type  = "cloud-init"
  cores    = 1
  sockets  = 1
  cpu      = "host"
  memory   = 1024
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot         = 0
    size         = "25G"
    type         = "scsi"
    storage      = "vm"
    iothread     = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=192.168.1.1${count.index + 1}/24,gw=192.168.1.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "k8s_agent" {
  count       = 2
  name        = "${var.proxmox_host}-node-${count.index + 1}"
  target_node = var.proxmox_host

  clone = var.template_name

  agent    = 1
  os_type  = "cloud-init"
  cores    = 1
  sockets  = 1
  cpu      = "host"
  memory   = 1024
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot         = 0
    size         = "25G"
    type         = "scsi"
    storage      = "vm"
    iothread     = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=192.168.1.2${count.index + 1}/24,gw=192.168.1.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "storage" {
  count       = 1
  name        = "${var.proxmox_host}-storage-${count.index + 1}"
  target_node = var.proxmox_host

  clone = var.template_name

  agent    = 1
  os_type  = "cloud-init"
  cores    = 1
  sockets  = 1
  cpu      = "host"
  memory   = 1024
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot         = 0
    size         = "100G"
    type         = "scsi"
    storage      = "vm"
    iothread     = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=192.168.1.3${count.index + 1}/24,gw=192.168.1.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

# resource "proxmox_vm_qemu" "puppet" {
#   count       = 1
#   name        = "${var.proxmox_host}-puppet-${count.index + 1}"
#   target_node = var.proxmox_host

#   clone = var.template_name

#   agent    = 1
#   os_type  = "cloud-init"
#   cores    = 2
#   sockets  = 1
#   cpu      = "host"
#   memory   = 4096
#   scsihw   = "virtio-scsi-pci"
#   bootdisk = "scsi0"

#   disk {
#     slot         = 0
#     size         = "25G"
#     type         = "scsi"
#     storage      = "vm"
#     storage_type = "lvm"
#     iothread     = 1
#   }

#   network {
#     model  = "virtio"
#     bridge = "vmbr0"
#   }

#   lifecycle {
#     ignore_changes = [
#       network,
#     ]
#   }

#   # Cloud Init Settings
#   ipconfig0 = "ip=192.168.1.4${count.index + 1}/24,gw=192.168.1.1"

#   sshkeys = <<EOF
#   ${var.ssh_key}
#   EOF
# }