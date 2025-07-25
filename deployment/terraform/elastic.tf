resource "yandex_compute_instance" "elasticsearch" {
  name     = "elasticsearch"
  hostname = "elasticsearch"
  zone     = "ru-central1-d"
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
    subnet_id          = yandex_vpc_subnet.other-servers-subnet.id
    security_group_ids = [yandex_vpc_security_group.ssh-access-local.id, yandex_vpc_security_group.elasticsearch-sg.id, yandex_vpc_security_group.kibana-sg.id, yandex_vpc_security_group.filebeat-sg.id]
    ip_address         = "10.20.3.25"
  }

  timeouts {
    create = "10m"
  }

  metadata = {
    user-data = "${file(var.user_data)}"
  }
}
