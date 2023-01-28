variable "aws_region" {
    type  = string
    default = "ap-southeast-1"
  
}

variable "vpc_cidr_range" {
    type = string
    default = "10.0.0.0/16"
    description = "cidr  for vpc"
  
}  

# variable "subnet_cidrs" {
#       type       = list
#       default    = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
#       description = "subnet ranges"
# }

# variable "subnet_azs" {
#        type    =  list
#        default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1a", "ap-southeast-1b"]  
#        description = "subnet azs"
# }

variable "subnet_name_tags" {
      type     = list(string)
     default   = ["web1", "web2", "app1", "app2", "db1", "db2"]  
     description = "subnet names"
}

variable "public_subnets" {
    type   = list(string)
    default = ["web1", "web2"]
  
}

variable "db_subnets" {
    type = list(string)
    default = [ "db1", "db2" ]
}

variable "keypath" {
    type        = string
    default     = "~/.ssh/id_rsa.pub"
}

variable "appserver_info" {
    type                    = object({
        ami_id              = string
        instance_type       = string
        name                = string
        public_ip_enabled   = bool
        count               = number
        subnets             = list(string)
    })
    default                 = {
        ami_id              = "ami-0750a20e9959e44ff"
        instance_type       = "t2.micro"
        name                = "appserver"
        public_ip_enabled   = false
        count               = 2
        subnets             = ["app1", "app2"]
    }  
}


variable "webserver_info" {
    type                    = object({
        ami_id              = string
        instance_type       = string
        name                = string
        public_ip_enabled   = bool
        count               = number
        subnets             = list(string)
    })
    default                 = {
        ami_id              = "ami-0750a20e9959e44ff"
        instance_type       = "t2.micro"
        name                = "webserver"
        public_ip_enabled   = true
        count               = 2
        subnets             = ["web1", "web2"]
    }  
}
#  variable "web1" {
#     type = string
#     default = "10.0.0.0/24"
#     description = "subnet for web1"
   
#  }

#  variable "web2" {
#     type = string
#     default = "10.0.1.0/24"
#     description = "subnet for web2"
   
#  }
#  variable "app1" {
#     type = string
#     default = "10.0.2.0/24"
#     description = "subnet for app1"
   
#  }

#  variable "app2" {
#     type = string
#     default = "10.0.3.0/24"
#     description = "subnet for app2"
   
#  }

#  variable "db1" {
#     type = string
#     default = "10.0.4.0/24"
#     description = "subnet for db1"
   
#  }

#   variable "db2" {
#     type = string
#     default = "10.0.5.0/24"
#     description = "subnet for db2"
   
#  }

#  variable "web1-az" {
#       type = string
#       default = "ap-southeast-1a"
#       description = "az for web1"

#  }

 
#  variable "web2-az" {
#       type = string
#       default = "ap-southeast-1b"
#       description = "az for web2"

#  }

 
#  variable "app1-az" {
#       type = string
#       default = "ap-southeast-1a"
#       description = "az for app1"

#  }

#  variable "app2-az" {
#       type = string
#       default = "ap-southeast-1b"
#       description = "az for app2"

#  }

#  variable "db1-az" {
#       type = string
#       default = "ap-southeast-1a"
#       description = "az for db1"

#  }

#  variable "db2-az" {
#       type = string
#       default = "ap-southeast-1b"
#       description = "az for db2"

#  }