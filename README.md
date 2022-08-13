# CoalFire-Project

Technical Project for CoalFire. This will include creating infrastructure in AWS using Terraform.
We are creating a new VPC, 4 subnets(2 private and 2 public), EC2 instance in a public subnet running RHEL 8
Webserver in the private subnets on t2.micros with AL2 as the OS, RHEL 8 was not working good and installing fast enough
Our ALB will be behind WAF for protection.

Normally I would put my terraform.tfvars file in the gitignore since there is sensitive information however I am not
For this instance. The only variable in it is the access_ip variable which is the CIDR range for our Bastion

You will need to change your key name variable to use this configuration. State can be stored local or I have the
resource built(the backend resource is # out) for it to be stored in an S3 bucket you will just need to make the s3 bucket in your cloud environment and add in the name.
