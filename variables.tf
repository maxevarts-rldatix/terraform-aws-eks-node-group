variable "enable_cluster_autoscaler" {
  type        = bool
  description = "Whether to enable node group to scale the Auto Scaling Group"
  default     = false
}

variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

variable "ec2_ssh_key" {
  type        = string
  description = "SSH key name that should be used to access the worker nodes"
  default     = null
}

variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes (external changes ignored)"
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes"
}

variable "min_size" {
  type        = number
  description = "Minimum number of worker nodes"
}

variable "subnet_ids" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
}

variable "existing_workers_role_policy_arns" {
  type        = list(string)
  default     = []
  description = "List of existing policy ARNs that will be attached to the workers default role on creation"
}

variable "existing_workers_role_policy_arns_count" {
  type        = number
  default     = 0
  description = "Count of existing policy ARNs that will be attached to the workers default role on creation. Needed to prevent Terraform error `count can't be computed`"
}

variable "ami_type" {
  type        = string
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to `AL2_x86_64`. Valid values: `AL2_x86_64`, `AL2_x86_64_GPU`. Terraform will only perform drift detection if a configuration value is provided"
  default     = "AL2_x86_64"
}

variable "disk_size" {
  type        = number
  description = "Disk size in GiB for worker nodes. Defaults to 20. Terraform will only perform drift detection if a configuration value is provided"
  default     = 20
}

variable "instance_types" {
  type        = list(string)
  description = "Set of instance types associated with the EKS Node Group. Defaults to [\"t3.medium\"]. Terraform will only perform drift detection if a configuration value is provided"
  default     = ["t3.medium"]

  validation {
    condition = (
      length(var.instance_types) == 1
    )
    error_message = "Per the EKS API, only a single instance type value is currently supported."
  }
}

variable "kubernetes_labels" {
  type        = map(string)
  description = "Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed"
  default     = {}
}

variable "ami_release_version" {
  type        = string
  description = "AMI version of the EKS Node Group. Defaults to latest version for Kubernetes version"
  default     = null
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version. Defaults to EKS Cluster Kubernetes version. Terraform will only perform drift detection if a configuration value is provided"
  default     = null
}

variable "source_security_group_ids" {
  type        = list(string)
  default     = []
  description = "Set of EC2 Security Group IDs to allow SSH access (port 22) from on the worker nodes. If you specify `ec2_ssh_key`, but do not specify this configuration when you create an EKS Node Group, port 22 on the worker nodes is opened to the Internet (0.0.0.0/0)"
}

variable "module_depends_on" {
  type        = any
  default     = null
  description = "Can be any value desired. Module will wait for this value to be computed before creating node group."
}

variable "launch_template_id" {
  type        = string
  description = "The ID of a custom launch template to use for the EKS node group."
  default     = null
}

variable "launch_template_version" {
  type        = string
  description = "A specific version of the above specific launch template"
  default     = null
}

variable "bootstrap_extra_args" {
  type        = string
  default     = ""
  description = "Extra arguments to the `bootstrap.sh` script to enable `--enable-docker-bridge` or `--use-max-pods`"
}

variable "kubelet_extra_args" {
  type        = string
  default     = ""
  description = "Extra arguments to pass to kubelet, like \"--register-with-taints=dedicated=ci-cd:NoSchedule --node-labels=purpose=ci-worker\""
}

variable "before_cluster_joining_userdata" {
  type        = string
  default     = ""
  description = "Additional commands to execute on each worker node before joining the EKS cluster (before executing the `bootstrap.sh` script). For more info, see https://kubedex.com/90-days-of-aws-eks-in-production"
}

variable "after_cluster_joining_userdata" {
  type        = string
  default     = ""
  description = "Additional commands to execute on each worker node after joining the EKS cluster (after executing the `bootstrap.sh` script). For more info, see https://kubedex.com/90-days-of-aws-eks-in-production"
}
