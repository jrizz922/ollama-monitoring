#!/bin/bash

LOG_DIR="./logs"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/start_$TIMESTAMP.log"

mkdir -p "$LOG_DIR"

echo "🔧 Starting Ollama Monitoring Stack..." | tee -a "$LOG_FILE"

# Check for port conflicts
declare -A PORTS=(
  [Grafana]=3131
  [Prometheus]=9090
  [OpenWebUI]=11434
)

for service in "${!PORTS[@]}"; do
  port="${PORTS[$service]}"
  if lsof -i ":$port" &> /dev/null; then
    echo "⚠️  Port $port (used by $service) is already in use." | tee -a "$LOG_FILE"
  fi
done

docker compose pull | tee -a "$LOG_FILE"
docker compose up -d | tee -a "$LOG_FILE"
docker compose ps | tee -a "$LOG_FILE"

echo -e "\n🌐 Access Points:" | tee -a "$LOG_FILE"
echo "  - Grafana:     http://localhost:3131" | tee -a "$LOG_FILE"
echo "  - Prometheus:  http://localhost:9090" | tee -a "$LOG_FILE"
echo "  - Open WebUI:  http://localhost:11434" | tee -a "$LOG_FILE"