resource "yandex_vpc_network" "default" {
  name = "logistic"
}

resource "yandex_vpc_route_table" "nat-instance-route" {
  name         = "nat-instance-route"
  network_id   = yandex_vpc_network.default.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "10.140.0.10"
  }
}

resource "yandex_vpc_subnet" "nat-instance-subnet" {
  name           = "nat-instance-subnet"
  network_id     = yandex_vpc_network.default.id
  zone           = var.zone
  v4_cidr_blocks = ["10.140.0.0/24"]
}

resource "yandex_vpc_subnet" "private-servers" {
  name           = "private-servers"
  network_id     = yandex_vpc_network.default.id
  zone           = var.zone
  v4_cidr_blocks = ["10.130.0.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

resource "yandex_vpc_subnet" "public-servers" {
  name           = "public-servers"
  network_id     = yandex_vpc_network.default.id
  zone           = var.zone
  v4_cidr_blocks = ["10.120.0.0/24"]
}
