module "deepmerge" {
  source = "../../"
  maps   = var.input_maps
}

locals {
  err_msg = <<EOF
Test "${var.test_key}": module output does not match expected output. Expected:
${jsonencode(var.expected_output)}

Received:
${jsonencode(module.deepmerge.merged)}
EOF
}

module "assert_correct_output" {
  source        = "Invicton-Labs/assertion/null"
  version       = "~> 0.2.1"
  error_message = local.err_msg
  condition     = module.deepmerge.merged == var.expected_output
}
