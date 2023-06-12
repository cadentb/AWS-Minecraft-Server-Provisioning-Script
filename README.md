## Minecraft Server Deployment on AWS

### Background

In this tutorial, we will use Terraform to provision an EC2 instance on AWS and deploy a Minecraft server on it. The server will be accessible over the internet, allowing players to connect and play the game.

#### Diagram

Clone Repository -> Retrieve Credentials -> Create Key Pair -> `terraform init` -> `terraform plan` -> `terraform apply` -> Play Minecraft -> Connect to Server

### Requirements

To run the pipeline, you will need:

- Terraform installed on your local machine ([Installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli))
- AWS credentials with appropriate permissions to provision resources (access key, secret key, token, etc.)
- SSH key pair for accessing the EC2 instance

### Tools and Credentials

- Terraform: version 1.0.0 or later
- AWS credentials (access key, secret key, token) with appropriate permissions
- SSH key pair generated on AWS (required for accessing the EC2 instance)

### Configuration

Before running the Terraform commands, make sure to set up the following:

1. Retrieve your access key, secret key, and token with appropriate permissions.
2. Add the keys and token to their corresponding locations in main.tf
2. Generate an SSH key pair on AWS by following the steps in the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#prepare-key-pair).
   1. Place the private key file in the cloned repository's directory

### Pipeline Steps

1. Clone the repository.
2. Modify the following values in the code to fit your requirements:
   - `ami`: Replace with the desired AMI ID for your AWS region.
   - `instance_type`: Replace with the desired EC2 instance type.
   - `key_name`: Replace with the name of your SSH key pair.
   - `region`: Replace with your desired AWS region.
3. Save the changes to the `main.tf` file.

### Pipeline Commands

Open a terminal or command prompt and navigate to the directory where you saved the `main.tf` file. Run the following commands:

1. Initialize the Terraform working directory:

   ```bash
   terraform init
   ```

2. Preview the changes that Terraform will make:

   ```bash
   terraform plan
   ```

3. Apply the Terraform configuration to create the resources:

   ```bash
   terraform apply
   ```

   Review the plan and enter `yes` when prompted to proceed with the resource creation.

4. Wait for Terraform to provision the resources. Once complete, it will display the public IP address of the Minecraft server.

### Connecting to the Minecraft Server

To connect to the Minecraft server once it's running, follow these steps:

1. Open the Minecraft game on your computer.

2. Click on "Multiplayer" and then "Add Server".

3. Enter a name for the server.

4. In the "Server Address" field, enter the public IP address of the Minecraft server obtained from the Terraform output.

5. Click "Done" and then select the server from the server list.

6. Click "Join Server" to connect to the Minecraft server.

You can now start playing on your own Minecraft server hosted on AWS!

Remember to clean up the resources to avoid incurring unnecessary costs. Run `terraform destroy` in the same directory where the Terraform configuration is located to delete the provisioned resources.

Please note that this tutorial provides a basic setup for a Minecraft server on AWS. Additional configuration and security measures may be necessary for production environments.
