# Infrastructure for Yandex Cloud Managed Service for Kubernetes cluster and Container Registry
#
# RU: https://cloud.yandex.ru/docs/managed-kubernetes/tutorials/alb-ingress-controller-log-options
# EN: https://cloud.yandex.com/en/docs/managed-kubernetes/tutorials/alb-ingress-controller-log-options

# Set the configuration of Managed Service for Kubernetes cluster, Container Registry, and Cloud Logging
locals {
  loggroup_name = "" # Log group name for Cloud Logging.

  # The following settings are predefined. Change them only if necessary.
  main_security_group_name = "yandex_vpc_security_group"         # Name of the main security group of the cluster
  public_services_sg_name  = "k8s-public-services" # Name of the public services security group for node groups
  k8s_cluster_name         = "k8s-regional"         # Name of the Kubernetes cluster
  k8s_node_group_name      = "k8s-node-group"      # Name of the Kubernetes node group
  zone_abc_v4_cidr_blocks    = "10.0.0.0/8"         # CIDR block for the subnet in the ru-central1-a availability zone
}


resource "yandex_vpc_security_group" "k8s-main-sg" {
  description = "Security group ensure the basic performance of the cluster. Apply it to the cluster and node groups."
  name        = local.main_security_group_name
  network_id  = yandex_vpc_network.vpc.id

  ingress {
    description    = "The rule allows availability checks from the load balancer's range of addresses. It is required for the operation of a fault-tolerant cluster and load balancer services."
    protocol       = "TCP"
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"] # The load balancer's address range
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    description       = "The rule allows the master-node and node-node interaction within the security group"
    protocol          = "ANY"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    description    = "The rule allows the pod-pod and service-service interaction. Specify the subnets of your cluster and services."
    protocol       = "ANY"
    v4_cidr_blocks = [local.zone_abc_v4_cidr_blocks]
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    description    = "The rule allows receipt of debugging ICMP packets from internal subnets"
    protocol       = "ICMP"
    v4_cidr_blocks = [local.zone_abc_v4_cidr_blocks]
  }

  ingress {
    description    = "The rule allows connection to Kubernetes API on 6443 port from specified network"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 6443
  }

  ingress {
    description    = "The rule allows connection to Kubernetes API on 443 port from specified network"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    description    = "The rule allows HTTP traffic"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  egress {
    description    = "The rule allows all outgoing traffic. Nodes can connect to Yandex Container Registry, Object Storage, Docker Hub, and more."
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "k8s-public-services" {
  description = "Security group allows connections to services from the internet. Apply the rules only for node groups."
  name        = local.public_services_sg_name
  network_id  = yandex_vpc_network.vpc.id

  ingress {
    description    = "The rule allows incoming traffic from the internet to the NodePort port range. Add ports or change existing ones to the required ports."
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }
}

resource "yandex_iam_service_account" "k8s-sa" {
  description = "Service account to manage the Kubernetes cluster and node group"
  name        = var.sa_name
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
    version = var.k8s_version
    regional {
      region = "ru-central1"
      location {
        zone      = yandex_vpc_subnet.public-subnet-a.zone
        subnet_id = yandex_vpc_subnet.public-subnet-a.id
      }
      location {
        zone      = yandex_vpc_subnet.public-subnet-b.zone
        subnet_id = yandex_vpc_subnet.public-subnet-b.id
      }
      location {
        zone      = yandex_vpc_subnet.public-subnet-c.zone
        subnet_id = yandex_vpc_subnet.public-subnet-c.id
      }
    }

    public_ip = true

    security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id]

  }
  service_account_id      = yandex_iam_service_account.k8s-sa.id # Cluster service account ID
  node_service_account_id = yandex_iam_service_account.k8s-sa.id # Node group service account ID
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
  name        = var.sa_alb
}

# Assign "alb.editor" role to service account
resource "yandex_resourcemanager_folder_iam_binding" "alb-editor" {
  folder_id = var.folder_id
  role      = "alb.editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-alb.id}"
  ]
}

# Assign "vpc.publicAdmin" role to service account
resource "yandex_resourcemanager_folder_iam_binding" "vpc-publicAdmin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-alb.id}"
  ]
}

# Assign "certificate-manager.certificates.downloader" role to service account
resource "yandex_resourcemanager_folder_iam_binding" "certificates-downloader" {
  folder_id = var.folder_id
  role      = "certificate-manager.certificates.downloader"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-alb.id}"
  ]
}

# Assign "compute.viewer" role to service account
resource "yandex_resourcemanager_folder_iam_binding" "compute-viewer" {
  folder_id = var.folder_id
  role      = "compute.viewer"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-alb.id}"
  ]
}

resource "yandex_iam_service_account_key" "sa-auth-key" {
  description        = "Authorized key for service accaunt"
  service_account_id = yandex_iam_service_account.sa-alb.id
}

# Local file with authorized key data
resource "local_sensitive_file" "key-json" {
  content = jsonencode({
    "id" : "${yandex_iam_service_account_key.sa-auth-key.id}",
    "service_account_id" : "${yandex_iam_service_account.sa-alb.id}",
    "created_at" : "${yandex_iam_service_account_key.sa-auth-key.created_at}",
    "key_algorithm" : "${yandex_iam_service_account_key.sa-auth-key.key_algorithm}",
    "public_key" : "${yandex_iam_service_account_key.sa-auth-key.public_key}",
    "private_key" : "${yandex_iam_service_account_key.sa-auth-key.private_key}"
  })
  filename = "key.json"
}

variable "key_json_data" {
  description = "JSON data for the key"
  type        = string
  default     = <<EOT
{
  "id" : yandex_iam_service_account_key.sa-auth-key.id,
  "service_account_id" : yandex_iam_service_account.sa-alb.id,
  "created_at" : yandex_iam_service_account_key.sa-auth-key.created_at,
  "key_algorithm" : yandex_iam_service_account_key.sa-auth-key.key_algorithm,
  "public_key" : yandex_iam_service_account_key.sa-auth-key.public_key,
  "private_key" : yandex_iam_service_account_key.sa-auth-key.private_key
}
EOT
}
