#----- modules/loadbalancer/variables.tf

variable "name" {}
variable "load_balancer_type" {}
variable "security_groups" {}
variable "internal" {}
variable "tg_port" {}
variable "tg_protocol" {}
variable "vpc_id" {}
variable "listener_protocol" {}
variable "private_subnets" {}
variable "lb_healthy_threshold" {}
variable "lb_unhealthy_threshold" {}
variable "lb_timeout" {}
variable "listener_port" {}
variable "lb_interval" {}
variable "default_sg" {}
variable "public_subnet" {}
