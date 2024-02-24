# HomeLab Dev

## Table of Contents

- [HomeLab Dev](#homelab-dev)
  - [Table of Contents](#table-of-contents)
  - [About ](#about-)
  - [Getting Started ](#getting-started-)
  - [Folder Structure](#folder-structure)
  - [Hardware](#hardware)
  - [Current Tech Stack](#current-tech-stack)
  - [Tools](#tools)
  - [Stuff deployed behind the scenes](#stuff-deployed-behind-the-scenes)
  - [My Journey Notes](#my-journey-notes)
    - [General Tips](#general-tips)
    - [Cert Manager](#cert-manager)

## About <a name = "about"></a>

This is the development repository for my HomeLab. It contains all the code and configurations for my HomeLab.

## Getting Started <a name = "getting_started"></a>

You can't really get started with this repository, but you can use the code and configurations as a reference for your own HomeLab

## Folder Structure

- `pve01` - Contain the Ansible configurations of my kubernetes cluster by kubespray
- `docker-apps` - Contains all the standalone docker-compose files for the LXC containers
- `argocd-apps` - ArgoCD managed applications
- `k8s-apps` - YAML k8s manifests
- `k8s-infra-apps` - YAML k8s manifests for infrastructural components
- `terraform` - Terraform configurations with Proxmox Provider and Cloud-Init for supervising my VM clusters

## Hardware

- My "Powerful" Proxmox Node
  - Specs
    - 5700X
    - 64 GB RAM
    - 128 GB SSD (OS)
    - 1 TB SSD (Windows, yes I have a Windows OS dual booted)
    - 1 TB SSD (The old SSD for my storage)
    - 3 * 2 TB HDD (Not yet raided or ZFSed, but soon! Currently, they are happy with simple directory)
    - 128 GB USB (Ventoy for emergency booting)
    - GTX 660 (Just for my Windows OS, poor 5700X doesn't have integrated graphics)
    - A Pi4B attached to it for PiKVM! (I love it, the reason why my Proxmox is die hard.)
    - I bought the PCIe → M.2 adapter, that's why I can have so many SSDs!
  - What's (will be) running on it?
    - (production) kubernetes cluster
    - heavy workloads

- My Always On Proxmox Node
  - Specs
    - N5105
    - 32 GB RAM
    - 4 * 2.5Gb LAN
  - What's already running on it?
    - Nginx Proxy Manager (Routing for my domain)
    - wg-easy (Most easy way to setup your WireGuard VPN)
    - AdGuard Home (I utilize the DNS rewrite for internal domain)

- My Raspberry Pi 4Bs (Thx to my friend [ac5tin](https://github.com/ac5tin) 😘)
  - Pi4B 8G * 2
  - Pi4B 4G * 2

- My Switch TP-Link TL-SG2016K
  - 16 Port 1 Gigabit Switch (You never need that much ports, do you? 😂)

## Current Tech Stack

- [Proxmox](https://www.proxmox.com/)
- [Kubespray](https://github.com/kubernetes-sigs/kubespray)
- [CoreDNS](https://github.com/coredns/coredns)
- [ArgoCD](https://github.com/argoproj/argo-cd)
- [MetalLB](https://metallb.universe.tf/)
- [Gitea](https://github.com/go-gitea/gitea)
- [Metrics Server](https://github.com/kubernetes-sigs/metrics-server)

## Tools

- [GitLeaks](https://github.com/zricethezav/gitleaks)
- [Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
- [Helm](https://github.com/helm/helm)
- [k9s](https://github.com/derailed/k9s)

## Stuff deployed behind the scenes

- [AdGuard Home](https://github.com/AdguardTeam/AdGuardHome)
- [PiKVM](https://github.com/pikvm/pikvm)
- [PiVPN](https://github.com/pivpn/pivpn)
- [wg-easy with nginx](https://github.com/wg-easy/wg-easy/wiki/Using-WireGuard-Easy-with-nginx-SSL)
- [Portainer with docker standalone agent](https://www.portainer.io/)
- [Nginx Proxy Manager]( https://nginxproxymanager.com/)

## My Journey Notes

### General Tips

When working with `Helm` or `Kustomize`, always try template or dry-run before your git commit.

```bash
helm template .
kustomize build .

helm install test-release . --dry-run --debug
```

---

For first time installed apps, always deploy on an individual namespace so that you can `kubectl delete namesapce` to clean up everything.

---

### Cert Manager

- When using `helm`, do not install CRD with `installCRDs`,  use the `kubectl` approach instead, e.g. `kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.crds.yaml`, because the `installCRDs` provided by `helm` is not up-to-date.
- Deploy in namespace `kube-system`, do not deploy in `cert-manager`. Check [cert-manager fails to work correctly due to insufficient permissions on v2.18.0 · Issue #8393 · kubernetes-sigs/kubespray](https://github.com/kubernetes-sigs/kubespray/issues/8393)
