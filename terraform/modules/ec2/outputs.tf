output "instance_1_id" {
  value = aws_instance.mittu-1.id
}

output "instance_2_id" {
  value = aws_instance.mittu-2.id
}

output "public_ip_1" {
  value = aws_instance.mittu-1.public_ip
}

output "public_ip_2" {
  value = aws_instance.mittu-2.public_ip
}