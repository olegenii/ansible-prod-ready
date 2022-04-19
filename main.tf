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
    null = {
      source = "hashicorp/null"
      version = "3.1.1"
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
  for_each = digitalocean_droplet.vps
  zone_id = data.aws_route53_zone.selected.zone_id
  name = each.value.name
  type    = "A"
  ttl     = "300"
  records = [each.value.ipv4_address]
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
  for_each = toset(var.vps_list)
  image  = "ubuntu-20-04-x64"
  name = "${each.key}"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  tags   = [digitalocean_tag.task_name.id, digitalocean_tag.user_email.id]
  ssh_keys = [digitalocean_ssh_key.ubuntu_ssh_admin.id, data.digitalocean_ssh_key.ubuntu_ssh_rebrain.id]
}

# Create an inventory using template
resource "local_file" "vps" {
  filename = "${path.module}/${var.file_out}"
  content  = templatefile("${path.module}/${var.file_in}", {domain = var.aws_route53_zone, vps_list = digitalocean_droplet.vps, backend=var.vps_list[1]})
}

# Create a null resource for ansible call
resource "null_resource" "vps_ready" {

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.yml --tags nginx,lb playbook.yml"
  }
  # wait till inventory.yml get ready
  depends_on = [
    local_file.vps,
  ]
}