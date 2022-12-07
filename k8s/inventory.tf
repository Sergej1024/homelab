data "template_file" "inventory" {
  template = file("${path.module}/templates/inventory.tpl")

  vars = {
    master_node = join("\n", formatlist("%s ansible_host=%s ansible_user=ansible", proxmox_vm_qemu.k8s_server.*.name, proxmox_vm_qemu.k8s_server.*.default_ipv4_address))
    works_node  = join("\n", formatlist("%s ansible_host=%s ansible_user=ansible", proxmox_vm_qemu.k8s_agent.*.name, proxmox_vm_qemu.k8s_agent.*.default_ipv4_address))
    list_master = join("\n", proxmox_vm_qemu.k8s_server.*.name)
    list_works  = join("\n", proxmox_vm_qemu.k8s_agent.*.name)
  }

  depends_on = [
    proxmox_vm_qemu.k8s_server,
    proxmox_vm_qemu.k8s_agent
    # proxmox_vm_qemu.storage
  ]
}

resource "null_resource" "inventories" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ./kubespray/inventory/mycluster/inventory.ini"
  }

  triggers = {
    template = data.template_file.inventory.rendered
  }
}