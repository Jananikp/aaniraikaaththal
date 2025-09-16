#!/bin/bash
# deploy.sh - One-command deploy to EC2

set -e  # Exit on any error

echo "📦 Deploying to production..."

# Get EC2 IP from Terraform (optional — or hardcode it)
EC2_IP=$(cd /Users/janani/Downloads/aaniraikaaththal/terraform/ && terraform output -raw elastic_ip)

# Or hardcode it (faster):
 EC2_IP="13.204.25.217"

# Copy your entire project to EC2 (excluding node_modules, .git, etc.)
rsync -avz --delete \
  --exclude="node_modules" \
  --exclude=".git" \
  --exclude="dist" \
  --exclude=".env" \
  ./ ubuntu@$EC2_IP:/home/ubuntu/aaniraikaaththal

# SSH into server → install deps → restart app
ssh -i /Users/janani/Downloads/aaniraikaaththal/terraform/keys//web-server-key.pem ubuntu@$EC2_IP << 'EOF'
  cd /home/ubuntu/aaniraikaaththal
  echo "🔄 Installing dependencies..."
  npm install --production
  echo "🚀 Restarting app..."
  pkill -f "vite" 2>/dev/null || true  # Kill old Vite process
  nohup npm run dev > /dev/null 2>&1 &
  echo "✅ App restarted on port 5173"
EOF

echo "🎉 Deploy complete! Visit: http://$EC2_IP"
