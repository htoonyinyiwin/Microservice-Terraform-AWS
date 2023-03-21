# locals {
#   key_name = "t4ginstance"
#   instance_names = ["API", "NATS", "Service1", "Service2"]
#   ami = "ami-0e2e292a9c4fb2f29"
# }

resource "aws_vpc" "custom" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "custom_vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.custom.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.custom.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom.id

  tags = {
    Name = "custom_igw"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "custom_nat_gw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.custom.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.custom.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# resource "aws_instance" "moleculer" {
#   count = 4

#   ami           = local.ami
#   instance_type = "t2.micro"

#   key_name = local.key_name

#   vpc_security_group_ids = [aws_security_group.allow_multiple_ports_in_same_vpc.id]

#   subnet_id = aws_subnet.private.id

#   iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_mgr.name

#   tags = {
#     Name = local.instance_names[count.index]
#   }
# }


