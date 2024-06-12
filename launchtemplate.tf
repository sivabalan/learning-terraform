resource "aws_launch_template" "main_launch_template" {
  name_prefix            = "main_launch_template"
  image_id               = var.ami_map[var.env]
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.main_sg.id]
  #user_data              = filebase64("./apache.sh")
}
