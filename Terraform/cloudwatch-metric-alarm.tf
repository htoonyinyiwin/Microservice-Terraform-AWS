# Create a CloudWatch Metric Alarm for high CPU utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name          = "high_cpu_utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = "70"
  alarm_description   = "This metric triggers when CPU utilization is greater than or equal to 70% for a period of 60 seconds."
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.moleculer_asg.name
  }
  depends_on = [aws_autoscaling_policy.scale_up]
}