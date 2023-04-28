# :file_folder: Instalacion de kubernetes

1. Install kubelet, kubeadm and kubectl

    ```bash
    sudo apt -y install curl apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt update
    sudo apt -y install vim git curl wget kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl

    kubectl version --client && kubeadm version
    ```

    Respuesta esperada:

    ```bash
    Client Version: version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.1", GitCommit:"8f94681cd294aa8cfd3407b8191f6c70214973a4", GitTreeState:"clean", BuildDate:"2023-01-18T15:58:16Z", GoVersion:"go1.19.5", Compiler:"gc", Platform:"linux/amd64"}
    Kustomize Version: v4.5.7
    kubeadm version: &version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.1", GitCommit:"8f94681cd294aa8cfd3407b8191f6c70214973a4", GitTreeState:"clean", BuildDate:"2023-01-18T15:56:50Z", GoVersion:"go1.19.5", Compiler:"gc", Platform:"linux/amd64"}
    ```

2. Desactivar swap

    ```bash
    sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

    sudo swapoff -a
    sudo mount -a
    free -h
    ```

3. Ejecutar

    ```bash
    # Enable kernel modules
    sudo modprobe overlay
    sudo modprobe br_netfilter

    # Add some settings to sysctl
    sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    net.ipv4.ip_forward = 1
    EOF

    # Reload sysctl
    sudo sysctl --system
    ```

4. Instalar cri-o

    ```bash
    # Ensure you load modules
    sudo modprobe overlay
    sudo modprobe br_netfilter

    # Set up required sysctl params
    sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    net.ipv4.ip_forward = 1
    EOF

    # Reload sysctl
    sudo sysctl --system

    # Add Cri-o repo
    sudo su -
    OS="xUbuntu_20.04"
    VERSION=1.26
    echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
    echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
    curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | apt-key add -
    curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key add -

    # Install CRI-O
    sudo apt update
    sudo apt install cri-o cri-o-runc

    # Update CRI-O CIDR subnet
    sudo sed -i 's/10.85.0.0/192.168.0.0/g' /etc/cni/net.d/100-crio-bridge.conflist

    # Start and enable Service
    sudo systemctl daemon-reload
    sudo systemctl restart crio
    sudo systemctl enable crio
    sudo systemctl status crio
    ```

## Iniciar Master

1. Ejecutar

    ```bash
    sudo systemctl enable kubelet

    sudo kubeadm config images pull --cri-socket unix:///var/run/crio/crio.sock

    sudo kubeadm init \
        --pod-network-cidr=192.168.0.0/16 \
        --cri-socket unix:///var/run/crio/crio.sock
    ```

2. Configurar kubectl

    ```bash
    mkdir -p $HOME/.kube
    sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```

3. Agregar la variable del kubeconf

    ```bash
    sudo echo "KUBECONFIG=$HOME/.kube/config" >> /etc/environment
    ```

4. Revisar la instalacion

    ```bash
    kubectl cluster-info
    ```

    Resultado

    ```bash
    Kubernetes master is running at https://k8s-cluster.computingforgeeks.com:6443
    KubeDNS is running at https://k8s-cluster.computingforgeeks.com:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
    ```

5. Instalar Calico

    ```bash
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/tigera-operator.yaml
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/custom-resources.yaml
    ```

6. Revisar instalacion de calico

    ```bash
    watch kubectl get pods --all-namespaces
    ```

    Resultado

    ```javascript
    Every 2.0s: kubectl get pods --all-namespaces                                             ubuntu: Fri Apr 28 18:20:23 2023

    NAMESPACE          NAME                                       READY   STATUS    RESTARTS   AGE
    calico-apiserver   calico-apiserver-c5dd5d875-4pckk           1/1     Running   0          67s
    calico-apiserver   calico-apiserver-c5dd5d875-lhlmk           1/1     Running   0          67s
    calico-system      calico-kube-controllers-789dc4c76b-h5579   1/1     Running   0          2m20s
    calico-system      calico-node-qnfdq                          1/1     Running   0          2m20s
    calico-system      calico-typha-c885b5964-9t8l4               1/1     Running   0          2m20s
    calico-system      csi-node-driver-h7mkw                      2/2     Running   0          2m20s
    kube-system        coredns-5d78c9869d-6sk5r                   1/1     Running   0          47m
    kube-system        coredns-5d78c9869d-t7p7f                   1/1     Running   0          47m
    kube-system        etcd-ubuntu                                1/1     Running   0          47m
    kube-system        kube-apiserver-ubuntu                      1/1     Running   0          47m
    kube-system        kube-controller-manager-ubuntu             1/1     Running   0          47m
    kube-system        kube-proxy-mdpwh                           1/1     Running   0          47m
    kube-system        kube-scheduler-ubuntu                      1/1     Running   0          47m
    tigera-operator    tigera-operator-549d4f9bdb-5hb7n           1/1     Running   0          5m23s
    ```

## Iniciar Nodo

