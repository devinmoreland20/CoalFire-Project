
output "webserver_lb_sg" {
  value = aws_security_group.webserver_lb_sg.id
}

output "bastion_sg" {
  value = aws_security_group.bastion_sg.id
}

output "public_redhat_box_sg" {
  value = aws_security_group.public_redhat_box_sg.id

}

output "launch_config_sg" {
  value = aws_security_group.launch_config_sg.id
}
output "default_sg" {
  value = aws_default_security_group.default_sg.id
}
