resource "aws_autoscaling_group" "wp_asg" {
  name                      = "wp-asg"
  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size

  tag {
    key                 = "Name"
    value               = "wp-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_notification" "wp_notifications" {
  group_names           = [aws_autoscaling_group.wp_asg.name]
  topic_arn             = var.notification_topic_arn
  notifications         = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
}