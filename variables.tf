# Add an AWS access tokens
variable "aws_access_key" {}
variable "aws_secret_key" {}

# Add an AWS Route53 Zone and Record name
variable "aws_route53_zone" {}
variable "aws_route53_record_name" {}

# Add file and template names
variable "file_out" {}
variable "file_in" {}

# Add server name list
variable "vps_list" {}

# Add GCP project ID
variable "gcp_project_id" {}

# Add GCP ssh pubkey info
variable "gcp_ssh_user" {}
variable "gcp_ssh_pub_key_file" {}