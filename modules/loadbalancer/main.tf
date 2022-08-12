

resource "aws_lb" "anonymous_webserver_lb" {
  name                       = var.name
  load_balancer_type         = var.load_balancer_type
  internal                   = false
  security_groups            = [var.security_groups, var.default_sg]
  subnets                    = var.public_subnet
  enable_deletion_protection = false # if true it can cuase problems or it wont destroy


  tags = {
    Environment = "project"
  }
}

resource "aws_lb_listener" "anonymous_lb_listener" {
  load_balancer_arn = aws_lb.anonymous_webserver_lb.arn
  port              = var.listener_port
  protocol          = var.tg_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.anonymous_lb_tg.arn
  }
}


resource "aws_lb_target_group" "anonymous_lb_tg" {
  name     = "project-lb-tg"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = var.lb_healthy_threshold
    unhealthy_threshold = var.lb_unhealthy_threshold
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }
}
