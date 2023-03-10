variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable aws_region {
    default = "eu-west-1"
}

variable desired_size {
    default = "2"
}