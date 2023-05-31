resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "container-handson-vpc"
  } 
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "handson-public"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_subnet" "public_1a" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "container-handson-subnet"
  } 
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "handson" {
  name = "handson"
  description = "Allow Handson Incoming traffic"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.mgmt_ip
  }

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "handson"
  }
}

resource "aws_security_group" "handson-init" {
  name = "handson-init"
  description = "Allow Handson init"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "kubeconfig"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [aws_security_group.handson.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "handson-init"
  }
}
