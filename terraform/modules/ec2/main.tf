#creating sg for instances
resource "aws_security_group" "mittu-ec2-sg" {
  name        = "mittu-sg"
  description = "Allow all access to bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mittu-sg"
  }

}

#creating instances
resource "aws_instance" "mittu-1" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_1_id
  vpc_security_group_ids      = [aws_security_group.mittu-ec2-sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = var.ec2_instance_profile   #role attach hogya ec2 me
  user_data_base64            = filebase64("userdata.sh")

  tags = {
    Name = "mittu-1"
  }
}

resource "aws_instance" "mittu-2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_2_id
  vpc_security_group_ids      = [aws_security_group.mittu-ec2-sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = var.ec2_instance_profile
  user_data_base64            = filebase64("userdata1.sh")

  tags = {
    Name = "mittu-2"
  }
}