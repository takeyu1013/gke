locals {
  subnet_name       = "subnet"
  ip_range_pods     = "pods"
  ip_range_services = "services"
  region            = "asia-northeast2"
}

data "google_client_config" "current" {}

module "network" {
  source = "terraform-google-modules/network/google"

  project_id   = data.google_client_config.current.project
  network_name = "network"
  subnets = [
    {
      subnet_name   = local.subnet_name
      subnet_ip     = "10.0.0.0/16"
      subnet_region = local.region
    },
  ]
  secondary_ranges = {
    (local.subnet_name) = [
      {
        range_name    = local.ip_range_pods
        ip_cidr_range = "10.1.0.0/16"
      },
      {
        range_name    = local.ip_range_services
        ip_cidr_range = "10.2.0.0/16"
      },
    ]
  }
}

module "gke" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"

  ip_range_pods                   = local.ip_range_pods
  ip_range_services               = local.ip_range_services
  name                            = "cluster"
  project_id                      = module.network.project_id
  network                         = module.network.network_name
  subnetwork                      = module.network.subnets_names[index(module.network.subnets_names, local.subnet_name)]
  region                          = module.network.subnets_regions[index(module.network.subnets_regions, local.region)]
  enable_vertical_pod_autoscaling = true
}
