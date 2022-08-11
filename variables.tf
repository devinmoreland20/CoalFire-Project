# -----root/variable

variable "tags" {
  default = "pilot_project"
}
variable "public_access" {
  default = "0.0.0.0/0"
}
variable "vpc_ip" {
  default = "10.1.0.0/16"
}
variable "access_ip" {
  # this var is in terraform.tfvars and is my local machines IP for ssh into bastion
}
