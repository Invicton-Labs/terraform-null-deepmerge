output "merged" {
  description = "The merged map."
  value       = module.asset_sufficient_levels.checked ? local.m0 : null
}
