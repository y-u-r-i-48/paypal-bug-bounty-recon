#!/bin/bash
# ============================================================
# Step 3: Live Host Detection
# Tool: httpx
# Author: Yuri Son — Capstone Project
# Usage: bash step3_live_hosts.sh paypal.com
# ============================================================

set -e

TARGET=${1:-"paypal.com"}
OUTPUT_DIR="./output/${TARGET}"

if [ ! -f "$OUTPUT_DIR/subdomains_all.txt" ]; then
  echo "[!] Run step2_subdomain_enum.sh first."
  exit 1
fi

echo "[*] Probing live hosts for: $TARGET"
echo "[*] Input: $OUTPUT_DIR/subdomains_all.txt"

# ── httpx probing ───────────────────────────────────────────
# -sc   : show status code
# -title: show page title
# -tech-detect: fingerprint technologies
cat "$OUTPUT_DIR/subdomains_all.txt" | httpx \
  -sc \
  -title \
  -tech-detect \
  -silent \
  -o "$OUTPUT_DIR/alive_hosts_full.txt"

# Extract just clean URLs (for use in next steps)
cat "$OUTPUT_DIR/subdomains_all.txt" | httpx \
  -sc \
  -silent \
  | awk '{print $1}' \
  > "$OUTPUT_DIR/alive_hosts.txt"

# Extract only 200 OK hosts (highest value targets)
grep "\[200\]" "$OUTPUT_DIR/alive_hosts_full.txt" \
  | awk '{print $1}' \
  > "$OUTPUT_DIR/alive_200.txt"

ALIVE=$(wc -l < "$OUTPUT_DIR/alive_hosts.txt")
OK200=$(wc -l < "$OUTPUT_DIR/alive_200.txt")

echo ""
echo "============================================"
echo "[+] LIVE HOSTS TOTAL: $ALIVE"
echo "[+] 200 OK HOSTS:     $OK200"
echo "[+] Full results:     $OUTPUT_DIR/alive_hosts_full.txt"
echo "[+] URL list:         $OUTPUT_DIR/alive_hosts.txt"
echo "[+] 200 OK list:      $OUTPUT_DIR/alive_200.txt"
echo "============================================"
