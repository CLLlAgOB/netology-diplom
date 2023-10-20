resource "yandex_iam_service_account" "github_actions" {
  name        = "github-actions"
  description = "Service account for GitHub Actions"
}

resource "yandex_iam_service_account_key" "github_actions_key" {
  service_account_id = yandex_iam_service_account.github_actions.id
}

# Assign "editor" role to Kubernetes service account
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.github_actions.id}"
  ]
}

# Assign "container-registry.images.pusher" role to Kubernetes service account
resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.pusher"
  members = [
    "serviceAccount:${yandex_iam_service_account.github_actions.id}"
  ]
}

locals {
  key_json = jsonencode({
    id             = yandex_iam_service_account_key.github_actions_key.id,
    service_account_id = yandex_iam_service_account.github_actions.id,
    created_at     = yandex_iam_service_account_key.github_actions_key.created_at,
    key_algorithm  = yandex_iam_service_account_key.github_actions_key.key_algorithm,
    public_key     = yandex_iam_service_account_key.github_actions_key.public_key,
    private_key    = yandex_iam_service_account_key.github_actions_key.private_key
  })
}

output "github_actions_key" {
  value = nonsensitive(local.key_json)
}