#created IGW
resource "aws_internet_gateway" "mittu-igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "mittu-igw"
  }

}