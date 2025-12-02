variable "region" {
}

variable "vpc_cidr" {
}

variable "subnet_1_cidr" {
    default = "10.0.0.0/24"
}

variable "subnet_2_cidr" {
    default = "10.0.1.0/24"
}

variable "subnet_3_cidr" {
    default = "10.0.2.0/24"
}

variable "subnet_1_az" {
    default = "ap-south-1a"
}

variable "subnet_2_az" {
    default = "ap-south-1b"

}

variable "subnet_3_az" {
    default = "ap-south-1c"

}

variable "s3_bucket" {
}

variable "ami" {
}

variable "instance_type" {
}

variable "key_name" {
}

variable "dynamodb_table" {
  
}

variable "cluster_name" {
  
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "node_group_name" {
  type    = string
  default = "rock-node-group"
}

variable "ecr_name" {
  type        = string
  description = "ECR repository name"
}

variable "ecr_tags" {
  type    = map(string)
  default = {}
}

variable "github_owner" {
  type = string
  default = "Hydra2206"
}

variable "github_repo" {
  type = string
  default = "beach-terraform-to-k8s"
}