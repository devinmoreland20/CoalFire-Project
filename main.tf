# ----root/main

resource "random_string" "random" {
  length  = 5
  lower   = true
  upper   = false
  numeric = true
  special = false
  lifecycle {
    ignore_changes = all
  }
}
data "aws_key_pair" "Ohio" {
  key_name           = "Ohio"
  include_public_key = true

}


module "s3" {
  source      = "./modules/s3"
  bucket_name = join("-", ["images-logs", random_string.random.result])
  tags        = var.tags
  acl         = "private"
}

module "networking" {
  source           = "./modules/networking"
  vpc_ip           = var.vpc_ip
  instance_tenancy = "default"
  public_access    = var.public_access
  tags             = var.tags
  random_az_count  = 2
  public_sn_count  = 2
  private_sn_count = 2
  public_cidrs     = [for i in range(0, 2, 1) : cidrsubnet(var.vpc_ip, 8, i)]
  private_cidrs    = [for i in range(2, 4, 1) : cidrsubnet(var.vpc_ip, 8, i)]
}

module "compute" {
  source                 = "./modules/compute"
  tags                   = var.tags
  redhat_box_count       = 1
  ami                    = "ami-092b43193629811af"
  instance_type          = "t2.micro"
  public_security_groups = module.security.public_redhat_box_sg
  public_subnet          = module.networking.public_subnet
  assc_pub_ip_address    = true
  key_name               = data.aws_key_pair.Ohio.key_name
  bastion_sg             = module.security.bastion_sg
  bastion_instance_count = 1
}

module "loadbalancer" {
  source                 = "./modules/loadbalancer"
  name                   = "anonymous-webserver-lb"
  load_balancer_type     = "application"
  internal               = false
  security_groups        = module.security.webserver_lb_sg
  default_sg             = module.security.default_sg
  private_subnets        = module.networking.private_subnet
  public_subnet          = module.networking.public_subnet
  tg_port                = 80
  tg_protocol            = "HTTP"
  vpc_id                 = module.networking.vpc_id
  listener_port          = 80
  listener_protocol      = "HTTP"
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 20
  lb_interval            = 60

}

module "autoscaling" {
  source                     = "./modules/autoscaling"
  asg_name                   = join("-", ["webserver-asg", var.tags])
  ami                        = "ami-092b43193629811af"
  instance_type              = "t2.micro"
  key_name                   = data.aws_key_pair.Ohio.key_name
  private_sn                 = module.networking.private_subnet
  launch_config_sg           = module.security.launch_config_sg
  webserver_target_group_arn = module.loadbalancer.lb_tg_arn
  max_size                   = 6
  min_size                   = 2
  desired_capacity           = 2
  force_delete               = true
  health_check_grace_period  = 450
  health_check_type          = "ELB"
  policy_type                = "TargetTrackingScaling"
  predefined_metric_type     = "ASGAverageCPUUtilization"
  adjustment_type            = "ChangeInCapacity"
  target_value               = 50.0
  #user_data                  = "${path.root}/userdata.tpl"

  root_block_device_encrypted   = true
  root_block_device_del_term    = true
  root_block_device_volume_type = "gp2"
  root_block_device_volume_size = 20

}

module "security" {
  source    = "./modules/security"
  vpc_id    = module.networking.vpc_id
  access_ip = var.access_ip
}

module "WAF" {
  source                     = "./modules/WAF"
  name                       = "ALB_WAF_Anonymous"
  description                = "WAF for our ALB to help prevent attacks, this is for you Max"
  scope                      = "REGIONAL"
  rule_name                  = "CommonRules"
  mng_rule_grp_state         = "AWSManagedRulesCommonRuleSet"
  vendor_name                = "AWS"
  lb_arn                     = module.loadbalancer.lb_arn
  cloudwatch_metrics_enabled = true
  vis_config_metric_name     = "friendly-rule-metric-name"
  sampled_requests_enabled   = true

}
module "sns" {
  source          = "./modules/sns"
  asg_group_names = module.autoscaling.asg_name
  notifications   = "autoscaling:EC2_INSTANCE_LAUNCH"
  sns_topic_name  = "ASG-increased-capacity"
  fifo_topic      = false
  sub_protocol    = "email"
  sub_endpoint    = "devinmoreland20@gmail.com"
}
