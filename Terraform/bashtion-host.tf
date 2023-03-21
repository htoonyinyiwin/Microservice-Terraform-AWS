# ... (Previous configuration remains the same)

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow SSH traffic for the bastion host"
  vpc_id      = aws_vpc.custom.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami           = local.ami
  instance_type = "t2.micro"

  key_name = local.key_name

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  subnet_id = aws_subnet.public.id

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_mgr.name


  tags = {
    Name = "Bastion"
  }
}

# # Update the security group rules for the instances in the private subnet
# resource "aws_security_group" "allow_multiple_ports_in_same_vpc" {
#   name        = "allow_multiple_ports_in_same_vpc"
#   description = "Allow traffic on ports 20, 22, 4222, 8080, 3000, 3001 within the same VPC"
#   vpc_id      = aws_vpc.custom.id

#   # ... (Previous ingress rules remain the same)

#   ingress {
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     security_groups = [aws_security_group.bastion_sg.id]
#   }

#   # ... (Egress rules remain the same)
# }

# # ... (Rest of the script remains the same)
