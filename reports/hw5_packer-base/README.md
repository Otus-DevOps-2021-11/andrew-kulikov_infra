## Homework 5

### Самостоятельное задание

Для подготовки базового образа был подготовлен конфигурационный файл [ubuntu16.json](../../packer/ubuntu16.json). Для установки приложений и пакетов использовались скрипты [install_ruby.sh](../../packer/scripts/install_ruby.sh) и [install_mongodb.sh](../../packer/scripts/install_mongodb.sh). Вначале столкнулся с ошикбой лока файла пакетного менеджера, помогло только ожидаение 30 секунд перед запуском provision стадии.
Id базового образа можно найти с помощью команды `yc compute image --folder-id="standard-images" get-latest-from-family "ubuntu-1604-lts"`.
Затем все переменные можем вынести в файл varibles.json. Пример заполнения: [variables.json.examples](../../packer/variables.json.examples).
Также был использован постпроцессор, который выводит id созданного образа в файл manifest.json.

### Дополнительное задание

<b> Построение bake-образа </b>

Для подготовки bake-образа был подготовлен конфигурационный файл [immutable.json](../../packer/immutable.json). Данный образ построен на базовом образе reddit-base из прошлого задания и дополняет его установкой git, и исходников и зависимостей приложения [bake_app.sh](../../packer/scripts/bake_app.sh). Затем был использован механизм systemd unit для того, чтобы приложение запускалось автоматически после старта инстанса. Алгоритм следующий:
1. Готовим unit file - [redditapp.service](../../packer/files/redditapp.service)
2. Копируем его с помощью file target в папку /tmp (не поддерживает загрузку файла в папку, для которой нужны права)
3. Переносим в /lib/systemd - `sudo mv /tmp/redditapp.service /system/redditapp.service`
4. Делаем автозагрузку для нашего сервиса
```bash
sudo chmod 644 /lib/systemd/system/redditapp.service
sudo systemctl daemon-reload
sudo systemctl enable redditapp.service
```

<b> Автоматизация создания ВМ </b>

Для создания ВМ был сделан скрипт [create-reddit-vm](../../config-scripts/create-reddit-vm.sh). В качестве базового образа используется полученный образ семейства reddit-full с айди, записанным в immutable-manifest.json.
