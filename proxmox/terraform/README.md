# Instrucciones

1. Crear un token en proxmox y asegurarse que la casilla de **Privilege Separetion** este **destildada**

2. Agregar el api key y el secret generado en el archivo **.env**

3. Ejecutar

    ```bash
    . .env
    ```

4. Ejecutar

    ```bash
    make i
    make p
    make a
    ```

5. Cambiar la ip de la maquina virtual

    ```bash
    sudo vim /etc/netplan/00-installer-config.yaml
    ```

    Agregar lo siguiente:

    ```bash
    network:
    ethernets:
        enp0s3:
            dhcp4: false
            addresses: [192.168.122.101/24]
            routes:
                - to: default
                  via: 192.168.122.1
            nameservers:
              addresses: [8.8.8.8,8.8.4.4,192.168.122.1]
    version: 2
    ```

    Ejecutar para aplicar los cambios:

    ```bash
    sudo netplan apply
    ```
