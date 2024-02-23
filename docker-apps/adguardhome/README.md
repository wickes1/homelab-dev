# AdGuard Home

[Port 53 already in use · Issue #4283 · AdguardTeam/AdGuardHome](https://github.com/AdguardTeam/AdGuardHome/issues/4283)

```bash
sudo mkdir /etc/systemd/resolved.conf.d
cd /etc/systemd/resolved.conf.d
sudo vim adguardhome.conf
sudo mv /etc/resolv.conf /etc/resolv.conf.backup
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
systemctl reload-or-restart systemd-resolved
```

```title=adguardhome.conf
[Resolve]
DNS=127.0.0.1
DNSStubListener=no
```

## Filtering Rule

[DNS filtering rules syntax | AdGuard DNS Knowledge Base](https://adguard-dns.io/kb/general/dns-filtering-syntax/)

```plaintext
||k8s.local^$dnsrewrite=1.2.3.4
```

This entails mapping all subdomains of `k8s.local` to the IP address `1.2.3.4`, which serves as the load balancing IP for the nginx ingress controller. As a result, you establish internal DNS resolution for `k8s.local`.
