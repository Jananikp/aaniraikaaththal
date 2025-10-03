#!/bin/bash

JAR_FILE=$(ls target/midtier-*.jar | head -n 1)

if [ -f "$JAR_FILE" ]; then
  PID=$(ps aux | grep "$JAR_FILE" | grep -v grep | awk '{print $2}')
  if [ -n "$PID" ]; then
    echo "Stopping midtier service (PID: $PID)..."
    kill $PID
    echo "Service stopped."
  else
    echo "No running midtier service found."
  fi
else
  echo "JAR file not found."
fi
