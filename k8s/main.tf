locals {
  instance_count = {
    "prod"=3
    "stage"=1
  }
  vm_cores = {
    "prod"=4
    "stage"=1
  }
  vm_memory = {
    "prod"=4
    "stage"=1024
  }
  vm_disk = {
    "prod"="50G"
    "stage"="25G"
  }

  instance_count_work = {
    "prod"=6
    "stage"=2
  }
  vm_cores_work = {
    "prod"=2
    "stage"=1
  }
  vm_memory_work = {
    "prod"=2
    "stage"=512
  }
  vm_disk_work = {
    "prod"="100G"
    "stage"="25G"
  }
}

resource "proxmox_vm_qemu" "k8s_server" {
  count       = local.instance_count[terraform.workspace]
  name        = "${terraform.workspace}-master-${count.index}"
  target_node = var.proxmox_host

  clone = var.template_name

  agent    = 1
  os_type  = "cloud-init"
  cores    = local.vm_cores[terraform.workspace]
  sockets  = 1
  cpu      = "host"
  memory   = local.vm_memory[terraform.workspace]
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  ssh_user        = "ansible"
  ssh_private_key = <<EOF
  ${var.ssh_key}
  EOF

    disk {
    slot         = 0
    size         = local.vm_disk[terraform.workspace]
    type         = "scsi"
    storage      = "vm"
    iothread     = 0
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

resource "proxmox_vm_qemu" "k8s_agent" {
  count = local.instance_count_work[terraform.workspace]
  name  = "${terraform.workspace}-worker-${count.index}"
  target_node = var.proxmox_host

  clone = var.template_name

  agent    = 1
  os_type  = "cloud-init"
  cores    = local.vm_cores_work[terraform.workspace]
  sockets  = 1
  cpu      = "host"
  memory   = local.vm_memory_work[terraform.workspace]
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  ssh_user        = "ansible"
  ssh_private_key = <<EOF
  ${var.ssh_key}
  EOF

  disk {
    slot         = 0
    size         = local.vm_disk_work[terraform.workspace]
    type         = "scsi"
    storage      = "vm"
    iothread     = 0
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
  ipconfig0 = "ip=192.168.1.4${count.index + 1}/24,gw=192.168.1.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

# resource "proxmox_vm_qemu" "storage" {

    # depends_on = [
    # null_resource.folder
    # ]

#   count       = 1
#   name        = "${var.proxmox_host}-storage-${count.index + 1}"
#   target_node = var.proxmox_host

#   clone = var.template_name

#   agent    = 1
#   os_type  = "cloud-init"
#   cores    = 1
#   sockets  = 1
#   cpu      = "host"
#   memory   = 1024
#   scsihw   = "virtio-scsi-pci"
#   bootdisk = "scsi0"

#   disk {
#     slot         = 0
#     size         = "100G"
#     type         = "scsi"
#     storage      = "vm"
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
#   ipconfig0 = "ip=192.168.1.5${count.index + 1}/24,gw=192.168.1.1"

#   sshkeys = <<EOF
#   ${var.ssh_key}
#   EOF
# }

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