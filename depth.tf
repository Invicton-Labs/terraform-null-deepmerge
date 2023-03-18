locals {

    map_indecies = range(0, length(local.input_maps))

    depth_0 = [
        for map_idx in local.map_indecies:
        {
            expandable = {
                for k, v in local.input_maps[map_idx]:
                jsonencode([k]) => {
                    // If you can get the keys, it's a map/object (we treat those the same)
                    // If you can concat an empty list to it, it's a list
                    typ = can(keys(v)) ? "MAPPING" : can(concat(v, [])) ? "LIST" : can(contains(v, 0)) ? "SET" : "PRIMITIVE"
                    val = v
                    path = [k]
                }
                if can(keys(v))
            }
            non_expandable = {
                for k, v in local.input_maps[map_idx]:
                jsonencode([k]) => {
                    // If you can get the keys, it's a map/object (we treat those the same)
                    // If you can concat an empty list to it, it's a list
                    typ = can(keys(v)) ? "MAPPING" : can(concat(v, [])) ? "LIST" : can(contains(v, 0)) ? "SET" : "PRIMITIVE"
                    val = v
                    path = [k]
                }
                if !can(keys(v))
            }
        }
    ]

    depth_1 = [
        for map_idx in local.map_indecies:
        {
            expandable = merge([
                for ek, ev in local.depth_0[map_idx].expandable:
                {
                    for k, v in ev.val:
                    jsonencode(concat(ev["path"], [k])) => {
                        typ = can(keys(v)) ? "MAPPING" : can(concat(v, [])) ? "LIST" : can(contains(v, 0)) ? "SET" : "PRIMITIVE"
                        val = v
                        path = concat(ev["path"], [k])
                    }
                    if can(keys(v))
                }
            ]...)
            non_expandable = merge([
                for ek, ev in local.depth_0[map_idx].expandable:
                {
                    for k, v in ev.val:
                    jsonencode(concat(ev["path"], [k])) => {
                        typ = can(keys(v)) ? "MAPPING" : can(concat(v, [])) ? "LIST" : can(contains(v, 0)) ? "SET" : "PRIMITIVE"
                        val = v
                        path = concat(ev["path"], [k])
                    }
                    if !can(keys(v))
                }
            ]...)
        }
    ]
    depth_2 = [
        for map_idx in local.map_indecies:
        {
            expandable = merge([
                for ek, ev in local.depth_1[map_idx].expandable:
                {
                    for k, v in ev.val:
                    jsonencode(concat(ev["path"], [k])) => {
                        typ = can(keys(v)) ? "MAPPING" : can(concat(v, [])) ? "LIST" : can(contains(v, 0)) ? "SET" : "PRIMITIVE"
                        val = v
                        path = concat(ev["path"], [k])
                    }
                    if can(keys(v))
                }
            ]...)
            non_expandable = merge([
                for ek, ev in local.depth_1[map_idx].expandable:
                {
                    for k, v in ev.val:
                    jsonencode(concat(ev["path"], [k])) => {
                        typ = can(keys(v)) ? "MAPPING" : can(concat(v, [])) ? "LIST" : can(contains(v, 0)) ? "SET" : "PRIMITIVE"
                        val = v
                        path = concat(ev["path"], [k])
                    }
                    if !can(keys(v))
                }
            ]...)
        }
    ]
    depth_3 = [
        for map_idx in local.map_indecies:
        {
            expandable = merge([
                for ek, ev in local.depth_2[map_idx].expandable:
                {
                    for k, v in ev.val:
                    jsonencode(concat(ev["path"], [k])) => {
                        typ = can(keys(v)) ? "MAPPING" : can(concat(v, [])) ? "LIST" : can(contains(v, 0)) ? "SET" : "PRIMITIVE"
                        val = v
                        path = concat(ev["path"], [k])
                    }
                    if can(keys(v))
                }
            ]...)
            non_expandable = merge([
                for ek, ev in local.depth_2[map_idx].expandable:
                {
                    for k, v in ev.val:
                    jsonencode(concat(ev["path"], [k])) => {
                        typ = can(keys(v)) ? "MAPPING" : can(concat(v, [])) ? "LIST" : can(contains(v, 0)) ? "SET" : "PRIMITIVE"
                        val = v
                        path = concat(ev["path"], [k])
                    }
                    if !can(keys(v))
                }
            ]...)
        }
    ]
    depth_4 = [
        for map_idx in local.map_indecies:
        {
            expandable = merge([
                for ek, ev in local.depth_3[map_idx].expandable:
                {
                    for k, v in ev.val:
                    jsonencode(concat(ev["path"], [k])) => {
                        typ = can(keys(v)) ? "MAPPING" : can(concat(v, [])) ? "LIST" : can(contains(v, 0)) ? "SET" : "PRIMITIVE"
                        val = v
                        path = concat(ev["path"], [k])
                    }
                    if can(keys(v))
                }
            ]...)
            non_expandable = merge([
                for ek, ev in local.depth_3[map_idx].expandable:
                {
                    for k, v in ev.val:
                    jsonencode(concat(ev["path"], [k])) => {
                        typ = can(keys(v)) ? "MAPPING" : can(concat(v, [])) ? "LIST" : can(contains(v, 0)) ? "SET" : "PRIMITIVE"
                        val = v
                        path = concat(ev["path"], [k])
                    }
                    if !can(keys(v))
                }
            ]...)
        }
    ]

    flattened_maps = [
        for map_idx in local.map_indecies:
        merge(
            local.depth_0[map_idx].non_expandable,
            local.depth_1[map_idx].non_expandable,
            local.depth_2[map_idx].non_expandable,
            local.depth_3[map_idx].non_expandable,
            local.depth_4[map_idx].non_expandable,
        )
    ]

    flattened_map_keys = [
        for flattened_map in local.flattened_maps:
        keys(flattened_map)
    ]

    // These get a list of all mergable values for each unique key at a given level
    items_by_key_4 = {
        for k in distinct(concat([
            for map_idx in local.map_indecies:
            keys(local.depth_4[map_idx].non_expandable)
        ]...)):
        k => [
            for map_idx in local.map_indecies:
            local.flattened_maps[map_idx][k]
            if contains(local.flattened_map_keys[map_idx], k)
        ]
    }
    items_by_key_3 = {
        for k in distinct(concat([
            for map_idx in local.map_indecies:
            keys(local.depth_3[map_idx].non_expandable)
        ]...)):
        k => [
            for map_idx in local.map_indecies:
            local.flattened_maps[map_idx][k]
            if contains(local.flattened_map_keys[map_idx], k)
        ]
    }
    items_by_key_2 = {
        for k in distinct(concat([
            for map_idx in local.map_indecies:
            keys(local.depth_2[map_idx].non_expandable)
        ]...)):
        k => [
            for map_idx in local.map_indecies:
            local.flattened_maps[map_idx][k]
            if contains(local.flattened_map_keys[map_idx], k)
        ]
    }
    items_by_key_1 = {
        for k in distinct(concat([
            for map_idx in local.map_indecies:
            keys(local.depth_1[map_idx].non_expandable)
        ]...)):
        k => [
            for map_idx in local.map_indecies:
            local.flattened_maps[map_idx][k]
            if contains(local.flattened_map_keys[map_idx], k)
        ]
    }
    items_by_key_0 = {
        for k in distinct(concat([
            for map_idx in local.map_indecies:
            keys(local.depth_0[map_idx].non_expandable)
        ]...)):
        k => [
            for map_idx in local.map_indecies:
            local.flattened_maps[map_idx][k]
            if contains(local.flattened_map_keys[map_idx], k)
        ]
    }

/*
    merged_flattened_maps = merge(local.flattened_maps...)

    distinct_paths_by_depth = [
        for depth in range(0, 6):
        distinct([
            for k, v in local.merged_flattened_maps:
            jsonencode(slice(v.path, 0, depth + 1)) => length(v.path) > depth
            if length(v.path) >= depth
        ])
    ]

    reconstructed_6 = {}
    reconstructed_5 = {
        for parent_jsonpath, parent_is_map in local.distinct_paths_by_depth[4]:
        parent_jsonpath => {
            for jsonpath, is_map in local.distinct_paths_by_depth[5]:
            is_map ? local.reconstructed_6[jsonpath] : local.merged_flattened_maps[jsonpath]
        }
        if parent_is_map
    }
    reconstructed_4 = {
        for parent_jsonpath, parent_is_map in local.distinct_paths_by_depth[3]:
        parent_jsonpath => {
            for jsonpath, is_map in local.distinct_paths_by_depth[4]:
            is_map ? local.reconstructed_5[jsonpath] : local.merged_flattened_maps[jsonpath]
        }
        if parent_is_map
    }
    reconstructed_3 = {
        for parent_jsonpath, parent_is_map in local.distinct_paths_by_depth[2]:
        parent_jsonpath => {
            for jsonpath, is_map in local.distinct_paths_by_depth[3]:
            is_map ? local.reconstructed_4[jsonpath] : local.merged_flattened_maps[jsonpath]
        }
        if parent_is_map
    }
    reconstructed_2 = {
        for parent_jsonpath, parent_is_map in local.distinct_paths_by_depth[1]:
        parent_jsonpath => {
            for jsonpath, is_map in local.distinct_paths_by_depth[2]:
            is_map ? local.reconstructed_3[jsonpath] : local.merged_flattened_maps[jsonpath]
        }
        if parent_is_map
    }
    reconstructed_1 = {
        for parent_jsonpath, parent_is_map in local.distinct_paths_by_depth[0]:
        parent_jsonpath => {
            for jsonpath, is_map in local.distinct_paths_by_depth[1]:
            is_map ? local.reconstructed_2[jsonpath] : local.merged_flattened_maps[jsonpath]
        }
        if parent_is_map
    }

*/
    insufficient_depth_indecies = [
        for map_idx in local.map_indecies:
        map_idx
        if length(local.depth_4[map_idx].expandable) > 0
    ]
}

// Check to make sure the highest level module has no remaining values that weren't recursed through
module "assert_sufficient_levels" {
  source        = "Invicton-Labs/assertion/null"
  version       = "~> 0.2.1"
  condition = length(local.insufficient_depth_indecies) == 0
  error_message = "The input maps at indecies (${join(", ", local.insufficient_depth_indecies)}) have more levels than this module supports (5). See the module README for instructions on supporting deeper maps."
}
