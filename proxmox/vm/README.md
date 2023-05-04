# Proxmox

## Instalacion KVM

1. Revisar si esta activada la virtualizacion de la CPU en la bios

    ```bash
    sudo apt install -y cpu-checker
    kvm-ok
    ```

    El resultado deberia ser algo asi:

    ```text
    INFO: /dev/kvm exists
    KVM acceleration can be used
    ```

2. Ejecutar

    ```bash
    sudo apt install -y qemu-kvm virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils
    ```

3. Habilitar dependencias

    ```bash
    sudo systemctl enable --now libvirtd
    sudo systemctl start libvirtd
    ```

4. Darle permisos al usuario

    ```bash
    sudo usermod -aG kvm $USER
    sudo usermod -aG libvirt $USER
    ```

5. Ejecutar GUI

    ```bash
    virt-manager
    ```

## Instalacion Proxmox

1. Descargar la imagen ISO:

    [link de la pagina oficial](https://www.proxmox.com/en/downloads/category/iso-images-pve)

2. Crear una maquina virtual en KVM (se puede usar la gui)
    * Se recomienda usar ips fijas
    * el host que pongas se transforma en el nombre del nodo

3. Una vez levantada la VM seguir los pasos de instalacion

4. Abrir el navegador en la url que aparece en el puerto **8006**

5. Las credenciales son:

    * **user**: root
    * **pass**: *la que se puso en la instalacion*

## Instalacion de ububntu server dentro de Proxmox

1. Descargar la ISO de ubuntu server de la pagina oficial

2. Cargar la imagen de ubuntu server dentro de proxmox en *local > ISO images > Upload*

3. Crear una maquina virtual normalmente dentro de proxmox
    * Usar la ISO de ubuntu cargada en proxmox
    * Se recomienda usar 4 GB de RAM
    * Se recomienda usar 4 cores
    * Todo lo demas dejarlo por default

4. Una vez generada la VM ir a *Hardware > Add > Cloudinit Driver*
    * Configurarlo con lo default

5. Una vez que esta el cloud init activo ir a *Cloud Init* y configurar con lo siguiente
    * user: kube
    * pass: kube
    * ipv4: 192.168.122.10
    * Gateway: 192.168.122.1
    * ipv6: DHCP

6. Luego iniciar la VM e instalar ubuntu server normalmente
    * Usar ip estatica:
        * subnet: 192.168.122.0/24
        * adress: 192.168.122.10
        * Gateway: 192.168.122.1
        * nameserver: 8.8.8.8,8.8.4.4

7. Luego de instalar, antes de reiniciar desacoplar el CD-ROM con la iso de instalacion *Hardware > CD/DVD Drive > Edit > Do not use any media*

8. Luego ejecutar los siguientes comandos para dejar bien configurado el ubuntu server

    ```bash
    sudo apt autoremove cloud-init
    sudo rm -fr /etc/cloud/
    sudo apt update
    sudo apt upgrade
    sudo apt install cloud-init
    ```

9. Convertir la VM en Temaplate llendo a *More > Convert to template*
