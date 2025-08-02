# Manual Deployment Commands

Copy and paste these commands one by one after SSHing to your droplet:

```bash
# 1. Navigate to app directory
cd /opt/quotes-app

# 2. Clean up existing files
rm -rf *

# 3. Clone your repository
git clone https://github.com/thetanomial/django-react-quotes-app.git .

# 4. Generate secure environment variables
POSTGRES_PASSWORD=$(openssl rand -base64 32)
DJANGO_SECRET_KEY=$(openssl rand -base64 50)

# 5. Create environment file
cat > .env << EOF
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
DJANGO_SECRET_KEY=$DJANGO_SECRET_KEY
DEBUG=False
EOF

# 6. Stop any existing containers
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

# 7. Build and start the application
docker-compose -f docker-compose.prod.yml up -d --build

# 8. Check status
docker-compose -f docker-compose.prod.yml ps

# 9. View logs (optional)
docker-compose -f docker-compose.prod.yml logs -f
```

The application will be available at: http://24.144.98.47