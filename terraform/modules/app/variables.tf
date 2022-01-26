variable environment {
  description = "Environment name"
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

variable subnet_id {
  description = "Subnet"
}

variable mongodb_internal_ip {
  description = "Internal ip of mongodb instance"
}
