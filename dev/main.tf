locals {
  input_maps = [
    {
      amap = {
        anothermap = {
          something = 1
          test      = [2]
        }
        p3 = 4
      }
      p1 = 123
      p2 = "abcd"
    },
    {
      mymap = {
        foo = "bar"
        baz = 0
      }
      amap = {
        p3 = 5
      }
    }
  ]
}

module "deepmerge" {
  source = "../"
  maps   = local.input_maps
}

output "deepmerge" {
  value = module.deepmerge
}
