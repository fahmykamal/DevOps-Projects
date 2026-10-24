#!/bin/bash

# ==============================================================================
# Script Name: server-stats.sh
# Description: Analyzes basic and advanced Linux server performance statistics.
# ==============================================================================

# Function to print clean section headers
print_header() {
    echo ""
    echo "--------------------------------------------------"
    echo " $1"
    echo "--------------------------------------------------"
}

echo "=================================================="
echo "           SERVER PERFORMANCE STATISTICS          "
echo "=================================================="

# --- 1. OS Version, Uptime & Load Average ---
print_header "1. System Information & Uptime"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "OS Version   : $PRETTY_NAME"
else
    echo "OS Version   : $(uname -r)"
fi
echo "Uptime       : $(uptime -p)"
echo "Load Average : $(uptime | awk -F'load average:' '{ print $2 }' | xargs)"

# --- 2. TOTAL CPU USAGE ---
print_header "2. Total CPU Usage"
# Calculates CPU usage from top (100% minus idle percentage)
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
CPU_USAGE=$(awk -v idle="$CPU_IDLE" 'BEGIN {print 100 - idle}')
echo "Total CPU Usage: ${CPU_USAGE}%"

# --- 3. TOTAL MEMORY USAGE ---
print_header "3. Memory Usage"
free -m | awk 'NR==2{
    total=$2;
    used=$3;
    free=$4;
    printf "Total Memory : %d MB\n", total;
    printf "Used Memory  : %d MB (%.2f%%)\n", used, (used/total)*100;
    printf "Free Memory  : %d MB (%.2f%%)\n", free, (free/total)*100;
}'

# --- 4. TOTAL DISK USAGE ---
print_header "4. Disk Usage (Root Filesystem)"
df -h / | awk 'NR==2{
    total=$2;
    used=$3;
    free=$4;
    percentage=$5;
    printf "Total Disk   : %s\n", total;
    printf "Used Disk    : %s (%s)\n", used, percentage;
    printf "Free Disk    : %s\n", free;
}'

# --- 5. TOP 5 PROCESSES BY CPU USAGE ---
print_header "5. Top 5 Processes by CPU Usage"
ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head -n 6

# --- 6. TOP 5 PROCESSES BY MEMORY USAGE ---
print_header "6. Top 5 Processes by Memory Usage"
ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%mem | head -n 6

# --- 7. Logged-in Users & Failed Logins ---
print_header "7. Logged-In Users / Sessions"
if [ -s /var/run/utmp ] && [ -n "$(who)" ]; then
    who
else
    echo "Current User : $(whoami)"
    echo "Active Sessions (via w):"
    w -h 2>/dev/null || echo "w command not fully supported in this environment."
fi

# --- 8. Security / Failed Login Attempts ---
print_header "8. Security / Failed Login Attempts"
if [ -f /var/log/auth.log ]; then
    FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l)
    echo "Failed login attempts found in auth.log: $FAILED_LOGINS"
elif command -v journalctl &> /dev/null; then
    FAILED_LOGINS=$(journalctl _SYSTEMD_UNIT=ssh.service --since "1 day ago" 2>/dev/null | grep -i "Failed" | wc -l)
    echo "Failed SSH login attempts (last 24h): $FAILED_LOGINS"
else
    echo "Unable to read failed login attempts (requires elevated permissions or unsupported log system)."
fi

echo ""
echo "=================================================="
echo "          STATISTICS COLLECTION COMPLETE          "
echo "=================================================="