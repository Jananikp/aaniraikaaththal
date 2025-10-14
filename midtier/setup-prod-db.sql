-- Production Database Setup for Aanirai Application
-- Run these commands in your production PostgreSQL instance

-- =============================================
-- PRODUCTION DATABASE SETUP
-- =============================================

-- Keep same DB name as local
CREATE DATABASE aanirai;

-- Keep same user as local (change password to your secure prod password)
CREATE USER aanirai_user WITH PASSWORD 'password';

-- 3. Grant connection privileges
GRANT CONNECT ON DATABASE aanirai TO aanirai_user;

-- 4. Connect to the production database
\c aanirai;

-- 5. Grant schema privileges (more restrictive than local)
GRANT USAGE ON SCHEMA public TO aanirai_user;
GRANT CREATE ON SCHEMA public TO aanirai_user;

-- 6. Set default privileges for future tables (read/write only, no DDL)
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO aanirai_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO aanirai_user;

-- 7. Optional: Create the oauth_users table manually (or let Hibernate create it)
CREATE TABLE IF NOT EXISTS oauth_users (
    id BIGSERIAL PRIMARY KEY,
    provider VARCHAR(50) NOT NULL,
    provider_user_id VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(320),
    display_name VARCHAR(255),
    picture_url VARCHAR(1024),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    login_count BIGINT NOT NULL DEFAULT 0
);

-- 8. Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_oauth_users_provider_user_id ON oauth_users(provider_user_id);
CREATE INDEX IF NOT EXISTS idx_oauth_users_email ON oauth_users(email);
CREATE INDEX IF NOT EXISTS idx_oauth_users_created_at ON oauth_users(created_at);

-- 9. Grant table privileges to the application user
GRANT SELECT, INSERT, UPDATE, DELETE ON oauth_users TO aanirai_user;
GRANT USAGE, SELECT ON SEQUENCE oauth_users_id_seq TO aanirai_user;

-- =============================================
-- PRODUCTION ENVIRONMENT VARIABLES
-- =============================================
-- Set these environment variables on your production server (same names as local):
-- 
-- DB_URL=jdbc:postgresql://your-db-host:5432/aanirai
-- DB_USERNAME=aanirai_user
-- DB_PASSWORD=your_secure_password_here
-- GOOGLE_CLIENT_ID=your_google_client_id
-- GOOGLE_CLIENT_SECRET=your_google_client_secret
-- JWT_SECRET=your_jwt_secret_key
-- JWT_EXPIRATION=86400
-- JWT_CLIENT_ID=your_google_client_id
-- FRONTEND_URL=https://eastcoastfarmer.com
