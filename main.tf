module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

resource "aws_subnet" "public" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = module.vpc.vpc_id
  tags = {

    Name = "devops-platform-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

module "security_group" {
  source = "./modules/security-group"
  vpc_id = module.vpc.vpc_id
}
