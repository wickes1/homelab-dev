# Secrets Management

Watch this first: [100,000 Different Ways to Manage Secrets in GitOps - Andrew Block, Red Hat](https://www.youtube.com/watch?v=FVaaqP7_AJg)

Now you shall understand there are 2 primary approaches to manage secrets in Kubernetes, **Encrypted Content** and **External Reference**.

For homelab user,

Popular choice of **Encrypted Content** are: SOPS and Sealed Secrets.

Popular choice of **External Reference** are: Vault

## How to choose?

If you are comfortable putting "public key" of your secret in git, then go with SOPS or Sealed Secrets. It encrypted the secret hence you can safely put it in git.

With using SOPS, you may have encrypted backend as AGE (you kept your own private key) or cloud KMS (Google Cloud KMS, AWS KMS, Azure Key Vault).

The downside of this approach is all of your secrets are in git and stick with same private key. The key rotation and multi-tenant are challenging. Key leakage will lead to all secrets compromised.

Stuff you may need:

- SOPS - encrypted content
- AGE - encryption backend
- vscode-sops - vscode extension to edit encrypted file
- KSOPS - kustomize plugin to deploy encrypted file

With using Vault, you can have a more enterprise-grade solution. Providing you with a centralized secret management system. You can have a different secret for different environment and different tenant. You can have a more granular access control. (But actually you just deploy them in the same cluster.)

The downside is also the "enterprise-grade" itself. It's more complex to setup and maintain. You are introducing extra dependency to your system. And a new topic was introduced - how to sync the secret from Vault to your Kubernetes cluster.

Stuff you may need:

- Vault agent injector - sidecar container to inject secret into pod
- Vault secrets operator - operator to sync secret from Vault to Kubernetes secret
- Vault CSI driver - to mount secret as volume
- Reloader - to reload the pod when secret changes

## What is my choice?

I am not confident to put my encrypted secret in git (although I know it's secure enough), also I may need to manage different secrets for different environment and different tenant. So I choose Vault for my centralized secret management system.

The extra complexity was more than I expected. My final choice is to use Vault with External Secrets Operator. Here's why:

The scenario is to sync the secret from Vault to the pod environment variables.

- Vault agent injector: manually annotated each key in the pod spec, however, it's not working as expected, check [here](https://github.com/hashicorp/vault-k8s/issues/186):

```yaml
    # Use with vault agent injector
    # Not working, see https://github.com/hashicorp/vault-k8s/issues/186
     - op: add
            path: /spec/template/metadata/annotations
            value:
              vault.hashicorp.com/agent-inject: 'true'
              vault.hashicorp.com/role: 'homepage'
              vault.hashicorp.com/agent-inject-secret-homepage-secret: 'internal/data/homepage'
              # Environment variable export template
              vault.hashicorp.com/agent-inject-template-config: |
                {{- with secret "internal/data/homepage" -}}
                  export HOMEPAGE_VAR_PROXMOX_PASSWORD="{{ .Data.data.HOMEPAGE_VAR_PROXMOX_PASSWORD }}"
                  export HOMEPAGE_VAR_PROXMOX_USERNAME="{{ .Data.data.HOMEPAGE_VAR_PROXMOX_USERNAME }}"
                {{- end }}
```

- Vault CSI driver / External Secret Operator: sync the secret to Kubernetes secret, then mount the secret as volume or inject the secret as environment variables. However, it's still had to specify the key/value field one by one.

```yaml
          - op: add
            path: /spec/template/spec/volumes
            value:
              - name: secrets-store-inline
                csi:
                  driver: secrets-store.csi.k8s.io
                  readOnly: true
                  volumeAttributes:
                    secretProviderClass: "internal-vault-provider"
          - op: add
            path:  /spec/template/spec/containers/0/volumeMounts
            value:
              - name: secrets-store-inline
                mountPath: /app/config/secrets
                readOnly: true
```

```yaml
spec:
    provider: vault # accepted provider options: akeyless or azure or vault or gcp
    parameters: # provider-specific parameters
        roleName: homepage
        vaultAddress: http://vault.vault.svc.cluster.local:8200
        objects: |
            - secretPath: "internal/data/homepage"
              objectName: "HOMEPAGE_VAR_PROXMOX_PASSWORD"
              secretKey: "HOMEPAGE_VAR_PROXMOX_PASSWORD"
            - secretPath: "internal/data/homepage"
              objectName: "HOMEPAGE_VAR_PROXMOX_USERNAME"
              secretKey: "HOMEPAGE_VAR_PROXMOX_USERNAME"
```

- Vault Secrets Operator/Vault Secrets Operator: sync the secret to Kubernetes secret, then inject the secret as environment variables. It's more flexible and easy to manage. So you only need the following annotation:

```yaml
          - op: add
            path: /spec/template/spec/containers/0/envFrom
            value:
              - secretRef:
                    name: homepage-secret
```

```yaml
spec:
    type: kv-v2

    # mount path
    mount: internal

    # path of the secret
    path: homepage

    # dest k8s secret
    destination:
        name: homepage-secret
        create: true
        overwrite: true

    # static secret refresh interval
    refreshAfter: 0s

    # Name of the CRD to authenticate to Vault
    vaultAuthRef: static-auth
```

In either way, you would want to use Reloader to reload the pod when secret changes:

```yaml
          - op: add
            path: /metadata/annotations
            value:
              configmap.reloader.stakater.com/reload: "homepage"
              secret.reloader.stakater.com/reload: "homepage-secret"
```

Among all, I found Vault combined with External Secrets Operator is the most flexible and easy to manage. Vault Secrets Operator is only built for Vault, while External Secrets Operator is built for multiple secret management systems, also support more advanced features when it comes to extracting the key/value from the secret.
