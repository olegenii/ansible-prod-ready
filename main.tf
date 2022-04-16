terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.19.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure DO Provider
provider "digitalocean" {
  # Configuration options
  token = var.do_token
}

# Configure AWS Provider
provider "aws" {
  region = "eu-central-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Get specified DNS zone
data "aws_route53_zone" "selected" {
  name = var.aws_route53_zone
}

# Create DNS record
resource "aws_route53_record" "www" {
  count = var.do_vps_count
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = digitalocean_droplet.vps[count.index].name
  type    = "A"
  ttl     = "300"
  records = [digitalocean_droplet.vps[count.index].ipv4_address]
}

# Create DNS records for vhost and www.vhost
resource "aws_route53_record" "vhost" {
  for_each = toset( [var.aws_route53_record_name, "www.${var.aws_route53_record_name}"] )
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.key
  type    = "A"
  ttl     = "300"
  records = [digitalocean_droplet.vps[0].ipv4_address]
}

# Create task_name tag
resource "digitalocean_tag" "task_name" {
  name = var.tag_task_name
}

# Create user_email tag
resource "digitalocean_tag" "user_email" {
  name = var.tag_admin_email
}

# Create new SSH key for admin access from file
resource "digitalocean_ssh_key" "ubuntu_ssh_admin" {
  name = var.admin_ssh_key_name
  public_key = file(var.admin_ssh_key_path)
}

# Get SSH key for rebrain access
data "digitalocean_ssh_key" "ubuntu_ssh_rebrain" {
  name = "REBRAIN.SSH.PUB.KEY"
}

# Create new vps Droplet in the fra1 region with tags and ssh keys
resource "digitalocean_droplet" "vps" {
  count = var.do_vps_count
  #image  = "ubuntu-20-04-x64"
  image = "centos-7-x64"
  name = "${var.vps_name}-${count.index}"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  tags   = [digitalocean_tag.task_name.id, digitalocean_tag.user_email.id]
  ssh_keys = [digitalocean_ssh_key.ubuntu_ssh_admin.id, data.digitalocean_ssh_key.ubuntu_ssh_rebrain.id]
}

# Create an inventory using template
resource "local_file" "vps" {
  filename = "${path.module}/${var.file_out}"
  content  = templatefile("${path.module}/${var.file_in}", {domain = var.aws_route53_zone, vps_list = digitalocean_droplet.vps, hostname=var.aws_route53_record_name})
}