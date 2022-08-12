
packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "redhat" {
  ami_name      = "redhat-bash"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami_filter {
    filters = {
      name                = "RHEL-8.6.0_HVM-20220503-x86_64-2-Hourly2-GP2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["309956199498"]
  }
  ssh_username = "ec2-user"
}

build {
  name = "redhat-bash"
  sources = [
    "source.amazon-ebs.redhat"
  ]
provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "systemctl enable httpd",
      "systemctl start httpd",
      "echo 'TEST WEB PAGE' > /var/www/html/index.html",
    ]
  }
}


