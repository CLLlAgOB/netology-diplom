# variables.tf
variable "username" {
  type    = string
  default = "terraform"
}
variable "cloud_id" {
  type    = string
  default = "b1g4gq7pag9ncoi3odtt"
}
variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "k8s_version" {
  type    = string
  default = "1.27"
}

variable "sa_name" {
  type    = string
  default = "svc-k8s"
}

variable "sa_alb" {
  type    = string
  default = "sa-alb"
}
variable "sa_token" {
  description = "Service Account Token"
  type        = string
}

variable "folder_id" {
  description = "Service Account Token"
  type        = string
}

variable "public_key" {
  type    = string
}