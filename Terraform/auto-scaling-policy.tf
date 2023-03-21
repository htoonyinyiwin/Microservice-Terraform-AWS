# Step 1: Create a Launch Template for your EC2 instances
resource "aws_launch_template" "moleculer_lt" {
  name_prefix = "moleculer_lt"

  image_id      = local.ami
  instance_type = "t2.micro"
  key_name      = local.key_name

  vpc_security_group_ids = [aws_security_group.allow_multiple_ports_in_same_vpc.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile_mgr.name
  }

  # Tags for instances launched from this Launch Template
  tag_specifications {
    resource_type = "instance"
    tags = {
      Terraform = "true"
      Name      = "moleculer-instance"
      # Name = join("-", [local.instance_names[0], count.index])
    }
  }



  # Tags for instances launched from this Launch Template
  tag_specifications {
    resource_type = "instance"
    tags = {
      Terraform = "true"
    }
  }
}

# Step 2: Create an Auto Scaling Group that uses the Launch Template
resource "aws_autoscaling_group" "moleculer_asg" {
  name = "moleculer_asg"

  desired_capacity   = 4
  min_size           = 4
  max_size           = 8
  health_check_type  = "EC2"
  vpc_zone_identifier = [aws_subnet.private.id]

  launch_template {
    id      = aws_launch_template.moleculer_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "moleculer-instance"
    propagate_at_launch = true
  }
}

# Step 4: Create an Auto Scaling Policy to scale up when high CPU utilization is detected
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  autoscaling_group_name = aws_autoscaling_group.moleculer_asg.name
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}