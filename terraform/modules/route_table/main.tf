#created  RT
resource "aws_route_table" "mittu-RT" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "mittu-RT"
  }

}

#Route table association
resource "aws_route_table_association" "rta-1" {
  subnet_id      = var.public_subnet_1
  route_table_id = aws_route_table.mittu-RT.id
}


resource "aws_route_table_association" "rta-2" {
  subnet_id      = var.public_subnet_2
  route_table_id = aws_route_table.mittu-RT.id
}

resource "aws_route_table_association" "rta-3" {
  subnet_id      = var.public_subnet_3
  route_table_id = aws_route_table.mittu-RT.id
}