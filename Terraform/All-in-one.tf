terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
    region = "ap-southeast-1"
    access_key = "AKIA4AIR7WOLYNGULC4B"
    secret_key = "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"
}

terraform {
  cloud {
    organization = "Htoo-Nyi-Nyi-Win1"

    workspaces {
      name = "Github"
    }
  }
}

locals {
  key_name = "t4ginstance"
  instance_names = ["API", "NATS", "Service1", "Service2"]
}


data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  filter {
    name   = "availability-zone"
    values = ["ap-southeast-1b"]
  } 
}



resource "aws_instance" "moleculer" {
  count = 4

  ami           = "ami-0d729dbb37b0f7a87" # Amazon Linux 2 LTS AMI for ap-southeast-1 region
  instance_type = "t2.micro"

  key_name = local.key_name

  # vpc_security_group_ids = [aws_security_group.allow_all.id]

  vpc_security_group_ids = [aws_security_group.allow_multiple_ports_same_vpc.id]

  associate_public_ip_address = true

  subnet_id = data.aws_subnet.default.id

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  tags = {
    Name = local.instance_names[count.index]
  }
}

output "instance_public_ips" {
  value = aws_instance.moleculer.*.public_ip
}

# resource "aws_security_group" "allow_all" {
#   name        = "allow_all"
#   description = "Allow all traffic"

#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

resource "aws_security_group" "allow_multiple_ports_same_vpc" {
  name        = "allow_multiple_ports_same_vpc"
  description = "Allow traffic on ports 22, 4222, 8080, 3000, 3001 within the same VPC"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  ingress {
    from_port   = 4222
    to_port     = 4222
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ssm_instance_role" {
  name = "ssm_instance_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_instance_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ssm_instance_role.name
}
