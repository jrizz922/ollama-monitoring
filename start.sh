#!/bin/bash

LOG_DIR="./logs"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/start_$TIMESTAMP.log"

mkdir -p "$LOG_DIR"

echo "🔧 Starting Ollama Monitoring Stack..." | tee -a "$LOG_FILE"

# Check for port conflicts in our monitoring services
declare -A PORTS=(
  [Grafana]=3131
  [Prometheus]=9090
  [cAdvisor]=8080
)

for service in "${!PORTS[@]}"; do
  port="${PORTS[$service]}"
  if lsof -i ":$port" &> /dev/null; then
    echo "⚠️  Port $port (used by $service) is already in use." | tee -a "$LOG_FILE"
  fi
done

# Check if monitored services are running
if ! lsof -i :3000 &> /dev/null; then
  echo "⚠️  OpenWebUI is not running on port 3000. Monitoring will not capture its metrics." | tee -a "$LOG_FILE"
fi

docker compose pull | tee -a "$LOG_FILE"
docker compose up -d --force-recreate | tee -a "$LOG_FILE"
docker compose ps | tee -a "$LOG_FILE"

# Diagnostics
echo -e "\n🔍 Checking Prometheus targets..." | tee -a "$LOG_FILE"
echo "Wait 30 seconds for services to initialize..." | tee -a "$LOG_FILE"
sleep 30

echo "Verifying Prometheus targets (this will be available at http://localhost:9090/targets):" | tee -a "$LOG_FILE"
curl -s http://localhost:9090/api/v1/targets | grep "health" | tee -a "$LOG_FILE"

echo -e "\n📊 Testing metrics availability:" | tee -a "$LOG_FILE"
echo "cAdvisor metrics:" | tee -a "$LOG_FILE"
curl -s http://localhost:8080/metrics | head -5 | tee -a "$LOG_FILE"
echo "Process exporter metrics:" | tee -a "$LOG_FILE"
curl -s http://localhost:9256/metrics | grep ollama | head -5 | tee -a "$LOG_FILE"

# Check and log the status of the services

echo -e "\n🌐 Access Points:" | tee -a "$LOG_FILE"
echo "  - Grafana:     http://localhost:3131" | tee -a "$LOG_FILE"
echo "  - Prometheus:  http://localhost:9090" | tee -a "$LOG_FILE"
echo "  - cAdvisor:    http://localhost:8080" | tee -a "$LOG_FILE"
echo "  - Open WebUI:  http://localhost:3000 (monitored external service)" | tee -a "$LOG_FILE"