# Nginx Log Analyser

A Bash script that summarizes an Nginx access log, showing the top five client IP addresses, requested paths, response status codes, and user agents.

The included `nginx-access.log` sample is available from this [sample log source](https://gist.githubusercontent.com/nilbuild/e66c3b9ea89a1a030d3b739eeeef22d0/raw/77fb3ac837a73c4f0206e78a236d885590b7ae35/nginx-access.log).

## Requirements

- Bash
- `awk` and `sort`

## Usage

Run the analyser against the included sample:

```bash
chmod +x nginx-log-analyser.sh
./nginx-log-analyser.sh
```

Pass a different access log as the first argument to analyze another file:

```bash
./nginx-log-analyser.sh /var/log/nginx/access.log
```

The script expects the standard quoted Nginx access-log format used by the included sample. It prints up to five results for each category, ordered by request count.
