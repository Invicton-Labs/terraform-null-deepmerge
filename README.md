# Deepmerge

This module performs a deep map merge of standard Terraform maps/objects. It is functionally similar to the built-in
`merge` function, except that it will merge maps at the same depth instead of overwriting them. It can handle maps with
a depth up to 100 (see commented-out code at the bottom of `main.tf` if you want to modify it to handle deeper maps).

It functions by "flattening" each input map into a map of depth 1 where each key is the full path to the value in
question. It then uses the standard merge function on these flat maps, and finally it re-builds the map structure in
reverse order.

**Note:** Lists will be overwritten. Only maps are merged.

## Usage

```hcl
locals {
  map1 = {
    key1-1 = {
      key1-1-1 = "value1-1-1"
      key1-1-2 = "value1-1-2"
      key1-1-3 = {
        key1-1-3-1 = "value1-1-3-1"
        key1-1-3-2 = "value1-1-3-2"
      }
    }
    key1-2 = "value1-2"
    key1-3 = {
      key1-3-1 = "value1-3-1"
      key1-3-2 = "value1-3-2"
    }
  }

  map2 = {
    key1-1 = {
      key1-1-1 = "value1-1-1(overwrite)"
      key1-1-3 = {
        key1-1-3-2 = "value1-1-3-2(overwrite)"
        key1-1-3-3 = {
          key1-1-3-3-1 = "value1-1-3-3-1"
        }
      }
      key1-1-4 = "value1-1-4"
    }
    key1-2 = {
      key1-2-1 = "value1-2-1"
      key1-2-2 = "value1-2-2"
      key1-2-3 = {
        key1-2-3-1 = "value1-2-3-1"
      }
    }
    key1-3 = "value1-3(overwrite)"
  }

  map3 = {
    key1-3 = "value1-3(double-overwrite)"
    key1-2 = {
      key1-2-3 = {
        key1-2-3-2 = "value1-2-3-2"
      }
    }
  }
}

module "deepmerge" {
  source  = "Invicton-Labs/deepmerge/null"
  maps = [
    local.map1,
    local.map2,
    local.map3
  ]
}

output "merged" {
  description = "The merged map."
  value       = module.deepmerge.merged
}
```

Output:

```hcl
merged = {
  "key1-1" = {
    "key1-1-1" = "value1-1-1(overwrite)"
    "key1-1-2" = "value1-1-2"
    "key1-1-3" = {
      "key1-1-3-1" = "value1-1-3-1"
      "key1-1-3-2" = "value1-1-3-2(overwrite)"
      "key1-1-3-3" = {
        "key1-1-3-3-1" = "value1-1-3-3-1"
      }
    }
    "key1-1-4" = "value1-1-4"
  }
  "key1-2" = {
    "key1-2-1" = "value1-2-1"
    "key1-2-2" = "value1-2-2"
    "key1-2-3" = {
      "key1-2-3-1" = "value1-2-3-1"
      "key1-2-3-2" = "value1-2-3-2"
    }
  }
  "key1-3" = "value1-3(double-overwrite)"
}
```

## TFLint restriction

If you are using [`tflint`](https://github.com/terraform-linters/tflint) (last tested with v0.56.0), and you are not
excluding remote modules, then it will be necessary to ignore this module due to the way `tflint` evaluates code.

This can be achieved in one of 2 ways:

1. Command line option `--ignore-module='Invicton-Labs/deepmerge/null'`.
2. `.tflint.hcl` configuration.
   ```hcl
   config {
     ignore_module = {
       "Invicton-Labs/deepmerge/null" = true
     }
   }
   ```

## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.3 |

## Providers

No providers.

## Modules

| Name                                                                                                          | Source                       | Version |
|---------------------------------------------------------------------------------------------------------------|------------------------------|---------|
| <a name="module_asset_sufficient_levels"></a> [asset\_sufficient\_levels](#module\_asset\_sufficient\_levels) | Invicton-Labs/assertion/null | ~>0.2.7 |

## Resources

No resources.

## Inputs

| Name                                           | Description                                                                                                                                                          | Type  | Default | Required | Validation                                                                                                                                                                                                 |
|------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|---------|:--------:|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <a name="input_maps"></a> [maps](#input\_maps) | A list of maps to merge. Maps should be ordered in increasing precedence, i.e. values in a map later in the list will overwrite values in a map earlier in the list. | `any` | n/a     |   yes    | The `var.maps` variable must be a list of maps and/or objects. The provided value is not a list.<br>The `var.maps` variable must be a list of maps and/or objects. Not all elements meet this requirement. |

## Outputs

| Name                                                   | Description     |
|--------------------------------------------------------|-----------------|
| <a name="output_merged"></a> [merged](#output\_merged) | The merged map. |
