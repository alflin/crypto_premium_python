#!/bin/bash
source venv/bin/activate
python -c 'import okex; okex.csv_update_history()'
echo "`date -u` updated" >> hist_log.txt