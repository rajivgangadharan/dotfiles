#!/usr/bin/env bash
set -euo pipefail
cd /home/rajivg/Code/stock-trading
python3 scripts/market_data_cron.py --now 2>&1 | tail -30