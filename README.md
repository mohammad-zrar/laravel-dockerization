# Dockerized Laravel Project Starter

A complete Docker setup for developing Laravel applications with Nginx, PHP-FPM, MySQL, and Composer.

## 📋 Prerequisites

- Docker and Docker Compose installed on your system
- Basic knowledge of Laravel and Docker

## 🏗️ Project Structure

```
.
├── docker-compose.yml          # Docker Compose configuration
├── dockerfiles/
│   ├── php.dockerfile          # PHP-FPM 8.3 with MySQL extensions
│   └── composer.dockerfile     # Composer service
├── env/
│   └── mysql.env              # MySQL environment variables
├── nginx/
│   └── nginx.conf             # Nginx server configuration
└── src/                       # Laravel application directory (created after setup)
```

## 🚀 Quick Start

### 1. Clone or Download This Repository

```bash
git clone git@github.com:mohammad-zrar/laravel-dockerization.git
cd laravel-dockerization
```

### 2. Create Your Laravel Project

Run the following command to create a new Laravel project in the `src` directory:

```bash
docker compose run --rm composer create-project laravel/laravel .
```

This will:

- Download and install Laravel and all dependencies
- Generate the application key
- Run initial migrations
- Set up the project structure

**Note:** The `.` at the end tells Composer to install Laravel in the current directory (`src/`).

### 3. Configure Docker Compose

Make sure your `docker-compose.yml` has the volume mount for the `server` service so Nginx can access your Laravel files. The `server` service should include:

```yaml
server:
  volumes:
    - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    - ./src:/var/www/html:delegated # Add this line if missing
```

### 4. Configure Laravel Environment

Update the `.env` file in the `src/` directory with your MySQL database credentials:

```env
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=demo_db
DB_USERNAME=laravel
DB_PASSWORD=secret
```

These credentials match the default values in `env/mysql.env`. You can modify them if needed.

### 5. Set Proper Permissions

Laravel needs write permissions for storage and cache directories:

```bash
docker compose run --rm php chmod -R 775 storage bootstrap/cache
docker compose run --rm php chown -R www-data:www-data storage bootstrap/cache
```

### 6. Start the Services

Start all Docker containers:

```bash
docker compose up -d
```

This will start:

- **Nginx** server on port `8000`
- **PHP-FPM** service
- **MySQL** database
- **Composer** service (for running Composer commands)

### 7. Access Your Application

Open your browser and navigate to:

```
http://localhost:8000
```

You should see the Laravel welcome page!

## 🛠️ Common Commands

### Composer Commands

Install dependencies:

```bash
docker compose run --rm composer install
```

Update dependencies:

```bash
docker compose run --rm composer update
```

Require a new package:

```bash
docker compose run --rm composer require vendor/package
```

### Artisan Commands

Run migrations:

```bash
docker compose run --rm php php artisan migrate
```

Create a controller:

```bash
docker compose run --rm php php artisan make:controller MyController
```

Clear cache:

```bash
docker compose run --rm php php artisan cache:clear
docker compose run --rm php php artisan config:clear
docker compose run --rm php php artisan route:clear
docker compose run --rm php php artisan view:clear
```

Generate application key (if needed):

```bash
docker compose run --rm php php artisan key:generate
```

### Docker Commands

View running containers:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f
```

View logs for a specific service:

```bash
docker compose logs -f php
docker compose logs -f mysql
docker compose logs -f server
```

Stop all services:

```bash
docker compose down
```

Stop and remove volumes (⚠️ This will delete your database data):

```bash
docker compose down -v
```

Rebuild containers:

```bash
docker compose build
docker compose up -d
```

## 🔧 Services Overview

### Nginx (server)

- **Port:** 8000
- **Image:** nginx:stable-alpine
- **Purpose:** Web server that serves your Laravel application
- **Document Root:** /var/www/public (Laravel's public directory)

### PHP-FPM (php)

- **Version:** PHP 8.3
- **Extensions:** PDO, PDO_MySQL
- **Purpose:** Processes PHP requests from Nginx
- **Working Directory:** /var/www/html

### MySQL (mysql)

- **Version:** MySQL 8.4
- **Database:** homestead (default)
- **User:** homestead (default)
- **Password:** secret (default)
- **Configuration:** `env/mysql.env`

### Composer (composer)

- **Version:** Composer 2.9
- **Purpose:** Run Composer commands to manage PHP dependencies
- **Working Directory:** /var/www/html

## 📝 Configuration Files

### MySQL Environment (`env/mysql.env`)

Default database credentials:

- Database: `homestead`
- User: `homestead`
- Password: `secret`
- Root Password: `secret`

You can modify these values, but remember to update your Laravel `.env` file accordingly.

### Nginx Configuration (`nginx/nginx.conf`)

Configured to:

- Listen on port 80
- Serve files from `/var/www/public`
- Process PHP files through PHP-FPM
- Handle Laravel routing

## 🐛 Troubleshooting

### Port Already in Use

If port 8000 is already in use, change it in `docker-compose.yml`:

```yaml
ports:
  - "8080:80" # Change 8000 to any available port
```

### Permission Denied Errors

If you encounter permission issues:

```bash
docker compose run --rm php chmod -R 775 storage bootstrap/cache
docker compose run --rm php chown -R www-data:www-data storage bootstrap/cache
```

### Database Connection Issues

1. Make sure MySQL service is running: `docker compose ps`
2. Check that your `.env` file has the correct database credentials
3. Verify the database host is set to `mysql` (the service name)
4. Wait a few seconds after starting services for MySQL to initialize

### Container Not Found

If you get "container not found" errors, rebuild the containers:

```bash
docker compose build
docker compose up -d
```

### Laravel Application Key

If you need to regenerate the application key:

```bash
docker compose run --rm php php artisan key:generate
```

## 📚 Additional Resources

- [Laravel Documentation](https://laravel.com/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is open source and available under the MIT License.
