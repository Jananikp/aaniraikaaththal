#!/bin/bash
set -e

echo "🔄 Updating package list..."
apt-get update

echo "⏫ Upgrading installed packages..."
apt-get upgrade -y

echo "📦 Installing Nginx..."
apt-get install nginx -y

echo "🐳 Installing Docker..."
apt-get install -y ca-certificates curl gnupg lsb-release

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

usermod -aG docker ubuntu

echo "🟢 Installing Node.js (for Vite/Vue)..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

echo "🔐 Installing Certbot for Let's Encrypt..."
apt-get install -y certbot python3-certbot-nginx

echo "⚙️  Setting up basic Nginx config for Vue dev server..."
cat > /etc/nginx/sites-available/default << 'EOF'
server {
    listen 80;
    listen [::]:80;

    server_name _;

    location / {
        proxy_pass http://localhost:5173;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

echo "✅ Testing Nginx config..."
nginx -t

echo "🔁 Enabling services on boot..."
systemctl enable nginx
systemctl enable docker

echo "📂 Creating app directory..."
mkdir -p /home/ubuntu/aaniraikaaththal
chown -R ubuntu:ubuntu /home/ubuntu/aaniraikaaththal

echo "🚀 Rebooting to finalize setup..."
reboot
