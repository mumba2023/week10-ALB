#security group

resource "aws_security_group" "lb" {
    name = "ld-sg-group1"
    description = "allow httpd"
    vpc_id = aws_vpc.vpc1.id

 ingress {
    description = "allow http"
    from_port = 80 
    to_port = 80 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 } 
 ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

 }
}

# security group2

resource "aws_security_group" "ec2" {
    name = "ec2-sg-group"
    description = "allow ssh and httpd"
    vpc_id = aws_vpc.vpc1.id


    ingress {
        description = "allow ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "allow httpd"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      env = "Dev"
    }
  
}