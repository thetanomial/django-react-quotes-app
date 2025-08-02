# Real-Time Quotes Application

A full-stack application that delivers inspirational quotes in real-time every 15 seconds using Django (backend), React (frontend), WebSockets, Docker, and Terraform for DigitalOcean deployment.

## 🌟 Features

- **Real-time Quote Delivery**: WebSocket connection delivers quotes every 15 seconds
- **Django Backend**: REST API with WebSocket support using Django Channels
- **React Frontend**: Single-page application with beautiful UI
- **Docker Integration**: Containerized services for easy deployment
- **Terraform Deployment**: Infrastructure as Code for DigitalOcean
- **PostgreSQL Database**: Persistent quote storage
- **Redis**: WebSocket channel layer backend

## 🏗️ Architecture

```
┌─────────────────┐    WebSocket    ┌─────────────────┐
│  React Frontend │ ◄──────────────► │ Django Backend  │
│   (Port 3000)   │    HTTP API     │   (Port 8000)   │
└─────────────────┘                 └─────────────────┘
                                             │
                                             ▼
                                    ┌─────────────────┐
                                    │   PostgreSQL    │
                                    │   (Port 5432)   │
                                    └─────────────────┘
                                             │
                                             ▼
                                    ┌─────────────────┐
                                    │     Redis       │
                                    │   (Port 6379)   │
                                    └─────────────────┘
```

## 🚀 Quick Start

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd docker-terraform-django-react-xp
   ```

2. **Start local development environment**
   ```bash
   chmod +x scripts/local-dev.sh
   ./scripts/local-dev.sh
   ```

3. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8000/api/
   - Admin Panel: http://localhost:8000/admin/

### Production Deployment to DigitalOcean

1. **Prerequisites**
   - DigitalOcean account and API token
   - SSH key added to your DigitalOcean account
   - Terraform installed locally

2. **Configure deployment**
   ```bash
   cp terraform/terraform.tfvars.example terraform/terraform.tfvars
   # Edit terraform.tfvars with your DigitalOcean credentials
   ```

3. **Deploy to DigitalOcean**
   ```bash
   chmod +x scripts/deploy.sh
   ./scripts/deploy.sh
   ```

## 📁 Project Structure

```
docker-terraform-django-react-xp/
├── backend/                    # Django application
│   ├── quotes_project/        # Django project settings
│   ├── quotes/                # Quotes app with WebSocket consumers
│   ├── requirements.txt       # Python dependencies
│   └── Dockerfile            # Backend container
├── frontend/                  # React application
│   ├── src/
│   │   ├── components/       # React components
│   │   └── App.js           # Main app component
│   ├── package.json         # Node.js dependencies
│   └── Dockerfile          # Frontend container
├── terraform/               # Infrastructure as Code
│   ├── main.tf             # Terraform configuration
│   ├── cloud-init.yml      # Server initialization
│   └── terraform.tfvars.example
├── scripts/                # Deployment scripts
├── docker-compose.yml      # Local development
└── README.md
```

## 🔧 Development

### Backend (Django)

The backend uses Django with Django Channels for WebSocket support:

- **Models**: `Quote` model with text and author fields
- **API**: REST endpoints for quotes listing and random quote
- **WebSocket**: Consumer that sends quotes every 15 seconds
- **Database**: PostgreSQL with sample quotes

### Frontend (React)

The frontend is a single React component that:

- Establishes WebSocket connection to backend
- Displays quotes with smooth animations
- Shows connection status
- Updates quote display every 15 seconds

### Commands

```bash
# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Build production images
chmod +x scripts/build-images.sh
./scripts/build-images.sh

# Access backend shell
docker-compose exec backend python manage.py shell

# Run migrations
docker-compose exec backend python manage.py migrate

# Create admin user
docker-compose exec backend python manage.py createsuperuser
```

## 🌐 Environment Variables

### Development (.env)
- `DEBUG=True`
- `SECRET_KEY=development-key`
- Database and Redis connection settings

### Production
- Automatically generated secure secrets
- Environment-specific configurations
- DigitalOcean droplet settings

## 📊 Monitoring

### Local Development
- Backend logs: `docker-compose logs backend`
- Frontend logs: `docker-compose logs frontend`
- Database logs: `docker-compose logs db`

### Production
- SSH to droplet: `ssh root@<droplet-ip>`
- View logs: `docker-compose -f /opt/quotes-app/docker-compose.prod.yml logs -f`

## 🔒 Security

- Environment variables for sensitive data
- CORS properly configured
- Production secrets auto-generated
- Firewall rules configured via Terraform
- HTTPS ready (SSL certificate setup required)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with `./scripts/local-dev.sh`
5. Submit a pull request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🆘 Troubleshooting

### Common Issues

1. **WebSocket connection fails**
   - Check if backend is running on port 8000
   - Verify CORS settings in Django

2. **No quotes appearing**
   - Run: `docker-compose exec backend python manage.py populate_quotes`

3. **Build failures**
   - Clear Docker cache: `docker system prune -a`
   - Rebuild: `docker-compose up --build`

4. **Terraform deployment issues**
   - Verify DigitalOcean API token
   - Check SSH key exists in your DO account
   - Ensure region is available

### Getting Help

For issues and questions:
1. Check the logs first
2. Review this README
3. Search existing issues
4. Create a new issue with detailed information