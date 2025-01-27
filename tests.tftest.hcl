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
