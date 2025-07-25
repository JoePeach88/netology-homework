resource "yandex_alb_target_group" "target-group" {
  name = "target-group"

  target {
    ip_address = yandex_compute_instance.web-1.network_interface.0.ip_address
    subnet_id  = yandex_vpc_subnet.web-1-subnet.id
  }

  target {
    ip_address = yandex_compute_instance.web-2.network_interface.0.ip_address
    subnet_id  = yandex_vpc_subnet.web-2-subnet.id
  }
}

resource "yandex_alb_backend_group" "backend-group" {
  name = "backend-group"

  http_backend {
    name             = "backend"
    weight           = 1
    port             = 80
    target_group_ids = ["${yandex_alb_target_group.target-group.id}"]
    load_balancing_config {
      panic_threshold = 90
    }

    healthcheck {
      timeout             = "10s"
      interval            = "3s"
      healthy_threshold   = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_vpc_security_group" "ssh-access" {
  name       = "ssh-access"
  network_id = yandex_vpc_network.main-network.id

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol          = "TCP"
    security_group_id = yandex_vpc_security_group.ssh-access-local.id
    port              = 22
  }
  egress {
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.ssh-access-local.id
  }
}

resource "yandex_vpc_security_group" "ssh-access-local" {
  name       = "ssh-access-local"
  network_id = yandex_vpc_network.main-network.id

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24", "10.20.4.0/24"]
    port           = 22
  }
  egress {
    protocol       = "TCP"
    v4_cidr_blocks = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24", "10.20.4.0/24"]
    port           = 22
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "nginx-sg" {
  name       = "nginx-sg"
  network_id = yandex_vpc_network.main-network.id

  ingress {
    protocol       = "ANY"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ANY"
    port           = 10050
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    port           = 10050
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "elasticsearch-sg" {
  name       = "elasticsearch-sg"
  network_id = yandex_vpc_network.main-network.id

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24", "10.20.4.0/24"]
    port           = 9200
  }

  ingress {
    protocol       = "ANY"
    port           = 10050
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24", "10.20.4.0/24"]
  }

  egress {
    protocol       = "ANY"
    port           = 10050
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "zabbix-sg" {
  name       = "zabbix-sg"
  network_id = yandex_vpc_network.main-network.id

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8080
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24", "10.20.4.0/24"]
    port           = 10050
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24", "10.20.4.0/24"]
    port           = 10051
  }

  egress {
    protocol       = "TCP"
    port           = 8080
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24", "10.20.4.0/24"]
  }

  egress {
    protocol       = "TCP"
    port           = 10051
    v4_cidr_blocks = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24", "10.20.4.0/24"]
  }
}

resource "yandex_vpc_security_group" "kibana-sg" {
  name       = "kibana-sg"
  network_id = yandex_vpc_network.main-network.id

  ingress {
    protocol       = "ANY"
    port           = 10050
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 5601
  }

  egress {
    protocol       = "ANY"
    port           = 10050
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "filebeat-sg" {
  name       = "filebeat-sg"
  network_id = yandex_vpc_network.main-network.id

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24", "10.20.4.0/24"]
    port           = 5044
  }
  egress {
    protocol       = "TCP"
    port           = 5044
    v4_cidr_blocks = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24", "10.20.4.0/24"]
  }
}

resource "yandex_vpc_security_group" "balancer-sg" {
  name       = "balancer-sg"
  network_id = yandex_vpc_network.main-network.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol          = "TCP"
    description       = "healthchecks"
    predefined_target = "loadbalancer_healthchecks"
    port              = 30080
  }
}
