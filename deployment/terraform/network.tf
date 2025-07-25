resource "yandex_vpc_network" "main-network" {
  name        = "main-network"
  description = "main-network"
}

resource "yandex_vpc_subnet" "web-1-subnet" {
  name           = "web-1-subnet"
  description    = "subnet-1"
  v4_cidr_blocks = ["10.20.1.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main-network.id
  route_table_id = yandex_vpc_route_table.route_table.id
}

resource "yandex_vpc_subnet" "web-2-subnet" {
  name           = "web-2-subnet"
  description    = "subnet-2"
  v4_cidr_blocks = ["10.20.2.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main-network.id
  route_table_id = yandex_vpc_route_table.route_table.id
}

resource "yandex_vpc_subnet" "other-servers-subnet" {
  name           = "other-servers-subnet"
  description    = "other-servers-subnet"
  v4_cidr_blocks = ["10.20.3.0/24"]
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.main-network.id
  route_table_id = yandex_vpc_route_table.route_table.id
}

resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public-subnet"
  description    = "public-subnet"
  v4_cidr_blocks = ["10.20.4.0/24"]
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.main-network.id
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "route_table" {
  network_id = yandex_vpc_network.main-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}
