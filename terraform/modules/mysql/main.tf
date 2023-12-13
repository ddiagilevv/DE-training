terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      #version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}

# Создание сети Docker, если она еще не существует
resource "docker_network" "mysql_network" {
  name = "mysql_network"
}

# Загрузка образа MySQL
resource "docker_image" "mysql" {
  name = "mysql:latest"
}

# Создание контейнера MySQL
resource "docker_container" "mysql_container" {
  image = docker_image.mysql.latest
  name  = "mysql-container"
  network_mode = docker_network.mysql_network.name
  volumes {
    container_path = "/var/lib/mysql"
    host_path      = "/mysql-data"
  }
  env = [
    "MYSQL_ROOT_PASSWORD=rootpassword",
    "MYSQL_DATABASE=TastePoint_target",
    "MYSQL_USER=user",
    "MYSQL_PASSWORD=password"
  ]
  ports {
    internal = 3306
    external = 3306
  }
}










#resource "null_resource" "docker_run" {

#  provisioner "local-exec" {
#    command = <<-EOT
#      docker network create mysql_network
#    EOT
#  }

#  provisioner "local-exec" {
#    command = <<-EOT
#      docker network create mysql_network
#      docker run -d --name mysql-container --network mysql_network -v mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=TastePoint_target -e MYSQL_USER=user -e MYSQL_PASSWORD=password -p 3306:3306 mysql:latest
#    EOT
#  }
#}


#variable "mysql_root_password" {
#  description = "The root password for the MySQL database"
#  type        = string
#}

#resource "null_resource" "docker_run" {
#  provisioner "local-exec" {
#    command = "docker run --name mysql-container -v mysql-volume:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=${var.mysql_root_password} -p 3306:3306 -d mysql:latest"
#  }

  // Остальная часть кода ...
#}
