resource "kubernetes_service" "mysql-server" {
  metadata {
    name = "mysql"
  }

  spec {
    port {
      port        = 3306
      target_port = var.mysql_port
    }
  }
}

resource "kubernetes_endpoints" "mysql-server" {
  metadata {
    name = "mysql"
  }
  subset {
    address {
      ip = var.database_server_private_ip
    }

    port {
      port = var.mysql_port
    }
  }
}

resource "kubernetes_service" "mysql-pc-server" {
  metadata {
    name = "mysql-pc"
  }

  spec {
    port {
      port        = 3306
      target_port = var.mysql_pc_port
    }
  }
}

resource "kubernetes_endpoints" "mysql-pc-server" {
  metadata {
    name = "mysql-pc"
  }
  subset {
    address {
      ip = var.database_server_private_ip
    }

    port {
      port = var.mysql_pc_port
    }
  }
}