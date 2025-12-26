#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="$ROOT_DIR/ci/reports/frontend-unit"
mkdir -p "$REPORT_DIR"

junit="$REPORT_DIR/junit.xml"

if node --test "$ROOT_DIR/frontend/tests/unit"/*.test.js; then
  cat >"$junit" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="frontend-unit" tests="1" failures="0" errors="0">
  <testcase classname="frontend" name="node_test"/>
</testsuite>
XML
  echo "Frontend unit tests passed"
  exit 0
fi

cat >"$junit" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="frontend-unit" tests="1" failures="1" errors="0">
  <testcase classname="frontend" name="node_test">
    <failure message="unit tests failed">node --test failed</failure>
  </testcase>
</testsuite>
XML

exit 1
