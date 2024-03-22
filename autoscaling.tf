#Create launch template
resource "aws_launch_template" "wp-launch-template" {
  name                   = "wp-launch-template"
  image_id               = data.aws_ami.latest-linux-ami.id
  instance_type          = "t2.micro"
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.allow-http.id, aws_security_group.allow-ssh.id]
  #user_data              = filebase64("userdata.sh")
  user_data = base64encode(data.template_file.ec2userdatatemplate.rendered)
  tags = {
    Name = "wp-launch-template"
  }
}

#Create autoscaling group with ELB health check
resource "aws_autoscaling_group" "wp-asg" {
  name                      = "wp-asg"
  vpc_zone_identifier       = [aws_subnet.public-1.id, aws_subnet.public-2.id]
  target_group_arns         = [aws_lb_target_group.wordpress-tg.id]
  max_size                  = 4
  min_size                  = 1
  desired_capacity          = 1
  health_check_type         = "ELB"
  health_check_grace_period = 300
  #force_delete              = true
  launch_template {
    id      = aws_launch_template.wp-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "wp-asg"
    propagate_at_launch = true
  }
}

#Create target tracking scaling policy
resource "aws_autoscaling_policy" "wp-policy" {
  name                   = "wp-policy"
  autoscaling_group_name = aws_autoscaling_group.wp-asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}