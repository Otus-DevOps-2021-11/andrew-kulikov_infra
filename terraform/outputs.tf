output "external_ip_address_app" {
  value = yandex_compute_instance.app.*.network_interface.0.nat_ip_address
}

output "external_ip_address_lb" {
  value = [
    for l in yandex_lb_network_load_balancer.reddit-load-balancer.listener :
    [for spec in l.external_address_spec : spec.address]
  ]
}
