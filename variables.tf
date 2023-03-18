variable "maps" {
  description = "A list of maps to merge. Maps should be ordered in increasing precedence, i.e. values in a map later in the list will overwrite values in a map earlier in the list."
  type        = any
  validation {
    // Ensure we can get a length, which restricts to maps, lists, sets, and strings
    // Ensure it's not a string, which restricts to maps, lists, and sets
    // Ensure we can't get its keys, which restricts to lists and sets
    condition     = can(length(var.maps)) && !can(tostring(var.maps)) && !can(keys(var.maps))
    error_message = "The `maps` variable must be a list or set of maps and/or objects. The provided value is not a list or set."
  }
  validation {
    condition = length([
      for mp in var.maps :
      null
      if !can(keys(mp))
    ]) == 0
    error_message = "The `maps` variable must be a list of maps and/or objects. Not all elements meet this requirement."
  }
}
/*
variable "null_into_non_null_behaviour" {
  description = "The behaviour to follow for merging `null` values into existing values. Options are `OVERWRITE` (the default, where the null value overwrites the existing value or follows the relevant values for the `primitive_into_sequence_behaviour` variable), `IGNORE` (null value is ignored and does not overwrite anything), or `REMOVE` (the key that has a null value will not appear in the final map, unless an input map with higher precedence has the same key and a non-null value)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "IGNORE", "REMOVE"], var.null_into_non_null_behaviour)
    error_message = "The `null_into_non_null_behaviour` variable must be `OVERWRITE`, `IGNORE`, or `REMOVE`."
  }
}

variable "primitive_into_list_behaviour" {
  description = "The behaviour to follow for merging primitive values (null, strings, or numbers) into lists. Options are `OVERWRITE` (the default, where the primitive being merged in replaces the existing list), `APPEND` (the primitive being merged in gets appended to the list), `PREPEND` (the primitive being merged in gets prepended to the list), or `IGNORE` (the primitive being merged in is ignored and the existing list remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "APPEND", "PREPEND", "IGNORE"], var.primitive_into_list_behaviour)
    error_message = "The `primitive_into_list_behaviour` variable must be `OVERWRITE`, `APPEND`, `PREPEND`, or `IGNORE`."
  }
}

variable "primitive_into_set_behaviour" {
  description = "The behaviour to follow for merging primitive values (null, strings, or numbers) into sets. Options are `OVERWRITE` (the default, where the primitive being merged in replaces the existing set), `ADD` (the primitive being merged in gets added to the existing set), or `IGNORE` (the primitive being merged in is ignored and the existing set remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "ADD", "IGNORE"], var.primitive_into_set_behaviour)
    error_message = "The `primitive_into_set_behaviour` variable must be `OVERWRITE`, `ADD`, or `IGNORE`."
  }
}

variable "primitive_into_mapping_behaviour" {
  description = "The behaviour to follow for merging primitive values (null, strings, or numbers) into mappings (maps or objects). Options are `OVERWRITE` (the default, where the primitive being merged in replaces the existing mapping) or `IGNORE` (the primitive being merged in is ignored and the existing mapping remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "IGNORE"], var.primitive_into_mapping_behaviour)
    error_message = "The `primitive_into_mapping_behaviour` variable must be `OVERWRITE` or `IGNORE`."
  }
}

variable "list_into_primitive_behaviour" {
  description = "The behaviour to follow for merging lists into primitive values (null, strings, or numbers). Options are `OVERWRITE` (the default, list being merged in replaces the existing primitive), `APPEND` (the existing primitive gets appended to the list being merged in), `PREPEND` (the existing primitive gets prepended to the list being merged in), or `IGNORE` (the list being merged in is ignored and the existing primitive remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "APPEND", "PREPEND", "IGNORE"], var.list_into_primitive_behaviour)
    error_message = "The `list_into_primitive_behaviour` variable must be `OVERWRITE`, `APPEND`, `PREPEND`, or `IGNORE`."
  }
}

variable "list_into_list_behaviour" {
  description = "The behaviour to follow for merging lists into other lists. Options are `OVERWRITE` (the default, where the list being merged in replaces the existing list), `APPEND` (the list being merged in gets appended as an individual element to the end of the existing list), `PREPEND` (the list being merged in gets prepended as an individual element to the beginning of the existing list), `CONCAT_RIGHT` (all elements of the list being merged in get appended to the end of the existing list), `CONCAT_LEFT` (all elements of the list being merged in get prepended to the beginning of the existing list), or `IGNORE` (the list being merged in is ignored and the existing list remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "APPEND", "PREPEND", "CONCAT_RIGHT", "CONCAT_LEFT", "IGNORE"], var.list_into_list_behaviour)
    error_message = "The `list_into_list_behaviour` variable must be `OVERWRITE`, `APPEND`, `PREPEND`, `CONCAT_RIGHT`, `CONCAT_LEFT`, or `IGNORE`."
  }
}

variable "list_into_set_behaviour" {
  description = "The behaviour to follow for merging lists into sets. Options are `OVERWRITE` (the default, where the list being merged in replaces the existing set), `UNION` (the list being merged in is joined with the existing set to produce a new set), or `IGNORE` (the list being merged in is ignored and the existing set remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "UNION", "IGNORE"], var.list_into_set_behaviour)
    error_message = "The `list_into_set_behaviour` variable must be `OVERWRITE`, `UNION`, or `IGNORE`."
  }
}

variable "list_into_mapping_behaviour" {
  description = "The behaviour to follow for merging lists into mappings (maps or objects). Options are `OVERWRITE` (the default, where the list being merged in replaces the existing mapping) or `IGNORE` (the list being merged in is ignored and the existing mapping remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "IGNORE"], var.list_into_mapping_behaviour)
    error_message = "The `list_into_mapping_behaviour` variable must be `OVERWRITE` or `IGNORE`."
  }
}

variable "set_into_primitive_behaviour" {
  description = "The behaviour to follow for merging sets into primitive values (null, strings, or numbers). Options are `OVERWRITE` (the default, where the set being merged in replaces the existing primitive), `ADD` (the primitive gets added to the set), or `IGNORE` (the set being merged in is ignored and the existing primitive remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "ADD", "IGNORE"], var.set_into_primitive_behaviour)
    error_message = "The `set_into_primitive_behaviour` variable must be `OVERWRITE`, `ADD`, or `IGNORE`."
  }
}

variable "set_into_set_behaviour" {
  description = "The behaviour to follow for merging sets into other sets. Options are `OVERWRITE` (the default, where the set being merged in replaces the existing set), `UNION` (the set being merged in is joined with the existing set to produce a new set), or `IGNORE` (the set being merged in is ignored and the existing set remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "UNION", "IGNORE"], var.set_into_set_behaviour)
    error_message = "The `set_into_set_behaviour` variable must be `OVERWRITE`, `UNION`, or `IGNORE`."
  }
}

variable "set_into_list_behaviour" {
  description = "The behaviour to follow for merging sets into lists. Options are `OVERWRITE` (the default, where the set being merged in replaces the existing set), `UNION` (the set being merged in is joined with the existing list to produce a new set), or `IGNORE` (the set being merged in is ignored and the existing list remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "UNION", "IGNORE"], var.set_into_list_behaviour)
    error_message = "The `set_into_list_behaviour` variable must be `OVERWRITE`, `UNION`, or `IGNORE`."
  }
}

variable "set_into_mapping_behaviour" {
  description = "The behaviour to follow for merging sets into mappings (maps or objects). Options are `OVERWRITE` (the default, where the set being merged in replaces the existing mapping) or `IGNORE` (the set being merged in is ignored and the existing mapping remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "IGNORE"], var.set_into_mapping_behaviour)
    error_message = "The `set_into_mapping_behaviour` variable must be `OVERWRITE` or `IGNORE`."
  }
}

variable "mapping_into_primitive_behaviour" {
  description = "The behaviour to follow for merging mappings (maps or objects) into primitive values (null, strings, or numbers). Options are `OVERWRITE` (the default, where the mapping being merged in replaces the existing primitive) or `IGNORE` (the mapping being merged in is ignored and the existing primitive remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "IGNORE"], var.mapping_into_primitive_behaviour)
    error_message = "The `mapping_into_primitive_behaviour` variable must be `OVERWRITE` or `IGNORE`."
  }
}

variable "mapping_into_list_behaviour" {
  description = "The behaviour to follow for merging mappings (maps or objects) into lists. Options are `OVERWRITE` (the default, where the mapping being merged in replaces the existing list) or `IGNORE` (the mapping being merged in is ignored and the existing list remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "IGNORE"], var.mapping_into_list_behaviour)
    error_message = "The `mapping_into_list_behaviour` variable must be `OVERWRITE` or `IGNORE`."
  }
}

variable "mapping_into_set_behaviour" {
  description = "The behaviour to follow for merging mappings (maps or objects) into sets. Options are `OVERWRITE` (the default, where the mapping being merged in overwrites the existing set) or `IGNORE` (the mapping being merged in is ignored and the existing set remains unaltered)."
  type        = string
  default     = "OVERWRITE"
  validation {
    condition     = contains(["OVERWRITE", "IGNORE"], var.mapping_into_set_behaviour)
    error_message = "The `mapping_into_set_behaviour` variable must be `OVERWRITE` or `IGNORE`."
  }
}

variable "mapping_into_mapping_behaviour" {
  description = "The behaviour to follow for merging mappings (maps or objects) into other mappings. Options are `DEEPMERGE_ALL` (the default, where the entire map is deep merged and key/values in the mapping being merged in overwrite keys with the same name in the existing mapping), `DEEPMERGE_NEW` (same as `DEEPMERGE_ALL` except that in the case of duplicate keys existing values are kept and not overwritten), `OVERWRITE` (the mapping being merged in replaces the existing mapping), or `IGNORE` (the mapping being merged in is ignored and the existing mapping remains)."
  type        = string
  default     = "DEEPMERGE_ALL"
  validation {
    condition     = contains(["DEEPMERGE_ALL", "DEEPMERGE_NEW", "OVERWRITE", "IGNORE"], var.mapping_into_mapping_behaviour)
    error_message = "The `mapping_into_mapping_behaviour` variable must be `DEEPMERGE_ALL`, `DEEPMERGE_NEW`, `OVERWRITE` or `IGNORE`."
  }
}
*/
