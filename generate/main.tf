module "depth_file" {
  source               = "Invicton-Labs/file-data/local"
  version              = "~> 0.1.0"
  content              = templatefile("${path.module}/depth.tmpl", { max_depth = var.max_depth })
  filename             = "${path.module}/../depth.tf"
  force_wait_for_apply = true
}
