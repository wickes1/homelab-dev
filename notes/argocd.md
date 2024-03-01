# ArgoCD Command

## Installation

```bash
# Install
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Install CLI
yay -S argocd

#Access with Load Balancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Access with Port Forward
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Init password and CLI login
argocd admin initial-password -n argocd
argocd login <ARGOCD_SERVER>

# Update password
argocd account update-password

# Example of Application
kubectl config set-context --current --namespace=argocd
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
argocd app get guestbook
argocd app sync guestbook
argocd app delete guestbook
```

## Full Example

[Application Specification Reference - Argo CD - Declarative GitOps CD for Kubernetes](https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/)

## Helm

[Helm - Argo CD - Declarative GitOps CD for Kubernetes](https://argo-cd.readthedocs.io/en/stable/user-guide/helm/)

```bash
cat > longhorn-application.yaml <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: longhorn
  namespace: argocd
spec:
  project: default
  sources:
    - chart: longhorn
      repoURL: https://charts.longhorn.io/
      targetRevision: v1.6.0 # Replace with the Longhorn version you'd like to install or upgrade to
      helm:
        valuesObject:
          preUpgradeChecker:
            jobEnabled: false
  destination:
    server: https://kubernetes.default.svc
    namespace: longhorn-system
EOF
kubectl apply -f longhorn-application.yaml
```

```bash
# Passing values.yaml

```

## Enable Kustomize with Helm

[Kustomize - Argo CD - Declarative GitOps CD for Kubernetes](https://argo-cd.readthedocs.io/en/stable/user-guide/kustomize/#kustomizing-helm-charts)
