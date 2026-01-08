# Terraform_Create-EKS-Module-Blue-Green-Deploy

```
Blue-Green EKS is implemented by creating two identical clusters with separate Terraform states and switching traffic between them for zero-downtime deployments.
```

## ▶️ How to Deploy (Blue / Green)

## Blue
cd envs/production/blue
terraform init -backend-config=backend.hcl
terraform apply

## Green
cd envs/production/green
terraform init -backend-config=backend.hcl
terraform apply

## 🧠 Key Concept (VERY IMPORTANT)

## File	Purpose

backend.hcl	            - Where state is stored
main.tf	                - What infrastructure is created
Module	                - Reusable logic
No tfvars	              - Values fixed per env

