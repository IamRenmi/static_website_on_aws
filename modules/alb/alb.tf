resource "aws_lb_target_group" "wp_tg" {
  name             = "wp-tg"
  protocol         = var.protocol
  port             = var.port
  vpc_id           = var.vpc_id
  protocol_version = "HTTP1"

  health_check {
    enabled             = true
    interval            = var.health_check.interval
    timeout             = var.health_check.timeout
    unhealthy_threshold = var.health_check.unhealthy_threshold
    healthy_threshold   = var.health_check.healthy_threshold
    matcher             = var.health_check.matcher
    port                = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "webservers" {
  for_each         = var.target_ids
  target_group_arn = aws_lb_target_group.wp_tg.arn
  target_id        = each.value
  port             = var.port
}