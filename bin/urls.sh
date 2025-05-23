#!/bin/bash
log_message() {
  echo "\$(date '+%Y-%m-%d %H:%M:%S') - \$1"
}

# Dynamic variables (must come from your wrapper):
# SERVER_IP, LOCAL_DOMAIN, GLOBAL_DOMAIN

URLS=(
  "http://${SERVER_IP}"
  "https://${SERVER_IP}"
  "http://${LOCAL_DOMAIN}"
  "https://${LOCAL_DOMAIN}"
  "http://${GLOBAL_DOMAIN}"
  "https://${GLOBAL_DOMAIN}"
)

declare -a RESULTS

check_url() {
  local url="$1"
  if curl -k -I --silent --fail --max-time 5 "$url" >/dev/null; then
    mark="✅"
  else
    mark="❌"
  fi
  RESULTS+=( "$url|$mark" )
}

# Literal loop: dollar signs are escaped, evaluated in the script
for url in "\${URLS[@]}"; do
  check_url "\$url"
done

# Output table
printf '+-%-60s-+-%-3s-+\n' "------------------------------------------------------------" "---"
printf '| %-60s | %-3s |\n' "URL" ""
printf '+-%-60s-+-%-3s-+\n' "============================================================" "==="
for entry in "\${RESULTS[@]}"; do
  IFS='|' read -r u mark <<< "\$entry"
  printf '| %-60s | %-3s |\n' "\$u" "\$mark"
done
printf '+-%-60s-+-%-3s-+\n' "------------------------------------------------------------" "---"
