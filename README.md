# HomeLab Dev

## Table of Contents

- [HomeLab Dev](#homelab-dev)
  - [Table of Contents](#table-of-contents)
  - [About ](#about-)
  - [Getting Started ](#getting-started-)
  - [Hardware](#hardware)
  - [Current Tech Stack](#current-tech-stack)
  - [Tools](#tools)
  - [Stuff deployed behind the scenes](#stuff-deployed-behind-the-scenes)

## About <a name = "about"></a>

This is the development repository for my HomeLab. It contains all the code and configurations for my HomeLab.

## Getting Started <a name = "getting_started"></a>

You can't really get started with this repository, but you can use the code and configurations as a reference for your own HomeLab.

## Hardware

- My "Powerful" Proxmox Node
  - 5700X
  - 64 GB RAM
  - 128 GB SSD (OS)
  - 1 TB SSD (Windows, yes I have a Windows OS dual booted)
  - 1 TB SSD (The old SSD for my storage)
  - 3 * 2 TB HDD (Not yet raided or ZFSed, but soon! Currently, they are happy with simple directory)
  - 128 GB USB (Ventoy for emergency booting)
  - GTX 660 (Just for my Windows OS, poor 5700X doesn't have integrated graphics)
  - A Pi4B attached to it for PiKVM! (I love it, the reason why my Proxmox is die hard.)

- My Always On Proxmox Node
  - N5105
  - 32 GB RAM
  - 4 * 2.5Gb LAN

- My Raspberry Pi 4Bs (Thx to my friend [ac5tin](https://github.com/ac5tin) 😘)
  - Pi4B 8G * 2
  - Pi4B 4G * 2

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
