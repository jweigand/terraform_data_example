terraform {
  required_version = ">= 1.8"

  cloud {
    organization = "weigand-hcp"
    hostname     = "app.terraform.io"

    workspaces {
      name = "tf_data_ephemeral_resource"
    }
  }

  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
}

variable "triggers_replace" {
  default = "demo"
}

resource "terraform_data" "var_based" {
  triggers_replace = var.triggers_replace

  provisioner "local-exec" {
    command = "echo this only happens on first create or when the variable changes"
  }
}

resource "random_pet" "this" {
  length = 4
}

resource "terraform_data" "res_based" {
  triggers_replace = random_pet.this.id

  provisioner "local-exec" {
    command = "echo this only happens on first create or when the resource changes"
  }
}

resource "terraform_data" "string_based" {
  triggers_replace = "demo1"

  provisioner "local-exec" {
    command = "echo this only happens on first create or when the string changes"
  }
}

output "test" {
  value = length(terraform_data.string_based)
}

output "test1" {
  value = terraform_data.string_based
}

module "data" {
  source  = "app.terraform.io/weigand-hcp/data/terraform"
  version = "2.0.0"
}
