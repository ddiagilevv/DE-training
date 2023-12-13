terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

module "mysql" {
  source = "./modules/mysql"
}

#module "snowflake" {
#  source = "./modules/snowflake"
#}
