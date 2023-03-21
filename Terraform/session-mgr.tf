resource "aws_iam_role" "ssm_instance_role_mgr" {
  name = "ssm_instance_role_mgr"

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

resource "aws_iam_instance_profile" "ssm_instance_profile_mgr" {
  name = "ssm_instance_profile_mgr"
  role = aws_iam_role.ssm_instance_role_mgr.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ssm_instance_role_mgr.name
}
