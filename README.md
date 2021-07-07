# Deepmerge

This module performs a deep map merge of standard Terraform maps/objects. It is functionally similar to the built-in `merge` function, except that it will merge maps at the same depth instead of overwriting them. It can handle maps with a depth up to 100 (see commented-out code at the bottom of `main.tf` if you want to modify it to handle deeper maps).

It functions by "flattening" each input map into a map of depth 1 where each key is the full path to the value in question. It then uses the standard merge function on these flat maps, and finally it re-builds the map structure in reverse order.

**Note:** Lists will be overwritten. Only maps are merged.
