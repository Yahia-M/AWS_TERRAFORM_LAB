resource "aws_launch_configuration" "app_lc" {
  name            = "app-lc"
  image_id        = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web_sg.id]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  launch_configuration = aws_launch_configuration.app_lc.id
  min_size             = 1
  max_size             = 5
  desired_capacity     = 2
  vpc_zone_identifier  = module.vpc.public_subnet_ids
}
   