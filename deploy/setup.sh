#!/bin/bash

set -e

echo "🚀 Setting up Quotes Application..."

# Generate secure passwords
POSTGRES_PASSWORD=$(openssl rand -base64 32)
DJANGO_SECRET_KEY=$(openssl rand -base64 50)

# Create environment file
cat > .env << EOF
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
DJANGO_SECRET_KEY=$DJANGO_SECRET_KEY
DEBUG=False
EOF

echo "📊 Environment file created with secure credentials"

# Build and start the application
echo "🐳 Building and starting containers..."
docker-compose -f docker-compose.prod.yml up -d --build

echo "✅ Application is starting up!"
echo "🌐 It will be available at http://$(curl -s ifconfig.me) in a few minutes"
echo ""
echo "📊 To check status:"
echo "   docker-compose -f docker-compose.prod.yml logs -f"
echo ""
echo "🛑 To stop:"
echo "   docker-compose -f docker-compose.prod.yml down"