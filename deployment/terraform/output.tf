output "webserver-1" {
  value = yandex_compute_instance.web-1.network_interface.0.ip_address
}

output "webserver-2" {
  value = yandex_compute_instance.web-2.network_interface.0.ip_address
}

output "load_balancer_pub" {
  value = yandex_alb_load_balancer.load-balancer.listener[0].endpoint[0].address[0].external_ipv4_address
}

output "bastion_nat" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}
output "bastion" {
  value = yandex_compute_instance.bastion.network_interface.0.ip_address
}

output "kibana-nat" {
  value = yandex_compute_instance.kibana.network_interface.0.nat_ip_address
}
output "kibana" {
  value = yandex_compute_instance.kibana.network_interface.0.ip_address
}

output "zabbix_nat" {
  value = yandex_compute_instance.zabbix.network_interface.0.nat_ip_address
}
output "zabbix" {
  value = yandex_compute_instance.zabbix.network_interface.0.ip_address
}

output "elasticsearch" {
  value = yandex_compute_instance.elasticsearch.network_interface.0.ip_address
}
