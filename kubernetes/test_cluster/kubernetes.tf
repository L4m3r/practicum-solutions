module "kube" {
  source = "github.com/terraform-yc-modules/terraform-yc-kubernetes.git"

  cluster_name = "cluster-from-terraform"
  network_id   = yandex_vpc_network.kubernetes.id

  master_locations = [
    {
      zone      = var.zone
      subnet_id = yandex_vpc_subnet.kubernetes.id
    }
  ]

  master_maintenance_windows = [
    {
      day        = "monday"
      start_time = "20:00"
      duration   = "3h"
    }
  ]

  node_groups = {
    "yc-k8s-ng-01" = {
      description = "Kubernetes nodes group 01 with fixed size scaling"
      fixed_scale = {
        size = 1
      }
    }
  }
}
