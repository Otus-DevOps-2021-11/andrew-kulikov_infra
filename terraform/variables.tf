variable cloud_id {
  description = "Cloud"
}

variable folder_id {
  description = "Folder"
}

variable zone {
  description = "Zone"
  default     = "ru-central1-a"
}

variable service_account_key_file {
  description = "key .json"
}

variable bucket {
  description = "Terraform state bucket name"
}

variable access_key {
  description = "Service account static access key"
}

variable secret_key {
  description = "Service account static secret key"
}
