# ========== Provider ==========
provider "aws" {
  region = "ap-south-1"  # Asia Pacific (Mumbai)
}

# ========== Generate SSH Key Pair ==========
resource "tls_private_key" "web_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.web_key.private_key_pem
  filename        = "${path.module}/keys/web-server-key.pem"
  file_permission = "0600"  # 🔐 Only owner can read
}

resource "aws_key_pair" "web_key" {
  key_name   = "web-server-key"
  public_key = tls_private_key.web_key.public_key_openssh

  tags = {
    Name = "web-server-key"
  }
}

# ========== VPC ==========
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

# ========== Subnet ==========
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"  
  tags = {
    Name = "main-subnet"
  }
}

# ========== Internet Gateway ==========
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# ========== Route Table ==========
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# ========== Security Group ==========
resource "aws_security_group" "web_sg" {
  name        = "allow_http_https_ssh"
  description = "Allow HTTP, HTTPS and SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 🔒 Later restrict to your IP
    description = "Allow SSH from anywhere (TEMPORARY)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "web-server-sg"
  }
}

# ========== EC2 Instance ==========
resource "aws_instance" "web" {
  ami                    = "ami-02d26659fd82cf299"  # ✅ Your Ubuntu 22.04 AMI in Mumbai
  instance_type          = "t2.micro"              # ✅ Free Tier eligible
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.web_key.key_name  # ✅ Use generated key

  user_data = file("${path.module}/scripts/install.sh")

  tags = {
    Name = "vue-web-server"
  }

  associate_public_ip_address = true
}

# ========== Elastic IP (Free if attached to running instance) ==========
resource "aws_eip" "web_eip" {
  instance = aws_instance.web.id
  

  tags = {
    Name = "web-server-eip"
  }
}
# ========== GitHub Actions Secret: EC2_PUBLIC_IP ==========
resource "github_actions_secret" "ec2_public_ip" {
  repository      = var.github_repo
  secret_name     = "EC2_PUBLIC_IP"
  plaintext_value = aws_eip.web_eip.public_ip
}
# ========== Outputs ==========
output "elastic_ip" {
  description = "Persistent public IP for your server"
  value       = aws_eip.web_eip.public_ip
}

output "ssh_command" {
  description = "Command to SSH into your server"
  value       = "ssh -i keys/web-server-key.pem ubuntu@${aws_eip.web_eip.public_ip}"
}

output "http_url" {
  description = "HTTP URL of your site (before HTTPS setup)"
  value       = "http://${aws_eip.web_eip.public_ip}"
}
