#!/bin/bash

# Local Database Setup Script
# Run this script to set up the local PostgreSQL database for development

echo "Setting up local PostgreSQL database for Aanirai application..."

# Check if PostgreSQL is running
if ! pg_isready -q; then
    echo "PostgreSQL is not running. Please start PostgreSQL first."
    echo "On macOS with Homebrew: brew services start postgresql"
    exit 1
fi

# Create database and user
echo "Creating database and user..."
psql -U postgres -c "CREATE DATABASE aanirai;" 2>/dev/null || echo "Database 'aanirai' may already exist"
psql -U postgres -c "CREATE USER aanirai_user WITH PASSWORD 'password';" 2>/dev/null || echo "User 'aanirai_user' may already exist"

# Grant privileges
echo "Granting privileges..."
psql -U postgres -d aanirai -c "GRANT ALL PRIVILEGES ON DATABASE aanirai TO aanirai_user;"
psql -U postgres -d aanirai -c "GRANT ALL ON SCHEMA public TO aanirai_user;"
psql -U postgres -d aanirai -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO aanirai_user;"
psql -U postgres -d aanirai -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO aanirai_user;"
psql -U postgres -d aanirai -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO aanirai_user;"
psql -U postgres -d aanirai -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO aanirai_user;"

echo "Local database setup complete!"
echo ""
echo "Update your .env file with these database credentials:"
echo "DB_URL=jdbc:postgresql://localhost:5432/aanirai"
echo "DB_USERNAME=aanirai_user"
echo "DB_PASSWORD=password"
