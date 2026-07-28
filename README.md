# MONITOR — Command Center

![MONITOR screenshot](https://img.shields.io/badge/status-active-success?style=flat-square)

A self-hosted **infrastructure monitoring command center** — a single-page dashboard that brings together Grafana, Prometheus, Loki, Wazuh, and more into one unified interface. Built by [@flameeecyber](https://github.com/flameeecyber).

## 🔭 Overview

MONITOR is not just another dashboard — it's a **cybersecurity-aware operations center** that gives you:

- **Live status probing** — every app card pings its target every 3 seconds (online/offline/probing)
- **App Registry** — register any service with your email for one-click launch with auto-injected `?email=` credentials
- **Cyber Security Detection Center** — a built-in explainer that maps each tool to real threats (brute-force, ransomware, data exfiltration, container escapes)
- **Detection Playbook** — kill-chain style breakdowns with exact PromQL/LogQL queries for 4 attack scenarios
- **Network scanner** — host discovery, port scanning, interface tables
- **Week tracker** — daily uptime bars with segmented status history
- **Gradient cyberpunk UI** — dark theme with Three.js particle background

## 🧱 Stack

| Tool | Port | Role |
|------|------|------|
| [Grafana](http://localhost:3000) | 3000 | Visualization & alerting |
| [Prometheus](http://localhost:9090) | 9090 | Metrics collection & PromQL |
| [Loki](http://localhost:3100) | 3100 | Log aggregation & LogQL |
| [Node Exporter](http://localhost:9100) | 9100 | Host metrics (CPU, RAM, Disk, Net) |
| [Wazuh](https://localhost:55000) | 55000 | SIEM, FIM, vulnerability detection |
| **MONITOR** | 8088 | This command center |

## 🚀 Quick Start

```bash
# Start MONITOR
python3 -m http.server 8088 -d /home/phntm/vibecode/data/projects/templates/monitor-app
```

Then open [http://localhost:8088](http://localhost:8088).

### Start all services (Docker)

```bash
# Grafana
cd ~/docker/grafana && docker-compose up -d

# Prometheus + Loki + Node Exporter
cd ~/docker/stack && docker-compose up -d

# Wazuh
cd ~/docker/wazuh && docker-compose up -d
```

## 🛡️ Cyber Security Detection Center

Built into MONITOR is a complete **CyberSec explainer** (click *CyberSec* in the sidebar) with:

### Four Pillars of Detection

1. **Metrics Analysis** (Prometheus) — real-time anomaly detection through CPU, memory, disk, and network telemetry
2. **Log Forensics** (Loki) — centralized log aggregation with LogQL for attack timeline reconstruction
3. **Alerting & Response** (Grafana) — multi-channel alerting with rate-of-change and threshold breaches
4. **Security Events / SIEM** (Wazuh) — FIM, rootkit detection, vulnerability scanning, CIS compliance

### Tool Security Matrix

Every tool has a dedicated card showing:
- **What it monitors** — exact metrics, log sources, or events
- **Threats detected** — concrete attack types
- **Security queries** — ready-to-run PromQL/LogQL examples

### Detection Playbook

Four real-world attack scenarios with phase-by-phase breakdowns:

| Scenario | Severity |
|----------|----------|
| Brute-Force SSH Attack | 🟠 High |
| Container Escape / RCE | 🔴 Critical |
| Data Exfiltration via Network | 🟠 High |
| Ransomware: Mass File Encryption | 🔴 Critical |

Each playbook follows the **Detect → Investigate → Respond → Prevent** kill chain with tool-specific commands.

## 🔌 App Registry

1. Enter your email on the login screen (or in *Settings > App Registry*)
2. Click **Register** on any app card in the App Launcher
3. Launching a registered app auto-injects `?email=you@example.com` into the URL
4. Registered apps show a green ✓ badge; unregistered show an amber ○ badge

## 📁 Project Structure

```
monitor-app/
├── index.html        # Everything — HTML, CSS, JS (SPA)
├── assets/           # Static assets
├── css/              # Additional stylesheets
├── js/               # Additional scripts
├── start.sh          # Quick launcher
├── .gitignore
└── README.md
```

> **Note:** This is a single-page application — all the code lives in `index.html` (no build step required).

## 👤 Author

**flameeecyber** — [@flameeecyber](https://github.com/flameeecyber)

## 📄 License

MIT
