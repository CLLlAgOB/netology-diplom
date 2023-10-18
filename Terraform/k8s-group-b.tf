# Его наполнение instance group 

resource "yandex_kubernetes_node_group" "k8s-group-b" {
  cluster_id = yandex_kubernetes_cluster.k8s-regional.id
  name       = "k8s-b"
  version = var.k8s_version
  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat                = true
      subnet_ids         = ["${yandex_vpc_subnet.public-subnet-b.id}"]
      security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id, yandex_vpc_security_group.k8s-public-services.id]
    }

    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    scheduling_policy {
      preemptible = true #Удаляемые русурсы стоят намного дешевле...
    }

    container_runtime {
      type = "containerd"
    }
    metadata = {
      user-data = data.template_file.instance_userdata.rendered
    }
  }
  scale_policy {
    auto_scale {
      min     = 1
      max     = 3
      initial = 1
    }
  }
  allocation_policy {
    location {
      zone = "ru-central1-b"
    }
  }
  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "14:00"
      duration   = "4h30m"
    }
  }
}
