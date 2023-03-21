terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
    region = "ap-southeast-1"   
}

#---------------------------------------------------For Terraform Cloud-------------------------------------- 

terraform {
  cloud {
    organization = "Htoo-Nyi-Nyi-Win1"

    workspaces {
      name = "Github"
    }
  }
}
#----------------------------Please, create Key Pair in advance and update in key_name variable-------------------------- 
locals {
  key_name = "t4ginstance"
  instance_names = ["API", "NATS", "Service1", "Service2"]
  ami = "ami-0e2e292a9c4fb2f29"
}



#--------------------------------------------------------------------------------------------------------------------------



#----------------------------------------Terraform give name to 4 instances but not working for Auto Scaling--------------------------------------------------------------------------

# resource "aws_instance" "moleculer" {
#   count = 4

#   ami           = local.ami # Amazon Linux 2 LTS AMI for ap-southeast-1 region
#   instance_type = "t2.micro"

#   key_name = local.key_name

#   # vpc_security_group_ids = [aws_security_group.allow_all.id]

#   vpc_security_group_ids = [aws_security_group.allow_multiple_ports_in_same_vpc.id]

#   associate_public_ip_address = true

#   subnet_id = data.aws_subnet.default.id

#   iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile_mgr.name

#   tags = {
#     Name = local.instance_names[count.index]
#   }
# }

#-------------------------------------------------------show ip address in console log---------------------
# output "instance_public_ips" {
#   value = aws_instance.moleculer.*.public_ip
# }

# resource "aws_security_group" "allow_all_instance" {
#   name        = "allow_all_instance"
#   description = "Allow all traffic"

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }