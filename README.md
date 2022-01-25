# andrew-kulikov_infra
andrew-kulikov Infra repository

## Homework 7

### Самостоятельное задание

Добавлен постфикс с именем среды в имя инстанса
### Дополнительное задание

`terraform init -backend-config=config.s3.backendconfig`
настройки в файле config.s3.backendconfig.example

Ошибка при попытке параллельного создания без лока
```
Error: Error while requesting API to create instance: server-request-id = f43ddf3a-c37e-4761-9ead-b540565c5c9c server-trace-id = f1ee6bc6b40d09fe:c70170720cfa15e2:f1ee6bc6b40d09fe:1 client-request-id = dff618c3-6429-484a-9d1e-a73d09a7cffa client-trace-id = 1fa32fb3-4d0f-41f5-83d3-69d65b304549 rpc error: code = AlreadyExists desc = Instance with name "reddit-app-prod" already exists

  on ../modules/app/main.tf line 1, in resource "yandex_compute_instance" "app":
   1: resource "yandex_compute_instance" "app" {



Error: Error while requesting API to create instance: server-request-id = c03748e6-90ca-4a40-88fb-fb78648e6601 server-trace-id = d51556b6b32ff186:fa4b3b127663e38b:d51556b6b32ff186:1 client-request-id = 655c781c-0766-4387-aece-aa17a6a1544e client-trace-id = 1fa32fb3-4d0f-41f5-83d3-69d65b304549 rpc error: code = AlreadyExists desc = Instance with name "reddit-db-prod" already exists

  on ../modules/db/main.tf line 1, in resource "yandex_compute_instance" "db":
   1: resource "yandex_compute_instance" "db" {
```
