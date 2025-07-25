resource "yandex_compute_instance" "web-1" {
  name     = "web-1"
  hostname = "web-1"
  zone     = "ru-central1-a"
  platform_id = var.platform_id

  resources {
    cores         = var.configuration_flavor.FLV_2_4_20_20.cores
    memory        = var.configuration_flavor.FLV_2_4_20_20.memory
    core_fraction = var.configuration_flavor.FLV_2_4_20_20.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      type     = "network-hdd"
      size     = "10"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.web-1-subnet.id
    security_group_ids = [yandex_vpc_security_group.ssh-access-local.id, yandex_vpc_security_group.nginx-sg.id, yandex_vpc_security_group.filebeat-sg.id]
    ip_address         = "10.20.1.10"
  }

  metadata = {
    user-data = "${file(var.user_data)}"
  }
}

resource "yandex_compute_instance" "web-2" {
  name     = "web-2"
  hostname = "web-2"
  zone     = "ru-central1-b"
  platform_id = var.platform_id

  resources {
    cores         = var.configuration_flavor.FLV_2_4_20_20.cores
    memory        = var.configuration_flavor.FLV_2_4_20_20.memory
    core_fraction = var.configuration_flavor.FLV_2_4_20_20.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      type     = "network-hdd"
      size     = var.configuration_flavor.FLV_2_4_20_20.disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.web-2-subnet.id
    security_group_ids = [yandex_vpc_security_group.ssh-access-local.id, yandex_vpc_security_group.nginx-sg.id, yandex_vpc_security_group.filebeat-sg.id]
    ip_address         = "10.20.2.10"
  }

  timeouts {
    create = "10m"
  }

  metadata = {
    user-data = "${file(var.user_data)}"
  }
}
