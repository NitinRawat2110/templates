# Define locals to flatten and structure the subnets
locals {
  flattened_subnets = flatten([
    for env, regions in var.ecs_subnets : [
      for region, subnets in regions : [
        for idx, subnet_id in subnets : {
          env     = env
          region  = region
          subnet  = subnet_id
        }
      ]
    ]
  ])
}
