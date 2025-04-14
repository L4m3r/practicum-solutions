terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 1.00"
  backend "s3" {
    endpoints = {
      s3       = "https://storage.yandexcloud.net"
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g7352p8pn6mut3ksn2/etneqk653jhjr357mutc"
    }
    bucket = "l4m3r-terraform-state-bucket-ymi2h5"
    region = "ru-central1"
    key    = "practicum/terraform/infra_stage.tfstate"

    dynamodb_table = "state-lock-table"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  zone      = "ru-central1-a"
  folder_id = "b1grqk4ls5g6lli03v8s"
}
