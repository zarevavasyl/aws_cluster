module "aws_eks" {
  source = "git::https://github.com/zarevavasyl/aws_eks.git?ref=v1.0.0"

  desired_size                  = "1"
  aws_subnet_private_1a         = data.aws_subnet.private-eu-west-1a.id
  aws_subnet_private_1b         = data.aws_subnet.private-eu-west-1b.id
  aws_subnet_public_1a          = data.aws_subnet.public-eu-west-1a.id
  aws_subnet_public_1b          = data.aws_subnet.public-eu-west-1b.id
}

module "aws_network" {
  source = "git::https://github.com/zarevavasyl/aws_network.git?ref=v1.0.0"
}

data "aws_subnet" "private-eu-west-1a" {
  depends_on = [
    module.aws_network
  ]

  filter {
    name   = "tag:Name"
    values = ["private-eu-west-1a"]
  }
}

data "aws_subnet" "private-eu-west-1b" {
  depends_on = [
    module.aws_network
  ]
  
  filter {
    name   = "tag:Name"
    values = ["private-eu-west-1b"]
  }
}

data "aws_subnet" "public-eu-west-1a" {
  depends_on = [
    module.aws_network
  ]
  
  filter {
    name   = "tag:Name"
    values = ["public-eu-west-1a"]
  }
}

data "aws_subnet" "public-eu-west-1b" {
  depends_on = [
    module.aws_network
  ]
  
  filter {
    name   = "tag:Name"
    values = ["public-eu-west-1b"]
  }
}

resource "null_resource" "add-kubeconfig-local" {

  depends_on = [
    module.aws_eks
  ]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region eu-west-1 --name demo"
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