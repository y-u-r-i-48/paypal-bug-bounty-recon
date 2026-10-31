# Step 1: Scope Validation

## Overview
Before running any tools, manually review the HackerOne program page to confirm
which assets are in scope. This step is manual — no scripts needed.

## In-Scope Targets (PayPal HackerOne Program)
- *.paypal.com        (wildcard — all subdomains eligible)
- *.paypalcorp.com
- *.braintreepayments.com
- *.venmo.com

## Out-of-Scope (examples — always verify current policy)
- Third-party services hosted on paypal.com infrastructure
- Denial of service testing
- Social engineering
- Physical security
- Automated scanning that degrades service

## Checklist Before Starting
1. Visit https://hackerone.com/paypal and read the full policy
2. Note any recently changed scope items
3. Note any explicit exclusions or restrictions
4. Confirm bounty eligibility for your target
5. Never start recon until scope is confirmed

## Why This Matters
Researching out-of-scope assets — even accidentally — can result in
legal action and permanent bans from bug bounty programs.
