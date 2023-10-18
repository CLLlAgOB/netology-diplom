# vpc.tf
# VPC
resource "yandex_vpc_network" "vpc" {
  name = "Netology-vpc"
  description = terraform.workspace == "prod" ? "nework Prod" : "nework Stage"
}

 # Public Subnet for k8s a
resource "yandex_vpc_subnet" "public-subnet-a" {
  name           = "public-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.5.0.0/16"]
}
# Public Subnet for k8s b
resource "yandex_vpc_subnet" "public-subnet-b" {
  name           = "public-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.6.0.0/16"]
}

# Public Subnet for k8s c
resource "yandex_vpc_subnet" "public-subnet-c" {
  name           = "public-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.7.0.0/16"]
}

/* # Private Subnet
resource "yandex_vpc_subnet" "private-subnet-a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}

# Private Subnet
resource "yandex_vpc_subnet" "private-subnet-b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.40.0/24"]
} */
