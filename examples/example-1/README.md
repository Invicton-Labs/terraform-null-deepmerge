# Example 1
This example will output the following:
```
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