variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

variable "environment" {
    description = "The environment will be applied as tag"
}

variable "location" {
    description = "The location where to put it"
}