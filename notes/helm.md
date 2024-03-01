# Helm Command

```bash
# Add Nginx Ingress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install Nginx Ingress
helm install nginx-ingress ingress-nginx/ingress-nginx

helm uninstall nginx-ingress

# List repositories
helm repo list

# List charts
helm search repo

# List all versions of a chart in a repository
helm search repo gitea-charts/gitea --versions
```
