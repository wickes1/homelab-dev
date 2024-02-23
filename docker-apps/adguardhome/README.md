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
