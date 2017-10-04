variable "gcp_project" {
 description =  "Name of the Google Compute project to use"
}

variable "gcp_region" {
  description = "Google Compute region to use for the cluster"
  default = "europe-west1"
}

variable "gcp_zone" {
  description = "Google Computer zone to use for the cluster"
  default = "europe-west1-d"
}

variable "cluster_name" {
  description = "Google Container Cluster name to use for the cluster"
  default = "hello-gke-cluster"
}
