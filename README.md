## Homework 10

### Дополнительное задание

Работу с динамическим inventory настраиваем аналогично прошлому заданию. Однако теперь разделяем конфигурацию динамического inventory по средам. Шаги:
1. Задаем тег env для инстансов в конфигурации terraform для модулей app и db
2. Переносим yc_compute.yml для каждой среды
3. В ansible.cfg задаем
```
[inventory]
enable_plugins = yc_compute
```
4. В yc_compute.yml добавляем новый фильтр по тегу env соответствующей среды
```yaml
filters:
  - status == 'RUNNING'
  - labels['env'] == 'stage'
```
5. Проверяем `ansible-inventory -i environments/stage/yc_compute.yml --list`
6. Запускаем плейбук с динамическим inventory `ansible-playbook -i environments/stage/yc_compute.yml playbooks/site.yml`
