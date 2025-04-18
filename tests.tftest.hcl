run "test_1" {
  command = plan
  variables {
    maps = [
      {
        a = "1"
        b = 2
      },
      {
        a = 3
        c = 4
      }
    ]
  }
  assert {
    condition = output.merged == {
      a = 3
      b = 2
      c = 4
    }
    error_message = "Unexpected output: ${jsonencode(output.merged)}"
  }
}

run "test_2" {
  command = plan
  variables {
    maps = [
      {
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
      },
      {
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
      },
      {
        key1-3 = "value1-3(double-overwrite)"
        key1-2 = {
          key1-2-3 = {
            key1-2-3-2 = "value1-2-3-2"
          }
        }
      }
    ]
  }
  assert {
    condition = output.merged == {
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
    error_message = "Unexpected output: ${jsonencode(output.merged)}"
  }
}

// https://github.com/Invicton-Labs/terraform-null-deepmerge/issues/2
run "test_3" {
  command = plan
  variables {
    maps = [
      {
        b = {
          "fubar" : [
            {
              "name" : "foo",
              "prefixes" : ["item1", "item2"]
            },
            {
              "name" : "bar",
              "prefixes" : null
            }
          ]
        }
      },
      {
        arr = [
          {
            foo = {}
            bar = "bar"
          },
          {
            foo = {}
            baz = "baz"
          },
        ]
      }
    ]
  }
  assert {
    condition = output.merged == {
      b = {
        "fubar" : [
          {
            "name" : "foo",
            "prefixes" : ["item1", "item2"]
          },
          {
            "name" : "bar",
            "prefixes" : null
          }
        ]
      }
      arr = [
        {
          foo = {}
          bar = "bar"
        },
        {
          foo = {}
          baz = "baz"
        },
      ]
    }
    error_message = "Unexpected output: ${jsonencode(output.merged)}"
  }
}

// https://github.com/Invicton-Labs/terraform-null-deepmerge/issues/5
run "test_4" {
  command = plan
  variables {
    maps = [
      yamldecode(<<YAML
top:
  - name: NAME_1
    param: value1
    param2:
      test: test
  - name: NAME_2
    param: value2
  - name: NAME_3
    param: value3
  - name: NAME_4
    param: value4
YAML
      ),
      {},
    ]
  }
  assert {
    condition = output.merged == {
      top = [
        {
          name  = "NAME_1"
          param = "value1"
          param2 = {
            test = "test"
          }
        },
        {
          name  = "NAME_2"
          param = "value2"
        },
        {
          name  = "NAME_3"
          param = "value3"
        },
        {
          name  = "NAME_4"
          param = "value4"
        }
      ]

    }
    error_message = "Unexpected output: ${jsonencode(output.merged)}"
  }
}

// https://github.com/Invicton-Labs/terraform-null-deepmerge/issues/10
run "test_5" {
  command = plan
  variables {
    maps = [
      {},
      {
        arr = [
          {
            foo = {}
            bar = "bar"
          },
          {
            foo = {}
            baz = "baz"
          },
        ]
      }
    ]
  }
  assert {
    condition = output.merged == {
      arr = [
        {
          foo = {}
          bar = "bar"
        },
        {
          foo = {}
          baz = "baz"
        },
      ]
    }
    error_message = "Unexpected output: ${jsonencode(output.merged)}"
  }
}

run "validation_test_bool" {
  command = plan
  variables {
    maps = true
  }
  expect_failures = [
    var.maps
  ]
}

run "validation_test_string" {
  command = plan
  variables {
    maps = "string"
  }
  expect_failures = [
    var.maps
  ]
}

run "validation_test_number" {
  command = plan
  variables {
    maps = 42
  }
  expect_failures = [
    var.maps
  ]
}

run "validation_test_map" {
  command = plan
  variables {
    maps = {}
  }
  expect_failures = [
    var.maps
  ]
}

run "validation_test_set_bool" {
  command = plan
  variables {
    maps = [true]
  }
  expect_failures = [
    var.maps
  ]
}

run "validation_test_set_string" {
  command = plan
  variables {
    maps = ["string"]
  }
  expect_failures = [
    var.maps
  ]
}

run "validation_test_set_number" {
  command = plan
  variables {
    maps = [42]
  }
  expect_failures = [
    var.maps
  ]
}

run "validation_test_set_map" {
  command = plan
  variables {
    maps = [{}]
  }
  assert {
    condition     = output.merged == {}
    error_message = "Unexpected output: ${jsonencode(output.merged)}"
  }
}

run "validation_test_depth_100" {
  command = plan
  variables {
    maps = [
      { "1" = { "2" = { "3" = { "4" = { "5" = { "6" = { "7" = { "8" = { "9" = { "10" = { "11" = { "12" = { "13" = { "14" = { "15" = { "16" = { "17" = { "18" = { "19" = { "20" = { "21" = { "22" = { "23" = { "24" = { "25" = { "26" = { "27" = { "28" = { "29" = { "30" = { "31" = { "32" = { "33" = { "34" = { "35" = { "36" = { "37" = { "38" = { "39" = { "40" = { "41" = { "42" = { "43" = { "44" = { "45" = { "46" = { "47" = { "48" = { "49" = { "50" = { "51" = { "52" = { "53" = { "54" = { "55" = { "56" = { "57" = { "58" = { "59" = { "60" = { "61" = { "62" = { "63" = { "64" = { "65" = { "66" = { "67" = { "68" = { "69" = { "70" = { "71" = { "72" = { "73" = { "74" = { "75" = { "76" = { "77" = { "78" = { "79" = { "80" = { "81" = { "82" = { "83" = { "84" = { "85" = { "86" = { "87" = { "88" = { "89" = { "90" = { "91" = { "92" = { "93" = { "94" = { "95" = { "96" = { "97" = { "98" = { "99" = { "first" = ["first"], } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } },
      { "1" = { "2" = { "3" = { "4" = { "5" = { "6" = { "7" = { "8" = { "9" = { "10" = { "11" = { "12" = { "13" = { "14" = { "15" = { "16" = { "17" = { "18" = { "19" = { "20" = { "21" = { "22" = { "23" = { "24" = { "25" = { "26" = { "27" = { "28" = { "29" = { "30" = { "31" = { "32" = { "33" = { "34" = { "35" = { "36" = { "37" = { "38" = { "39" = { "40" = { "41" = { "42" = { "43" = { "44" = { "45" = { "46" = { "47" = { "48" = { "49" = { "50" = { "51" = { "52" = { "53" = { "54" = { "55" = { "56" = { "57" = { "58" = { "59" = { "60" = { "61" = { "62" = { "63" = { "64" = { "65" = { "66" = { "67" = { "68" = { "69" = { "70" = { "71" = { "72" = { "73" = { "74" = { "75" = { "76" = { "77" = { "78" = { "79" = { "80" = { "81" = { "82" = { "83" = { "84" = { "85" = { "86" = { "87" = { "88" = { "89" = { "90" = { "91" = { "92" = { "93" = { "94" = { "95" = { "96" = { "97" = { "98" = { "99" = { "second" = ["second"], } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } },
    ]
  }
  assert {
    condition     = output.merged == { "1" = { "2" = { "3" = { "4" = { "5" = { "6" = { "7" = { "8" = { "9" = { "10" = { "11" = { "12" = { "13" = { "14" = { "15" = { "16" = { "17" = { "18" = { "19" = { "20" = { "21" = { "22" = { "23" = { "24" = { "25" = { "26" = { "27" = { "28" = { "29" = { "30" = { "31" = { "32" = { "33" = { "34" = { "35" = { "36" = { "37" = { "38" = { "39" = { "40" = { "41" = { "42" = { "43" = { "44" = { "45" = { "46" = { "47" = { "48" = { "49" = { "50" = { "51" = { "52" = { "53" = { "54" = { "55" = { "56" = { "57" = { "58" = { "59" = { "60" = { "61" = { "62" = { "63" = { "64" = { "65" = { "66" = { "67" = { "68" = { "69" = { "70" = { "71" = { "72" = { "73" = { "74" = { "75" = { "76" = { "77" = { "78" = { "79" = { "80" = { "81" = { "82" = { "83" = { "84" = { "85" = { "86" = { "87" = { "88" = { "89" = { "90" = { "91" = { "92" = { "93" = { "94" = { "95" = { "96" = { "97" = { "98" = { "99" = { "first" = ["first"], "second" = ["second"], } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } } }
    error_message = "Unexpected output: ${jsonencode(output.merged)}"
  }
}
