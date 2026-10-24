#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: log-archive <log_directory>" >&2
    exit 1
fi

log_dir="${1%/}"  # Remove trailing slash if present

if [[ ! -d "$log_dir" ]]; then
    echo "Error: '$log_dir' is not a valid directory." >&2
    exit 1
fi

timestamp=$(date +"%Y%m%d_%H%M%S")
archive_dir="$HOME/log_archives"
archive_file="$archive_dir/log_archive_${timestamp}.tar.gz"

mkdir -p "$archive_dir"

tar -czf "$archive_file" -C "$(dirname "$log_dir")" "$(basename "$log_dir")" || {
    echo "Error: Failed to create archive." >&2
    exit 1
}

printf '%s %s\n' "$(date +"%Y-%m-%d %H:%M:%S")" "$(basename "$archive_file")" 
    >> "$archive_dir/archive_log"

echo "Created archive: $archive_file"
