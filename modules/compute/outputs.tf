
output "redhat_box_public_ip" {
  value = aws_instance.public_redhat.*.public_ip
}

output "redhat_box_private_ip" {
  value = aws_instance.public_redhat.*.private_ip
}
output "bastion_public_ip" {
  value = aws_instance.public_redhat.*.public_ip
}
