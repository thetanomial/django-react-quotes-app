#!/bin/bash

echo "🚀 Manual Deployment Script for DigitalOcean Droplet"
echo "=================================================="
echo ""
echo "📋 Instructions:"
echo "1. Copy this entire script"
echo "2. SSH into your droplet: ssh root@24.144.98.47"
echo "3. Paste and run the script"
echo ""
echo "🔑 For private repo access, you'll need to either:"
echo "   - Make the repo temporarily public, OR"
echo "   - Set up SSH key or GitHub token on the server"
echo ""
echo "📋 COPY THE COMMANDS BELOW:"
echo "=================================================="
echo ""

cat << 'EOF'
# Update system
apt-get update

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl start docker
    systemctl enable docker
fi

# Install Docker Compose if not already installed
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Navigate to app directory
mkdir -p /opt/quotes-app
cd /opt/quotes-app

# Remove any existing files
rm -rf *

# OPTION 1: For public repo (temporarily)
echo "🔓 Cloning repository..."
git clone https://github.com/thetanomial/django-react-quotes-app.git .

# Generate secure environment variables
echo "🔐 Generating secure credentials..."
POSTGRES_PASSWORD=$(openssl rand -base64 32)
DJANGO_SECRET_KEY=$(openssl rand -base64 50)

cat > .env << EOL
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
DJANGO_SECRET_KEY=$DJANGO_SECRET_KEY
DEBUG=False
EOL

echo "📊 Environment file created"

# Build and start the application
echo "🐳 Building and starting containers..."
docker-compose -f docker-compose.prod.yml up -d --build

echo "✅ Deployment complete!"
echo ""
echo "📊 Check status with:"
echo "   docker-compose -f docker-compose.prod.yml ps"
echo "   docker-compose -f docker-compose.prod.yml logs -f"
echo ""
echo "🌐 App should be available at http://$(curl -s ifconfig.me)"
EOF

echo ""
echo "=================================================="