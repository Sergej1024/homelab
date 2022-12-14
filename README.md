# Настройка Proxmox для домашнего сервера

## Скачиваем Linux Cloud image

<details><summary>Детали</summary>

> CentOS 8: https://cloud.centos.org/centos/8/x86_64/images/

```shell
wget https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2
```
</details>

## Создаем виртуальную машину, а затем настраиваем ее для использования в качестве шаблона.

<details><summary>Детали</summary>

Затем с помощью командной строки (или веб-интерфейса) мы создадим виртуальную машину с произвольным неиспользуемым идентификатором (9000), который позже будем использовать в качестве шаблона cloud-init.

```shell
qm create 9000 --name "centos8-cloudinit-template" --memory 2048 --net0 virtio,bridge=vmbr0
```

Затем импортируйте cloud image, который мы загрузили ранее, в хранилище Proxmox (которое при установке по умолчанию будет называться local-lvm), используя тот же идентификатор.

```shell
qm importdisk 9000 CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2 local-lvm
```

Эта загрузка будет называться в формате «vm--disk-», который для нас будет vm-9000-disk-0, поэтому мы можем затем подключить этот диск через SCSI к нашей виртуальной машине и убедиться, что это загрузочный диск.

```shell
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0
```

Затем, чтобы мы могли позже передать поддерживаемые значения cloud-init, мы должны прикрепить образ cloudinit Proxmox в виде CDROM.

```shell
qm set 9000 --ide2 local-lvm:cloudinit
```

Для некоторых функций cloud-init требуется последовательная консоль, поэтому мы также добавляем ее.

```shell
qm set 9000 --serial0 socket --vga serial0
```

Наконец, мы можем преобразовать этот образ виртуальной машины нашего образа cloud-init в шаблон для будущего использования.

```shell
qm template 9000
```
</details>

## Тестирование

<details><summary>Детали</summary>

Чтобы убедиться, что шаблон можно использовать, мы можем создать виртуальную машину из этого шаблона и передать некоторые входные значения cloud-init, чтобы убедиться, что конечный результат является загружаемой (и подключаемой виртуальной машиной!) — это можно сделать либо с помощью веб-интерфейса, либо с помощью следующих команд CLI (заменив идентификаторы и сетевую конфигурацию на необходимые)

```shell
qm clone 9000 100 --name test-box
qm set 100 --sshkey ~/.ssh/id_rsa.pub
qm set 100 --ipconfig0 ip=192.168.0.100/24,gw=192.168.0.1
qm start 100
```

Это может занять некоторое время, но в конечном итоге эта виртуальная машина должна загрузиться в командной строке (пользователь по умолчанию для CentOS 8 — «centos»), затем подключаемся по SSH.

```shell
ssh -i ~/.ssh/id_rsa centos@192.168.0.100
```
</details>

## Настройка Terraform

<details><summary>Детали</summary>

`variables.tf`

Этот файл позволяет нам указать ожидаемые входные переменные, чтобы разрешить передачу их из командной строки или установить значения по умолчанию.

```yml
variable "pproxmox_api_url" {
  default = "https://<PROXMOX IP>:8006/api2/json"
}

variable "proxmox_api_token_id" {
  efault = "terraform-prov@pve!terraform" # API Token ID
}

variable "proxmox_api_token_secret" {
    default = "api_token"
}

variable "template_name" {
  default = "centos-8-cloudinit-template" # This should match name of template from Part 1
}

variable "proxmox_host" {
  default = "<PROXMOX HOSTNAME>"
}

variable "ssh_key" {
  default = "<YOUR PUBLIC SSH KEY>"
}
```
</details>

## Тестирование

<details><summary>Детали</summary>

```shell
terraform init
terraform plan

# Extra optional
terraform apply # to actually provision using Terraform use this
```
</details>