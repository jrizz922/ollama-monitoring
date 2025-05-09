#!/bin/bash

LOG_DIR="./logs"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/stop_$TIMESTAMP.log"

mkdir -p "$LOG_DIR"

echo "🛑 Stopping Ollama Monitoring Stack..." | tee -a "$LOG_FILE"

docker compose down | tee -a "$LOG_FILE"

echo "🧼 Cleaning up unused Docker images..." | tee -a "$LOG_FILE"
docker image prune -f | tee -a "$LOG_FILE"

echo "✅ All services stopped." | tee -a "$LOG_FILE"