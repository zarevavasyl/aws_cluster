### Creating a Kubernetes cluster in AWS.

The following modules are used:<br />
https://github.com/zarevavasyl/aws_network<br />
https://github.com/zarevavasyl/aws_eks


* Create a terraform.tfvars file (sample file - terraform.tfvars.sample). Specify the following parameters:<br />
desired_size - The number of nodes in the cluster<br />
aws_region - Region where all resources will be created<br />
kube_config - The location of the kube_config file<br />