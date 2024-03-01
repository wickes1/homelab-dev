# Linux Command

## Show Directory Size

```bash
du -sh /path/to/directory
du -h --max-depth=2
```

## Show Port Usage

```bash
netstat -tulnp
lsof -i :3000
```

## Kill Process by Port

```bash
kill -9 $(lsof -t -i:3000)
fuser -k 3000/tcp
```

## List All Environment Variables

```bash
printenv
env
```

## Copy SSH Key to Target Server

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub user@host
ssh user@host 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
```

## Install Docker on Debian

```bash
# Remove old versions
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group
sudo addgroup --system docker
sudo adduser $USER docker
newgrp docker
```

## Docker Compose

```bash
# Remove running containers and volumes and images
docker compose down --rmi all --volumes
```

## Check LInux Version and Distro

```bash
# Check Linux Distro
cat /etc/os-release

# Check Linux Version
uname -a
```

## Check MotherBoard and CPU Info

```bash
# Check MotherBoard Info
sudo dmidecode -t 2

# Check CPU Info
lscpu
```

## Delete Linux User

```bash
# List Users
cat /etc/passwd

# Delete User
sudo userdel -r username
```

## Install Wireguard on Pi

```bash
curl -L https://install.pivpn.io | bash
```

## Find All Hostnames and IPs in LAN

```bash
# sn = no port scan
nmap -sn 192.168.1.0/24
```

## Changing DNS with systemd-resolved

```bash
# This file is managed by man:systemd-resolved(8). Do not edit....

# Edit DNS in /etc/systemd/resolved.conf
sudo nvim /etc/systemd/resolved.conf

# [Resolve]
# DNS=192.168.88.22
# FallbackDNS=8.8.8.8
# Domains=yourdomain.local

suido service systemd-resolved restart

# <= Ubuntu 22
# systemd-resolve --status
resolvectl status
```

## Install Docker in Ubuntu

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```
