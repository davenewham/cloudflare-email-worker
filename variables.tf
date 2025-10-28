variable "cloudflare_account_id" { type = string }
variable "cloudflare_zone_id" { type = string }
variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "domain" { type = string }
variable "email_address" { type = string }

variable "telegram_token" {
  type      = string
  sensitive = true
}

variable "telegram_channel_id" {
  type      = string
  sensitive = true
}

variable "worker_script_path" { type = string }
