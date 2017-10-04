provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}

resource "google_container_cluster" "primary" {
  name = "${var.cluster_name}"
  zone = "${var.gcp_zone}"
  initial_node_count = 2

  node_config {
    machine_type = "g1-small"
    disk_size_gb = 10

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${google_container_cluster.primary.zone} --project ${var.gcp_project}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f kubernetes/"
  }
}
