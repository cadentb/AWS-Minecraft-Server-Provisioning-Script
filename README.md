# AWS-Minecraft-Server-Provisioning-Script

To run the Terraform script, follow these steps:

Install Terraform: Download and install Terraform from the official website (https://www.terraform.io/downloads.html) based on your operating system.

Preliminary AWS Steps
Make keypair
get access key and secret key
choose desired AMI ID and instance_type
select correct region in tf file


Initialize the Terraform project: Open a terminal or command prompt, navigate to the directory where you created the main.tf file, and run the following command to initialize the Terraform project:

bash
Copy code
terraform init
This command downloads the necessary provider plugins and sets up the working directory.

Plan the infrastructure changes: Run the following command to see a preview of the changes that Terraform will make to your infrastructure:

bash
Copy code
terraform plan
This command will show you the resources that Terraform will create, modify, or destroy.

Apply the infrastructure changes: If the plan looks good, you can apply the changes by running the following command:

bash
Copy code
terraform apply
Terraform will prompt you to confirm the changes. Enter yes to proceed.

This command will provision the AWS resources defined in the Terraform script.

Wait for the provisioning to complete: Terraform will take some time to provision the resources. Once the process is complete, you will see a message indicating the changes that were made.

Access the Minecraft server: After the script finishes, it will output the public IP address of the Minecraft server. You can use this IP address to connect to your Minecraft server.

bash
Copy code
Outputs:

minecraft_server_public_ip = <public_ip>
Replace <public_ip> with the actual IP address shown in the output.

That's it! You have successfully provisioned the AWS resources for your Minecraft server using Terraform. You can now connect to the server using the provided public IP address.