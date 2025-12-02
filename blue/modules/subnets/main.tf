#created 4 subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet-1-cidr
  availability_zone = var.subnet-1-az
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }

}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet-2-cidr
  availability_zone = var.subnet-2-az
  map_public_ip_on_launch = true


  tags = {
    Name = "public-subnet-2"
  }

}

resource "aws_subnet" "public_subnet_3" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet-3-cidr
  availability_zone = var.subnet-3-az
  map_public_ip_on_launch = true


  tags = {
    Name = "public-subnet-3"
  }

}