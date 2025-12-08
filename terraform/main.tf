provider "aws" {
  region = var.region
}

#created vpc
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 4.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = var.private_subnets

  enable_nat_gateway = false
  single_nat_gateway = true
}


#created subnets
module "subnets" {
  source        = "./modules/subnets"
  subnet-1-cidr = var.subnet_1_cidr
  subnet-2-cidr = var.subnet_2_cidr
  subnet-3-cidr = var.subnet_3_cidr
  subnet-1-az   = var.subnet_1_az
  subnet-2-az   = var.subnet_2_az
  subnet-3-az   = var.subnet_3_az
  vpc_id        = module.vpc.vpc_id


}

#created IGW
module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
}

#created RT & associations
module "route-table" {
  source          = "./modules/route_table"
  vpc_id          = module.vpc.vpc_id
  igw_id          = module.igw.igw_id
  public_subnet_1 = module.subnets.public_subnet_1
  public_subnet_2 = module.subnets.public_subnet_2
  public_subnet_3 = module.subnets.public_subnet_3
}


#This is for remote backend setup & terraform state lock
resource "aws_dynamodb_table" "terraform_lock" {
  name         = var.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


# EKS Cluster Role (trust: eks.amazonaws.com)
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "eks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the AWS managed policy AmazonEKSClusterPolicy
resource "aws_iam_role_policy_attachment" "eks_cluster_attach" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# Node Group Role (EC2 trusted entity)
resource "aws_iam_role" "node_group_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Attach required managed policies for worker nodes
resource "aws_iam_role_policy_attachment" "node_attach_worker" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "node_attach_cni" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_iam_role_policy_attachment" "node_attach_ecr" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


# EKS cluster
resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.32" # pick a K8s version; update as desired

  vpc_config {
    subnet_ids              = concat(module.vpc.public_subnets, module.vpc.private_subnets)
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  # simple example: no logging config here — add as required
}

# EKS Managed Node Group
resource "aws_eks_node_group" "workers" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = [module.subnets.public_subnet_1, module.subnets.public_subnet_2, module.subnets.public_subnet_3]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 0
  }

  instance_types = ["t3.micro"]
  ami_type       = "AL2023_x86_64_STANDARD"

  # Optional tags, labels, remote access, etc.
  labels = { role = "worker" }
}


#creating ECR resource 
resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.ecr_name
  image_tag_mutability = "IMMUTABLE" # prevents tag mutation (recommended)
  image_scanning_configuration {
    scan_on_push = false # enable scan on push
  }

  encryption_configuration {
    encryption_type = "AES256" # or "KMS" and supply kms_key
  }

  tags = var.ecr_tags

  lifecycle {
    prevent_destroy = false # consider true for production (careful)
  }
}

# Data for account id 
data "aws_caller_identity" "current" {}

#this will give me oidc provider details that i've created manually
data "aws_iam_openid_connect_provider" "github" {
  arn = "arn:aws:iam::840026269170:oidc-provider/token.actions.githubusercontent.com"
}

#grants permissions for Terraform to create infra (EC2/EKS/ECR/S3/IAM/etc).
resource "aws_iam_role" "github_actions_terraform_role" {
  name = "github-actions-terraform-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRoleWithWebIdentity",
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github.arn
        },
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/*"
          }
        }
      }
    ]
  })
}

#Attach Terraform Permissions (broad for learning; restrict later)
resource "aws_iam_policy" "terraform_policy" {
  name        = "terraform-ci-policy"
  description = "Permissions for Terraform CI role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [

      # Allow Terraform to manage ECR, EKS, EC2, S3 (state), DynamoDB (locks)
      {
        Effect = "Allow",
        Action = [
          "ecr:*",
          "eks:*",
          "ec2:*",
          "iam:*",
          "s3:*",
          "dynamodb:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_attach" {
  role       = aws_iam_role.github_actions_terraform_role.name
  policy_arn = aws_iam_policy.terraform_policy.arn
}

#grants Docker build & push → ECR, Kubernetes deploy → EKS
resource "aws_iam_role" "github_actions_deploy_role" {
  name = "github-actions-deploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRoleWithWebIdentity",
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github.arn
        },
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/*"
          }
        }
      }
    ]
  })
}

#Attach Minimal Deploy Permissions (for ECR push + EKS)
resource "aws_iam_policy" "deploy_policy" {
  name        = "github-actions-deploy-policy"
  description = "Minimal permissions for deploying to EKS and pushing to ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [

      # Required to authenticate docker to ECR
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      },

      # Push/pull images to ECR
      {
        Effect = "Allow",
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:ListImages",
          "ecr:BatchGetImage"
        ],
        Resource = "*"
      },

      # Required to run "aws eks update-kubeconfig"
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "deploy_attach" {
  role       = aws_iam_role.github_actions_deploy_role.name
  policy_arn = aws_iam_policy.deploy_policy.arn
}