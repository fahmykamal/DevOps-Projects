#!/bin/bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
log_file="${1:-"$script_dir/nginx-access.log"}"

if [[ $# -gt 1 ]]; then
    printf 'Usage: %s [log_file]\n' "$0" >&2
    exit 1
fi

if [[ ! -f "$log_file" || ! -r "$log_file" ]]; then
    printf 'Error: log file is missing or unreadable: %s\n' "$log_file" >&2
    exit 1
fi

top_five() {
    local title="$1"
    local field="$2"

    printf '\n%s\n' "$title"
    awk -F '"' -v field="$field" '
        NF < 7 { next }
        {
            split($1, prefix, /[[:space:]]+/)
            split($2, request, /[[:space:]]+/)
            response_text = $3
            sub(/^[[:space:]]+/, "", response_text)
            split(response_text, response, /[[:space:]]+/)

            if (field == "ip") {
                value = prefix[1]
            } else if (field == "path") {
                value = request[2]
            } else if (field == "status") {
                value = response[1]
            } else {
                value = $6
            }

            if (value != "") {
                counts[value]++
            }
        }
        END {
            for (value in counts) {
                printf "%d\t%s\n", counts[value], value
            }
        }
    ' "$log_file" |
        sort -t "$(printf '\t')" -k1,1nr -k2,2 |
        awk -F '\t' 'NR <= 5 { printf "  %-8s %s\n", $1, $2 }'
}

printf 'Nginx Access Log Analysis: %s\n' "$log_file"
top_five "Top 5 IP addresses with the most requests" ip
top_five "Top 5 most requested paths" path
top_five "Top 5 response status codes" status
top_five "Top 5 user agents" user_agent
