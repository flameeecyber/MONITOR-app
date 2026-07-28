#!/bin/bash
# MONITOR App — Quick Start
# Serves the monitoring app on port 8088

PORT=${1:-8088}
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  MONITOR — Command Center"
echo "  Serving at: http://localhost:$PORT"
echo "  Login: admin / admin"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Use Python 3 HTTP server
python3 -m http.server "$PORT" --directory "$DIR"
