# Instalacion

1. Ejecutar

    ```bash
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
    ```

2. Configurar permisos

    Antes borrar los CRB y el CR de kubernetes-dashboard

    ```bash
    kubectl apply -f yamls/
    ```
