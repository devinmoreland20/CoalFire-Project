# ----modules/computer/main.tf

resource "aws_instance" "public_redhat" {
  count                       = var.redhat_box_count
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.public_security_groups]
  subnet_id                   = var.public_subnet[1]
  associate_public_ip_address = var.assc_pub_ip_address
  root_block_device {
    encrypted             = true
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = 20
  }
  key_name = var.key_name

  tags = {
    Name = join("-", [var.tags, "redhat-box"])
  }
}

resource "aws_instance" "bastion" {
  count                       = var.bastion_instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.bastion_sg]
  subnet_id                   = var.public_subnet[0]
  associate_public_ip_address = var.assc_pub_ip_address
  key_name                    = var.key_name
  tags = {
    Name = join("-", [var.tags, "bastion"])
  }
}

