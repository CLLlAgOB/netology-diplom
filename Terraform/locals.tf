# Определяем список данных для подсетей
locals {
  subnets = [
    { name = "public-a", zone = "ru-central1-a", cidr_block = "10.5.0.0/16" },
    { name = "public-b", zone = "ru-central1-b", cidr_block = "10.6.0.0/16" },
    { name = "public-c", zone = "ru-central1-c", cidr_block = "10.7.0.0/16" },
  ]
}

# настройки мастер кластера к8с
locals {
  loggroup_name = "" # Log group name for Cloud Logging.

  # The following settings are predefined. Change them only if necessary.
  k8s_version              = "1.27"                      # Версия Kubernetes
  sa_name                  = "svc-k8s"                   # Имя сервисного аккаунта
  sa_alb                   = "sa-alb"                    # Имя сервисного аккаунта для Application Load Balancer (ALB)
  main_security_group_name = "yandex_vpc_security_group" # Name of the main security group of the cluster
  public_services_sg_name  = "k8s-public-services"       # Name of the public services security group for node groups
  k8s_cluster_name         = "k8s-regional"              # Name of the Kubernetes cluster
  k8s_node_group_name      = "k8s-node-group"            # Name of the Kubernetes node group
  zone_abc_v4_cidr_blocks  = "10.0.0.0/8"                # CIDR block for the subnet in the ru-central1-a availability zone
}

# сохраняем ключик через output для создание ingressom ALB.
locals {
  key_json = jsonencode({
    id                 = yandex_iam_service_account_key.sa-auth-key.id,
    service_account_id = yandex_iam_service_account.sa-alb.id,
    created_at         = yandex_iam_service_account_key.sa-auth-key.created_at,
    key_algorithm      = yandex_iam_service_account_key.sa-auth-key.key_algorithm,
    public_key         = yandex_iam_service_account_key.sa-auth-key.public_key,
    private_key        = yandex_iam_service_account_key.sa-auth-key.private_key
  })
}

# Время обслуживания для нод кластера.
locals {
  maintenance_policies = [
    {
      auto_upgrade = true
      auto_repair  = true
      maintenance_windows = [
        {
          day        = "monday"
          start_time = "11:00"
          duration   = "3h"
        },
        {
          day        = "friday"
          start_time = "10:00"
          duration   = "4h30m"
        }
      ]
    },
    {
      auto_upgrade = true
      auto_repair  = true
      maintenance_windows = [
        {
          day        = "tuesday"
          start_time = "11:30"
          duration   = "2h45m"
        },
        {
          day        = "saturday"
          start_time = "12:00"
          duration   = "5h"
        }
      ]
    },
    {
      auto_upgrade = true
      auto_repair  = true
      maintenance_windows = [
        {
          day        = "wednesday"
          start_time = "10:00"
          duration   = "3h15m"
        },
        {
          day        = "sunday"
          start_time = "14:00"
          duration   = "6h"
        }
      ]
    }
  ]
}

# Для групп нод конфигурация
locals {
  instance_memory    = 4  # Объем памяти для экземпляра
  instance_cores     = 2  # Количество ядер для экземпляра
  instance_disk_size = 64 # Размер диска для экземпляра

  preemptible_instance = true # Использование экземпляров с возможностью досрочного завершения

  container_runtime_type = "containerd" # Тип контейнерного рантайма

  auto_scale_min     = 1 # Минимальное количество экземпляров в группе
  auto_scale_max     = 3 # Максимальное количество экземпляров в группе
  auto_scale_initial = 1 # Начальное количество экземпляров в группе
}

