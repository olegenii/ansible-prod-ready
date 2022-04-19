# Add DO token
variable "do_token" {}

# Add a task_name tag
variable "tag_task_name" {}

# Add a user_email tag
variable "tag_admin_email" {}

# Add a new SSH key for admin access from file
variable "admin_ssh_key_name" {}
variable "admin_ssh_key_path" {}

variable "admin_ssh_privkey_path" {}
variable "vps_user_name" {}

# Add an AWS access tokens
variable "aws_access_key" {}
variable "aws_secret_key" {}

# Add an AWS Route53 Zone and Record name
variable "aws_route53_zone" {}
variable "aws_route53_record_name" {}

# # Add DO droplet count
# variable "do_vps_count" {}
# variable "vps_name" {}

# Add file and template names
variable "file_out" {}
variable "file_in" {}

# Add server name list
variable "vps_list" {}