# Docker Setup Guide

This guide explains how to run the Car Booking System using Docker for quick and easy deployment.

## Prerequisites

- Docker installed on your system
- Docker Compose installed
- Git (to clone the repository)

## Quick Start with Docker

### 1. Clone the Repository

```bash
git clone https://github.com/AL-Kaisi/CarBookingSystem.git
cd CarBookingSystem
```

### 2. Start PostgreSQL with Docker Compose

```bash
docker-compose up -d
```

This will:
- Download PostgreSQL 13 Alpine image
- Create a database named `carbooking`
- Set up user credentials
- Expose PostgreSQL on port 5432

### 3. Install the Car Booking System

Wait for the database to be ready, then install:

```bash
# Connect to the database
docker exec -it carbooking_db psql -U carbooking -d carbooking

# Run installation script (from within psql)
\i /docker-entrypoint-initdb.d/install.sql

# Exit psql
\q
```

### 4. Load Sample Data (Optional)

```bash
docker exec -it carbooking_db psql -U carbooking -d carbooking -f /sql/data/sample_data.sql
```

### 5. Connect to the Database

You can connect using any PostgreSQL client:

- Host: localhost
- Port: 5432
- Database: carbooking
- Username: carbooking
- Password: carbooking123

## Using the System

### Through Docker

```bash
# Connect to psql
docker exec -it carbooking_db psql -U carbooking -d carbooking

# Run a query
SELECT * FROM available_vehicles('SUV', CURRENT_DATE, CURRENT_DATE + 7);

# Exit
\q
```

### Through Local psql

```bash
psql -h localhost -p 5432 -U carbooking -d carbooking
```

## Management Commands

### Stop the Database

```bash
docker-compose down
```

### Stop and Remove All Data

```bash
docker-compose down -v
```

### View Logs

```bash
docker-compose logs -f postgres
```

### Backup Database

```bash
docker exec carbooking_db pg_dump -U carbooking carbooking > backup.sql
```

### Restore Database

```bash
docker exec -i carbooking_db psql -U carbooking carbooking < backup.sql
```

## Customisation

### Change Database Credentials

Edit `docker-compose.yml`:

```yaml
environment:
  POSTGRES_DB: your_database
  POSTGRES_USER: your_user
  POSTGRES_PASSWORD: your_password
```

### Change Port

Edit `docker-compose.yml`:

```yaml
ports:
  - "5433:5432"  # Use port 5433 on host
```

### Persist Data Location

Add a local directory binding:

```yaml
volumes:
  - ./data:/var/lib/postgresql/data
```

## Troubleshooting

### Database Not Starting

Check logs:
```bash
docker-compose logs postgres
```

### Permission Denied

Ensure Docker daemon is running:
```bash
sudo systemctl start docker
```

### Port Already in Use

Change the port in `docker-compose.yml` or stop the conflicting service.

### Connection Refused

Wait for the database to fully start:
```bash
docker-compose ps
```

The status should show "healthy".

## Production Considerations

For production use:

1. Change default passwords
2. Use environment variables for secrets
3. Enable SSL/TLS
4. Set up regular backups
5. Monitor database performance
6. Use Docker secrets for passwords

## Alternative: Using Docker Run

If you prefer not to use Docker Compose:

```bash
# Create network
docker network create carbooking-net

# Run PostgreSQL
docker run -d \
  --name carbooking_db \
  --network carbooking-net \
  -e POSTGRES_DB=carbooking \
  -e POSTGRES_USER=carbooking \
  -e POSTGRES_PASSWORD=carbooking123 \
  -p 5432:5432 \
  -v postgres_data:/var/lib/postgresql/data \
  postgres:13-alpine

# Install schema
docker exec -i carbooking_db psql -U carbooking -d carbooking < scripts/install.sql
```

## Cleanup

To completely remove the Car Booking System:

```bash
# Stop and remove containers
docker-compose down -v

# Remove images (optional)
docker rmi postgres:13-alpine

# Remove the local repository (optional)
cd ..
rm -rf CarBookingSystem
```

That's it! You now have the Car Booking System running in Docker.