module "aws_eks" {
  source = "git::https://github.com/zarevavasyl/aws_eks.git?ref=v3.0.0"

  desired_size                  = var.desired_size
  aws_subnet_private_1a         = module.aws_network.private-1a
  aws_subnet_private_1b         = module.aws_network.private-1b
  aws_subnet_public_1a          = module.aws_network.public-1a
  aws_subnet_public_1b          = module.aws_network.public-1b
}

module "aws_network" {
  source = "git::https://github.com/zarevavasyl/aws_network.git?ref=v5.0.3"
  aws_region                    = var.aws_region
}


# Updating local kubeconfig to allow HELM to work

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