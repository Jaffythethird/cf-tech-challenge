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
    subnet_id = aws_subnet.sub2.id
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    root_block_device {
        volume_size = 20
    }

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

    # Instance Info
    ami = var.rhel_ami
    instance_type = "t2.micro"
    ebs-size = 20
    user_data = file("./src/user-data/install-apache.sh")
    key_name = aws_key_pair.deployer-key.id
    private_key = file(var.private_key_path)

    # Networking
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]
    subnet_ids = [aws_subnet.sub3.id, aws_subnet.sub4.id]
    vpc_id = aws_vpc.main.id

    # ASG/ALB Values
    asg_min = 2
    asg_max = 6
}

###########
#   SSH   #
###########
resource "aws_key_pair" "deployer-key" {
  key_name   = "deployer-key"
  public_key = file(var.pub_key_path)
}