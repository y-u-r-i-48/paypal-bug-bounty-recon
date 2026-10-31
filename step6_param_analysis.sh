#!/bin/bash
# ============================================================
# Step 6: Parameter Analysis
# Tools: grep, awk
# Author: Yuri Son — Capstone Project
# Usage: bash step6_param_analysis.sh paypal.com
# ============================================================

set -e

TARGET=${1:-"paypal.com"}
OUTPUT_DIR="./output/${TARGET}"

if [ ! -f "$OUTPUT_DIR/urls_with_params.txt" ]; then
  echo "[!] Run step5_crawl.sh first."
  exit 1
fi

echo "[*] Analyzing parameters for high-risk patterns..."
echo ""

# ── Open Redirect Parameters ────────────────────────────────
echo "[*] Filtering open redirect candidates (redirect=, return=, next=, url=)..."
grep -Ei "[\?&](redirect|return|next|url|goto|dest|destination|redir|target|to|forward)=" \
  "$OUTPUT_DIR/urls_with_params.txt" \
  > "$OUTPUT_DIR/params_redirect.txt"
REDIRECT=$(wc -l < "$OUTPUT_DIR/params_redirect.txt")
echo "[+] Open redirect candidates: $REDIRECT"

# ── Authentication / Token Parameters ───────────────────────
echo "[*] Filtering auth/token parameters..."
grep -Ei "[\?&](token|access_token|auth|api_key|apikey|key|secret|password|passwd|session|sid)=" \
  "$OUTPUT_DIR/urls_with_params.txt" \
  > "$OUTPUT_DIR/params_auth.txt"
AUTH=$(wc -l < "$OUTPUT_DIR/params_auth.txt")
echo "[+] Auth/token parameter URLs: $AUTH"

# ── SSRF Candidates ─────────────────────────────────────────
echo "[*] Filtering SSRF candidates (url=, callback=, webhook=)..."
grep -Ei "[\?&](url|callback|webhook|endpoint|host|server|fetch|load|src|source)=" \
  "$OUTPUT_DIR/urls_with_params.txt" \
  > "$OUTPUT_DIR/params_ssrf.txt"
SSRF=$(wc -l < "$OUTPUT_DIR/params_ssrf.txt")
echo "[+] SSRF candidates: $SSRF"

# ── ID / IDOR Candidates ────────────────────────────────────
echo "[*] Filtering IDOR candidates (id=, user_id=, account=, order=)..."
grep -Ei "[\?&](id|user_id|userid|account|account_id|order|order_id|invoice|customer)=" \
  "$OUTPUT_DIR/urls_with_params.txt" \
  > "$OUTPUT_DIR/params_idor.txt"
IDOR=$(wc -l < "$OUTPUT_DIR/params_idor.txt")
echo "[+] IDOR candidates: $IDOR"

# ── Summary report ──────────────────────────────────────────
echo ""
echo "============================================"
echo "PARAMETER ANALYSIS SUMMARY"
echo "============================================"
echo "Open Redirect candidates : $REDIRECT  -> $OUTPUT_DIR/params_redirect.txt"
echo "Auth/Token candidates    : $AUTH       -> $OUTPUT_DIR/params_auth.txt"
echo "SSRF candidates          : $SSRF       -> $OUTPUT_DIR/params_ssrf.txt"
echo "IDOR candidates          : $IDOR       -> $OUTPUT_DIR/params_idor.txt"
echo "============================================"
echo ""
echo "[!] REMINDER: These are passive observations only."
echo "    Do NOT test these parameters without confirming"
echo "    the host is in scope and you understand the impact."
