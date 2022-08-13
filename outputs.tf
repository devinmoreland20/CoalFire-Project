#----root/outputs.tf
output "bucket_name" {
  value = module.s3.bucket_name
}

output "alb_dns_name" {
  value = module.loadbalancer.dns_name
}
output "redhat_box_public_ip" {
  value = module.compute.redhat_box_public_ip
}

output "bastion_public_ip" {
  value = module.compute.bastion_public_ip
}


