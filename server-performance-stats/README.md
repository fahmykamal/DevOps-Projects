# Server Performance Stats (`server-stats.sh`)
https://roadmap.sh/projects/server-stats

A lightweight, zero-dependency Bash script for Linux servers that provides real-time performance metrics and basic health checks. Designed for DevOps engineers, system administrators, and developers who need quick insight into system resources.

---

## 🚀 Features

* **System & Kernel Overview**: OS version, system uptime, and 1/5/15-minute load averages.
* **CPU Metrics**: Real-time total CPU utilization percentage.
* **Memory Analysis**: Detailed memory breakdown (Total, Used, Free, Shared, Buffers/Cache, and Available) with calculated percentage utilization.
* **Disk Usage**: Total, used, and remaining capacity for the root filesystem (`/`).
* **Process Tracking**: Top 5 processes sorted separately by CPU and Memory usage.
* **Security & Access**: Active logged-in users and failed SSH/login attempt metrics.

---

## 📋 Prerequisites

* **Operating System**: Any Linux-based distribution (Ubuntu, Debian, CentOS, RHEL, Fedora, Arch, etc.) or WSL2 (Windows Subsystem for Linux).
* **Permissions**: Standard user access for basic stats. `sudo` / root privileges recommended for full access to system log files (e.g., failed login attempts).
* **Dependencies**: Uses standard core utilities pre-installed on Linux systems (`top`, `ps`, `df`, `free`, `awk`, `grep`).

---

## 🔧 Installation & Setup

1. **Clone or download the repository**:
   ```bash
   git clone https://github.com/fahmykamal/DevOps-Projects.git
   cd DevOps-Projects/server-performance-stats
   ```

2. **Make the script executable**:
   ```bash
   chmod +x server-stats.sh
   ```

---

## 💻 Usage

Run the script directly from your terminal:

```bash
./server-stats.sh
```

To view security log metrics (failed login attempts), run with elevated privileges:

```bash
sudo ./server-stats.sh
```

---

## 📊 Sample Output

```text
==================================================
           SERVER PERFORMANCE STATISTICS          
==================================================

--------------------------------------------------
 1. System Information & Uptime
--------------------------------------------------
OS Version   : Ubuntu 22.04.3 LTS
Uptime       : up 2 weeks, 3 days, 14 hours
Load Average : 0.15, 0.08, 0.03

--------------------------------------------------
 2. Total CPU Usage
--------------------------------------------------
Total CPU Usage: 4.2%

--------------------------------------------------
 3. Memory Usage
--------------------------------------------------
Total Memory     : 11894 MB
Used Memory      : 804 MB (6.76%)
Free Memory      : 10538 MB (88.60%)
Shared Memory    : 5 MB
Buffered/Cached  : 725 MB
Available Memory : 11090 MB

--------------------------------------------------
 4. Disk Usage (Root Filesystem)
--------------------------------------------------
Total Disk   : 64G
Used Disk    : 18G (30%)
Free Disk    : 44G

--------------------------------------------------
 5. Top 5 Processes by CPU Usage
--------------------------------------------------
  PID  PPID COMMAND                     %CPU %MEM
 1234  1000 node /app/server.js          8.5  2.1
 5678     1 /usr/bin/dockerd             3.2  1.4
 9101     1 /usr/sbin/mysqld             2.1  4.8
  432     1 nginx: worker process        1.0  0.3
  789  1000 top -bn1                     0.8  0.1

--------------------------------------------------
 6. Top 5 Processes by Memory Usage
--------------------------------------------------
  PID  PPID COMMAND                     %CPU %MEM
 9101     1 /usr/sbin/mysqld             2.1  4.8
 1234  1000 node /app/server.js          8.5  2.1
 5678     1 /usr/bin/dockerd             3.2  1.4
 3456  1000 python3 app.py               0.4  1.2
  432     1 nginx: worker process        1.0  0.3

--------------------------------------------------
 7. Logged-In Users
--------------------------------------------------
fahmy    pts/0        2026-10-24 10:15 (192.168.1.50)

--------------------------------------------------
 8. Security / Failed Login Attempts
--------------------------------------------------
Failed login attempts found in auth.log: 0

==================================================
          STATISTICS COLLECTION COMPLETE          
==================================================
```

---

## 🛠️ How It Works

| Metric | Command / Logic Used | Description |
| :--- | :--- | :--- |
| **CPU Usage** | `top -bn1 \| grep "Cpu(s)"` | Takes a single batch snapshot of `top`, extracts idle CPU (`$8`), and subtracts it from 100%. |
| **Memory** | `free -m \| awk 'NR==2{...}'` | Captures column values `$2` through `$7` from row 2 of `free -m` to output exact Megabytes and percentage ratios. |
| **Disk Usage** | `df -h /` | Parses the root partition storage details. |
| **Top Processes** | `ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu` | Filters processes formatted by PID, PPID, Command, CPU %, and Mem %, sorted in descending order. |
| **Security Logs** | `/var/log/auth.log` or `journalctl` | Checks standard system log files for failed SSH or password entry counts. |

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).