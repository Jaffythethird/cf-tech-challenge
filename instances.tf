########################
#   Public Instances   #
########################

# I could get the AMI like this, but specifying one is more reliable
// data "aws_ami" "redhat" {
//     most_recent = true

//     filter {
//         name   = "name"
//         values = ["RHEL-8.0.0_HVM-20*-x86_64-*-GP2"]
//     }

//     filter {
//         name   = "virtualization-type"
//         values = ["hvm"]
//     }

//     owners = ["309956199498"]
// }

# Declare public instance in subnet 2
resource "aws_instance" "public_instance" {
    ami = var.rhel_ami
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_sub_2.id
    vpc_security_group_ids = aws_security_group.allow_ssh.id

    # SSH
    key_name = aws_key_pair.deployer-key.id
    connection {
        user = "ec2-user"
        private_key = file(var.private_key_path)
    }
}

#########################
#   Private Instances   #
#########################
module "private_instances" {
    source = "./modules/asg-cluster"
}

###########
#   SSH   #
###########
resource "aws_key_pair" "deployer-key" {
  key_name   = "deployer-key"
  public_key = file(var.pub_key_path)
}