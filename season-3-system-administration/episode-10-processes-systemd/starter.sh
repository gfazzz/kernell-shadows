#!/bin/bash
################################################################################
# KERNEL SHADOWS - Episode 10: Processes & SystemD
# Season 3: System Administration
# Starter Script Template
################################################################################
#
# Mission: Process Management & SystemD Configuration
# Location: Saint Petersburg, Russia
# Mentor: Boris Kuznetsov - SystemD Architect
#
# Your tasks:
#   1. Find and kill backdoor process
#   2. Create systemd service for monitoring
#   3. Create systemd timer for backups
#   4. Analyze logs with journalctl
#   5. Monitor system health
#   6. Generate audit report
#
# Hints:
#   - Use ps, pgrep, top for process inspection
#   - Signals: SIGTERM (15) graceful, SIGKILL (9) force
#   - SystemD unit files in /etc/systemd/system/
#   - Always systemctl daemon-reload after changes
#   - Journalctl for logs: journalctl -u servicename
#
################################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="/usr/local/bin"
SERVICE_DIR="/etc/systemd/system"
BACKUP_DIR="/var/backups/shadow"
REPORT_DIR="/var/operations"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  KERNEL SHADOWS - Episode 10${NC}"
echo -e "${BLUE}  Processes & SystemD${NC}"
echo -e "${BLUE}========================================${NC}"
echo

################################################################################
# Task 1: Hunt for backdoor process
################################################################################

hunt_backdoor_process() {
    echo -e "${YELLOW}=== Task 1: Hunting for Backdoor Process ===${NC}"
    
    # TODO: Find all sshd processes
    # Hint: ps aux | grep sshd
    # Hint: pgrep -a sshd
    
    # TODO: Check for suspicious processes
    # Hint: Look for processes not in /usr/sbin/
    # Hint: Check /proc/PID/exe for each process
    
    # TODO: Identify the backdoor
    # Suspicious signs:
    #   - Process in /tmp/ or /home/
    #   - Name similar to system service (sshd_backup)
    #   - Unusual parent process
    
    echo "TODO: Implement backdoor detection"
    echo "      Check README.md Task 1 for hints"
}

################################################################################
# Task 2: Kill backdoor process
################################################################################

kill_backdoor_process() {
    echo -e "${YELLOW}=== Task 2: Kill Backdoor Process ===${NC}"
    
    local process_name="sshd_backup"  # Example backdoor name
    
    # TODO: Find PID of suspicious process
    # Hint: pgrep -f processname
    
    # TODO: Try graceful shutdown first (SIGTERM)
    # Hint: kill -15 PID
    
    # TODO: Wait 5 seconds
    # Hint: sleep 5
    
    # TODO: Check if still running
    # Hint: ps -p PID
    
    # TODO: If still alive, force kill (SIGKILL)
    # Hint: kill -9 PID
    
    # TODO: Verify killed
    
    echo "TODO: Implement process killing"
    echo "      Check README.md Task 2 for hints"
}

################################################################################
# Task 3: Create systemd monitoring service
################################################################################

create_monitoring_service() {
    echo -e "${YELLOW}=== Task 3: Create SystemD Monitoring Service ===${NC}"
    
    # TODO: Create monitoring script at /usr/local/bin/shadow-monitor.sh
    # Script should:
    #   - Check for suspicious processes every minute
    #   - Log alerts via logger or echo
    #   - Run in infinite loop (while true)
    
    # TODO: Make script executable
    # Hint: chmod +x /usr/local/bin/shadow-monitor.sh
    
    # TODO: Create service unit at /etc/systemd/system/shadow-monitor.service
    # Unit file structure:
    #   [Unit]
    #   Description=...
    #   After=network.target
    #
    #   [Service]
    #   Type=simple
    #   ExecStart=...
    #   Restart=always
    #   User=root
    #   StandardOutput=journal
    #
    #   [Install]
    #   WantedBy=multi-user.target
    
    # TODO: Reload systemd
    # Hint: systemctl daemon-reload
    
    # TODO: Enable and start service
    # Hint: systemctl enable shadow-monitor.service
    # Hint: systemctl start shadow-monitor.service
    
    # TODO: Check status
    # Hint: systemctl status shadow-monitor.service
    
    echo "TODO: Implement monitoring service"
    echo "      Check README.md Task 3 for hints"
}

################################################################################
# Task 4: Create systemd timer for backups
################################################################################

create_backup_timer() {
    echo -e "${YELLOW}=== Task 4: Create SystemD Backup Timer ===${NC}"
    
    # TODO: Create backup script at /usr/local/bin/shadow-backup.sh
    # Script should:
    #   - Create backup directory
    #   - Backup configs with tar
    #   - Log via logger
    #   - Keep only last 24 backups
    
    # TODO: Create service unit: shadow-backup.service
    # [Service]
    # Type=oneshot  (important for timers!)
    # ExecStart=/usr/local/bin/shadow-backup.sh
    
    # TODO: Create timer unit: shadow-backup.timer
    # [Timer]
    # OnCalendar=hourly
    # Persistent=true
    # 
    # [Install]
    # WantedBy=timers.target
    
    # TODO: Enable and start timer
    # Hint: systemctl enable shadow-backup.timer
    # Hint: systemctl start shadow-backup.timer
    
    # TODO: Check timer status
    # Hint: systemctl list-timers shadow-backup.timer
    
    # TODO: Trigger manual test
    # Hint: systemctl start shadow-backup.service
    
    echo "TODO: Implement backup timer"
    echo "      Check README.md Task 4 for hints"
}

################################################################################
# Task 5: Analyze logs with journalctl
################################################################################

analyze_logs() {
    echo -e "${YELLOW}=== Task 5: Analyze Logs with Journalctl ===${NC}"
    
    # TODO: View last 50 lines of shadow-monitor service
    # Hint: journalctl -u shadow-monitor.service -n 50
    
    # TODO: Find errors in last 24 hours
    # Hint: journalctl -p err --since "24 hours ago"
    
    # TODO: Check all shadow-* services
    # Hint: journalctl -u 'shadow-*'
    
    # TODO: Check disk usage of journal
    # Hint: journalctl --disk-usage
    
    # TODO: Follow logs in real-time (optional)
    # Hint: journalctl -u shadow-monitor.service -f
    
    echo "TODO: Implement log analysis"
    echo "      Check README.md Task 5 for hints"
}

################################################################################
# Task 6: Monitor system health
################################################################################

monitor_system_health() {
    echo -e "${YELLOW}=== Task 6: System Health Check ===${NC}"
    
    # TODO: Show load average
    # Hint: uptime
    
    # TODO: Show memory usage
    # Hint: free -h
    
    # TODO: Show CPU cores
    # Hint: nproc
    
    # TODO: Top 5 processes by CPU
    # Hint: ps aux --sort=-%cpu | head -6
    
    # TODO: Top 5 processes by Memory
    # Hint: ps aux --sort=-%mem | head -6
    
    # TODO: Check shadow-* services status
    # Hint: systemctl status 'shadow-*'
    
    # TODO: Check for failed services
    # Hint: systemctl --failed
    
    echo "TODO: Implement health monitoring"
    echo "      Check README.md Task 6 for hints"
}

################################################################################
# Task 7: Generate audit report
################################################################################

generate_audit_report() {
    echo -e "${YELLOW}=== Task 7: Generate Process Audit Report ===${NC}"
    
    local report_file="/var/operations/process_audit_ep10.txt"
    
    # TODO: Create report directory
    # Hint: mkdir -p /var/operations
    
    # TODO: Generate comprehensive report including:
    #   1. Backdoor detection results
    #   2. Created systemd services
    #   3. Timer configuration
    #   4. Journal analysis
    #   5. System health metrics
    #   6. Recommendations
    
    # TODO: Set correct permissions
    # Hint: chmod 640 report_file
    # Hint: chown viktor:operations report_file
    
    echo "TODO: Implement report generation"
    echo "      Check README.md Task 7 for hints"
    echo "      Expected output: $report_file"
}

################################################################################
# Main execution
################################################################################

main() {
    # Check if running with appropriate privileges
    if [[ $EUID -ne 0 ]]; then
        echo -e "${YELLOW}Warning: Some operations require root privileges.${NC}"
        echo -e "${YELLOW}Will use sudo where necessary.${NC}"
        echo
    fi
    
    echo -e "${BLUE}Boris Kuznetsov:${NC} 'Init scripts — это прошлое."
    echo -e "${BLUE}                  SystemD — это будущее. И настоящее.'${NC}"
    echo
    
    # Execute tasks
    hunt_backdoor_process
    echo
    
    kill_backdoor_process
    echo
    
    create_monitoring_service
    echo
    
    create_backup_timer
    echo
    
    analyze_logs
    echo
    
    monitor_system_health
    echo
    
    generate_audit_report
    echo
    
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Episode 10 tasks outlined!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Implement each TODO section"
    echo "  2. Test with: ./starter.sh"
    echo "  3. Run tests: cd tests && ./test.sh"
    echo "  4. Compare with solution/ if stuck"
    echo
    echo -e "${BLUE}LILITH:${NC} 'Процессы — это пульс системы. Научись их читать.'"
    echo
}

# Run main function
main "$@"

