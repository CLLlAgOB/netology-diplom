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
  default     = "y0_AgAAAAACk9ciAATuwQAAAADtlT0cE_ZygWHpSlqZ2KBj8VMMstvFnjo"
}

variable "folder_id" {
  description = "Service Account Token"
  type        = string
  default     = "b1gnjt4tv12ioq5lvflm"
}

variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5eZQIYqkK0iqUSO+BJ80wJ5OFu3E04P/y3bRtLhZEE2lesNjHITnnH6cXc7JYV7nTl/gqgG+3FzQ0Iezy8DLAAymGZ2JhUEMyDqnWAX2/7UXbU1rFVD+Wa1DWmPsUDnEob4c6bYQsMovW8iON4xvh5o25Pn1wm6048h6K8JP34/9MB9XK3gK56MFWf58bX/q0gL1q5E5HglPla1/mQCSHie1UTtLUDJ9gA7Rbjz8JMkwQfqTAykQy5npL/6gELqxNTeArgApEwFyBtumOVz8Hn5XKkNQEzmeYNzzmt5cAGteOJ+e7XzIOtmqou6Q8yWq+pfo/7qE+xGsM/smPKXOSrdkAqZoV3jcMPyWUbE6I8v1xO1QfnRl5nLG7LY/ipu8W8omZf9jv4E3J1zD0HtU33kgAQSI7URBTPLfuFEq5F3iWs9xzbEv4hYn3qwiRp5nqui9v/cjpEGcBeksACiqwx9eU8fHFvP6gFwgCxSSBAxVlqRpnYilhiR+wbXqgR8c= aleksandr@R2D2"
}