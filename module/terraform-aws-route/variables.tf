variable "env" { 
    type = string
}
variable "method" { 
    type = string
}
variable "company" { 
    type = string
}
variable "name" { 
    type = string
}
variable "azs" { 
    type = string
    default = ""
}
variable "vpc_id" { 
    type = string
}
variable "subnet_id" { 
    type = list(string)
}
variable "igw_id" { 
    type = string
    default = null
}
variable "nat_id" { 
    type = string
   default = null
}
variable "route_rule" { 
    type = map(any)
}
variable "tags" { 
    type = map(string)
}
