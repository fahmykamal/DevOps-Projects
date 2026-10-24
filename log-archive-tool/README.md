# Log Archive Tool

A Bash utility that creates a timestamped, gzip-compressed archive of a directory and keeps a log of created archives.

## Requirements

- Linux or another Unix-like environment with Bash.
- `tar`.

## Usage

From the repository root:

```bash
chmod +x log-archive-tool/log-archive.sh
./log-archive-tool/log-archive.sh /var/log
```

Pass exactly one existing directory as the argument. Use a directory path you have permission to read. The script removes a trailing slash from the path before archiving.

> **Reminder:** Some directories, such as `/var/log`, may require elevated permissions. If you run the script with `sudo`, `$HOME` may refer to root's home directory, so the archive and archive log may be created under `/root/log_archives` instead of your own home directory.

## Output

Archives are saved under `$HOME/log_archives` with names in this format:

```text
log_archive_YYYYMMDD_HHMMSS.tar.gz
```

The archive log at `$HOME/log_archives/archive_log` records each archive's creation time and filename.

## Errors

The script exits with an error if you provide the wrong number of arguments, the path is not a directory, or archive creation fails.
