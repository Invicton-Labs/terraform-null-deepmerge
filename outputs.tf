/*
output "merged" {
  description = "The merged map."
  value = module.assert_sufficient_levels.checked ? local.reconstructed_1 : null
}
*/
output "flattened_maps" {
  value = local.flattened_maps
}

output "depth_0" {
  value = local.depth_0
}
output "depth_1" {
  value = local.depth_1
}
output "depth_2" {
  value = local.depth_2
}
output "depth_3" {
  value = local.depth_3
}
output "depth_4" {
  value = local.depth_4
}

output "items_by_key_0" {
  value = local.items_by_key_0
}
output "items_by_key_1" {
  value = local.items_by_key_1
}
output "items_by_key_2" {
  value = local.items_by_key_2
}
output "items_by_key_3" {
  value = local.items_by_key_3
}
output "items_by_key_4" {
  value = local.items_by_key_4
}

/*
output "merged_flattened_maps" {
  value = local.merged_flattened_maps
}
output "reconstructed_3" {
  value = local.reconstructed_3
}
output "reconstructed_2" {
  value = local.reconstructed_2
}
output "reconstructed_1" {
  value = local.reconstructed_1
}
*/
