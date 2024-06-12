
resource "aws_autoscaling_group" "main_autoscaling_group" {
  desired_capacity    = 2
  max_size            = 5
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.zonea_public_subnet.id, aws_subnet.zoneb_public_subnet.id]

  launch_template {
    id      = aws_launch_template.main_launch_template.id
    version = "$Latest"
  }
}
