#!/bin/bash
# ============================================================
# Step 4: Port & Service Scanning (NEW)
# Tool: nmap
# Author: Yuri Son — Capstone Project
# Usage: bash step4_port_scan.sh paypal.com
# ============================================================

set -e

TARGET=${1:-"paypal.com"}
OUTPUT_DIR="./output/${TARGET}"

if [ ! -f "$OUTPUT_DIR/alive_hosts.txt" ]; then
  echo "[!] Run step3_live_hosts.sh first."
  exit 1
fi

echo "[*] Starting port scan for live hosts of: $TARGET"

# Resolve hostnames to IPs for nmap input
# (nmap works better with IPs from a host list)
echo "[*] Resolving hostnames to IPs..."
while read host; do
  # Strip http:// or https://
  host_clean=$(echo "$host" | sed 's|https\?://||' | cut -d/ -f1)
  dig +short "$host_clean" 2>/dev/null | grep -E '^[0-9]' | head -1
done < "$OUTPUT_DIR/alive_hosts.txt" \
  | sort -u \
  | grep -v '^$' \
  > "$OUTPUT_DIR/ips.txt"

IP_COUNT=$(wc -l < "$OUTPUT_DIR/ips.txt")
echo "[+] Resolved $IP_COUNT unique IPs"

# ── nmap scan ───────────────────────────────────────────────
# -iL      : read hosts from file
# -p       : specific ports to scan
# -T3      : normal timing (not too aggressive)
# -sV      : version detection
# --open   : only show open ports
# -oN      : normal output file
echo "[*] Running nmap..."
nmap \
  -iL "$OUTPUT_DIR/ips.txt" \
  -p 22,80,443,3000,8000,8080,8443,9000 \
  -T3 \
  -sV \
  --open \
  -oN "$OUTPUT_DIR/portscan.txt" \
  -oG "$OUTPUT_DIR/portscan_grep.txt"

# ── Parse interesting findings ──────────────────────────────
echo ""
echo "[*] Summarizing interesting open ports..."
echo ""
echo "--- Port 22 (SSH — should NOT be public) ---"
grep "22/open" "$OUTPUT_DIR/portscan_grep.txt" | awk '{print $2}' || echo "None found"

echo ""
echo "--- Ports 3000/8000 (Dev Servers) ---"
grep -E "3000/open|8000/open" "$OUTPUT_DIR/portscan_grep.txt" | awk '{print $2}' || echo "None found"

echo ""
echo "--- Ports 8080/8443 (Alt HTTP/HTTPS) ---"
grep -E "8080/open|8443/open" "$OUTPUT_DIR/portscan_grep.txt" | awk '{print $2}' || echo "None found"

echo ""
echo "============================================"
echo "[+] Full nmap results: $OUTPUT_DIR/portscan.txt"
echo "============================================"
