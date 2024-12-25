# Security Group creation
resource "aws_security_group" "sg-test" {
  name        = "ec2-test-sg"
  description = "Allow SSH and HTTP access"

  # Allow inbound SSH (port 22) from anywhere (0.0.0.0/0)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTP (port 80) from anywhere (0.0.0.0/0)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic (default allows all)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "DEMO"
  }
}

# EC2 Instance creation
resource "aws_instance" "example" {
  ami           = "ami-053b12d3152c0cc71"  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"               # Change to the desired instance type
  key_name      = "ec2-test"     # Replace with your SSH key pair name

  # Attach the previously created security group to the instance
  vpc_security_group_ids = [aws_security_group.sg-test.id]

  # Tags for identification
  tags = {
    Name = "EC2-TEST",
    ENV  = "dev"
  }


  availability_zone = "ap-south-1a"  # Adjust based on your region

  # Subnet ID (optional)
  subnet_id = "subnet-0effed2fb97154dc8"  # Replace with your subnet ID (if using VPC)
}

# Output the public IP of the EC2 instance
output "ec2_public_ip" {
  value = aws_instance.example.public_ip
}
