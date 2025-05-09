#!/bin/bash
# Save as diagnose.sh

echo "Checking process_exporter metrics for ollama:"
curl -s http://localhost:9256/metrics | grep -i ollama

echo -e "\nChecking available metrics from cadvisor:"
curl -s http://localhost:8080/metrics | grep -i container_cpu | head -5

echo -e "\nChecking Prometheus targets:"
curl -s http://localhost:9090/api/v1/targets | jq .

echo -e "\nChecking available metrics in Prometheus:"
curl -s 'http://localhost:9090/api/v1/label/__name__/values' | jq . | grep -E 'process_|container_'