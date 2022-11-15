provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${var.dev_account}:role/OrganizationAccountAccessRole"
  }
  region = var.region
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${var.dev_account}:role/OrganizationAccountAccessRole"
  }
  region = var.rds_backup_region
  alias  = "rds_backup"
}

provider "aws" {
  region = var.region
  alias  = "root"

}
