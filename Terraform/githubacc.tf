resource "yandex_iam_service_account" "github_actions" {
  name        = "github-actions"
  description = "Service account for GitHub Actions"
}

resource "yandex_iam_service_account_key" "github_actions_key" {
  service_account_id = yandex_iam_service_account.github_actions.id
}

resource "yandex_resourcemanager_folder_iam_binding" "github_actions_role" {
  folder_id = var.folder_id
  role      = "editor"
  members   = ["serviceAccount:${yandex_iam_service_account.github_actions.id}"]

  bindings {
    role = "roles/container.clusterAdmin"
    members = [
      "serviceAccount:${yandex_iam_service_account.github_actions.id}"
    ]
  }

  bindings {
    role = "roles/container.developer"
    members = [
      "serviceAccount:${yandex_iam_service_account.github_actions.id}"
    ]
  }

  bindings {
    role = "roles/container.viewer"
    members = [
      "serviceAccount:${yandex_iam_service_account.github_actions.id}"
    ]
  }

  bindings {
    role = "roles/container.admin"
    members = [
      "serviceAccount:${yandex_iam_service_account.github_actions.id}"
    ]
  }

  bindings {
    role = "roles/container.viewer"
    members = [
      "serviceAccount:${yandex_iam_service_account.github_actions.id}"
    ]
  }

  bindings {
    role = "roles/container.worker"
    members = [
      "serviceAccount:${yandex_iam_service_account.github_actions.id}"
    ]
  }
}

output "github_actions_secret" {
  value = nonsensitive(yandex_iam_service_account_key.github_actions_key.secret)
}
