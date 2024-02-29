# Vault

## How to install HA Vault?

```bash
cd terraform
terraform init
terraform apply
```

## How to unseal?

```bash
# Initialize Vault
kubectl -n vault exec -it vault-0 -- vault operator init

# Join the other nodes to the leader
kubectl exec vault-1 -n vault -- vault operator raft join http://vault-0.vault-internal:8200
kubectl exec vault-2 -n vault -- vault operator raft join http://vault-0.vault-internal:8200

# Unseal all vault nodes
kubectl -n vault exec -it vault-0 -- vault operator unseal

 ROOT_TOKEN=""

# Login leader  vault
kubectl -n vault exec vault-0 -- vault login $ROOT_TOKEN

# Get status
kubectl -n vault exec vault-0 -- vault operator raft list-peers
```

## How to enable kubernetes auth method?

```bash
# SSH into the leader pod and enable the kubernetes auth method

kubectl exec --stdin=true --tty=true vault-0 -n vault -- /bin/sh
vault enable kubernetes auth method
vault auth enable kubernetes
vault write auth/kubernetes/config \
    kubernetes_host=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT


# Or use local Vault CLI tools
vault login $ROOT_TOKEN
kubernetes_host=$(kubectl get svc kubernetes --namespace default -o json | jq -r '[.spec.clusterIP, (.spec.ports[] | select(.name=="https") | .port)] | map(tostring) | join(":")')
vault write auth/kubernetes/config \
    kubernetes_host=https://$kubernetes_host
```
