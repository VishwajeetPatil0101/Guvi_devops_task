provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

variable "primary_region" {
  type    = string
  default = "ap-northeast-3"
}

variable "secondary_region" {
  type    = string
  default = "ap-northeast-2"
}


