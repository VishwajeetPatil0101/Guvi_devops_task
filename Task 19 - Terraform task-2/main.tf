# Provider for ap-northeast-3 (default)
provider "aws" {
    alias  = "northeast-3"
    region = "ap-northeast-3"
}

# Provider alias for ap-northeast-2
provider "aws" {
  alias  = "northeast-2"
  region = "ap-northeast-2"
}

# Get default VPCs for each region
data "aws_vpc" "default_northeast_3" {
  provider = aws.northeast-3
  default = true
}

data "aws_vpc" "default_northeast_2" {
  provider = aws.northeast-2
  default  = true
}




# Security Group for northeast-3
resource "aws_security_group" "allow_http_northeast-3" {
  name        = "allow_http_ssh_northeast-3"
  description = "Allow HTTP and SSH traffic in northeast-3"
  vpc_id      = data.aws_vpc.default_northeast_3.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

# Security Group for northeast-2
resource "aws_security_group" "allow_http_northeast-2" {
  provider    = aws.northeast-2
  name        = "allow_http_ssh_northeast-2"
  description = "Allow HTTP and SSH traffic in northeast-2"
  vpc_id      = data.aws_vpc.default_northeast_2.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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



# main.tf

# EC2 instance in ap-northeast-3
resource "aws_instance" "northeast_3_instance" {
  provider      = aws.northeast-3
  ami           = "ami-0aafffc426e129572"  # Ubuntu 20.04 LTS (us-east-1)
  instance_type = "t2.micro"
  key_name      = "GuviDevopsKey"  # <- Replace this with your actual EC2 key pair name
  vpc_security_group_ids = [aws_security_group.allow_http_northeast-3.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "nginx-northeast_3"
  }
}


# EC2 instance in ap-northeast-2
resource "aws_instance" "ap-northeast-2_instance" {
  provider      = aws.northeast-2
  ami           = "ami-0662f4965dfc70aca"  # Ubuntu 20.04 LTS (us-west-2)
  instance_type = "t2.micro"
  key_name      = "Guvi_Devops_key"  # <- Replace this with your actual EC2 key pair name
  vpc_security_group_ids = [aws_security_group.allow_http_northeast-2.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "nginx-northeast-2"
  }
}




# Output public IPs
output "ap-northeast-3" {
  value = aws_instance.northeast_3_instance.public_ip
}

output "ap-northeast-2_ip" {
  value = aws_instance.ap-northeast-2_instance.public_ip
}

