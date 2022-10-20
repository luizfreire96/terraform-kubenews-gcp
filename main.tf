terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("kubenews-366023-f346d337be75.json")

  project = "kubenews-366023"
  region  = var.region
  zone    = "southamerica-east1-a"
}

resource "google_compute_instance" "jenkinsvm" {
  name         = "jenkinsvm"
  machine_type = "e2-micro"
  zone         = "southamerica-east1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = "echo hi > /test.txt"
}

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    machine_type = "e2-micro"
  }
}

variable "region" {
  default = ""
}

output "jenkins_ip" {
  value = google_compute_instance.jenkinsvm.network_interface.0.access_config.0.nat_ip
}
resource "" "name" {
  
}