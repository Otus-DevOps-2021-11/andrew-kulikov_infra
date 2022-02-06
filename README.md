# andrew-kulikov_infra
andrew-kulikov Infra repository

## Homework 9

### Самостоятельное задание. Packer provisioning with ansible

Для замены исходных скриптов были созданы плейбуки ansible, выполняющие аналогичные дествия с помощью специализированных модулей. Были использованы следующие модули: `apt`, `apt_key`, `apt_repository`, `service`.

В результате получаем следующие плейбуки: [packer_app.yml](ansible/packer_app.yml) и [packer_db.yml](ansible/packer_db.yml)

### Дополнительное задание

Плагин был взят из ветки yc_compute. Исходный код плагина можно найти здесь: https://github.com/st8f/community.general/blob/yc_compute/plugins/inventory/yc_compute.py

Для работы с динамическим inventory через плагин выполняем следующие шаги:

1. В requirements.txt указываем зависимость `yandexcloud==0.10.1` (как указано в документации плагина).
2. Задаем переменную среды `export ANSIBLE_INVENTORY_PLUGINS={path_to_plugin_dir}`, где path_to_plugin_dir - путь к папке, в которую скачали исходники плагина (в нашем случае ansbile/plugins).
3. Указываем наш плагин в ansible.cfg
```
[defaults]
inventory = ./yc_compute.yml
remote_user = ubuntu
private_key_file = ~/.ssh/appuser
host_key_checking = False
retry_files_enabled = False

[inventory]
enable_plugins = yc_compute
```

4. Создаем файл inventory [yc_compute.yml](ansible/plugins/yc_compute.yml.example). Там указываем наш плагин, а также folder_id и путь к ключу сервисного аккаунта. Задаем группы app и db по тегам, которые задавали в конфигурации terraform.
```yaml
plugin: yc_compute
folders:
  - folder_id
filters:
  - status == 'RUNNING'
auth_kind: serviceaccountfile
service_account_file: key.json
hostnames:
  - "{{name}}_{{id}}"
compose:
  ansible_host: network_interfaces[0].primary_v4_address.one_to_one_nat.address
groups:
  app: labels['tags'] == 'reddit-app'
  db: labels['tags'] == 'reddit-db'
```

5. Проверяем работоспособность с помощью `ansible-inventory --list -i yc_compute.yml`

P.S. Можно было использовать и keyed groups, но теги называются reddit-app и reddit-db. А в скриптах уже везде прописаны app и db, поэтому использовал обычные groups. С keyed_grops выглядело бы так:
```yaml
keyed_groups:
  - key: labels['tags']
    prefix: ''
    separator: ''
```
