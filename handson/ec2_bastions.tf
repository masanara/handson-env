resource "aws_instance" "bastions" {
  count         = var.instance_number
  ami           = var.ami_id
  instance_type = "t2.micro"
  disable_api_termination = false
  monitoring             = true
  subnet_id     = "${aws_subnet.public_1a.id}"
  vpc_security_group_ids = ["${aws_security_group.handson.id}"]
  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "standard"
  }
  user_data = <<EOF
#!/bin/bash
echo 'export NS=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)' >> ~ubuntu/.bashrc
git clone https://github.com/masanara/handson.git ~ubuntu/handson
chown -R ubuntu:ubuntu ~ubuntu/handson
rm -rf ~ubuntu/.git*
mkdir ~ubuntu/.kube/
chown ubuntu:ubuntu ~ubuntu/.kube
EOF
  credit_specification {
    cpu_credits = "standard"
  }
  key_name = var.key_name
  tags = {
    "Name" = "instance-${count.index}"
    "Owner" = "houser${count.index}"
    "svc" = "handson"
  }
}


# IPアドレスの出力
output "bastion_ids" {
   value = aws_instance.bastions.*.id
}
output "bastion_ips" {
   value = aws_instance.bastions.*.public_ip
}
