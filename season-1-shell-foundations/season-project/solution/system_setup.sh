#!/bin/bash
################################################################################
# SYSTEM SETUP MASTER SCRIPT
# Season 1 Integration Project — KERNEL SHADOWS
#
# This script integrates all skills from Episodes 01-04:
# - Episode 01: System checking and file navigation
# - Episode 02: Shell scripting and monitoring
# - Episode 03: Text processing and log analysis
# - Episode 04: Package management
#
# Author: Max Sokolov (Reference Solution)
# Date: October 2025
################################################################################

set -euo pipefail

#------------------------------------------------------------------------------
# CONFIGURATION
#------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARTIFACTS_DIR="$(dirname "$SCRIPT_DIR")/artifacts"

SYSTEM_REPORT="system_report.txt"
SECURITY_ANALYSIS="security_analysis.txt"
SETUP_LOG="setup.log"
INSTALL_LOG="install.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

#------------------------------------------------------------------------------
# HELPER FUNCTIONS
#------------------------------------------------------------------------------

log_message() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $level: $message" >> "$SETUP_LOG"
}

print_status() {
    local status="$1"
    local message="$2"

    case "$status" in
        "ok")
            echo -e "${GREEN}[✓]${NC} $message"
            ;;
        "error")
            echo -e "${RED}[✗]${NC} $message"
            ;;
        "info")
            echo -e "${BLUE}[i]${NC} $message"
            ;;
        "warn")
            echo -e "${YELLOW}[!]${NC} $message"
            ;;
    esac
}

print_header() {
    local text="$1"
    echo ""
    echo -e "${CYAN}============================================================${NC}"
    echo -e "${CYAN}  $text${NC}"
    echo -e "${CYAN}============================================================${NC}"
}

initialize_logs() {
    > "$SETUP_LOG"
    > "$SYSTEM_REPORT"
    > "$SECURITY_ANALYSIS"
    > "$INSTALL_LOG"

    log_message "INFO" "=== System Setup Started ==="
    log_message "INFO" "Hostname: $(hostname)"
    log_message "INFO" "User: $(whoami)"
}

#------------------------------------------------------------------------------
# MODULE 1: SYSTEM CHECK
#------------------------------------------------------------------------------

check_system() {
    log_message "INFO" "Starting system check module..."

    echo "" >> "$SYSTEM_REPORT"
    echo "=== SYSTEM CHECK ===" >> "$SYSTEM_REPORT"
    echo "" >> "$SYSTEM_REPORT"

    check_system_info
    check_disk_space
    check_critical_paths

    log_message "INFO" "System check module completed"
}

check_system_info() {
    print_status "info" "Gathering system information..."

    {
        echo "Hostname: $(hostname)"
        echo "OS: $(lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown")"
        echo "Kernel: $(uname -r)"
        echo "Architecture: $(uname -m)"
        echo "Uptime: $(uptime -p 2>/dev/null || uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}')"
        echo ""
    } >> "$SYSTEM_REPORT"

    print_status "ok" "System information collected"
}

check_disk_space() {
    print_status "info" "Checking disk space..."

    local usage
    usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

    {
        echo "Disk Usage:"
        df -h / | head -2
        echo ""
    } >> "$SYSTEM_REPORT"

    if [[ $usage -gt 80 ]]; then
        print_status "warn" "Disk usage: ${usage}% (WARNING: High usage)"
        echo "WARNING: Disk usage is ${usage}%" >> "$SYSTEM_REPORT"
    else
        print_status "ok" "Disk usage: ${usage}%"
    fi

    log_message "INFO" "Disk usage: ${usage}%"
}

check_critical_paths() {
    print_status "info" "Checking critical paths..."

    local paths_file="$ARTIFACTS_DIR/critical_paths.txt"

    if [[ ! -f "$paths_file" ]]; then
        print_status "warn" "Critical paths file not found: $paths_file"
        return 0
    fi

    local missing_count=0
    local total_count=0

    echo "Critical Paths Check:" >> "$SYSTEM_REPORT"

    while IFS= read -r path || [[ -n "$path" ]]; do
        [[ "$path" =~ ^#.*$ || -z "$path" ]] && continue

        ((total_count++))

        if [[ -e "$path" ]]; then
            echo "  ✓ $path" >> "$SYSTEM_REPORT"
        else
            echo "  ✗ $path (MISSING)" >> "$SYSTEM_REPORT"
            ((missing_count++))
            log_message "WARN" "Critical path missing: $path"
        fi
    done < "$paths_file"

    echo "" >> "$SYSTEM_REPORT"

    if [[ $missing_count -eq 0 ]]; then
        print_status "ok" "All critical paths present ($total_count/$total_count)"
    else
        print_status "warn" "$missing_count critical paths missing ($((total_count - missing_count))/$total_count present)"
    fi
}

#------------------------------------------------------------------------------
# MODULE 2: SYSTEM MONITORING
#------------------------------------------------------------------------------

monitor_system() {
    log_message "INFO" "Starting system monitoring module..."

    echo "" >> "$SYSTEM_REPORT"
    echo "=== SYSTEM MONITORING ===" >> "$SYSTEM_REPORT"
    echo "" >> "$SYSTEM_REPORT"

    monitor_resources
    check_services

    log_message "INFO" "System monitoring module completed"
}

monitor_resources() {
    print_status "info" "Monitoring system resources..."

    # CPU Load
    local load_avg
    load_avg=$(uptime | awk -F'load average:' '{print $2}')
    print_status "info" "Load average:$load_avg"
    echo "CPU Load Average:$load_avg" >> "$SYSTEM_REPORT"

    # Memory
    local mem_total mem_used mem_free mem_percent
    mem_total=$(free -h | awk 'NR==2 {print $2}')
    mem_used=$(free -h | awk 'NR==2 {print $3}')
    mem_free=$(free -h | awk 'NR==2 {print $4}')

    print_status "info" "Memory: $mem_used / $mem_total used"
    {
        echo "Memory Usage:"
        echo "  Total: $mem_total"
        echo "  Used: $mem_used"
        echo "  Free: $mem_free"
        echo ""
    } >> "$SYSTEM_REPORT"

    # Process count
    local proc_count
    proc_count=$(ps aux | wc -l)
    print_status "info" "Running processes: $proc_count"
    echo "Running Processes: $proc_count" >> "$SYSTEM_REPORT"
    echo "" >> "$SYSTEM_REPORT"

    log_message "INFO" "Resource monitoring completed"
}

check_services() {
    print_status "info" "Checking critical services..."

    local services=("ssh" "cron" "systemd-logind")
    local service_count=0

    echo "Critical Services:" >> "$SYSTEM_REPORT"

    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            echo "  ✓ $service (running)" >> "$SYSTEM_REPORT"
            ((service_count++))
        else
            echo "  ✗ $service (not running)" >> "$SYSTEM_REPORT"
            log_message "WARN" "Service not running: $service"
        fi
    done

    echo "" >> "$SYSTEM_REPORT"

    print_status "ok" "$service_count/${#services[@]} critical services running"
}

#------------------------------------------------------------------------------
# MODULE 3: SECURITY ANALYSIS
#------------------------------------------------------------------------------

analyze_security() {
    log_message "INFO" "Starting security analysis module..."

    echo "=== SECURITY ANALYSIS ===" > "$SECURITY_ANALYSIS"
    echo "" >> "$SECURITY_ANALYSIS"
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')" >> "$SECURITY_ANALYSIS"
    echo "" >> "$SECURITY_ANALYSIS"

    analyze_failed_logins
    check_threat_database

    log_message "INFO" "Security analysis module completed"
}

analyze_failed_logins() {
    print_status "info" "Analyzing failed login attempts..."

    local auth_log="/var/log/auth.log"

    if [[ ! -f "$auth_log" ]]; then
        print_status "warn" "auth.log not found, skipping failed login analysis"
        echo "auth.log not found - skipping analysis" >> "$SECURITY_ANALYSIS"
        return 0
    fi

    local failed_count
    failed_count=$(grep -c "Failed password" "$auth_log" 2>/dev/null || echo "0")

    print_status "info" "Failed login attempts: $failed_count"

    {
        echo "Failed Login Attempts: $failed_count"
        echo ""
    } >> "$SECURITY_ANALYSIS"

    if [[ $failed_count -gt 0 ]]; then
        echo "TOP-10 Attacking IPs:" >> "$SECURITY_ANALYSIS"
        grep "Failed password" "$auth_log" 2>/dev/null | \
            awk '{for(i=1;i<=NF;i++) if($i ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) print $i}' | \
            sort | uniq -c | sort -rn | head -10 >> "$SECURITY_ANALYSIS"
        echo "" >> "$SECURITY_ANALYSIS"
    fi

    log_message "INFO" "Failed login analysis completed: $failed_count attempts"
}

check_threat_database() {
    print_status "info" "Checking against threat database..."

    local threat_db="$ARTIFACTS_DIR/threat_database.txt"
    local auth_log="/var/log/auth.log"

    if [[ ! -f "$threat_db" ]]; then
        print_status "warn" "Threat database not found: $threat_db"
        return 0
    fi

    if [[ ! -f "$auth_log" ]]; then
        return 0
    fi

    local threats_found=0

    echo "Known Threats Detection:" >> "$SECURITY_ANALYSIS"

    while IFS= read -r threat_ip || [[ -n "$threat_ip" ]]; do
        [[ "$threat_ip" =~ ^#.*$ || -z "$threat_ip" ]] && continue

        local count
        count=$(grep -c "$threat_ip" "$auth_log" 2>/dev/null || echo "0")

        if [[ $count -gt 0 ]]; then
            echo "  ⚠ THREAT DETECTED: $threat_ip ($count occurrences)" >> "$SECURITY_ANALYSIS"
            ((threats_found++))
            log_message "WARN" "Known threat detected in logs: $threat_ip"
        fi
    done < "$threat_db"

    if [[ $threats_found -eq 0 ]]; then
        echo "  ✓ No known threats detected in logs" >> "$SECURITY_ANALYSIS"
        print_status "ok" "No known threats detected"
    else
        echo "" >> "$SECURITY_ANALYSIS"
        print_status "warn" "$threats_found known threats detected in logs"
    fi
}

#------------------------------------------------------------------------------
# MODULE 4: PACKAGE MANAGEMENT
#------------------------------------------------------------------------------

install_packages() {
    log_message "INFO" "Starting package management module..."

    if [[ $EUID -ne 0 ]]; then
        print_status "warn" "Not running as root, skipping package installation"
        log_message "WARN" "Package installation skipped (not root)"
        return 0
    fi

    local packages_file="$ARTIFACTS_DIR/required_packages.txt"

    if [[ ! -f "$packages_file" ]]; then
        print_status "error" "Required packages file not found: $packages_file"
        return 1
    fi

    print_status "info" "Updating package lists..."
    apt-get update >> "$INSTALL_LOG" 2>&1

    local installed=0
    local already_installed=0
    local failed=0

    while IFS= read -r package || [[ -n "$package" ]]; do
        [[ "$package" =~ ^#.*$ || -z "$package" ]] && continue

        if dpkg -l 2>/dev/null | grep -q "^ii  $package "; then
            print_status "ok" "$package (already installed)"
            ((already_installed++))
        else
            print_status "info" "Installing $package..."
            if DEBIAN_FRONTEND=noninteractive apt-get install -y "$package" >> "$INSTALL_LOG" 2>&1; then
                print_status "ok" "$package (installed)"
                ((installed++))
                log_message "INFO" "Package installed: $package"
            else
                print_status "error" "$package (installation failed)"
                ((failed++))
                log_message "ERROR" "Package installation failed: $package"
            fi
        fi
    done < "$packages_file"

    echo ""
    print_status "info" "Package summary: $installed installed, $already_installed already present, $failed failed"

    log_message "INFO" "Package management completed: $installed installed, $failed failed"
}

#------------------------------------------------------------------------------
# MODULE 5: REPORTING
#------------------------------------------------------------------------------

generate_report() {
    log_message "INFO" "Generating final report..."

    add_report_footer
    add_recommendations

    print_status "ok" "Reports generated successfully"
}

add_report_footer() {
    {
        echo ""
        echo "=== REPORT SUMMARY ==="
        echo ""
        echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Script: $0"
        echo ""
    } >> "$SYSTEM_REPORT"
}

add_recommendations() {
    local recommendations=()

    # Check disk usage
    local disk_usage
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [[ $disk_usage -gt 80 ]]; then
        recommendations+=("- Disk usage is high ($disk_usage%). Consider cleanup or expansion.")
    fi

    # Check failed logins
    if [[ -f /var/log/auth.log ]]; then
        local failed_count
        failed_count=$(grep -c "Failed password" /var/log/auth.log 2>/dev/null || echo "0")
        if [[ $failed_count -gt 100 ]]; then
            recommendations+=("- High number of failed logins ($failed_count). Consider implementing fail2ban.")
        fi
    fi

    {
        echo "=== RECOMMENDATIONS ==="
        echo ""
        if [[ ${#recommendations[@]} -eq 0 ]]; then
            echo "✓ System is in good condition. No critical recommendations."
        else
            for rec in "${recommendations[@]}"; do
                echo "$rec"
            done
        fi
        echo ""
    } >> "$SYSTEM_REPORT"
}

#------------------------------------------------------------------------------
# MAIN FUNCTION
#------------------------------------------------------------------------------

main() {
    local dry_run=false

    if [[ "${1:-}" == "--dry-run" ]]; then
        dry_run=true
        print_status "info" "Running in DRY-RUN mode (no package installation)"
    fi

    initialize_logs

    print_header "KERNEL SHADOWS — System Setup"
    echo -e "${MAGENTA}Season 1 Integration Project${NC}"
    echo ""

    # Module 1: System Check
    print_header "MODULE 1: System Check"
    check_system

    # Module 2: System Monitoring
    print_header "MODULE 2: System Monitoring"
    monitor_system

    # Module 3: Security Analysis
    print_header "MODULE 3: Security Analysis"
    analyze_security

    # Module 4: Package Installation
    if [[ "$dry_run" == false ]]; then
        print_header "MODULE 4: Package Management"
        install_packages
    else
        print_header "MODULE 4: Package Management (SKIPPED)"
        print_status "info" "Package installation skipped in dry-run mode"
    fi

    # Module 5: Report Generation
    print_header "MODULE 5: Report Generation"
    generate_report

    # Final Summary
    print_header "SETUP COMPLETE"
    print_status "ok" "System setup completed successfully"
    echo ""
    echo -e "${CYAN}Generated Reports:${NC}"
    echo "  • $SYSTEM_REPORT"
    echo "  • $SECURITY_ANALYSIS"
    echo "  • $SETUP_LOG"
    [[ -s "$INSTALL_LOG" ]] && echo "  • $INSTALL_LOG"
    echo ""

    log_message "INFO" "=== System Setup Completed Successfully ==="
}

#------------------------------------------------------------------------------
# EXECUTION
#------------------------------------------------------------------------------

main "$@"

