# create ec2 instance using terraform

resource "aws_instance" "TF-ec2" {
    ami = "ami-0354c98ae10b02961"
    instance_type = "t3.micro"
    key_name = aws_key_pair.TF-key-pair.key_name
    #security_groups = ["aws_security_group.TF-sg.name"]
    vpc_security_group_ids = [aws_security_group.TF-sg.id]
}

# create was key pair using terraform

resource "aws_key_pair" "TF-key-pair"{
    key_name = "aws-kp"
    public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa"{
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "local_file" "ec2kp" {
    content = tls_private_key.rsa.private_key_pem
    filename = "/Users/kyellapp/private_key.pem"
}

# create security group using terraform

resource "aws_security_group" "TF-sg" {
  name        = "allow_ssh_from_internet"
  description = "allow_inbound_ssh_from_internet"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}





