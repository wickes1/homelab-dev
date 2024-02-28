resource "proxmox_vm_qemu" "k8s-cp" {
  # Node name has to be the same name as within the cluster
  # this might not include the FQDN
  target_node = "pve01"
  desc        = "Cloudinit Ubuntu"
  count       = 3
  onboot      = true

  # The template name to clone this vm from
  clone = "ubuntu-cloud"

  # Activate QEMU agent for this VM
  agent = 0

  os_type = "cloud-init"
  cores   = 4
  sockets = 1
  numa    = true
  vcpus   = 0
  cpu     = "host"
  memory  = 8192
  name    = "k8s-cp-0${count.index + 1}"

  cloudinit_cdrom_storage = "nvme0n1"
  scsihw                  = "virtio-scsi-single"
  bootdisk                = "scsi0"

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "nvme0n1"
          size    = 20
        }
      }
    }
  }

  # Setup the ip address using cloud-init.
  # Keep in mind to use the CIDR notation for the ip.
  ipconfig0  = "ip=192.168.1.20${count.index + 1}/24,gw=192.168.1.1"
  ciuser     = "ubuntu"
  nameserver = "192.168.1.1"
  sshkeys    = <<EOF
${var.vm_ssh_key}
    EOF
}

resource "proxmox_vm_qemu" "k8s-wn" {
  # Node name has to be the same name as within the cluster
  # this might not include the FQDN
  target_node = "pve01"
  desc        = "Cloudinit Ubuntu"
  count       = 2
  onboot      = true

  # The template name to clone this vm from
  clone = "ubuntu-cloud"

  # Activate QEMU agent for this VM
  agent = 0

  os_type = "cloud-init"
  cores   = 2
  sockets = 1
  numa    = true
  vcpus   = 0
  cpu     = "host"
  memory  = 4096
  name    = "k8s-wn-0${count.index + 1}"

  cloudinit_cdrom_storage = "nvme0n1"
  scsihw                  = "virtio-scsi-single"
  bootdisk                = "scsi0"

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "nvme0n1"
          size    = 20
        }
      }
    }
  }

  # Setup the ip address using cloud-init.
  # Keep in mind to use the CIDR notation for the ip.
  ipconfig0 = "ip=192.168.1.21${count.index + 1}/24,gw=192.168.1.1"
  ciuser    = "ubuntu"
  sshkeys   = <<EOF
${var.vm_ssh_key}
    EOF
}
