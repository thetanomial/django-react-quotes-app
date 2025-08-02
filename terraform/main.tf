terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "ssh_key_name" {
  description = "Name of SSH key in DigitalOcean"
  type        = string
  default     = "quotes-app-key"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc1"
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_vpc" "quotes_vpc" {
  name   = "quotes-app-vpc"
  region = var.region
}

resource "digitalocean_droplet" "quotes_app" {
  image  = "docker-20-04"
  name   = "quotes-app-server"
  region = var.region
  size   = "s-2vcpu-2gb"
  vpc_uuid = digitalocean_vpc.quotes_vpc.id
  
  ssh_keys = [
    data.digitalocean_ssh_key.quotes_key.id
  ]

  user_data = file("${path.module}/cloud-init.yml")

  tags = ["quotes-app", "web"]
}

data "digitalocean_ssh_key" "quotes_key" {
  name = var.ssh_key_name
}

resource "digitalocean_firewall" "quotes_firewall" {
  name = "quotes-app-firewall"

  droplet_ids = [digitalocean_droplet.quotes_app.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_domain" "quotes_domain" {
  name = "quotes-app.${digitalocean_droplet.quotes_app.ipv4_address}.nip.io"
}

resource "digitalocean_record" "quotes_record" {
  domain = digitalocean_domain.quotes_domain.name
  type   = "A"
  name   = "@"
  value  = digitalocean_droplet.quotes_app.ipv4_address
}

output "droplet_ip" {
  value = digitalocean_droplet.quotes_app.ipv4_address
  description = "The public IP address of the droplet"
}

output "domain_name" {
  value = digitalocean_domain.quotes_domain.name
  description = "The domain name for the application"
}