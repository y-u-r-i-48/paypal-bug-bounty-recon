#!/bin/bash
# ============================================================
# Step 5: Web Crawling
# Tool: katana
# Author: Yuri Son — Capstone Project
# Usage: bash step5_crawl.sh https://registration.paypal.com
# ============================================================

set -e

TARGET_URL=${1:-"https://registration.paypal.com"}
TARGET_NAME=$(echo "$TARGET_URL" | sed 's|https\?://||' | cut -d/ -f1)
OUTPUT_DIR="./output/${TARGET_NAME}"
mkdir -p "$OUTPUT_DIR"

echo "[*] Crawling: $TARGET_URL"

# ── katana crawl ────────────────────────────────────────────
# -u     : target URL
# -d 5   : crawl depth (5 levels deep)
# -ef    : exclude file extensions (static assets we don't care about)
# -jc    : enable JavaScript crawling
# -kf    : enable known files (robots.txt, sitemap, etc.)
# -o     : output file
katana \
  -u "$TARGET_URL" \
  -d 5 \
  -ef woff2,jpeg,jpg,gif,svg,png,css,ico \
  -jc \
  -kf all \
  -silent \
  -o "$OUTPUT_DIR/urls_all.txt"

TOTAL=$(wc -l < "$OUTPUT_DIR/urls_all.txt")
echo "[+] Total URLs discovered: $TOTAL"

# ── Extract URLs with parameters ────────────────────────────
grep "?" "$OUTPUT_DIR/urls_all.txt" > "$OUTPUT_DIR/urls_with_params.txt"
PARAMS=$(wc -l < "$OUTPUT_DIR/urls_with_params.txt")
echo "[+] URLs with parameters: $PARAMS"

# ── Extract unique parameters ───────────────────────────────
grep -oP '(?<=\?|&)[^=&]+(?==)' "$OUTPUT_DIR/urls_with_params.txt" \
  | sort -u \
  > "$OUTPUT_DIR/unique_params.txt"
UNIQUE_PARAMS=$(wc -l < "$OUTPUT_DIR/unique_params.txt")
echo "[+] Unique parameter names: $UNIQUE_PARAMS"

echo ""
echo "============================================"
echo "[+] All URLs:           $OUTPUT_DIR/urls_all.txt"
echo "[+] URLs with params:   $OUTPUT_DIR/urls_with_params.txt"
echo "[+] Unique param names: $OUTPUT_DIR/unique_params.txt"
echo "============================================"
