output "merged" {
  description = "The merged map."
  value       = local.m0
}

output "fields_json" {
  description = "For each input map, convert it to a single-level map with a unique key for every nested value"
  value = local.fields_json
}