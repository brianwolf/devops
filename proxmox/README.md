# Proxmox

## Instalacion VM

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

2. Crear una maquina vritual en KVM (se puede usar la gui)
    * Se recomienda usar ips fijas

3. Una vez levantada la VM seguir los pasos de instalacion

4. Abrir el navegador en la url que aparece en el puerto 8006

5. Las credenciales son:

    * user: root
    * pass: *la que se puso en la instalacion*
