locals {
  tests = [
    {
      input_maps = [
        {
          a = 1
          b = 2
        },
        {
          c = 3
          d = 4
        }
      ]
      expected_output = {
        a = 1
        b = 2
        c = 3
        d = 4
      }
    },
    {
      input_maps = [
        {
          a = 1
          b = 2
        },
        {
          a = 5
          d = 4
        }
      ]
      expected_output = {
        a = 5
        b = 2
        d = 4
      }
    },
    {
      input_maps = [
        {
          a = 1
          b = "foo"
        },
        {
          a = 5
          d = 4
        }
      ]
      expected_output = {
        a = 5
        b = "foo"
        d = 4
      }
    },
    {
      input_maps = [
        {
          a = 1
          b = "foo"
        },
        {
          a = "bar"
          d = 4
        }
      ]
      expected_output = {
        a = "bar"
        b = "foo"
        d = 4
      }
    },
    {
      input_maps = [
        {
          a = [1, 2, 3]
          b = "foo"
        },
        {
          a = "bar"
          d = 4
        }
      ]
      expected_output = {
        a = "bar"
        b = "foo"
        d = 4
      }
    },
    {
      input_maps = [
        {
          a = [1, 2, 3]
          b = "foo"
        },
        {
          a = [4, 5, 6]
          d = 4
        }
      ]
      expected_output = {
        a = [4, 5, 6]
        b = "foo"
        d = 4
      }
    },
    {
      input_maps = [
        yamldecode(<<YAML
mylist:
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
        {
          mymap = {
            foo = "bar"
            baz = 0
          }
        }
      ],
      expected_output = {
        mylist = [
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
          },
        ]
        mymap = {
          foo = "bar"
          baz = 0
        }
      }
    }
  ]
}

module "tests" {
  source          = "./test"
  count           = length(local.tests)
  input_maps      = local.tests[count.index].input_maps
  expected_output = local.tests[count.index].expected_output
  test_key        = count.index
}
