# Ollama Monitoring Setup

Run `docker-compose up -d`

Open:

* Prometheus: <http://localhost:9090>
* Grafana: <http://localhost:3000>
* Login: admin / admin
* Add Prometheus as a data source: ≤<http://prometheus:9090>>
* Import dashboards or build your own.
    🧩 How to Use This
  1. Open Grafana at <http://localhost:3000>
(login: admin / admin if you haven’t changed it)
  2. Go to:
  • ☰ → Dashboards → Import
  3. Paste the JSON below into the Import via panel JSON field.

⸻

📊 Ollama + WebUI Monitoring Dashboard JSON

```json
{
  "id": null,
  "title": "Ollama & OpenWebUI Process Monitoring",
  "timezone": "browser",
  "panels": [
    {
      "type": "graph",
      "title": "CPU Usage - Ollama",
      "targets": [
        {
          "expr": "rate(process_cpu_seconds_total{name=\"ollama\"}[1m])",
          "legendFormat": "Ollama CPU",
          "interval": ""
        }
      ],
      "datasource": "Prometheus",
      "gridPos": {
        "x": 0,
        "y": 0,
        "w": 12,
        "h": 8
      }
    },
    {
      "type": "graph",
      "title": "Memory Usage - Ollama",
      "targets": [
        {
          "expr": "process_resident_memory_bytes{name=\"ollama\"}",
          "legendFormat": "Ollama RAM",
          "interval": ""
        }
      ],
      "datasource": "Prometheus",
      "gridPos": {
        "x": 12,
        "y": 0,
        "w": 12,
        "h": 8
      }
    },
    {
      "type": "graph",
      "title": "CPU Usage - OpenWebUI",
      "targets": [
        {
          "expr": "rate(process_cpu_seconds_total{name=\"openwebui\"}[1m])",
          "legendFormat": "WebUI CPU",
          "interval": ""
        }
      ],
      "datasource": "Prometheus",
      "gridPos": {
        "x": 0,
        "y": 8,
        "w": 12,
        "h": 8
      }
    },
    {
      "type": "graph",
      "title": "Memory Usage - OpenWebUI",
      "targets": [
        {
          "expr": "process_resident_memory_bytes{name=\"openwebui\"}",
          "legendFormat": "WebUI RAM",
          "interval": ""
        }
      ],
      "datasource": "Prometheus",
      "gridPos": {
        "x": 12,
        "y": 8,
        "w": 12,
        "h": 8
      }
    }
  ],
  "schemaVersion": 30,
  "version": 1,
  "refresh": "5s"
}
```

## Features

* Real-time CPU and RAM usage per process
* Split view for ollama and openwebui
* Works with the process_exporter config I gave earlier

## To Run

```bash
chmod +x start.sh stop.sh
./start.sh
```
