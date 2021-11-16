variable "name" { }
variable "namespace" { }

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "test" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_role" "example" {
  metadata {
    namespace = kubernetes_namespace.test.metadata[0].name
    name      = "no_auth_users_role"
  }

  rule {
    api_groups     = ["*"]
    resources      = ["pods"]
    resource_names = [""]
    verbs          = ["*"]
  }
}

resource "kubernetes_role_binding" "example" {
  metadata {
    namespace = kubernetes_namespace.test.metadata[0].name
    name      = "no_auth_users_role_binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.example.metadata[0].name
  }
  subject {
    kind      = "User"
    name      = var.name
    namespace = ""
    api_group = "rbac.authorization.k8s.io"
  }
}