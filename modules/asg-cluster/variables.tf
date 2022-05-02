# Instance Info
variable "ami" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "ebs-size" {
    type = number
}

variable "user_data" {
    type = string
}

variable "key_name" {
    type = string
}

variable "private_key" {
    type = string
}

# Networking
variable "vpc_security_group_ids" {
    type = list(string)
}

variable "subnet_ids" {
    type = list(string)
}

# ASG/ALB Values
variable "asg_min" {
    type = number
}

variable "asg_max" {
    type = number
}
