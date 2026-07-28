<div align="center">
  <img src="assets/logo.svg" alt="MONITOR Logo" width="120">
  <h1>MONITOR — Command Center</h1>
</div>

![MONITOR screenshot](https://img.shields.io/badge/status-active-success?style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/flameeecyber/MONITOR-app)
![GitHub repo size](https://img.shields.io/github/repo-size/flameeecyber/MONITOR-app)

A self-hosted **infrastructure monitoring command center** — a single-page dashboard that brings together Grafana, Prometheus, Loki, Wazuh, and more into one unified interface. Built by [@flameeecyber](https://github.com/flameeecyber).

---

## 🚀 Rapid Free Test (No Setup Required)

Want to see MONITOR **right now** without installing anything? Just run:

```bash
python3 -m http.server 8080
```

Then open `http://localhost:8080` in your browser. The UI works fully standalone — you'll see the dashboard, app launcher, CyberSec explainer, and all pages.

> **No Docker, no databases, no config files needed.** MONITOR is a single HTML file with inline CSS and JS. The status dots will show "offline" for services not running on your machine, but all the UI, navigation, CyberSec content, and app registry work completely.

### 🔗 Live Demo (GitHub Pages)

You can also access it via GitHub Pages at:
```
https://flameeecyber.github.io/MONITOR-app/
```
(enable GitHub Pages in your repo settings > Pages > deploy from `main` branch `/` root).

---

## 📦 Full Installation Guide

### Conditions / Prerequisites

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| OS | Linux (any distro) | Fedora 40+, Ubuntu 22.04+ |
| RAM | 4 GB | 8 GB+ |
| Disk | 10 GB free | 20 GB+ |
| Docker | 24+ | Latest |
| Docker Compose | v2 standalone | v2 or v5 |
| Python | 3.8+ | 3.11+ |
| Network | Ports 3000, 9090, 3100, 9100, 55000, 8088 available | Same |
| Container runtime | Root or rootless Docker | Root Docker |
| SELinux (Fedora/RHEL) | Must set `container_file_t` context | See notes below |

> **⚠️ Fedora / RHEL / CentOS users:** SELinux Enforcing mode will block container bind mounts. Run these commands for each volume directory:
> ```bash
> sudo chcon -Rt container_file_t /path/to/volume/dir
> ```

---

### Step 1 — Clone & Serve MONITOR

```bash
git clone https://github.com/flameeecyber/MONITOR-app.git
cd MONITOR-app

# Start MONITOR (standalone — no deps)
python3 -m http.server 8088
```

Open [http://localhost:8088](http://localhost:8088) — you're running.

---

### Step 2 — Infrastructure Stack (Docker)

#### Grafana

```bash
mkdir -p ~/docker/grafana
```

Create `~/docker/grafana/docker-compose.yml`:
```yaml
version: "3.8"
services:
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana
    networks:
      - grafana_monitoring
    restart: unless-stopped

volumes:
  grafana-data:

networks:
  grafana_monitoring:
    driver: bridge
```

```bash
docker-compose up -d
# Grafana will be at http://localhost:3000 (admin/admin)
```

#### Prometheus + Loki + Node Exporter

```bash
mkdir -p ~/docker/stack/prometheus ~/docker/stack/loki
```

Create `~/docker/stack/docker-compose.yml`:
```yaml
version: "3.8"
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus:/etc/prometheus
    command:
      - "--config.file=/etc/prometheus/prometheus.yml"
      - "--storage.tsdb.path=/prometheus"
    networks:
      - grafana_monitoring
    restart: unless-stopped

  loki:
    image: grafana/loki:latest
    container_name: loki
    ports:
      - "3100:3100"
    volumes:
      - ./loki:/etc/loki
    command: "-config.file=/etc/loki/loki-config.yaml"
    networks:
      - grafana_monitoring
    restart: unless-stopped

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    command:
      - "--path.rootfs=/host"
    networks:
      - grafana_monitoring
    restart: unless-stopped

networks:
  grafana_monitoring:
    external: true
```

#### Wazuh (SIEM)

```bash
mkdir -p ~/docker/wazuh
```

Create `~/docker/wazuh/docker-compose.yml`:
```yaml
version: "3.8"
services:
  wazuh-manager:
    image: wazuh/wazuh-manager:4.10.1
    container_name: wazuh-manager
    ports:
      - "55000:55000"
      - "1514:1514"
      - "1515:1515"
      - "1516:1516"
    networks:
      - grafana_monitoring
    restart: unless-stopped

networks:
  grafana_monitoring:
    external: true
```

> ⚠️ **Wazuh API** uses HTTPS with a self-signed certificate on port 55000. Default credentials: `wazuh` / `wazuh`. The MONITOR status probe will show Wazuh as offline from the browser due to TLS — this is expected.

---

### Step 3 — Start Everything

```bash
# Grafana
cd ~/docker/grafana && docker-compose up -d

# Stack (Prometheus, Loki, Node Exporter)
cd ~/docker/stack && docker-compose up -d

# Wazuh
cd ~/docker/wazuh && docker-compose up -d

# MONITOR
cd ~/MONITOR-app && python3 -m http.server 8088
```

Open [http://localhost:8088](http://localhost:8088) — all services should show green online dots.

---

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
MONITOR-app/
├── index.html        # Everything — HTML, CSS, JS (SPA)
├── assets/           # Static assets
├── css/              # Additional stylesheets
├── js/               # Additional scripts
├── start.sh          # Quick launcher
├── .gitignore
└── README.md
```

> **Note:** This is a single-page application — all the code lives in `index.html` (no build step required, no dependencies).

## 👤 Author

**flameeecyber** — [@flameeecyber](https://github.com/flameeecyber)

## 📄 License

MIT — free to use, modify, and distribute.
