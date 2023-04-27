resource "proxmox_vm_qemu" "ubuntu-server-01" {
  name = "ubuntu-server-01"
  desc = "ubuntu-server cloned"
  tags = "EKS"

  vmid        = "102"
  target_node = "server01"
  clone       = "ubuntu-server"

  os_type = "ubuntu"
  agent   = 0

  startup = "1"
  cores   = 2
  sockets = 2
  memory  = 4096

  network {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "32G"
  }

}
