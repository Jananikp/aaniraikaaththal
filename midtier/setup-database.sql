-- Database Setup for Aanirai Application
-- Run these commands in pgAdmin or psql

-- =============================================
-- LOCAL DEVELOPMENT SETUP
-- =============================================

-- 1. Create database (run as postgres superuser)
CREATE DATABASE aanirai;

-- 2. Create application user (run as postgres superuser)
CREATE USER aanirai_user WITH PASSWORD 'password';

-- 3. Grant privileges to the user
GRANT ALL PRIVILEGES ON DATABASE aanirai TO aanirai_user;

-- 4. Connect to the aanirai database and grant schema privileges
\c aanirai;
GRANT ALL ON SCHEMA public TO aanirai_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO aanirai_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO aanirai_user;

-- 5. Set default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO aanirai_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO aanirai_user;

-- =============================================
-- PRODUCTION SETUP (More Secure)
-- =============================================

-- 1. Create database (run as postgres superuser)
-- CREATE DATABASE aanirai_prod;

-- 2. Create application user with limited privileges (run as postgres superuser)
-- CREATE USER aanirai_prod_user WITH PASSWORD 'your_secure_password_here';

-- 3. Grant only necessary privileges
-- GRANT CONNECT ON DATABASE aanirai_prod TO aanirai_prod_user;

-- 4. Connect to the production database
-- \c aanirai_prod;

-- 5. Grant schema privileges
-- GRANT USAGE ON SCHEMA public TO aanirai_prod_user;
-- GRANT CREATE ON SCHEMA public TO aanirai_prod_user;

-- 6. Set default privileges for future tables
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO aanirai_prod_user;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO aanirai_prod_user;

-- =============================================
-- TABLE CREATION (Will be auto-created by Hibernate)
-- =============================================

-- The oauth_users table will be automatically created by Spring Boot/Hibernate
-- when the application starts with spring.jpa.hibernate.ddl-auto=update

-- If you want to create it manually, here's the structure:
/*
CREATE TABLE oauth_users (
    id BIGSERIAL PRIMARY KEY,
    provider VARCHAR(50) NOT NULL,
    provider_user_id VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(320),
    display_name VARCHAR(255),
    picture_url VARCHAR(1024),
    created_at TIMESTAMP NOT NULL,
    last_login_at TIMESTAMP NOT NULL,
    login_count BIGINT NOT NULL
);

-- Create index for faster lookups
CREATE INDEX idx_oauth_users_provider_user_id ON oauth_users(provider_user_id);
CREATE INDEX idx_oauth_users_email ON oauth_users(email);
*/
