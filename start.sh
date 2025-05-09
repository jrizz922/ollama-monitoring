#!/bin/bash

LOG_DIR="./logs"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/start_$TIMESTAMP.log"

mkdir -p "$LOG_DIR"

echo "🔧 Starting Ollama Monitoring Stack..." | tee -a "$LOG_FILE"

# Check for port conflicts
declare -A PORTS=(
  [Grafana]=3000
  [Prometheus]=9090
  [OpenWebUI]=11434
)

for service in "${!PORTS[@]}"; do
  port="${PORTS[$service]}"
  if lsof -i ":$port" &> /dev/null; then
    echo "⚠️  Warning: Port $port (used by $service) is already in use." | tee -a "$LOG_FILE"
  fi
done

# Pull latest images
docker compose pull | tee -a "$LOG_FILE"

# Start services
docker compose up -d | tee -a "$LOG_FILE"

# Show status
docker compose ps | tee -a "$LOG_FILE"

echo -e "\n🌐 Access Points:" | tee -a "$LOG_FILE"
echo "  - Grafana:     http://localhost:3000" | tee -a "$LOG_FILE"
echo "  - Prometheus:  http://localhost:9090" | tee -a "$LOG_FILE"
echo "  - Open WebUI:  http://localhost:11434" | tee -a "$LOG_FILE"