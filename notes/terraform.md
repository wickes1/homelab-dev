# Terraform Command

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
# terraform apply -var "container_name=YetAnotherName"
# terraform apply -auto-approve
terraform show
terraform state list
terraform output
terraform destroy
terraform state rm  $(terraform state list) # Remove all resources from state
```

## References

[Docker | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/tutorials/docker-get-started)
[How To Deploy Helm Charts With Terraform](https://getbetterdevops.io/terraform-with-helm/)
