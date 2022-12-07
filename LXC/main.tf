resource "proxmox_lxc" "DC" {
  target_node  = "home-pve"
  hostname     = "DC"
  cores    = 1
  memory   = "1024"
  swap     = "2048"
  ostemplate   = "local:vztmpl/debian-10-turnkey-domain-controller_16.2-1_amd64.tar.gz"
  password     = "123456"
  unprivileged = true
  start        = true


  ssh_public_keys = <<-EOT
    ssh-rsa ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDczVXUSDGxF0csVtFKZrBwFQ9E0a1+AxerO47P3W1B8i0oAkol93nR1x3r0O7+e94GNdcp1GFvnHLV/bk1C6oxXs6kFmErbnfsAH5wVbmbScKNW5Ai1z3b6juHYTQmsvOPJgrOidiGaoK97sYf5UXZdMkKzmBlcCg5UxPD/IXRWDndbEGo+RxGH1j4L/+uKw/Rzb+KCCQLDZk94C6eNGoJoQ7sTUuekcB07RDOj6GKV8rogkZMJsefcybq3w33lZ/4RTWLNWQPbtMGxShG0CwF4uK52nSggTPZWQB7GSjO646zr8yNlOQRKA0aKemUfCQk2cdXv7n0kLQhSCpv/DBTKwFQHt4V33c33D0+phMzK/1Z7INKpclVhgHkra4ylrAZl6gdZH+IX2X9CP4gxFJl+RL76vnKp9J7j2nhBUHNZCLh26ikWVdz0MTg1bO/sxEeD1fU5zDcQJDgo22CkOupg8VY3sKRv3Ymibw05Br5xczSCoAUXKvsccfKwW4rTNs= user@home
  EOT

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "vm"
    size    = "25G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }
}

