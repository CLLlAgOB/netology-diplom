resource "yandex_kubernetes_node_group" "k8s-group" {
  count      = length(local.subnets)
  cluster_id = yandex_kubernetes_cluster.k8s-regional.id
  name       = "k8s-${local.subnets[count.index].name}"
  version    = var.k8s_version

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.public-subnet[count.index].id]
      security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id, yandex_vpc_security_group.k8s-public-services.id]
    }

    resources {
      memory = local.instance_memory
      cores  = local.instance_cores
    }

    boot_disk {
      type = "network-ssd"
      size = local.instance_disk_size
    }

    scheduling_policy {
      preemptible = local.preemptible_instance
    }

    container_runtime {
      type = local.container_runtime_type
    }

    metadata = {
      user-data = data.template_file.instance_userdata.rendered
    }
  }

  scale_policy {
    auto_scale {
      min     = local.auto_scale_min
      max     = local.auto_scale_max
      initial = local.auto_scale_initial
    }
  }

  allocation_policy {
    location {
      zone = local.subnets[count.index].zone
    }
  }

  maintenance_policy {
    auto_upgrade = local.maintenance_policies[count.index].auto_upgrade
    auto_repair  = local.maintenance_policies[count.index].auto_repair

    dynamic "maintenance_window" {
      for_each = local.maintenance_policies[count.index].maintenance_windows
      content {
        day        = maintenance_window.value.day
        start_time = maintenance_window.value.start_time
        duration   = maintenance_window.value.duration
      }
    }
  }
}
