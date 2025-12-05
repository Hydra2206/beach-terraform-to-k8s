
output "alb-dns" {
  value = module.alb.alb_dns
}

output "public_ip_1" {
  value = module.ec2.public_ip_1
}

output "public_ip_2" {
  value = module.ec2.public_ip_2
}


output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}
output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}
output "cluster_certificate_authority" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}
output "node_role_arn" {
  value = aws_iam_role.node_group_role.arn
}

output "cluster_region" {
  description = "Region of the EKS cluster"
  value       = var.region
}