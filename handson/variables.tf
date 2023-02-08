variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
  default = "ap-northeast-1"
}

variable "instance_number" {
  type = number
  default = 0
}

variable "eks_cluster_name" {
  type = string
  default = "prod"
}

variable "aws_availability_zones" {
  type = string
  default = "asia-northeast-1a"
}

variable "key_name" {
  type = string
  default = "handson"
}

variable "mgmt_ip" {
  type = list(string)
  default = ["192.168.0.0/24"]
}

variable "ami_id" {
  type = string
}

variable "public_key" {
  type = string
}

variable "eks_addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = [
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.15.0-eksbuild.1"
    },
    {
      name    = "kube-proxy"
      version = "v1.24.9-eksbuild.1"
    },
    {
      name    = "vpc-cni"
      version = "v1.12.1-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.8.7-eksbuild.3"
    }
  ]
}
