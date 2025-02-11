
variable "company" { 
    type = string
}
variable "env" { 
    type = string
}
variable "method" { 
    type = string
}
variable "vpc_cidr" { 
    type = string
}
variable "azs" { 
    type = list(string)
}
variable "enable_internet_gateway" { 
    type = bool
}
variable "enable_nat_gateway" { 
    type = bool
}
variable "subnet" { 
    type = any
}

variable "tags" { 
    type = map(string)
}