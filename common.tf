resource "aws_vpc" "my-vpc" {
  cidr_block       = var.vpc_cidr_range
  instance_tenancy = "default"

  tags = {
    Name = "tf-vpc"
  }
}

resource "aws_subnet" "subnets" {
      #count                  = 6
       count                  = length(var.subnet_name_tags)
       vpc_id                 = aws_vpc.my-vpc.id
      #cidr_block             = var.subnet_cidrs[count.index]
       cidr_block             = cidrsubnet(var.vpc_cidr_range,8,count.index) 
      #availability_zone      = var.subnet_azs[count.index]
      #availability_zone      = format("${var.aws_region}%s", 
      #count.index%2==0?"a":"b")   
       availability_zone      = format("${var.aws_region}%s", count.index%2==0?"a":"b")
         tags ={
           Name  = var.subnet_name_tags[count.index]
         }
         depends_on = [
           aws_vpc.my-vpc
         ]
}
# resource "aws_subnet" "web1" {
#   vpc_id     = aws_vpc.my-vpc.id
#   cidr_block = var.subnet_cidrs[0]
#   availability_zone = var.subnet_azs[0]

#   tags = {
#     Name = var.subnet_name_tags[0]
#   }
# }

# resource "aws_subnet" "web2" {
#   vpc_id     = aws_vpc.my-vpc.id
#   cidr_block = var.subnet_cidrs[1]
#   availability_zone = var.subnet_azs[1]
#   tags = {
#     Name = var.subnet_name_tags[1]
#   }
# }


# resource "aws_subnet" "app1" {
#   vpc_id     = aws_vpc.my-vpc.id
#   cidr_block = var.subnet_cidrs[2]
#   availability_zone = var.subnet_azs[2]
#   tags = {
#     Name = var.subnet_name_tags[2]
#   }
# }

# resource "aws_subnet" "app2" {
#   vpc_id     = aws_vpc.my-vpc.id
#   cidr_block = var.subnet_cidrs[3]
#   availability_zone = var.subnet_azs[3]
#   tags = {
#     Name = var.subnet_name_tags[3]
#   }
# }

# resource "aws_subnet" "db1" {
#   vpc_id     = aws_vpc.my-vpc.id
#   cidr_block = var.subnet_cidrs[4]
#    availability_zone = var.subnet_azs[4]
#   tags = {
#     Name = var.subnet_name_tags[4]
#   }
# }

# resource "aws_subnet" "db2" {
#   vpc_id     = aws_vpc.my-vpc.id
#   cidr_block = var.subnet_cidrs[5]
# availability_zone = var.subnet_azs[5]
#   tags = {
#     Name = var.subnet_name_tags[5]
#   }
# }

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "tf-gw"
  }
  depends_on = [
    aws_vpc.my-vpc
  ]
}

resource "aws_security_group" "websg" {
     vpc_id            = aws_vpc.my-vpc.id
     description       = local.default-description

     ingress {
      from_port     = local.ssh_port
      to_port       = local.ssh_port
      protocol      = local.protocol
      cidr_blocks   = [local.any_where]
     }

      ingress {
      from_port     = local.http_port
      to_port       = local.http_port
      protocol      = local.protocol
      cidr_blocks   = [local.any_where]
     }

     egress {
        from_port         = local.allports
        to_port           = local.allports
        protocol          = local.any_protocol
        cidr_blocks       = [local.any_where]
        ipv6_cidr_blocks  = [local.any_where_ipv6]

     } 
     tags = {
      Name  =  "web security"
     }
     depends_on = [
      aws_internet_gateway.gw
     ]
}

resource "aws_security_group" "appsg" {
     vpc_id            = aws_vpc.my-vpc.id
     description       =  local.default-description

     ingress {
      from_port     = local.ssh_port
      to_port       = local.ssh_port
      protocol      = local.protocol
      cidr_blocks   = [local.any_where]
     }

      ingress {
      from_port     = local.app_port
      to_port       = local.app_port
      protocol      = local.protocol
      cidr_blocks   = [var.vpc_cidr_range]
     }

     egress {
        from_port         = local.allports
        to_port           = local.allports
        protocol          = local.any_protocol
        cidr_blocks       = [local.any_where]
        ipv6_cidr_blocks  = [local.any_where_ipv6]

     } 
     tags = {
      Name  =  "app security"
     }
    depends_on = [
      aws_internet_gateway.gw
    ]
}

resource "aws_security_group" "dbsg" {
     vpc_id            = aws_vpc.my-vpc.id
     description       =  local.default-description

     ingress {
      from_port     = local.ssh_port
      to_port       = local.ssh_port
      protocol      = local.protocol
      cidr_blocks   = [local.any_where]
     }

      ingress {
      from_port     = local.db_port
      to_port       = local.db_port
      protocol      = local.protocol
      cidr_blocks   = [var.vpc_cidr_range]
     }

     egress {
        from_port         = local.allports
        to_port           = local.allports
        protocol          = local.any_protocol
        cidr_blocks       = [local.any_where]
        ipv6_cidr_blocks  = [local.any_where_ipv6]

     } 
     tags = {
      Name  =  "db security"
     }
     depends_on = [
       aws_internet_gateway.gw
     ]
}

resource "aws_route_table" "publicrt" {
    vpc_id          =  aws_vpc.my-vpc.id
    route {
        cidr_block  = local.any_where
        gateway_id  = aws_internet_gateway.gw.id
    }
    tags            = {
        Name        = "Public RT"
    } 
    depends_on = [
      aws_internet_gateway.gw,
      aws_vpc.my-vpc
    ]
    
}
  resource "aws_route_table" "privatert" {
   vpc_id = aws_vpc.my-vpc.id
     
     tags = {
      Name = " Private RT"
       }
       depends_on = [
         aws_vpc.my-vpc,
         aws_internet_gateway.gw
       ]
  }

  # resource "aws_route_table_association" "associations" {
  #    count           =  length(aws_subnet.subnets)
  #    subnet_id       =  aws_subnet.subnets[count.index].id
  #    route_table_id  =  count.index<2 ? aws_route_table.publicrt.id : aws_route_table.privatert.id
  # }

  resource "aws_route_table_association" "associations" {

      count = length(aws_subnet.subnets)
      subnet_id = aws_subnet.subnets[count.index].id
      route_table_id = contains(var.public_subnets,
      lookup(aws_subnet.subnets[count.index].tags_all, "Name", ""))?aws_route_table.publicrt.id : aws_route_table.privatert.id
    depends_on = [
      aws_route_table.publicrt,
      aws_route_table.privatert
    ]
  
  }
      