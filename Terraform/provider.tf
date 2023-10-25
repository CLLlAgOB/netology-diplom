#provider.tf
provider "yandex" {
  cloud_id  = var.cloud_id
  token     = var.sa_token
  folder_id = var.folder_id
  zone      = var.zone
}
