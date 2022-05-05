provider "google" {
  credentials = file("account.json")
}

provider "google-beta" {
  credentials = file("account.json")
}

data "google_client_config" "default" {}

module "gke" {
  source            = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"
  ip_range_pods     = "pods"
  ip_range_services = "services"
  name              = "cluster"
  network           = "default"
  project_id        = "primal-insight-344912"
  subnetwork        = "default"
  region            = "asia-northeast1"
}
