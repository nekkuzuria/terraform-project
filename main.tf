resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/terraform_key.pub")
}

resource "aws_instance" "web" {
  ami           = "ami-0559665adb3f0e333"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              cat <<EOT > /var/www/html/index.html
                  ${file("hello.html")}
              EOT
              EOF

  tags = {
    Name = "TerraformWeb"
  }
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
