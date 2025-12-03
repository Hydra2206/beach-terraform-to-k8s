# beach-terraform-to-k8s
Creating a project for resume &amp; learning how to create CI/CD pipeline for Terraform code, k8s, docker &amp; learning

1/12/2025 - EKS cluster + Node group create karna sikha hu Terraform code ke through
2/12/2025 - Created ECR repo, OIDC provider manually from console, 2 IAM Roles (terraform role, deploy role)
            Created 2 workflow file for CI pipeline in Github Actions
            debugged Configure AWS Credential via OIDC (Added oidc role arn in github secrets)

(TASK FOR TOMMOROW -> 3/12/2025)
Kal ke liye task Terraform PR Plan, Terraform Plan me aake stuck hoja raha hai woh var.ami ki value expect kar raha hai, locally toh variables ki value terraform.tfvars se mil jata hai but ab yeh find out karna hai ki pipeline me variables ki values kaise pass karte hai
