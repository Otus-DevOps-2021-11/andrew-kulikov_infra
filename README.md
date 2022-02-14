## Homework 11

### Самостоятельное задание.

Тест для проверки открыт ли порт 27017 реализуем с помощью модуля socket:

```python
# check if MongoDB is listening on port 27017
def test_port27017_open(host):
    socket = host.socket("tcp://0.0.0.0:27017")
    assert socket.is_listening
```


Для использования ролей в ansible provisioner есть переменная `roles_path`, но она не работает. Поэтому применяем обход с помощью `ansible_env_vars`. Теги передаем через `extra_arguments`.

В результате получаем следующую конфигурацию провижинера:

[app.json](packer/app.json)
```json
"provisioners": [
  {
    "type": "ansible",
    "user": "ubuntu",
    "ansible_env_vars": [ "ANSIBLE_ROLES_PATH=ansible/roles" ],
    "extra_arguments": ["--tags", "ruby"],
    "playbook_file": "ansible/playbooks/packer_app.yml"
  }
]
```

[db.json](packer/db.json)
```json
"provisioners": [
  {
    "type": "ansible",
    "user": "appuser",
    "ansible_env_vars": [ "ANSIBLE_ROLES_PATH=ansible/roles" ],
    "extra_arguments": ["--tags", "install"],
    "playbook_file": "ansible/playbooks/packer_db.yml"
  }
]
```



### Дополнительное задание. Настройка конфигурации nginx для Vagrant

Рядом с Vagrantfile создаем файл [nginx_vagrant.yml](ansible/nginx_vagrant.yml), в котором задаем конфигурацию nginx:
```yaml
nginx_sites:
  default:
    - listen 80
    - server_name "reddit"
    - location / {
        proxy_pass http://127.0.0.1:9292;
      }
```
Затем в Vagrantfile считываем файл с помощью модуля yaml:
```ruby
current_dir = File.dirname(File.expand_path(__FILE__))
nginx_config = YAML.load_file("#{current_dir}/nginx_vagrant.yml")
```
И используем в блоке extra_vars:
```ruby
app.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbooks/site.yml"
    ansible.groups = {
        "app" => ["appserver"],
        "app:vars" => { "db_host" => "192.168.56.10"}
    }
    ansible.extra_vars = {
        "deploy_user" => "vagrant",
        "nginx_sites" => nginx_config['nginx_sites']
    }
end
```
