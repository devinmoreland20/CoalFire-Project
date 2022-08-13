#------ modules/networking/main.tf

resource "aws_vpc" "anonymous" {
  cidr_block       = var.vpc_ip
  instance_tenancy = var.instance_tenancy
  tags = {
    Name = var.tags
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.anonymous.id

  tags = {
    Name = var.tags
  }
}

resource "aws_nat_gateway" "anonymous" {
  allocation_id = aws_eip.anonymous.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = join("-", ["Nat Gateway", var.tags])
  }
  depends_on = [aws_internet_gateway.gw]
}
resource "aws_eip" "anonymous" {
  vpc = true
}

data "aws_availability_zones" "available" {
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.random_az_count #this will only choose two AZ, We could make a list of AZ if we preferred. 
}

resource "aws_subnet" "public_subnet" {
  count             = var.public_sn_count
  vpc_id            = aws_vpc.anonymous.id
  cidr_block        = var.public_cidrs[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]
  tags = {
    Name = join("-", [var.tags, "public", count.index])
  }
}

resource "aws_subnet" "private_subnet" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.anonymous.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]
  tags = {
    Name = join("-", [var.tags, "private", count.index])
  }
}

resource "aws_default_route_table" "private_rt" {
  default_route_table_id = aws_vpc.anonymous.default_route_table_id
  route {
    cidr_block     = var.public_access
    nat_gateway_id = aws_nat_gateway.anonymous.id
  }
  tags = {
    Name = var.tags
  }
}

resource "aws_route_table_association" "private_rt_association" {
  count          = var.private_sn_count
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_default_route_table.private_rt.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.anonymous.id
  route {
    cidr_block = var.public_access
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = var.tags
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
