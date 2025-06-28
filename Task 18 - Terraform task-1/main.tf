# main.tf

resource "aws_instance" "primary_ec2" {
  provider       = aws.primary
  ami            = "ami-0aafffc426e129572"
  instance_type  = "t2.micro"
  tags = {
    Name = "Primary-Instance-${var.primary_region}"
  }
}

resource "aws_instance" "secondary_ec2" {
  provider       = aws.secondary
  ami            = "ami-0662f4965dfc70aca"
  instance_type  = "t2.micro"
  tags = {
    Name = "Secondary-Instance-${var.secondary_region}"
  }
}
