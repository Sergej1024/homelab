locals {
  k8s_server = "${zipmap("${proxmox_vm_qemu.k8s_server.*.name}", "${proxmox_vm_qemu.k8s_server.*.default_ipv4_address}")}"
  k8s_agent  = "${zipmap("${proxmox_vm_qemu.k8s_agent.*.name}", "${proxmox_vm_qemu.k8s_agent.*.default_ipv4_address}")}"
  # storage    = "${zipmap("${proxmox_vm_qemu.storage.*.name}", "${proxmox_vm_qemu.storage.*.default_ipv4_address}")}"
  #puppet     = "${zipmap("${proxmox_vm_qemu.puppet.*.name}", "${proxmox_vm_qemu.puppet.*.default_ipv4_address}")}"

}

output "servers" {
  value = "${merge("${local.k8s_server}", "${local.k8s_agent}")}"#, "${local.storage}", "${local.puppet}"

  depends_on = [
    proxmox_vm_qemu.k8s_server,
    proxmox_vm_qemu.k8s_agent
    # proxmox_vm_qemu.storage
  ]
}