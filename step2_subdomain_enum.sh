#!/bin/bash
# ============================================================
# Step 2: Subdomain Enumeration
# Tools: subfinder, amass
# Author: Yuri Son — Capstone Project
# Usage: bash step2_subdomain_enum.sh paypal.com
# ============================================================

set -e

TARGET=${1:-"paypal.com"}
OUTPUT_DIR="./output/${TARGET}"
mkdir -p "$OUTPUT_DIR"

echo "[*] Starting subdomain enumeration for: $TARGET"
echo "[*] Output directory: $OUTPUT_DIR"
echo ""

# ── subfinder ──────────────────────────────────────────────
echo "[*] Running subfinder..."
subfinder -d "$TARGET" -all -silent -o "$OUTPUT_DIR/subdomains_subfinder.txt"
SF_COUNT=$(wc -l < "$OUTPUT_DIR/subdomains_subfinder.txt")
echo "[+] subfinder found: $SF_COUNT subdomains"

# ── amass ───────────────────────────────────────────────────
echo "[*] Running amass (passive mode)..."
amass enum -passive -d "$TARGET" -o "$OUTPUT_DIR/subdomains_amass.txt"
AMASS_COUNT=$(wc -l < "$OUTPUT_DIR/subdomains_amass.txt")
echo "[+] amass found: $AMASS_COUNT subdomains"

# ── Combine and deduplicate ─────────────────────────────────
echo "[*] Merging and deduplicating results..."
cat "$OUTPUT_DIR/subdomains_subfinder.txt" \
    "$OUTPUT_DIR/subdomains_amass.txt" \
    | sort -u \
    > "$OUTPUT_DIR/subdomains_all.txt"

TOTAL=$(wc -l < "$OUTPUT_DIR/subdomains_all.txt")
echo ""
echo "============================================"
echo "[+] TOTAL UNIQUE SUBDOMAINS: $TOTAL"
echo "[+] Results saved to: $OUTPUT_DIR/subdomains_all.txt"
echo "============================================"
