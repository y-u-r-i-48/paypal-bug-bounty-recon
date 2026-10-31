# Bug Bounty Recon Workflow — Code Submission
**Author:** Yuri Son  
**Course:** Capstone Project   

---

## Overview

This folder contains all scripts for the seven-step bug bounty reconnaissance
workflow documented in the Final Capstone Report.

---

## File Index

| File | Step | Description |
|------|------|-------------|
| `step1_scope_validation.md` | 1 | Manual scope validation notes and checklist |
| `step2_subdomain_enum.sh` | 2 | Subdomain enumeration using subfinder + amass |
| `step3_live_hosts.sh` | 3 | Live host detection using httpx |
| `step4_port_scan.sh` | 4 | Port and service scanning using nmap (NEW) |
| `step5_crawl.sh` | 5 | Web crawling using katana |
| `step6_param_analysis.sh` | 6 | High-risk parameter filtering using grep |
| `step7_nuclei_scan.sh` | 7 | Automated vulnerability scanning using nuclei (NEW) |
| `run_full_pipeline.sh` | ALL | Master script that runs all steps in sequence |

---

## Required Tools

Install these before running:

```bash
# subfinder
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# amass
go install -v github.com/owasp-amass/amass/v4/...@master

# httpx
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# katana
go install github.com/projectdiscovery/katana/cmd/katana@latest

# nuclei
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# nmap (macOS)
brew install nmap

# nmap (Linux)
sudo apt install nmap
```

---

## Usage

### Run the full pipeline:
```bash
bash run_full_pipeline.sh paypal.com
```

### Run individual steps:
```bash
bash step2_subdomain_enum.sh paypal.com
bash step3_live_hosts.sh paypal.com
bash step4_port_scan.sh paypal.com
bash step5_crawl.sh https://registration.paypal.com
bash step6_param_analysis.sh paypal.com
bash step7_nuclei_scan.sh paypal.com
```

---

## Output Structure

All results are saved under `./output/<target>/`:

```
output/
└── paypal.com/
    ├── subdomains_subfinder.txt
    ├── subdomains_amass.txt
    ├── subdomains_all.txt        ← combined + deduplicated
    ├── alive_hosts_full.txt      ← httpx full output
    ├── alive_hosts.txt           ← clean URL list
    ├── alive_200.txt             ← 200 OK hosts only
    ├── ips.txt                   ← resolved IPs for nmap
    ├── portscan.txt              ← nmap output
    ├── urls_all.txt              ← all crawled URLs
    ├── urls_with_params.txt      ← URLs with parameters
    ├── unique_params.txt         ← unique param names
    ├── params_redirect.txt       ← open redirect candidates
    ├── params_auth.txt           ← auth/token candidates
    ├── params_ssrf.txt           ← SSRF candidates
    ├── params_idor.txt           ← IDOR candidates
    └── nuclei_results.txt        ← vulnerability findings
```

---

## Ethical Notice

These scripts are written for authorized bug bounty research only.
- Only run against in-scope targets as defined by the program policy
- Never attempt to exploit identified vulnerabilities
- Report all findings through the designated disclosure channel
- The run_full_pipeline.sh script includes a scope confirmation prompt
