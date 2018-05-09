#!/bin/bash
cd /srv/shiny-server/crypto_premium_python/crypto_premium_shiny
source venv/bin/activate
python -c 'import okex; okex.csv_update_history()'
echo "`date -u` updated" >> hist_log.txt