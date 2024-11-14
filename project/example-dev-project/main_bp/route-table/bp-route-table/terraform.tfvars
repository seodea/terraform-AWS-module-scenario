
company = "sdh"
env = "prd"
method = "bp"

# {company}-{env}-{method}-vpc
vpc_filter_name = {
  Name = "sdh-prd-service-vpc"
}

# {company}-{subnet용도}-{zone}-subnet
subnet_filter_name = {
  # Name = "sdh-eks-2a-subnet" # 단일 {company}-{method}-{region}-subnet
  Name = "sdh-bp-*" # 같은 용도의 sunbet 여러개 선택 시  
}

tags = {
  env = "prd"
}