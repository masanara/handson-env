resource "kubernetes_service_account" "handson_sa" {
  metadata {
    name      = "nos-handson"
    namespace = "kube-system"
  }
}

resource "kubernetes_service_account" "aws-load-balancer-controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = "${aws_iam_role.aws-load-balancer-controller.arn}"
    }
  }
}

resource "kubernetes_secret" "handson_secret" {
  metadata {
    name        = "nos-handson-secret"
    namespace   = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = "nos-handson"
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_cluster_role_binding" "handson" {
  metadata {
    name = "nos-handson"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "nos-handson"
    namespace = "kube-system"
  }
}
