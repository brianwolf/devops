resource "proxmox_vm_qemu" "ubuntu-kube-m1" {

  name = "kube-m1"
  desc = "ubuntu-server for kubernetes"
  tags = "kube,master"
  vmid = "101"

  target_node = "server01"
  clone       = "kube"

  os_type      = "cloud-init"
  agent        = 0
  ipconfig0    = "ip=192.168.122.101/24,gw=192.168.122.1"
  ciuser       = "kube"
  cicipassword = "kube"

  startup = "1"
  cores   = 2
  sockets = 2
  memory  = 4096

}
