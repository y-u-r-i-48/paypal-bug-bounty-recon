#!/bin/bash
# ============================================================
# Step 7: Automated Vulnerability Scanning (NEW)
# Tool: nuclei
# Author: Yuri Son — Capstone Project
# Usage: bash step7_nuclei_scan.sh paypal.com
#
# IMPORTANT: Only run against in-scope hosts.
# Use -rate-limit and -timeout to avoid disrupting services.
# ============================================================

set -e

TARGET=${1:-"paypal.com"}
OUTPUT_DIR="./output/${TARGET}"

if [ ! -f "$OUTPUT_DIR/alive_hosts.txt" ]; then
  echo "[!] Run step3_live_hosts.sh first."
  exit 1
fi

echo "[*] Starting nuclei scan for: $TARGET"
echo "[!] Using safe templates only (exposures + misconfigurations)"
echo ""

# Update nuclei templates first
echo "[*] Updating nuclei templates..."
nuclei -update-templates -silent

# ── Nuclei scan — safe templates only ───────────────────────
# -l              : read hosts from file
# -t              : template categories to use
# -rate-limit 10  : max 10 requests/sec (be polite)
# -timeout 10     : 10 second timeout per request
# -severity       : only report info, low, medium, high (not unknown)
# -o              : output file
nuclei \
  -l "$OUTPUT_DIR/alive_hosts.txt" \
  -t exposures/ \
  -t misconfigurations/ \
  -t technologies/ \
  -rate-limit 10 \
  -timeout 10 \
  -severity info,low,medium,high \
  -silent \
  -o "$OUTPUT_DIR/nuclei_results.txt"

FINDINGS=$(wc -l < "$OUTPUT_DIR/nuclei_results.txt" 2>/dev/null || echo 0)

echo ""
echo "============================================"
echo "[+] Nuclei scan complete"
echo "[+] Total findings: $FINDINGS"
echo "[+] Results saved to: $OUTPUT_DIR/nuclei_results.txt"
echo "============================================"
echo ""

# ── Parse by severity ───────────────────────────────────────
if [ -s "$OUTPUT_DIR/nuclei_results.txt" ]; then
  echo "FINDINGS BY SEVERITY:"
  echo ""
  echo "MEDIUM:"
  grep "\[medium\]" "$OUTPUT_DIR/nuclei_results.txt" || echo "  None"
  echo ""
  echo "LOW:"
  grep "\[low\]" "$OUTPUT_DIR/nuclei_results.txt" || echo "  None"
  echo ""
  echo "INFO:"
  grep "\[info\]" "$OUTPUT_DIR/nuclei_results.txt" || echo "  None"
fi

echo ""
echo "[!] REMINDER: Review all findings manually before reporting."
echo "    Nuclei findings are a starting point, not a confirmation."
echo "    Submit valid findings through HackerOne only."
