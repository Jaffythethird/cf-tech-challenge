variable "region" {
    description = "The AWS region to build the environment in"
    type = string
    default = "us-east-1"
}

variable "rhel_ami" {
    description = "The AMI to be used for Red Hat Linux instances"
    type = string
    default = "ami-0b0af3577fe5e3532"
}

variable "keypair_name" {
    description = "The name of the keypair created in AWS"
    type = string
}

variable "profile" {
    description = "The name of the profile as stated in your AWS Credentials/Config file"
    type = string
}

variable "shared_config_files" {
    description = "The path to your .aws config file"
    type = string
    default = "~/.aws/config"
}

variable "shared_credentials_files" {
    description = "The path to your .aws credentials file"
    type = string
    default = "~/.aws/credentials"
}
