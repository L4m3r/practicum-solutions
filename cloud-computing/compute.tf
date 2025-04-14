resource "yandex_compute_instance" "nat-instance" {
  name        = "nat-instance"
  zone        = var.zone
  platform_id = "standard-v3"
  hostname = "nat-instance"

  resources {
    cores   = 2
    memory  = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd84t5iv61apqenqg4vo"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.nat-instance-subnet.id
    ip_address = "10.140.0.10"
    nat = true
  }

  metadata = {
    ssh-keys = "adminuser:${file("~/.ssh/id_ed25519.pub")}"
    user-data = file("user-data.yaml")
  }
}

resource "yandex_compute_instance" "collector" {
  name        = "collector"
  zone        = var.zone
  platform_id = "standard-v3"
  hostname = "collector"

  resources {
    cores   = 2
    memory  = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8pfd17g205ujpmpb0a"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-servers.id
    ip_address = "10.130.0.10"
  }

  metadata = {
    ssh-keys = "adminuser:${file("~/.ssh/id_ed25519.pub")}"
    user-data = file("user-data.yaml")
  }
}

resource "yandex_compute_instance" "db-server" {
  name        = "db-server"
  zone        = var.zone
  platform_id = "standard-v3"
  hostname = "db-server"

  resources {
    cores   = 2
    memory  = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8pfd17g205ujpmpb0a"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-servers.id
    ip_address = "10.130.0.11"
  }

  metadata = {
    ssh-keys = "adminuser:${file("~/.ssh/id_ed25519.pub")}"
    user-data = file("user-data.yaml")
  }
}

resource "yandex_compute_instance" "reporter" {
  name        = "reporter"
  zone        = var.zone
  platform_id = "standard-v3"
  hostname = "reporter"

  resources {
    cores   = 2
    memory  = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8pfd17g205ujpmpb0a"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-servers.id
    ip_address = "10.130.0.12"
  }

  metadata = {
    ssh-keys = "adminuser:${file("~/.ssh/id_ed25519.pub")}"
    user-data = file("user-data.yaml")
  }
}
