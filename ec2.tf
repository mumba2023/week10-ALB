# ec2

resource "aws_instance" "ec2-one" {
  ami             = "ami-01bc990364452ab3e"  
  instance_type   = "t2.micro"               # Corrected instance type
  subnet_id       = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name        = aws_key_pair.ec2_key.key_name  # Use key_name attribute
  user_data       = file("userdata.sh")
  tags = {
    Name = "webserver-1"
  }
}


resource "aws_instance" "ec2-two" {
  ami             = "ami-01bc990364452ab3e"  # Replace with a valid AMI ID
  instance_type   = "t2.micro"               # Corrected instance type
  subnet_id       = aws_subnet.public_subnet2.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name        = aws_key_pair.ec2_key.key_name  # Use key_name attribute
  user_data       = file("userdata.sh")
  tags = {
    Name = "webserver-2"
  }
}


# Generates a secure private k ey and encodes it as PEM
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
# Create the Key Pair
resource "aws_key_pair" "ec2_key" {
  key_name   = "privatekeypair"  
  public_key = tls_private_key.ec2_key.public_key_openssh
}
# Save file
resource "local_file" "ssh_key" {
  filename = "keypair.pem"
  content  = tls_private_key.ec2_key.private_key_pem
}

output "ssh-command1" {
  value = "ssh -i keypair.pem ec2-user@${aws_instance.ec2-one.public_dns}"
}

output "public-ip" {
  value = aws_instance.ec2-one.public_ip
}

output "ssh-command2" {
  value = "ssh -i keypair.pem ec2-user@${aws_instance.ec2-two.public_dns}"
}

output "public-ip2" {
  value = aws_instance.ec2-two.public_ip
}

