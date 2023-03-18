locals {
  // If no maps are passed in, we have to provide a default empty map for this module to work with
  // We have to use concat instead of a simple ternary operator since Terraform will try to convert the 
  // objects on both side of the ternary to the same type
  input_maps = concat(var.maps, length(var.maps) == 0 ? [{}] : [])
}
