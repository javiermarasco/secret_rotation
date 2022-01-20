# General

En este repositorio estan los recursos necesarios para poder implementar una solucion de rotacion de secrets para 
Azure service principals de forma automatica.

Este repositorio va a ir mutando a medida que vaya agregando mas videos a mi canal (javi__codes @youtube) para reflejar el 
avance del proyecto.

### Pre requisitos

- [x] kubectl (cli para manejar el cluster de kubernetes)
- [x] kubens (tool para cambiar de namespace en kubernetes) (opcional)
- [x] kubectx (tool para cambiar de cluster rapidamente) (opcional)
- [x] helm (tool para manejar charts)
- [x] terraform
- [x] Azure CLI

## Capitulo 1

- Desplegar un cluster AKS completo
- Desplegar Vault dentro de AKS
  - [x]  descargar helm chart
  - [x]  configurar 3 replicas
  - [x]  configurar storage account como storage backend
  - [x]  configurar keyvault como key unseal
- Keyvault para key de unseal del vault
  - [x] Terraform para crear la keyvault
- Storage account para backend de vault
  - [x] Terraform para crear la storage account
- Confirmar que podemos loguearnos a Vault 
  - [x] Port forward del pod:8200 a localhost:8200
            kubectl port-forward vault-o 8200:8200
