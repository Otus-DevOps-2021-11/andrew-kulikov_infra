resource "yandex_compute_instance" "app" {
  name = "reddit-app-${var.environment}"

  labels = {
    tags = "reddit-app"
    env  = var.environment
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.app_image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  # connection {
  #   type        = "ssh"
  #   host        = self.network_interface.0.nat_ip_address
  #   user        = "ubuntu"
  #   agent       = false
  #   private_key = file(var.private_key_path)
  # }

  # provisioner "file" {
  #   source      = "${path.module}/files/puma.service"
  #   destination = "/tmp/puma.service"
  #   on_failure  = continue
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "echo 'DATABASE_URL=${var.mongodb_internal_ip}' > ~/reddit.env"
  #   ]
  #   on_failure  = continue
  # }

  # provisioner "remote-exec" {
  #   script      = "${path.module}/files/deploy.sh"
  #   on_failure  = continue
  # }

}
