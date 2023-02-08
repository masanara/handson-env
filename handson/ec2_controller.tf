resource "aws_eip" "eip" {
  instance = "${aws_instance.controller.id}"
  vpc = true
}

resource "aws_instance" "controller" {
  ami                       = var.ami_id
  instance_type             = "t2.micro"
  disable_api_termination   = false
  vpc_security_group_ids    = ["${aws_security_group.handson.id}","${aws_security_group.handson-init.id}"]
  monitoring                = true
  subnet_id                 = "${aws_subnet.public_1a.id}"
  root_block_device {
    delete_on_termination   = true
    volume_size             = 8
    volume_type             = "standard"
  }
  user_data = <<EOF
#!/bin/bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && mv kubectl /usr/local/bin/
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker ubuntu
mkdir ~ubuntu/.kube && chown ubuntu:ubuntu ~ubuntu/.kube
EOF
  credit_specification {
    cpu_credits = "standard"
  }
  key_name                  = var.key_name
  tags = {
    "Name"                  = "handson-control"
    "svc"                   = "handson"
  }
}
