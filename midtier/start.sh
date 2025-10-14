#!/bin/bash

# Usage: ./start.sh [local|prod]
PROFILE=${1:-local}

echo "Setting SPRING_PROFILES_ACTIVE to $PROFILE"
export SPRING_PROFILES_ACTIVE=$PROFILE

# --- Load environment variables based on profile ---
if [ "$PROFILE" = "prod" ]; then
  ENV_FILE="/etc/aanirai/env"
  if [ -f "$ENV_FILE" ]; then
    echo "Loading environment from $ENV_FILE"
    export $(grep -v '^#' "$ENV_FILE" | xargs)
    # Map to Spring Boot standard env var names so they bind to spring.datasource.*
    if [ -n "$DB_URL" ]; then export SPRING_DATASOURCE_URL="$DB_URL"; fi
    if [ -n "$DB_USERNAME" ]; then export SPRING_DATASOURCE_USERNAME="$DB_USERNAME"; fi
    if [ -n "$DB_PASSWORD" ]; then export SPRING_DATASOURCE_PASSWORD="$DB_PASSWORD"; fi
  else
    echo "ERROR: Production env file not found: $ENV_FILE"
    echo "Create it with DB_URL, DB_USERNAME, DB_PASSWORD"
    exit 1
  fi
else
  # Local: load from .env file if it exists
  ENV_FILE=".env"
  if [ -f "$ENV_FILE" ]; then
    echo "Loading environment from $ENV_FILE"
    # export $(grep -v '^#' "$ENV_FILE" | grep -v '^$' | xargs)
    set -a  # automatically export all variables
    source "$ENV_FILE"
    set +a
  else
    echo "No .env file found, using defaults"
  fi
  
  # # Set defaults if not already set
  # export DB_URL=${DB_URL:-jdbc:postgresql://localhost:5432/aanirai}
  # export DB_USERNAME=${DB_USERNAME:-postgres}
  # export DB_PASSWORD=${DB_PASSWORD:-password}
  export GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID:-531654488309-l67rmm2ga2kvdvr5ornmrel3uohdrihb.apps.googleusercontent.com}
  export GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET:-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}
  export JWT_SECRET=${JWT_SECRET:-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}
  export JWT_EXPIRATION=${JWT_EXPIRATION:-86400}
  export JWT_CLIENT_ID=${JWT_CLIENT_ID:-531654488309-l67rmm2ga2kvdvr5ornmrel3uohdrihb.apps.googleusercontent.com}
  export FRONTEND_URL=${FRONTEND_URL:-http://localhost:5173}
  # Map to Spring Boot standard env var names so they bind to spring.datasource.*
  if [ -n "$DB_URL" ]; then export SPRING_DATASOURCE_URL="$DB_URL"; fi
  if [ -n "$DB_USERNAME" ]; then export SPRING_DATASOURCE_USERNAME="$DB_USERNAME"; fi
  if [ -n "$DB_PASSWORD" ]; then export SPRING_DATASOURCE_PASSWORD="$DB_PASSWORD"; fi
fi
cd "$(dirname "$0")"
echo "Building the project (skipping tests)..."
./mvnw -DskipTests clean package

JAR_FILE=$(ls target/midtier-*.jar | head -n 1)

if [ -f "$JAR_FILE" ]; then
  echo "Starting the application with profile: $PROFILE"
  nohup java -jar "$JAR_FILE" > midtier.log 2>&1 &
  echo "App started. Check midtier.log for output."
else
  echo "JAR file not found. Build may have failed."
  exit 1
fi
