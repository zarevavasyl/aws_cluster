module "aws_eks" {
  source = "git::https://github.com/zarevavasyl/aws_eks.git?ref=v2.0.0"

  desired_size                  = var.desired_size
  aws_subnet_private_1a         = data.aws_subnet.private-1a.id
  aws_subnet_private_1b         = data.aws_subnet.private-1b.id
  aws_subnet_public_1a          = data.aws_subnet.public-1a.id
  aws_subnet_public_1b          = data.aws_subnet.public-1b.id
}

module "aws_network" {
  source = "git::https://github.com/zarevavasyl/aws_network.git?ref=v2.0.0"
  aws_region                    = var.aws_region
}

data "aws_subnet" "private-1a" {
  depends_on = [
    module.aws_network
  ]

  filter {
    name   = "tag:Name"
    values = ["private-1a"]
  }
}

data "aws_subnet" "private-1b" {
  depends_on = [
    module.aws_network
  ]
  
  filter {
    name   = "tag:Name"
    values = ["private-1b"]
  }
}

data "aws_subnet" "public-1a" {
  depends_on = [
    module.aws_network
  ]
  
  filter {
    name   = "tag:Name"
    values = ["public-1a"]
  }
}

data "aws_subnet" "public-1b" {
  depends_on = [
    module.aws_network
  ]
  
  filter {
    name   = "tag:Name"
    values = ["public-1b"]
  }
}

resource "null_resource" "add-kubeconfig-local" {

  depends_on = [
    module.aws_eks
  ]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name demo"
  }
}

resource "helm_release" "example-nginx" {

  depends_on = [
    null_resource.add-kubeconfig-local
  ]

  name       = "nginx-helm"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
}