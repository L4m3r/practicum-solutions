terraform {
  backend "s3" {
    region = "ru-central1"
    bucket = "terraform-state-bucket-l4m3r"
    key    = "terraform.tfstate"

    dynamodb_table = "state-lock-table"

    endpoints = {
      s3       = "https://storage.yandexcloud.net",
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g7n9hu3fl3q03p9emk/etns34nf8j7adf6fu9am"
    }

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
