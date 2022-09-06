variable "proxmox_api_url" {
    default = "https://192.168.1.2:8006/api2/json" # Your Proxmox IP Address
}

variable "proxmox_api_token_id" {
    default = "terraform-prov@pve!terraform" # API Token ID
}

variable "proxmox_api_token_secret" {
    default = "24e71791-236a-4ad9-8078-64703a712213"
}

variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDczVXUSDGxF0csVtFKZrBwFQ9E0a1+AxerO47P3W1B8i0oAkol93nR1x3r0O7+e94GNdcp1GFvnHLV/bk1C6oxXs6kFmErbnfsAH5wVbmbScKNW5Ai1z3b6juHYTQmsvOPJgrOidiGaoK97sYf5UXZdMkKzmBlcCg5UxPD/IXRWDndbEGo+RxGH1j4L/+uKw/Rzb+KCCQLDZk94C6eNGoJoQ7sTUuekcB07RDOj6GKV8rogkZMJsefcybq3w33lZ/4RTWLNWQPbtMGxShG0CwF4uK52nSggTPZWQB7GSjO646zr8yNlOQRKA0aKemUfCQk2cdXv7n0kLQhSCpv/DBTKwFQHt4V33c33D0+phMzK/1Z7INKpclVhgHkra4ylrAZl6gdZH+IX2X9CP4gxFJl+RL76vnKp9J7j2nhBUHNZCLh26ikWVdz0MTg1bO/sxEeD1fU5zDcQJDgo22CkOupg8VY3sKRv3Ymibw05Br5xczSCoAUXKvsccfKwW4rTNs= user@home"
}
variable "proxmox_host" {
    default = "home-pve"
}

variable "template_name" {
    default = "centos8-cloudinit-template"
}