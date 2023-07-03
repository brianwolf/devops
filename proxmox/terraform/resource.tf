resource "random_id" "random" {
  byte_length = 8
}

resource "proxmox_vm_qemu" "ubuntu-kube-m1" {

  name = "kube-${random_id.random.hex}"
  desc = "ubuntu-server for kubernetes"
  tags = "kube,master"

  target_node = "server01"
  clone       = "kube"

  os_type    = "ubuntu"
  agent      = 1
  full_clone = false
  clone_wait = 0

  cores   = 2
  sockets = 2
  memory  = 4096

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "35G"
  }
}
