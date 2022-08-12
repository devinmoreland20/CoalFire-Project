output "lb_tg_arn" {
  value = aws_lb_target_group.anonymous_lb_tg.arn
}
output "dns_name" {
  value = aws_lb.anonymous_webserver_lb.dns_name
}

output "lb_arn" {
  value = aws_lb.anonymous_webserver_lb.arn
}
