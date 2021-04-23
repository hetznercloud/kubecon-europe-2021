terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.26.0"
    }
  }
}

provider "hcloud" {}

resource "hcloud_ssh_key" "kubecon" {
  name       = "KubeCon 2021"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtQfpA5hgiFC1b3uVfC/d1qbqmly2qwHkl8BLavzTcg kubecon@europe"
}

resource "hcloud_network" "k3s" {
  name     = "k3s"
  ip_range = "10.92.0.0/16"
}

resource "hcloud_network_subnet" "k3s" {
  network_id   = hcloud_network.k3s.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.92.0.0/24"
}

resource "hcloud_firewall" "base" {
  name = "base"
  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_firewall" "k3s-server" {
  name = "k3s-server"
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "6443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_server" "server" {
  count       = 1
  name        = "server-${count.index}"
  image       = "ubuntu-20.04"
  server_type = "cx21"
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.kubecon.id]
  labels = {
    "kubecon/server" = "true",
    "kubecon/agent"  = "false"
  }
  firewall_ids = [hcloud_firewall.base.id, hcloud_firewall.k3s-server.id]
}

resource "hcloud_server" "agent-cx21" {
  count       = 2
  name        = "agent-cx21-${count.index}"
  image       = "ubuntu-20.04"
  server_type = "cx21"
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.kubecon.id]
  labels = {
    "kubecon/server" = "false",
    "kubecon/agent"  = "true"
  }
  firewall_ids = [hcloud_firewall.base.id]
}

resource "hcloud_server_network" "server" {
  count      = length(hcloud_server.server)
  server_id  = hcloud_server.server[count.index].id
  network_id = hcloud_network.k3s.id
}

resource "hcloud_server_network" "agent-cx21" {
  count      = length(hcloud_server.agent-cx21)
  server_id  = hcloud_server.agent-cx21[count.index].id
  network_id = hcloud_network.k3s.id
}
