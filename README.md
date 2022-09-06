# Настройка Proxmox для домашнего сервера

## Скачиваем Linux Cloud image

> CentOS 8: https://cloud.centos.org/centos/8/x86_64/images/

```shell
wget https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2
```

## Создаем виртуальную машину, а затем настраиваем ее для использования в качестве шаблона.

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