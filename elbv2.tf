#Create application load balancer
resource "aws_lb" "wordpress-alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.wordpress-sg.id]
  subnets            = [aws_subnet.public-1.id, aws_subnet.public-2.id]
  ip_address_type    = "ipv4" ###AI did not give, why?
  #enable_deletion_protection = false ###Dominic did not have, why?

  tags = {
    Name = "wordpress-alb"
  }
}
#Create target group
resource "aws_lb_target_group" "wordpress-tg" {
  name        = "wordpress-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance" ###AI did not give, necessary?
  vpc_id      = aws_vpc.dev_vpc.id
  health_check {
    enabled             = true           #enabled by default, but this setting ensures it is not disabled unintentionally
    path                = "/"            ###different path in lab, y?
    port                = "traffic-port" ###AI did not give, necessary? What exactly does it do?
    protocol            = "HTTP"
    matcher             = "200-399" #is "200" by default (even if not specified) => target will be considered healthy only if the health check returns an HTTP 200 OK response
    interval            = 10        #AI did 30
    timeout             = 5
    healthy_threshold   = 2 #AI did 5
    unhealthy_threshold = 2
  }
  tags = {
    Name = "wordpress-tg"
  }
}
#Create listener
resource "aws_lb_listener" "wordpress-listener" {
  load_balancer_arn = aws_lb.wordpress-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tg.arn
  }
  tags = {
    Name = "wordpress-listener"
  }
}
#Create target group attachment ###why? - Attaching wp instance so I can reach the WP server via alb dns
resource "aws_lb_target_group_attachment" "wordpress-tg-attach" {
  port             = 80 ###Dominic does not have it, necessary?
  target_group_arn = aws_lb_target_group.wordpress-tg.arn
  target_id        = aws_instance.wp-instance[count.index].id
  count            = length(aws_instance.wp-instance) ###Is this in place b/c w/ how TF behaves, the ASG could be in place before the ALB?
}
#What is a listener rule/does it do? Alternative to default action? (AI wants to create one here.)