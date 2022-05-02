#################
#      VPC      #
#################
resource "aws_vpc" "main" {
    cidr_block = "10.1.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    instance_tenancy = "default"

    tags {
        Name = "cf-assessment-vpc"
    }
}

#################
#    Subnets    #
#################
# Declare the data source for available AZ's
data "aws_availability_zones" "available" {
    state = "available"
}

# Declare public subnets
resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.main.id
    availability_zone = data.aws_availability_zones.available.names[0]
    cidr_block = "10.1.0.0/24"
    map_public_ip_on_launch = true

    tags {
        Name = "Sub1"
    }
}

resource "aws_subnet" "sub2" {
    vpc_id = aws_vpc.main.id
    availability_zone = data.aws_availability_zones.available.names[1]
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = true
    
    tags {
        Name = "Sub2"
    }
}

# Declare private subnets
resource "aws_subnet" "sub3" {
    vpc_id = aws_vpc.main.id
    availability_zone = data.aws_availability_zones.available.names[0]
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = false
    
    tags {
        Name = "Sub3"
    }
}

resource "aws_subnet" "sub4" {
    vpc_id = aws_vpc.main.id
    availability_zone = data.aws_availability_zones.available.names[1]
    cidr_block = "10.1.3.0/24"
    map_public_ip_on_launch = false
    
    tags {
        Name = "Sub4"
    }
}

####################
#   Connectivity   #
####################
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_routing" {
    vpc_id = aws_vpc.main.id
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
}

resource "aws_route_table_association" "sub1-public"{
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.public_routing.id
}

resource "aws_route_table_association" "sub2-public"{
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.public_routing.id
}

#######################
#   Security Groups   #
#######################

# Learn our public IP address for making sure the person deploying is the only person able to get through the sg
# Directly taken from https://www.reddit.com/r/Terraform/comments/9g62ox/comment/e620jyu/?utm_source=share&utm_medium=web2x&context=3
data "http" "icanhazip" {
   url = "http://icanhazip.com"
}

resource "aws_security_group" "allow_ssh" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }    
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${chomp(data.http.icanhazip.body)}"]
    }
}