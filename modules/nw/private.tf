
#variable "vpc_cidr_block" {}
variable "private_subnet_0_cidr_block" {}
variable "private_subnet_1_cidr_block" {}
#variable "private_subnet_cidr_block" {}

# Private Subnet 01作成
resource "aws_subnet" "private_0" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.private_subnet_0_cidr_block
  # Subnet上で起動すると自動でPublicIPを付与する
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone_0
}

# Private Subnet 02作成
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.private_subnet_1_cidr_block
  # Subnet上で起動すると自動でPublicIPを付与する
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone_1
}

# Private Route Table作成
resource "aws_route_table" "private_0" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.example.id
}

# Private Route TableにRoute作成
resource "aws_route" "private_0" {
  route_table_id         = aws_route_table.private_0.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_0.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1" {
  route_table_id         = aws_route_table.private_1.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
  destination_cidr_block = "0.0.0.0/0"
}

# Private Sub01とRoute Tableの関連付け
resource "aws_route_table_association" "private_0" {
  subnet_id      = aws_subnet.private_0.id
  route_table_id = aws_route_table.private_0.id
}

# Private Sub02とRoute Tableの関連付け
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

output "private_subnet_0_id" {
  value       = aws_subnet.private_0.id  
}
output "private_subnet_1_id" {
  value       = aws_subnet.private_1.id  
}
