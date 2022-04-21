terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.18.0"
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

# Configure GCP Provider
provider "google" {
  project = var.gcp_project_id
  region  = "europe-central2"
  zone    = "europe-central2-a"
  credentials = file("key.json")
}

# Configure AWS Provider
provider "aws" {
  region = "eu-central-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Create a default firewall rule
resource "google_compute_firewall" "default" {
  name    = "default-firewall"
  network = google_compute_network.vps_network.id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]
  direction = "INGRESS"
}

# Create a firewall rule for health-check
resource "google_compute_firewall" "health-check" {
  name    = "health-check-firewall"
  network = google_compute_network.vps_network.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["web"]
  source_ranges = ["130.211.0.0/22","35.191.0.0/16"]
  direction = "INGRESS"
}

# Create an internal VPC for inctances
resource "google_compute_network" "vps_network" {
  name = "vpc-network"
}

# Create an instance group with webservers and named port
resource "google_compute_instance_group" "backend" {
  name        = "backend"
  description = "Backend webserver instance group"
  
  instances = [for vm in google_compute_instance.vm_instance : vm.id]

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "https"
    port = "8443"
  }
}

# Create a backend service with instance group as http backend
resource "google_compute_backend_service" "backend_service" {
  name      = "backend-service"
  port_name = "http"
  protocol  = "HTTP"
  timeout_sec = 10
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_instance_group.backend.id
  }

  health_checks = [google_compute_health_check.http-health-check.id]
}

# Create an url map with proxing all requests to backend service
resource "google_compute_url_map" "urlmap" {
  name        = "urlmap"
  description = "a description"
  default_service = google_compute_backend_service.backend_service.id
}

# Create a http proxy with url map
resource "google_compute_target_http_proxy" "lb" {
  name    = "http-proxy"
  url_map = google_compute_url_map.urlmap.id
}

# Create a global forwarding rule to http proxy
resource "google_compute_global_forwarding_rule" "default" {
  name   = "website-forwarding-rule"
  ip_address            = google_compute_global_address.lb-ipv4-1.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.lb.id
}

# Create a http health-check for backend webserver
resource "google_compute_health_check" "http-health-check" {
  name = "http-health-check"

  timeout_sec        = 1
  check_interval_sec = 1

  http_health_check {
    port = 80
  }
}

# Create a VPS for backend webserver
resource "google_compute_instance" "vm_instance" {
  for_each = toset(var.vps_list)
  name         = "${each.key}"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${file(var.gcp_ssh_pub_key_file)}"
  }

  network_interface {
    network = google_compute_network.vps_network.id
    access_config {
    }
  }

  tags = ["web"]
}

# Create an IP address for load balancer
resource "google_compute_global_address" "lb-ipv4-1" {
  name = "lb-ipv4-1"
}

# Get specified DNS zone
data "aws_route53_zone" "selected" {
  name = var.aws_route53_zone
}

# Create DNS record for backend webservers
resource "aws_route53_record" "web" {
  for_each = google_compute_instance.vm_instance
  zone_id = data.aws_route53_zone.selected.zone_id
  name = each.value.name
  type    = "A"
  ttl     = "300"
  records = [each.value.network_interface.0.access_config.0.nat_ip]
}

# Create DNS record for lb and www.lb
resource "aws_route53_record" "lb" {
  for_each = toset( [var.aws_route53_record_name, "www.${var.aws_route53_record_name}"] )
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.key
  type    = "A"
  ttl     = "300"
  records = [google_compute_global_address.lb-ipv4-1.address]
}

# Create an inventory using template
resource "local_file" "vps" {
  filename = "${path.module}/${var.file_out}"
  content  = templatefile("${path.module}/${var.file_in}", {domain = var.aws_route53_zone, vps_list = google_compute_instance.vm_instance, gcp_user = var.gcp_ssh_user})
}

# Create a null resource for ansible call
resource "null_resource" "vps_ready" {

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.yml --tags nginx playbook.yml"
  }
  # wait till inventory.yml get ready
  depends_on = [
    local_file.vps,
  ]
}