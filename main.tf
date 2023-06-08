# Specify your AWS provider credentials
provider "aws" {
  access_key = "<AWS_ACCESS_KEY>"
  secret_key = "<AWS_SECRET_KEY>"
  region     = "us-west-2"  # Change to your desired region
}

# Create a security group allowing SSH and Minecraft traffic
resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-sg"
  description = "Security group for Minecraft server"

  ingress {
    from_port   = 22   # SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25565   # Minecraft server
    to_port     = 25565
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

# Provision an EC2 instance for the Minecraft server
resource "aws_instance" "minecraft_server" {
  ami           = "ami-0c94855ba95c71c99"   # Replace with your desired AMI ID
  instance_type = "t2.micro"   # Replace with your desired instance type
  key_name      = "AWSMinecraftServerKeyPair"   # Replace with your SSH key pair name

  security_group_ids = [aws_security_group.minecraft_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y default-jdk
              wget -O minecraft_server.jar https://launcher.mojang.com/v1/objects/2f8d3f7c61fbc00c87f600704be6a19b88b6a0fa/server.jar
              echo "eula=true" > eula.txt
              nohup java -Xmx1024M -Xms1024M -jar minecraft_server.jar &
              EOF

  tags = {
    Name = "minecraft-server"
  }
}

# Configure instance stop and start behavior
resource "aws_instance" "minecraft_server" {
  instance_id = aws_instance.minecraft_server.id

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}

# Output the public IP address of the Minecraft server
output "minecraft_server_public_ip" {
  value       = aws_instance.minecraft_server.public_ip
  description = "Public IP address of the Minecraft server"
}
