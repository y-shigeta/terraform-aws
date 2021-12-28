
variable "public_subnet_0_cidr_block" {}
variable "public_subnet_1_cidr_block" {}
#variable "availability_zone_1" {}
#variable "availability_zone_2" {}
#variable "private_subnet_cidr_block" {}

# Public Subnet作成
resource "aws_subnet" "public_0" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.public_subnet_0_cidr_block
  # Subnet上で起動すると自動でPublicIPを付与する
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_0
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.public_subnet_1_cidr_block
  # Subnet上で起動すると自動でPublicIPを付与する
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_1
}

# Public Route Table作成
resource "aws_route_table" "public_0" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "public_1" {
  vpc_id = aws_vpc.example.id
}

# Public Route TableにRoute作成
resource "aws_route" "public_0" {
  route_table_id         = aws_route_table.public_0.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "public_1" {
  route_table_id         = aws_route_table.public_1.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

# Public SubとRoute Tableの関連付け
resource "aws_route_table_association" "public_0" {
  subnet_id      = aws_subnet.public_0.id
  route_table_id = aws_route_table.public_0.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_1.id
}

# Internet GW作成
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

# EIP作成
resource "aws_eip" "nat_gateway_0" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_eip" "nat_gateway_1" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

# NAT GW作成
resource "aws_nat_gateway" "nat_gateway_0" {
  allocation_id = aws_eip.nat_gateway_0.id
  subnet_id     = aws_subnet.public_0.id
  depends_on    = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.example]
}

output "public_subnet_0_id" {
  value       =  aws_subnet.public_0.id
}
output "public_subnet_1_id" {
  value       =  aws_subnet.public_1.id
}
