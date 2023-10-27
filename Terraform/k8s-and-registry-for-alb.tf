resource "yandex_iam_service_account" "k8s-sa" {
  description = "Service account to manage the Kubernetes cluster and node group"
  name        = local.sa_name
}

# Assign "editor" role to Kubernetes service account
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
  ]
}

# Assign "container-registry.images.puller" role to Kubernetes service account
resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
  ]
}


resource "yandex_kubernetes_cluster" "k8s-regional" {
  description = "Managed Service for Kubernetes cluster"
  name        = local.k8s_cluster_name
  network_id  = yandex_vpc_network.vpc.id

  master {
    version = local.k8s_version
    regional {
      region = "ru-central1"
      dynamic "location" {
        for_each = yandex_vpc_subnet.public-subnet[*]
        content {
          zone      = location.value.zone  
          subnet_id = location.value.id
        }
      }
    }

    public_ip          = true
    security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id]
  }

  service_account_id      = yandex_iam_service_account.k8s-sa.id
  node_service_account_id = yandex_iam_service_account.k8s-sa.id

  depends_on = [
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_resourcemanager_folder_iam_binding.images-puller
  ]
}


resource "yandex_logging_group" "logging-group" {
  description = "Cloud Logging group"
  name        = local.loggroup_name
  folder_id   = var.folder_id
}


resource "yandex_iam_service_account" "sa-alb" {
  description = "Service account for the ALB ingress controller to run"
  name        = local.sa_alb
}

resource "yandex_resourcemanager_folder_iam_binding" "custom_roles" {
  for_each  = local.roles
  folder_id = var.folder_id
  role      = each.value
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-alb.id}"
  ]
}

resource "yandex_iam_service_account_key" "sa-auth-key" {
  description        = "Authorized key for service accaunt"
  service_account_id = yandex_iam_service_account.k8s-sa.id
}

output "key-json" {
  value = nonsensitive(local.key_json)
}