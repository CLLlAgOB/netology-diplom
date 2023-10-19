# variables.tf
variable "username" {
  type    = string
  default = "terraform"
}
variable "cloud_id" {
  type    = string
  default = "b1g4gq7pag9ncoi3odtt"
}
variable "public_key" {
  type = string
}
variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "user_name" {
  type    = string
  default = "netology_db" # Здесь замените на имя пользователя
}


variable "db_name" {
  type    = string
  default = "netology_db" # Здесь замените на имя пользователя
}

variable "user_password" {
  type    = string
  default = "netology_db" # Здесь замените на пароль пользователя
}


variable "k8s_version" {
  type    = string
  default = "1.27" # Здесь замените на пароль пользователя
}

variable "sa_name" {
  type    = string
  default = "svc-k8s" # Здесь замените на пароль пользователя
}

variable "sa_alb" {
  type    = string
  default = "sa-alb" # Здесь замените на пароль пользователя
}
variable "sa_token" {
  description = "Service Account Token"
  type        = string
}

variable "folder_id" {
  description = "Service Account Token"
  type        = string
}

