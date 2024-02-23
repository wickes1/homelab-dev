output "cp_info" {
  value = [
    for host in proxmox_vm_qemu.k8s-cp : {
      "name" : host.name,
      "ip0" : host.ipconfig0,
      "memory" : host.memory,
      "vcpus" : host.vcpus,
    }
  ]
}

output "wn_info" {
  value = [
    for host in proxmox_vm_qemu.k8s-wn : {
      "name" : host.name,
      "ip0" : host.ipconfig0,
      "memory" : host.memory,
      "vcpus" : host.vcpus,
    }
  ]
}
