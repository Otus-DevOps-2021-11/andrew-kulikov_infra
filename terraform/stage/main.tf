provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

locals {
  environment = "stage"
}

module "app" {
  source          = "../modules/app"
  environment     = local.environment
  public_key_path = var.public_key_path
  app_image_id    = var.app_image_id
  subnet_id       = var.subnet_id
}

module "db" {
  source          = "../modules/db"
  environment     = local.environment
  public_key_path = var.public_key_path
  db_image_id     = var.db_image_id
  subnet_id       = var.subnet_id
}
