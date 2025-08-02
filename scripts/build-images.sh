#!/bin/bash

set -e

echo "🏗️  Building Docker images for production..."

echo "📦 Building backend image..."
docker build -t quotes-backend:latest ./backend

echo "📦 Building frontend image..."
docker build -t quotes-frontend:latest ./frontend

echo "✅ All images built successfully!"
echo ""
echo "📤 To push to a registry (optional):"
echo "   docker tag quotes-backend:latest your-registry/quotes-backend:latest"
echo "   docker tag quotes-frontend:latest your-registry/quotes-frontend:latest"
echo "   docker push your-registry/quotes-backend:latest"
echo "   docker push your-registry/quotes-frontend:latest"