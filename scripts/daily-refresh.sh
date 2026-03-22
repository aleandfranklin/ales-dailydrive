#!/bin/bash
# =============================================================================
# Daily Drive — Full Daily Refresh
# =============================================================================
# Runs once per day (e.g., 4:00 AM via cron).
# - Fetches fresh music (top tracks + genre discovery) and podcasts
# - Saves the music selection to state.json for hourly runs to reuse
# - Cleans up log files older than 7 days
#
# Cron example:  0 4 * * * /opt/dailydrive/scripts/daily-refresh.sh
# =============================================================================

set -euo pipefail

DAILYDRIVE_DIR="/opt/dailydrive"
LOG_DIR="${DAILYDRIVE_DIR}/logs"
LOG_FILE="${LOG_DIR}/dailydrive-$(date +%Y%m%d).log"

# Make sure log directory exists
mkdir -p "${LOG_DIR}"

# --- Log cleanup: delete log files older than 7 days ---
find "${LOG_DIR}" -name "dailydrive-*.log" -type f -mtime +7 -delete

# --- Run the full playlist refresh ---
echo "=== Daily full refresh started at $(date) ===" >> "${LOG_FILE}"
cd "${DAILYDRIVE_DIR}"
/usr/bin/node index.js >> "${LOG_FILE}" 2>&1
EXIT_CODE=$?
echo "=== Daily full refresh finished at $(date) (exit code: ${EXIT_CODE}) ===" >> "${LOG_FILE}"
echo "" >> "${LOG_FILE}"

exit ${EXIT_CODE}
