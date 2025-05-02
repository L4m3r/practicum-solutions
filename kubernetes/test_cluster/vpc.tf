resource "yandex_vpc_network" "kubernetes" {
  name = "kubernetes"
}

resource "yandex_vpc_subnet" "kubernetes" {
  name           = "kubernetes"
  zone           = var.zone
  network_id     = yandex_vpc_network.kubernetes.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}
