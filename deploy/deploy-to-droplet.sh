#!/bin/bash

echo "🚀 Deploying Django-React Quotes App to DigitalOcean"
echo "======================================================"
echo ""
echo "This script will SSH into your droplet and deploy the application."
echo "You'll need to enter your SSH key passphrase when prompted."
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

echo ""
echo "🔗 Connecting to droplet 24.144.98.47..."

ssh root@24.144.98.47 << 'ENDSSH'
set -e

echo "✅ Connected to droplet successfully!"
echo ""

# Check system status
echo "📊 Checking system status..."
docker --version
docker-compose --version
echo ""

# Navigate to app directory
echo "📁 Setting up application directory..."
mkdir -p /opt/quotes-app
cd /opt/quotes-app

# Clean up any existing files
echo "🧹 Cleaning up existing files..."
rm -rf *

# Clone the repository
echo "📥 Cloning repository..."
git clone https://github.com/thetanomial/django-react-quotes-app.git .

if [ $? -eq 0 ]; then
    echo "✅ Repository cloned successfully"
else
    echo "❌ Failed to clone repository"
    exit 1
fi

# Generate secure environment variables
echo "🔐 Generating secure credentials..."
POSTGRES_PASSWORD=$(openssl rand -base64 32)
DJANGO_SECRET_KEY=$(openssl rand -base64 50)

cat > .env << EOF
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
DJANGO_SECRET_KEY=$DJANGO_SECRET_KEY
DEBUG=False
EOF

echo "✅ Environment file created"

# Stop any existing containers
echo "🛑 Stopping any existing containers..."
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

# Build and start the application
echo "🐳 Building and starting containers..."
docker-compose -f docker-compose.prod.yml up -d --build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Deployment completed successfully!"
    echo ""
    echo "📊 Container status:"
    docker-compose -f docker-compose.prod.yml ps
    echo ""
    echo "🌐 Application should be available at:"
    echo "   http://24.144.98.47"
    echo "   http://quotes-app.24.144.98.47.nip.io"
    echo ""
    echo "📋 To check logs:"
    echo "   docker-compose -f docker-compose.prod.yml logs -f"
else
    echo "❌ Deployment failed"
    echo "📋 Check logs with:"
    echo "   docker-compose -f docker-compose.prod.yml logs"
fi

ENDSSH

echo ""
echo "🏁 Deployment script completed!"
echo ""
echo "Testing connection to your application..."
sleep 5

curl -I http://24.144.98.47 2>/dev/null && echo "✅ Application is responding!" || echo "⏳ Application may still be starting up..."