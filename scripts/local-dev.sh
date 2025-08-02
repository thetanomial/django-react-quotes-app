#!/bin/bash

set -e

echo "🏠 Starting local development environment..."

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "🐳 Building and starting containers..."
docker-compose up --build -d

echo "⏳ Waiting for services to be ready..."
sleep 10

echo "🔗 Services started successfully!"
echo ""
echo "📱 Frontend: http://localhost:3000"
echo "🔧 Backend API: http://localhost:8000/api/"
echo "📊 Admin panel: http://localhost:8000/admin/"
echo "🗄️  Database: localhost:5432"
echo "🔴 Redis: localhost:6379"
echo ""
echo "📋 To view logs:"
echo "   docker-compose logs -f"
echo ""
echo "🛑 To stop the services:"
echo "   docker-compose down"