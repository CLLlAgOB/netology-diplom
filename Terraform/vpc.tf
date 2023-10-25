# vpc.tf

# Создаем VPC
resource "yandex_vpc_network" "vpc" {
  name        = "Netology-vpc"
  description = terraform.workspace == "prod" ? "network Prod" : "network Stage"
}

# Создаем публичные подсети для k8s
resource "yandex_vpc_subnet" "public-subnet" {
  count          = length(local.subnets)
  name           = local.subnets[count.index].name
  zone           = local.subnets[count.index].zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [local.subnets[count.index].cidr_block]
}
