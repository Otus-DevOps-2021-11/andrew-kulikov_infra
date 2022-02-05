resource "yandex_compute_instance" "db" {
  name = "reddit-db-${var.environment}"

  labels = {
    tags = "reddit-db"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.db_image_id
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

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf",
  #     "sudo systemctl restart mongod.service"
  #   ]
  #   on_failure  = continue
  # }
}
