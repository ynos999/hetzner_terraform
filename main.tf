terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.56.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

variable "hcloud_token" {}
variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

# ───────────────────────────────
# Privātais tīkls
# ───────────────────────────────
resource "hcloud_network" "k8s_net" {
  name     = "k8s-private-net"
  ip_range = "10.10.0.0/16"
}

resource "hcloud_network_subnet" "k8s_subnet" {
  network_id   = hcloud_network.k8s_net.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.10.1.0/24"
}

# ───────────────────────────────
# SSH Key
# ───────────────────────────────
resource "hcloud_ssh_key" "default" {
  name       = "k8s-test-key"
  public_key = file(var.ssh_public_key)
}

# ───────────────────────────────
# Floating IP (izeja uz internetu)
# ───────────────────────────────
resource "hcloud_floating_ip" "nat_ip" {
  type     = "ipv4"
  home_location = "hel1"
  description   = "NAT for k8s nodes"
}

# Floating IP tiek piesaistīts masteriem
resource "hcloud_floating_ip_assignment" "assign_nat" {
  floating_ip_id = hcloud_floating_ip.nat_ip.id
  server_id      = hcloud_server.master.id
}

# ───────────────────────────────
# Master serveris
# ───────────────────────────────
resource "hcloud_server" "master" {
  name        = "master"
  server_type = "cx23"
  image       = "ubuntu-22.04"
  location    = "hel1"
  ssh_keys    = [hcloud_ssh_key.default.id]

  network {
    network_id = hcloud_network.k8s_net.id
    ip         = "10.10.1.10"
  }

}

# ───────────────────────────────
# Worker 2 serveri
# ───────────────────────────────
resource "hcloud_server" "worker1" {
  name        = "worker1"
  server_type = "cx23"
  image       = "ubuntu-22.04"
  location    = "hel1"
  ssh_keys    = [hcloud_ssh_key.default.id]

  network {
    network_id = hcloud_network.k8s_net.id
    ip         = "10.10.1.20"
  }

}

resource "hcloud_server" "worker2" {
  name        = "worker2"
  server_type = "cx23"
  image       = "ubuntu-22.04"
  location    = "hel1"
  ssh_keys    = [hcloud_ssh_key.default.id]

  network {
    network_id = hcloud_network.k8s_net.id
    ip         = "10.10.1.20"
  }

}