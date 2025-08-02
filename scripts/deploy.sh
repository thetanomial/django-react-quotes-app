#!/bin/bash

set -e

echo "🚀 Starting deployment process..."

if [ ! -f "terraform/terraform.tfvars" ]; then
    echo "❌ terraform.tfvars not found. Please copy terraform.tfvars.example and fill in your values."
    exit 1
fi

cd terraform

echo "📋 Initializing Terraform..."
terraform init

echo "📝 Planning Terraform deployment..."
terraform plan

echo "🎯 Applying Terraform configuration..."
terraform apply -auto-approve

echo "📄 Getting droplet IP..."
DROPLET_IP=$(terraform output -raw droplet_ip)
DOMAIN_NAME=$(terraform output -raw domain_name)

echo "✅ Deployment completed!"
echo "🌐 Application will be available at: http://$DOMAIN_NAME"
echo "🖥️  Droplet IP: $DROPLET_IP"
echo ""
echo "⏱️  Note: It may take a few minutes for the application to fully start."
echo "📊 You can check the status by SSH'ing to the droplet and running:"
echo "   ssh root@$DROPLET_IP"
echo "   docker-compose -f /opt/quotes-app/docker-compose.prod.yml logs -f"