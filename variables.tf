variable "region" {
    description = "The AWS region to build the environment in"
    type = "string"
    default = "us-east-1"
}

variable "rhel_ami" {
    description = "The AMI to be used for Red Hat Linux instances"
    type = "string"
    default = "ami-0b0af3577fe5e3532"
}
