# Specify your AWS provider credentials
provider "aws" {
  access_key = "ASIATL7JQS6AWAWMXDZT"
  secret_key = "YLzqKb7PMNnbQ5xlEPjY+CfJ5uhn0X75Enct0/yo"
  token = "FwoGZXIvYXdzEHUaDD+v1HvzmsrJjzS3fiLJAbN6Qu4c2I2pKX7UhLOTFWHk18CFTmzUAp2RJy6HzqQSa77iWExA/R8B7F0YyJ2zBLTpxmVLSdbd/C4f+qGz1rv8EZT58ZGUNtMzHu7CWQlQY1FR1r12eqC7ASXoA9Gl1yAV6xinSTu5wwe2ohmNS5j4gQjIrji1Fm6HpLZHzv0dF/V6bF7yTo0RMQPUcjoBelYkqO8fT3qxBM0jI45MeGHOugPzL44b0IoQYQNeZpt0L3Q7iiIEKb0vytTFhFV7Gl1XPhnGiaoc0Sj4mpOkBjItyPAZ0LogbjTWZG4i5Muxv9JEwSPkLpj/W0fJqjpvWVdq10cEq8OJZBS+bVof"
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
            wget -O /home/ubuntu/minecraft_server.jar https://piston-data.mojang.com/v1/objects/15c777e2cfe0556eef19aab534b186c0c6f277e1/server.jar
            echo "eula=true" > /home/ubuntu/eula.txt
            
            # Create a systemd service for Minecraft server
            cat > minecraft.service << EOL
            [Unit]
            Description=Minecraft Server
            After=network.target

            [Service]
            WorkingDirectory=/home/ubuntu
            User=ubuntu
            ExecStart=nohup /usr/bin/java -Xmx1024M -Xms1024M -jar minecraft_server.jar
            ExecStop=/bin/kill -INT $MAINPID
            Restart=on-failure

            [Install]
            WantedBy=multi-user.target
            EOL
            
            sudo mv minecraft.service /etc/systemd/system/
            sudo systemctl enable minecraft.service
            sudo systemctl start minecraft.service
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
