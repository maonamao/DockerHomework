#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="$ROOT_DIR/ci/reports/integration"
mkdir -p "$REPORT_DIR"

COMPOSE_FILE="$ROOT_DIR/docker-compose.ci.yml"

cleanup() {
  docker compose -f "$COMPOSE_FILE" down -v --remove-orphans || true
}
trap cleanup EXIT

# Build & start
docker compose -f "$COMPOSE_FILE" up -d --build

# Wait for backend health
health_url="http://127.0.0.1:8080/actuator/health"
products_url="http://127.0.0.1:8080/api/products"

ok=false
for i in {1..60}; do
  if curl -fsS "$health_url" >/dev/null; then
    ok=true
    break
  fi
  sleep 2
done

# Minimal JUnit report
junit="$REPORT_DIR/junit.xml"
if [ "$ok" = true ]; then
  # Verify products endpoint
  if curl -fsS "$products_url" >/dev/null; then
    cat >"$junit" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="integration" tests="1" failures="0" errors="0">
  <testcase classname="integration" name="backend_api_products"/>
</testsuite>
XML
    echo "Integration test passed"
    exit 0
  fi
fi

cat >"$junit" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="integration" tests="1" failures="1" errors="0">
  <testcase classname="integration" name="backend_api_products">
    <failure message="integration failed">Backend health or /api/products endpoint not reachable.</failure>
  </testcase>
</testsuite>
XML

echo "Integration test failed"
exit 1
