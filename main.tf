# Specify your AWS provider credentials
provider "aws" {
  access_key = "ASIATL7JQS6A4IUFL3HR"
  secret_key = "RveRkR9Soo+MHq+mv7ZYowH1tNOhy/9VPFZbH8FO"
  token = "FwoGZXIvYXdzEEsaDMfkoJ1swG/lyOrmlCLJAcnp1FLlRNxONzH/QlRZXzK4T8MrV4MtT27mxczXwSuO3sPwEIqYBRngsLM9CVj90p/ySokJvRIqJ+ui5tSfYdryTo4fpEleIJuDhFPeaky7z2onB14kGWseFyEf9STqhATO3UT9T/dVG5L9uTkXoA0L0VviwOtJs3WMpXzPi9mK0tyuDiwCVxHgwxTZYJIF/YyuRaaLeswCtHNphWTvRE39FxL7T4axdVvAzBbqLSQgfrEycfbC4M0bBS14/JsHqsxXNS4OBEe/OyiskIqkBjItbdu4kph5U9V+cvtm4P2clbSwH7giLoRqY/U4kxUBe3MyJMUhVc1D0kAF/AdP"
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
  ami           = "ami-03f65b8614a860c29"   # Replace with your desired AMI ID
  instance_type = "t2.medium"   # Replace with your desired instance type
  key_name      = "minecraftkey"   # Replace with your SSH key pair name

  security_groups = [aws_security_group.minecraft_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y openjdk-17-jdk
              wget -O minecraft_server.jar https://piston-data.mojang.com/v1/objects/15c777e2cfe0556eef19aab534b186c0c6f277e1/server.jar
              echo "eula=true" > eula.txt
              nohup java -Xmx1024M -Xms1024M -jar minecraft_server.jar &
              EOF

  tags = {
    Name = "minecraft-server"
  }

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
