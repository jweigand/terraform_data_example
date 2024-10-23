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

resource "terraform_data" "bootstrap" {
  triggers_replace = var.triggers_replace

  provisioner "local-exec" {
    command = "echo this only happens on first create or when the triggers change"
  }
}

resource "random_pet" "this" {
  length = 3
}
