# andrew-kulikov_infra
andrew-kulikov Infra repository

## Homework 6

### Дополнительное задание

### Подход с двумя копиями

Минусы:
* Больше кода
* Нужно везеде прописывать имена руками
* При копировании можно ошибиться
* Нужно поддерживать в одиноковом состоянии конфиги всех скопированных ресурсов (при копировании забыл поменять имя в provisioner connection, и второй раз полезло на первую машину)
* Плохо масштабируется
* Ресурсы создаются последовательно, а не параллельно

Пример конфигурации 2 ресурсов для 2 инстансов:

```terraform
resource "yandex_compute_instance" "app" {
  name = "reddit-app"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = yandex_compute_instance.app.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "yandex_compute_instance" "app2" {
  name = "reddit-app-2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = yandex_compute_instance.app2.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}
```

### Подход с count

Лишен недостатков, описанных в прошлом пункте. Также не нужно дублировать targets в конфигурации балансировщика.

В connection вместо `yandex_compute_instance.app[count.index].network_interface.0.nat_ip_address` нужно использовать `self.network_interface.0.nat_ip_address`, иначе получаем `Error: Cycle: yandex_compute_instance.app[1], yandex_compute_instance.app[0]`

Пример создания ресурса compute_instance с помощью count:

```
resource "yandex_compute_instance" "app" {
  name = "reddit-app-${count.index}"

  count = var.instance_count

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}
```
