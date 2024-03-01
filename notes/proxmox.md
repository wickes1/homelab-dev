# Proxmox Command

## Synchronize Time

```bash
systemctl restart chronyd
journalctl --since -1h -u chrony
timedatectl
```

## Proxmox  Upgrade from 7  to 8

[Upgrade from 7 to 8 - Proxmox VE](https://pve.proxmox.com/wiki/Upgrade_from_7_to_8)

## Proxmox Cloud Init

```bash
# qm = QEMU / KVM
# create = Create VM
# 5000 = VM ID
# --name ubuntu-cloud = VM Name
# --memory 2048 = Memory
# --net0 (default network device) = virtio,bridge=vmbr0 (vmbr0 usually is the default bridge of Proxmox)
qm create 5000 --name ubuntu-cloud --memory 2048 --net0 virtio,bridge=vmbr0 --cores 2 --description "Ubuntu 20.04 Cloud Init"

# Import Cloud Image
cd /var/lib/vz/template/iso
qm importdisk 5000 noble-server-cloudimg-amd64.img nvme0n1

# Attach the disk to the VM
qm set 5000 --scsihw virtio-scsi-pci --scsi0 nvme0n1:5000/vm-5000-disk-0.raw

# Like a create a CD-ROM and mount on ide2
qm set 5000 --ide2 nvme0n1:cloudinit

# Set the boot order to boot from CD-ROM
qm set 5000 --boot c --bootdisk scsi0

# Create a serial serial port, like plugin a VGA monitor, in case you cannot access the VM via SSH
qm set 5000 --serial0 socket --vga serial0
```

## Update

```bash
sudo apt update && sudo apt upgrade -y
```

## QEMU Agent

```sh
sudo apt install qemu-guest-agent
sudo systemctl enable qemu-guest-agent
sudo shutdown now
sudo systemctl start qemu-guest-agent
sudo systemctl status qemu-guest-agent
```

## Change password

```bash
sudo -i passwd
sudo passwd root
```

## Stop and Remove VMs

```bash
cat /etc/pve/.vmlist
qm stop 200 --skiplock
qm destroy 200
ps aux | grep "/usr/bin/kvm -id 200"
kill -9 PID

# remove all VMs
# vmids=$(cat /etc/pve/.vmlist);
vmids=(105 106 107 108 109)
for vmid in "${vmids[@]}"; do
  qm stop $vmid --skiplock
  qm destroy $vmid
done
```

## Error Debug

- failed to set wall message, ignoring: transport endpoint is not connected call to reboot failed: transport endpoint is not connected

```bash
systemctl --force --force reboot
```
