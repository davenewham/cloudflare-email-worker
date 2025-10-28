resource "terraform_data" "build" {
  provisioner "local-exec" {
    command = "npm run build"
  }
}

resource "cloudflare_worker" "email_telegram_worker" {
  account_id = var.cloudflare_account_id
  name       = "email-telegram-worker"

  observability = {
    enabled = true
  }
}

resource "cloudflare_worker_version" "email_telegram_worker_version" {
  account_id  = var.cloudflare_account_id
  worker_id   = cloudflare_worker.email_telegram_worker.id
  main_module = "index.js"

  bindings = [
    {
      name = "BOT_TOKEN"
      text = var.telegram_token
      type = "secret_text"
    },
    {
      name = "CHANNEL_ID"
      text = var.telegram_channel_id
      type = "secret_text"
    }
  ]

  modules = [{
    name         = "index.js"
    content_file = "${path.module}/${var.worker_script_path}"
    content_type = "application/javascript+module"
  }]

  depends_on = [terraform_data.build]
}

resource "cloudflare_workers_deployment" "email_telegram_worker_deployment" {
  account_id  = var.cloudflare_account_id
  script_name = cloudflare_worker.email_telegram_worker.name
  strategy    = "percentage"

  versions = [{
    version_id = cloudflare_worker_version.email_telegram_worker_version.id
    percentage = 100
  }]
}

resource "cloudflare_email_routing_rule" "tg" {
  zone_id = var.cloudflare_zone_id
  name    = "Send email bodies to telegram"
  enabled = true

  matchers = [{
    type  = "literal"
    field = "to"
    value = var.email_address
  }]

  actions = [{
    type  = "worker"
    value = [cloudflare_worker.email_telegram_worker.name]
  }]

  depends_on = [
    cloudflare_workers_deployment.email_telegram_worker_deployment
  ]
}
