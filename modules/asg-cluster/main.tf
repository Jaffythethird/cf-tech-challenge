###########
#   ASG   #
###########

resource "aws_autoscaling_group" "main"{
    name = "httpd-servers"
    min_size = var.asg_min
    max_size = var.asg_max
    desired_capacity = var.asg_min
    launch_configuration = aws_launch_configuration.main.name
    vpc_zone_identifier = var.subnet_ids
    target_group_arns = [aws_lb_target_group.main.arn]
}

resource "aws_launch_configuration" "main" {
    name = "httpd-server"
    image_id = var.ami
    instance_type = var.instance_type
    user_data = var.user_data
    root_block_device {
        volume_size = var.ebs-size
    }
    security_groups = var.vpc_security_group_ids

    key_name = var.key_name
}

###########
#   ALB   #
###########
resource "aws_lb" "main" {
    load_balancer_type = "application"
    security_groups = var.vpc_security_group_ids
    subnets = var.subnet_ids
}

resource "aws_lb_listener" "main" {
    load_balancer_arn = aws_lb.main.arn
    port = 80
    protocol = "TCP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.main.arn
    }
}

resource "aws_lb_target_group" "main" {
    port = 8080
    protocol = "TCP"    
    target_type = "instance"
    vpc_id = var.vpc_id
}
