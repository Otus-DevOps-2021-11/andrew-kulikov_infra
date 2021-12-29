
## Homework 4

### Самостоятельное задание

1. Скрипт по установке ruby: [install_ruby.sh](install_ruby.sh)

```bash
#!/bin/bash
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install ruby-full ruby-bundler build-essential
ruby -v
bundler -v
```
2. Скрипт по установке mongodb: [install_mongodb.sh](install_ruby.sh)

```bash
#!/bin/bash
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [arch=amd64] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
sudo apt-get -y update
sudo apt-get -y install mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
```

3. Скрипт по деплою приложения: [deploy.sh](install_ruby.sh)
```bash
#!/bin/bash
sudo apt-get -y install git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
puma -d
ps aux | grep puma
```

### Дополнительное задание

С использованием источников https://cloud.yandex.ru/docs/compute/concepts/vm-metadata и https://cloudinit.readthedocs.io/en/latest/topics/examples.html был создан файл с метанаднными пользователя. В секции runcmd были прописаны все шаги из скриптов описанных выше. В результате при старте инстанса были установлены все необходимые пакеты и было запущено приложение.

Из того, что не понравилось:
* Нельзя указать несколько файлов скриптов, все нужно было копировать в секцию runcmd
* При использовании user-data нельзя передавать параметр ssh-key-file. Публичный нужно копировать в конфиг
* Слетает дефолтная конфигурация yc-user, ее также необходимо прописывать

<b>Команда создания инстанса</b> : [create_instance.sh](create_instance.sh)

```bash
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata-from-file user-data=cloud-config.yaml \
  --metadata serial-port-enable=1
```

<b>Файл конфигурации метаданных</b> : [cloud-config.yaml](cloud-config.yaml)

```yaml
#cloud-config

package_update: true
package_upgrade: true

users:
  - name: yc-user
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    lock_passwd: true
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCx59gwu7lqMcbf70vq6zmWsed1z35dzs66UXCuYZgboibIRH4Qlp1l+swMHpMN0HBzXWVOVbwm0wnALBD9fL7ZDp4WjFW20VQq19wwqAm/nytgcEX9EQCDWgl1aVuVxMoCIw9N18gBBE2q4t+ibtdvbeGJynPyLfZYZvzs72+Yc+9Gvfx7xCTcInS7LzWTU7mxbBU0pYI8PgSAQf7ydRrOzmbWDvbreVQifxhxk7MjElBHQkYyB06KX06x7O3VuX9XpJhUYqpxKQtdpv/M5jYKR71VZ02jIQbF13cVsZOJnZnJ9JnFr2HqMjOQp86MJPP4uLcY8O1bKp5ppymqRUTz appuser

runcmd:
  - apt-get -y install ruby-full ruby-bundler build-essential
  - ruby -v
  - bundler -v
  - sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 4B7C549A058F8B6B
  - 'echo "deb [arch=amd64] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list'
  - sudo apt-get -y update
  - sudo apt-get -y install mongodb-org
  - systemctl start mongod
  - systemctl enable mongod
  - systemctl status mongod
  - apt-get -y install git
  - git clone -b monolith https://github.com/express42/reddit.git
  - cd reddit
  - bundle install
  - puma -d
  - 'ps aux | grep puma'

final_message: "The system is finally up, after $UPTIME seconds"
```


testapp_IP = 51.250.5.58
testapp_port = 9292
