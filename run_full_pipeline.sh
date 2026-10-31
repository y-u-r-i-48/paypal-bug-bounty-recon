#!/bin/bash
# ============================================================
# FULL RECON PIPELINE — Master Runner
# Author: Yuri Son — Capstone Project
# Usage: bash run_full_pipeline.sh paypal.com
#
# Runs all 7 steps in sequence.
# Each step's output feeds into the next.
# ============================================================

TARGET=${1:-"paypal.com"}

echo "================================================"
echo "  BUG BOUNTY RECON PIPELINE"
echo "  Target: $TARGET"
echo "  Author: Yuri Son"
echo "================================================"
echo ""
echo "[!] ETHICAL REMINDER:"
echo "    Only run against targets you are authorized to test."
echo "    Confirm scope on HackerOne before proceeding."
echo ""
read -p "Have you confirmed $TARGET is in scope? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
  echo "[!] Aborting. Confirm scope first."
  exit 1
fi

echo ""
echo "--- STEP 2: Subdomain Enumeration ---"
bash step2_subdomain_enum.sh "$TARGET"

echo ""
echo "--- STEP 3: Live Host Detection ---"
bash step3_live_hosts.sh "$TARGET"

echo ""
echo "--- STEP 4: Port Scanning ---"
bash step4_port_scan.sh "$TARGET"

echo ""
echo "--- STEP 5: Web Crawling (registration.$TARGET) ---"
bash step5_crawl.sh "https://registration.$TARGET"

echo ""
echo "--- STEP 6: Parameter Analysis ---"
bash step6_param_analysis.sh "$TARGET"

echo ""
echo "--- STEP 7: Nuclei Vulnerability Scan ---"
bash step7_nuclei_scan.sh "$TARGET"

echo ""
echo "================================================"
echo "  PIPELINE COMPLETE"
echo "  All outputs saved to: ./output/$TARGET/"
echo "================================================"
