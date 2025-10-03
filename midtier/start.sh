#!/bin/bash

# Usage: ./start.sh [local|prod]
PROFILE=${1:-local}

echo "Setting SPRING_PROFILES_ACTIVE to $PROFILE"
export SPRING_PROFILES_ACTIVE=$PROFILE

cd "$(dirname "$0")"
echo "Building the project..."
./mvnw clean package

JAR_FILE=$(ls target/midtier-*.jar | head -n 1)

if [ -f "$JAR_FILE" ]; then
  echo "Starting the application with profile: $PROFILE"
  nohup java -jar "$JAR_FILE" > midtier.log 2>&1 &
  echo "App started. Check midtier.log for output."
else
  echo "JAR file not found. Build may have failed."
  exit 1
fi
