variable "cloudflare_api_token" { type = string sensitive = true }

variable "cloudflare_account_id" { type = string }
variable "domain" { type = string }
variable "email_address" { type = string }

variable "telegram_token" { 
	type = string 
	sensitive = true
}

variable "telegram_chat_id" { 
	type = string 
	sensitive = true
}
