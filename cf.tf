variable "account_id" {
  default = "replace_me"
}

resource "cloudflare_worker" "my_worker" {
  account_id = var.account_id
  name = "my-worker"
  observability = {
    enabled = true
  }
}

resource "cloudflare_worker_version" "my_worker_version" {
  account_id = var.account_id
  worker_id = cloudflare_worker.my_worker.id
  compatibility_date = "$today"
  main_module = "my-script.mjs"
  modules = [
    {
      name = "my-script.mjs"
      content_type = "application/javascript+module"
      # Replacement (version creation) is triggered whenever this file changes
      content_file = "my-script.mjs"
    }
  ]
}

resource "cloudflare_workers_deployment" "my_worker_deployment" {
  account_id = var.account_id
  script_name = cloudflare_worker.my_worker.name
  strategy = "percentage"
  versions = [{
    percentage = 100
    version_id = cloudflare_worker_version.my_worker_version.id
  }]
}
