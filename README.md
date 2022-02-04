# andrew-kulikov_infra
andrew-kulikov Infra repository

## Homework 8

### Самостоятельное задание


Пояснение к повторному выполнению плейбука с git clole:

После выполнения `ansible app -m command -a 'rm -rf ~/reddit'` при попытке повторного выполнения `ansible-playbook clone.yml` получаем результат `appserver                  : ok=2    changed=1`. Это связано с тем, что теперь папки нет, и модуль отработал успешно. О чем и свидетельствует `changed=1`. Это значит, что модуль git написан верно и идемпотентен. То есть при повторном запуске будет произведена проверка на наличие директории. И команда будет выполнена только в случае ее отсутствия.


### Дополнительное задание. Динамический inventory

Как было выяснено из статей, динамический inventory - любой исполняемый файл, который в stdout возвращает валидный inventory в формате json.
Для получения адресов интансов было решено использовать terraform output. Для этого был реализован [скрипт](ansible/yc.py) на python3, запускающий команду `terraform output` в папке, из которой мы поднимали инфраструктуру с помощью terraform. Путь к папке берется из переменной среды `REDDITAPP_TERRAFORM_FOLDER`.

Код парсинга terraform output:
```python
ENV_TERRAFORM_FOLDER = 'REDDITAPP_TERRAFORM_FOLDER'
APP_IP_OUTPUT_KEY = 'external_ip_address_app'
DB_IP_OUTPUT_KEY = 'external_ip_address_db'


def get_terraform_outputs(folder_path):
    with subprocess.Popen(['terraform', 'output'], cwd=folder_path, stdout=subprocess.PIPE) as process:
        return process.communicate()[0].decode('utf-8')


def parse_terraform_outputs(terraform_output_lines):
    return dict(map(parse_terraform_output_line, terraform_output_lines))


def parse_terraform_output_line(line):
    (name, value) = line.split(' = ')
    return (name, value)


def get_parsed_terraform_outputs():
    terraform_path = os.environ.get(ENV_TERRAFORM_FOLDER)

    output = get_terraform_outputs(terraform_path)
    output_lines = output.splitlines()

    return parse_terraform_outputs(output_lines)
```

Код построения динамического inventory:
```python
class YCTerraformInventory(object):

    def __init__(self):
        self.inventory = {}
        self.read_cli_args()

        # Called with `--list`.
        if self.args.list:
            self.inventory = self.yandex_terraform_inventory()
        # Called with `--host [hostname]`.
        elif self.args.host:
            # Not implemented, since we return _meta info `--list`.
            self.inventory = self.empty_inventory()
        # If no groups or vars are present, return an empty inventory.
        else:
            self.inventory = self.empty_inventory()

        print(json.dumps(self.inventory))

    def yandex_terraform_inventory(self):
        terraform_outputs = get_parsed_terraform_outputs()

        app_instance_ip = terraform_outputs[APP_IP_OUTPUT_KEY]
        db_instance_ip = terraform_outputs[DB_IP_OUTPUT_KEY]

        return {
            'app': {
                'hosts': ['appserver']
            },
            'db': {
                'hosts': ['dbserver']
            },
            '_meta': {
                'hostvars': {
                    'appserver': {
                        'ansible_host': app_instance_ip
                    },
                    'dbserver': {
                        'ansible_host': db_instance_ip
                    }
                }
            }
        }

    # Empty inventory for testing.
    def empty_inventory(self):
        return {'_meta': {'hostvars': {}}}

    # Read the command line args passed to the script.
    def read_cli_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action='store_true')
        parser.add_argument('--host', action='store')
        self.args = parser.parse_args()


YCTerraformInventory()
```

Затем в ansible.cfg меняем путь до inventory файла на наш скрипт `inventory = ./yc.py`, предварительно дав ему права на исполнение `chmod 777 ./yc.py`. В результате выполнения `ansible all -m ping` получаем успешный результат:
```
appserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
dbserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```
