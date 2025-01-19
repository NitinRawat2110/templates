# Flatten the nested map into a list of objects
locals {
  flattened_subnets = flatten([
    for env, regions in var.subnets : [
      for region, subnets in regions : [
        for idx, subnet_id in subnets : {
          env     = env
          region  = region
          subnet  = subnet_id
          index   = idx
        }
      ]
    ]
  ])
}
