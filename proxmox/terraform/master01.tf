resource "proxmox_vm_qemu" "ubuntu-kube-m1" {

  name = "kube-m1"
  desc = "ubuntu-server for kubernetes"
  tags = "kube,master"

  target_node = "server01"
  clone       = "kube"

  os_type = "ubuntu"
  agent   = 1

  cores   = 2
  sockets = 2
  memory  = 4096

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "35G"
  }
  
  full_clone = false
  clone_wait = 0
}


output "ip_v4" {
  value = proxmox_vm_qemu.ubuntu-kube-m1.default_ipv4_address
}
