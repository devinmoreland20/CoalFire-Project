
# ---- modules/autoscaling/main

resource "aws_autoscaling_group" "webserver_asg" {
  name                      = var.asg_name
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = var.force_delete
  launch_configuration      = aws_launch_configuration.anonymous_web_server.name
  vpc_zone_identifier       = var.private_sn
  target_group_arns         = [var.webserver_target_group_arn]
}

resource "aws_autoscaling_policy" "anonymous" {
  name                   = "ASG Policy for Web Server ASG"
  policy_type            = var.policy_type
  adjustment_type        = var.adjustment_type
  autoscaling_group_name = aws_autoscaling_group.webserver_asg.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type
    }

    target_value = var.target_value
  }
}




resource "aws_launch_configuration" "anonymous_web_server" {
  #cant use here when using a ASG it wont let you update the config without destroy first. https://github.com/hashicorp/terraform/issues/3665
  image_id        = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [var.launch_config_sg]
  #user_data       = var.user_data
  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    encrypted             = var.root_block_device_encrypted
    delete_on_termination = var.root_block_device_del_term
    volume_type           = var.root_block_device_volume_type
    volume_size           = var.root_block_device_volume_size
  }


}
# user_data = <<-EOF
#   #!/bin/bash
#   yum update -y
#   yum install httpd -y
#   systemctl enable httpd
#   systemctl start httpd
#   echo "<h1>TEST WEB PAGE</h1>" > /var/www/html/index.html
#   EOF
