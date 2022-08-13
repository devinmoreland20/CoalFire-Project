#----modules/autoscaling/outputs.tf

output "asg_name" {
  value = aws_autoscaling_group.webserver_asg.name
}

