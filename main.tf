module "network" {
  source = "terraform-google-modules/network/google"

  project_id   = "primal-insight-344912"
  network_name = "network"

  subnets = [
    {
      subnet_name   = "subnet"
      subnet_ip     = "10.0.0.0/16"
      subnet_region = "asia-northeast1"
    },
  ]

  secondary_ranges = {
    ("subnet") = [
      {
        range_name    = "pods"
        ip_cidr_range = "192.168.0.0/16"
      },
      {
        range_name    = "services"
        ip_cidr_range = "192.168.0.0/16"
      },
    ]
  }
}

module "gke" {
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"
  ip_range_pods                   = "pods"
  ip_range_services               = "services"
  name                            = "cluster"
  project_id                      = "primal-insight-344912"
  network                         = "network"
  subnetwork                      = "subnet"
  region                          = "asia-northeast1"
  enable_vertical_pod_autoscaling = true
}
