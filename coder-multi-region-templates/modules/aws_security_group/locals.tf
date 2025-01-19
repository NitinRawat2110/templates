locals {
  # Flatten the vpc_ids map into a single map with a unique key for environment and region
  flattened_vpc_ids = flatten([
    for env, regions in var.vpc_ids : [
      for region, vpc_id in regions : {
        key     = "${env}-${region}"
        vpc_id  = vpc_id
      }
    ]
  ])
}
