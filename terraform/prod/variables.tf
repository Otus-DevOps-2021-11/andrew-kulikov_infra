variable instance_count {
  description = "Number of instances"
  default     = 1
}

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

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for provisioner connection"
}

variable app_image_id {
  description = "Application vm disk image"
}

variable db_image_id {
  description = "Database vm disk image"
}

variable subnet_id {
  description = "Subnet"
}

variable service_account_key_file {
  description = "key .json"
}
