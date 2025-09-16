# variables.tf

variable "github_token" {
  description = "GitHub Personal Access Token for updating secrets"
  type        = string
  sensitive   = true
}

variable "github_repo" {
  description = "GitHub repository name (e.g., my-vue-website)"
  type        = string
  default     = "aaniraikaaththal"  # 👈 Replace with your repo name
}