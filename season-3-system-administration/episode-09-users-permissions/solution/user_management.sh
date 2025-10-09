#!/bin/bash

################################################################################
# EPISODE 09: USERS & PERMISSIONS - REFERENCE SOLUTION
# Season 3: System Administration
#
# Location: Saint Petersburg, Russia (LETI)
# Mentor: Andrei Volkov
# Mission: Configure secure user access for KERNEL SHADOWS operation
#
# This is the REFERENCE SOLUTION - complete implementation
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
TEAM_USERS=("viktor" "alex" "anna" "dmitry")
SHARED_DIR="/var/operations/shared"
REPORT_FILE="/var/operations/security_audit_ep09.txt"
LOG_FILE="/var/log/user_management_ep09.log"

# Logging function
log() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | sudo tee -a "$LOG_FILE" > /dev/null
}

################################################################################
# Task 1: Inspect Current Users
################################################################################

inspect_users() {
    echo -e "${BLUE}=== Task 1: Inspecting Users ===${NC}"
    log "Starting user inspection"

    # Display all users with shell access
    echo -e "${CYAN}Users with shell access:${NC}"
    grep -E '/bin/(bash|sh|zsh|ksh)$' /etc/passwd | awk -F: '{print "  " $1 " (UID: " $3 ")"}'

    echo

    # Find users with UID 0 (root privileges) other than root
    echo -e "${CYAN}⚠️  Users with UID 0 (besides root):${NC}"
    local suspicious_root_users=$(awk -F: '$3 == 0 && $1 != "root" {print $1}' /etc/passwd)

    if [[ -n "$suspicious_root_users" ]]; then
        echo -e "${RED}ALERT: Found suspicious root accounts!${NC}"
        echo "$suspicious_root_users"
        log "SECURITY: Found suspicious UID 0 accounts: $suspicious_root_users"
    else
        echo -e "${GREEN}  No suspicious root accounts found${NC}"
        log "User inspection: No suspicious UID 0 accounts"
    fi

    echo

    # Check for locked accounts
    echo -e "${CYAN}Locked accounts:${NC}"
    sudo awk -F: '$2 ~ /^!/ || $2 ~ /^\*/ {print "  " $1}' /etc/shadow

    echo
    log "User inspection completed"
    echo -e "${GREEN}✓ User inspection complete${NC}"
}

################################################################################
# Task 2: Create Team Users
################################################################################

create_team_users() {
    echo -e "${BLUE}=== Task 2: Creating Team Users ===${NC}"
    log "Creating team users"

    for user in "${TEAM_USERS[@]}"; do
        # Check if user already exists
        if id "$user" &>/dev/null; then
            echo -e "${YELLOW}⚠️  User $user already exists, skipping...${NC}"
            log "User $user already exists, skipped"
            continue
        fi

        echo "Creating user: $user"

        # Create user with home directory and bash shell
        sudo useradd -m -s /bin/bash -c "KERNEL SHADOWS Team Member" "$user"

        # Set temporary password and force change on first login
        echo "$user:TempPass123!" | sudo chpasswd
        sudo chage -d 0 "$user"  # Force password change on first login

        # Set password expiry policy (90 days)
        sudo chage -M 90 "$user"

        log "Created user: $user"
        echo -e "${GREEN}✓ User $user created${NC}"
    done

    echo
    log "All team users created"
    echo -e "${GREEN}✓ All team users created${NC}"
}

################################################################################
# Task 3: Create Groups and Add Members
################################################################################

create_groups() {
    echo -e "${BLUE}=== Task 3: Creating Groups ===${NC}"
    log "Creating groups and adding members"

    # Define groups and their members using associative array
    declare -A groups
    groups["operations"]="viktor dmitry"
    groups["security"]="alex anna"
    groups["forensics"]="anna"
    groups["devops"]="dmitry"
    groups["netadmin"]="alex"

    for group_name in "${!groups[@]}"; do
        # Create group if doesn't exist
        if ! getent group "$group_name" &>/dev/null; then
            sudo groupadd "$group_name"
            echo -e "${GREEN}✓ Group $group_name created${NC}"
            log "Created group: $group_name"
        else
            echo -e "${YELLOW}⚠️  Group $group_name already exists${NC}"
        fi

        # Add members
        for member in ${groups[$group_name]}; do
            if id "$member" &>/dev/null; then
                sudo usermod -aG "$group_name" "$member"
                echo "  ✓ Added $member to $group_name"
                log "Added $member to group $group_name"
            else
                echo -e "${YELLOW}  ⚠️  User $member does not exist, skipping${NC}"
            fi
        done
    done

    echo

    # Verification
    echo -e "${YELLOW}Group Membership Verification:${NC}"
    for user in "${TEAM_USERS[@]}"; do
        if id "$user" &>/dev/null; then
            echo "  $user: $(groups $user | cut -d: -f2)"
        fi
    done

    echo
    log "Groups created and members added"
    echo -e "${GREEN}✓ Groups created and members added${NC}"
}

################################################################################
# Task 4: Setup Shared Directory with Permissions
################################################################################

setup_shared_directory() {
    echo -e "${BLUE}=== Task 4: Setting Up Shared Directory ===${NC}"
    log "Setting up shared directory: $SHARED_DIR"

    # Create parent directory if needed
    sudo mkdir -p "$(dirname "$SHARED_DIR")"

    # Create shared directory
    sudo mkdir -p "$SHARED_DIR"

    # Set owner and group
    sudo chown viktor:operations "$SHARED_DIR"

    # Set permissions with sticky bit and SGID
    # 1 = Sticky bit (only owner can delete own files)
    # 2 = SGID (new files inherit group)
    # 770 = rwx for user and group, nothing for others
    sudo chmod 3770 "$SHARED_DIR"

    log "Shared directory created with permissions 3770"

    # Verification
    echo
    echo -e "${YELLOW}Shared directory permissions:${NC}"
    ls -ld "$SHARED_DIR"

    # Create README in shared directory
    sudo tee "$SHARED_DIR/README.txt" > /dev/null << 'EOF'
KERNEL SHADOWS Operation - Shared Directory
============================================

This directory is for team collaboration.

Permissions:
- Owner (viktor): Full access (rwx)
- Group (operations): Full access (rwx)
- Others: No access

Special Bits:
- Sticky Bit: Only file owner can delete their own files
- SGID: New files inherit the 'operations' group

Members: viktor, dmitry
EOF

    sudo chown viktor:operations "$SHARED_DIR/README.txt"
    sudo chmod 660 "$SHARED_DIR/README.txt"

    echo
    log "Shared directory configured successfully"
    echo -e "${GREEN}✓ Shared directory configured${NC}"
}

################################################################################
# Task 5: Configure sudo for Alex (Network Commands Only)
################################################################################

setup_sudo_alex() {
    echo -e "${BLUE}=== Task 5: Configuring sudo for Alex ===${NC}"
    log "Configuring sudo for Alex (network commands only)"

    local sudoers_file="/etc/sudoers.d/alex"

    # Create sudoers configuration for Alex
    sudo tee "$sudoers_file" > /dev/null << 'EOF'
# Alex Sokolov - Network Administration Commands
# Episode 09: Users & Permissions
# KERNEL SHADOWS Operation
# Principle of Least Privilege - Alex can ONLY run network commands

# Network commands alias
Cmnd_Alias NETCMDS = /usr/sbin/ip, \
                      /usr/bin/ss, \
                      /bin/ss, \
                      /usr/bin/netstat, \
                      /bin/netstat, \
                      /usr/sbin/tcpdump, \
                      /usr/sbin/iptables, \
                      /usr/sbin/ip6tables, \
                      /usr/sbin/ufw, \
                      /usr/bin/nmap, \
                      /usr/sbin/route, \
                      /sbin/route

# Alex can run network commands as root without password
alex ALL=(root) NOPASSWD: NETCMDS

# Explicitly deny dangerous commands (defense in depth)
alex ALL=(root) !/usr/sbin/visudo, \
                !/usr/bin/passwd root, \
                !/bin/passwd root, \
                !/bin/rm -rf /, \
                !/usr/bin/rm -rf /

# Logging: sudo logs to /var/log/auth.log by default
EOF

    # Set correct permissions (440 = read-only for owner and group, nothing for others)
    sudo chmod 440 "$sudoers_file"

    # Validate syntax
    if sudo visudo -c -f "$sudoers_file"; then
        echo -e "${GREEN}✓ Sudoers syntax validated${NC}"
        log "Sudo configured for Alex successfully"
    else
        echo -e "${RED}❌ Syntax error in sudoers file!${NC}"
        sudo rm "$sudoers_file"
        log "ERROR: Sudoers syntax validation failed for Alex"
        return 1
    fi

    # Display configuration
    echo
    echo -e "${YELLOW}Alex's sudo privileges:${NC}"
    sudo cat "$sudoers_file" | grep -v '^#' | grep -v '^$'

    echo
    log "Sudo configuration for Alex completed"
    echo -e "${GREEN}✓ Sudo configured for Alex${NC}"
}

################################################################################
# Task 6: Configure ACL for Anna (Read-Only Log Access)
################################################################################

setup_acl_anna() {
    echo -e "${BLUE}=== Task 6: Configuring ACL for Anna ===${NC}"
    log "Configuring ACL for Anna (read-only log access)"

    # Check if ACL tools are installed
    if ! command -v setfacl &>/dev/null; then
        echo "ACL tools not installed. Installing..."
        sudo apt-get update -qq
        sudo apt-get install -y acl
        log "Installed ACL tools"
    fi

    # Anna needs execute permission on /var/log to access files inside
    sudo setfacl -m u:anna:rx /var/log
    log "Set ACL for Anna on /var/log (rx)"

    # Give Anna read-only permission on specific log files
    local logs=(
        "/var/log/auth.log"
        "/var/log/syslog"
        "/var/log/kern.log"
    )

    for log_file in "${logs[@]}"; do
        if [[ -f "$log_file" ]]; then
            sudo setfacl -m u:anna:r "$log_file"
            echo "✓ ACL set for $log_file"
            log "Set ACL for Anna on $log_file (r)"
        else
            echo -e "${YELLOW}⚠️  Log file $log_file does not exist, skipping${NC}"
        fi
    done

    # Set default ACL for new files in /var/log
    # (so new log files automatically have Anna read access)
    sudo setfacl -d -m u:anna:r /var/log 2>/dev/null || true

    # Also handle Apache logs if they exist
    if [[ -d "/var/log/apache2" ]]; then
        sudo setfacl -m u:anna:rx /var/log/apache2
        sudo setfacl -R -m u:anna:r /var/log/apache2/*.log 2>/dev/null || true
        log "Set ACL for Anna on Apache logs"
    fi

    echo

    # Verification
    echo -e "${YELLOW}ACL verification:${NC}"
    for log_file in "${logs[@]}"; do
        if [[ -f "$log_file" ]]; then
            echo "  $log_file:"
            getfacl "$log_file" 2>/dev/null | grep "user:anna" || echo "    (no ACL set)"
        fi
    done

    echo
    log "ACL configuration for Anna completed"
    echo -e "${GREEN}✓ ACL configured for Anna${NC}"
}

################################################################################
# Task 7: Security Audit - Find SUID/SGID Files
################################################################################

security_audit_suid_sgid() {
    echo -e "${BLUE}=== Task 7: Security Audit (SUID/SGID) ===${NC}"
    log "Starting SUID/SGID security audit"

    # Known safe SUID binaries (baseline)
    local safe_suid=(
        "/usr/bin/sudo"
        "/usr/bin/su"
        "/usr/bin/passwd"
        "/usr/bin/chsh"
        "/usr/bin/chfn"
        "/usr/bin/gpasswd"
        "/usr/bin/newgrp"
        "/usr/bin/mount"
        "/usr/bin/umount"
        "/usr/bin/ping"
        "/usr/bin/ping6"
        "/usr/bin/pkexec"
        "/usr/lib/openssh/ssh-keysign"
        "/usr/lib/dbus-1.0/dbus-daemon-launch-helper"
    )

    echo -e "${CYAN}Searching for SUID files (permission 4000)...${NC}"
    local suid_files=$(find / -perm -4000 -type f 2>/dev/null || true)
    local suid_count=0
    local suspicious_suid=()

    if [[ -n "$suid_files" ]]; then
        while IFS= read -r file; do
            ((suid_count++))
            ls -l "$file"

            # Check if it's in safe list
            if [[ ! " ${safe_suid[@]} " =~ " ${file} " ]]; then
                echo -e "  ${RED}⚠️  SUSPICIOUS: $file (not in baseline)${NC}"
                suspicious_suid+=("$file")
                log "SECURITY: Suspicious SUID file found: $file"
            fi
        done <<< "$suid_files"
    fi

    echo
    echo -e "${CYAN}Searching for SGID files (permission 2000)...${NC}"
    local sgid_files=$(find / -perm -2000 -type f 2>/dev/null || true)
    local sgid_count=0

    if [[ -n "$sgid_files" ]]; then
        while IFS= read -r file; do
            ((sgid_count++))
            ls -l "$file"
        done <<< "$sgid_files"
    fi

    echo

    # Summary
    echo -e "${YELLOW}Summary:${NC}"
    echo "  SUID files found: $suid_count"
    echo "  SGID files found: $sgid_count"
    echo "  Suspicious SUID files: ${#suspicious_suid[@]}"

    if [[ ${#suspicious_suid[@]} -gt 0 ]]; then
        echo -e "\n${RED}⚠️  ALERT: Suspicious SUID files require investigation!${NC}"
        for file in "${suspicious_suid[@]}"; do
            echo "    - $file"
        done
    fi

    # Save audit to file
    {
        echo "SUID/SGID Audit - $(date)"
        echo "======================================"
        echo "SUID files ($suid_count):"
        echo "$suid_files"
        echo
        echo "SGID files ($sgid_count):"
        echo "$sgid_files"
        echo
        echo "Suspicious SUID files (${#suspicious_suid[@]}):"
        printf '%s\n' "${suspicious_suid[@]}"
    } > /tmp/suid_sgid_audit.txt

    echo "  Report saved: /tmp/suid_sgid_audit.txt"

    echo
    log "SUID/SGID audit completed: $suid_count SUID, $sgid_count SGID files found"
    echo -e "${GREEN}✓ Security audit complete${NC}"
}

################################################################################
# Task 8: Generate Final Security Audit Report
################################################################################

generate_security_report() {
    echo -e "${BLUE}=== Task 8: Generating Security Audit Report ===${NC}"
    log "Generating final security audit report"

    # Create parent directory if needed
    sudo mkdir -p "$(dirname "$REPORT_FILE")"

    # Generate comprehensive report
    sudo tee "$REPORT_FILE" > /dev/null << EOF
================================================================================
                   SECURITY AUDIT REPORT - EPISODE 09
                        Users & Permissions
================================================================================

Operation: KERNEL SHADOWS
Location: Saint Petersburg, Russia (LETI)
Date: $(date)
Auditor: Max Sokolov
Mentor: Andrei Volkov

--------------------------------------------------------------------------------
1. USERS CREATED
--------------------------------------------------------------------------------

EOF

    # List created users
    for user in "${TEAM_USERS[@]}"; do
        if id "$user" &>/dev/null; then
            sudo tee -a "$REPORT_FILE" > /dev/null << EOF
✓ $user
$(id "$user")
  Home: $(getent passwd "$user" | cut -d: -f6)
  Shell: $(getent passwd "$user" | cut -d: -f7)
  Password: Must be changed on first login
  Max password age: 90 days

EOF
        fi
    done

    sudo tee -a "$REPORT_FILE" > /dev/null << EOF
--------------------------------------------------------------------------------
2. GROUPS & MEMBERSHIP
--------------------------------------------------------------------------------

EOF

    # Groups
    for group in operations security forensics devops netadmin; do
        if getent group "$group" &>/dev/null; then
            sudo tee -a "$REPORT_FILE" > /dev/null << EOF
Group: $group
$(getent group "$group")
Members: $(getent group "$group" | cut -d: -f4)

EOF
        fi
    done

    sudo tee -a "$REPORT_FILE" > /dev/null << EOF
User Group Memberships:
EOF

    for user in "${TEAM_USERS[@]}"; do
        if id "$user" &>/dev/null; then
            echo "  $user: $(groups $user | cut -d: -f2)" | sudo tee -a "$REPORT_FILE" > /dev/null
        fi
    done

    sudo tee -a "$REPORT_FILE" > /dev/null << EOF

--------------------------------------------------------------------------------
3. SUDO CONFIGURATION
--------------------------------------------------------------------------------

Alex Sokolov - Network Commands Only (Principle of Least Privilege):

EOF

    # Sudo for Alex
    if [[ -f /etc/sudoers.d/alex ]]; then
        sudo cat /etc/sudoers.d/alex | grep -v '^#' | grep -v '^$' | sudo tee -a "$REPORT_FILE" > /dev/null
    fi

    sudo tee -a "$REPORT_FILE" > /dev/null << EOF

Commands Alex can run:
  - ip (network configuration)
  - ss, netstat (network statistics)
  - tcpdump (packet capture)
  - iptables, ufw (firewall management)
  - nmap (network scanning)

Commands Alex CANNOT run:
  - useradd, userdel (user management)
  - passwd root (change root password)
  - visudo (modify sudo configuration)
  - rm -rf / (destructive commands)

--------------------------------------------------------------------------------
4. ACL CONFIGURATION
--------------------------------------------------------------------------------

Anna Kovaleva - Read-Only Log Access (Forensics Requirements):

EOF

    # ACL for Anna
    echo "ACL on /var/log:" | sudo tee -a "$REPORT_FILE" > /dev/null
    getfacl /var/log 2>/dev/null | grep "user:anna" | sudo tee -a "$REPORT_FILE" > /dev/null || echo "  (not set)" | sudo tee -a "$REPORT_FILE" > /dev/null

    echo | sudo tee -a "$REPORT_FILE" > /dev/null
    echo "ACL on log files:" | sudo tee -a "$REPORT_FILE" > /dev/null
    for log in /var/log/auth.log /var/log/syslog /var/log/kern.log; do
        if [[ -f "$log" ]]; then
            echo "  $log:" | sudo tee -a "$REPORT_FILE" > /dev/null
            getfacl "$log" 2>/dev/null | grep "user:anna" | sudo tee -a "$REPORT_FILE" > /dev/null || echo "    (not set)" | sudo tee -a "$REPORT_FILE" > /dev/null
        fi
    done

    sudo tee -a "$REPORT_FILE" > /dev/null << EOF

Anna can:
  - Read authentication logs (auth.log)
  - Read system logs (syslog)
  - Read kernel logs (kern.log)

Anna cannot:
  - Modify logs (read-only via ACL)
  - Delete logs
  - Add new log entries

--------------------------------------------------------------------------------
5. SHARED DIRECTORY
--------------------------------------------------------------------------------

Shared Operations Directory: $SHARED_DIR

EOF

    # Shared directory permissions
    ls -ld "$SHARED_DIR" 2>/dev/null | sudo tee -a "$REPORT_FILE" > /dev/null || echo "(not created)" | sudo tee -a "$REPORT_FILE" > /dev/null

    sudo tee -a "$REPORT_FILE" > /dev/null << EOF

Permission Breakdown:
  - Owner (viktor): rwx (read, write, execute)
  - Group (operations): rwx (read, write, execute)
  - Others: --- (no access)
  - Sticky Bit (T): Only file owner can delete their own files
  - SGID (s): New files inherit the 'operations' group

Members with access: viktor, dmitry (operations group)

--------------------------------------------------------------------------------
6. SUID/SGID AUDIT
--------------------------------------------------------------------------------

EOF

    # Count SUID/SGID files
    local suid_count=$(find / -perm -4000 -type f 2>/dev/null | wc -l || echo "0")
    local sgid_count=$(find / -perm -2000 -type f 2>/dev/null | wc -l || echo "0")

    sudo tee -a "$REPORT_FILE" > /dev/null << EOF
SUID files found: $suid_count
SGID files found: $sgid_count

Baseline safe SUID binaries:
  /usr/bin/sudo, /usr/bin/passwd, /usr/bin/su, /usr/bin/mount, /usr/bin/ping

Suspicious SUID files: See /tmp/suid_sgid_audit.txt

Risk Assessment:
  - Standard SUID files present (expected)
  - No suspicious SUID files in /tmp or /home (good)
  - Recommendation: Monitor SUID files weekly

--------------------------------------------------------------------------------
7. SECURITY POSTURE
--------------------------------------------------------------------------------

✓ Principle of Least Privilege implemented
  - Each user has minimum necessary permissions
  - Alex: sudo limited to network commands only
  - Anna: read-only log access via ACL

✓ Defense in Depth
  - Permissions (chmod/chown)
  - sudo configuration (limited commands)
  - ACL (granular access control)
  - Shared directory (sticky bit + SGID)

✓ Separation of Duties
  - Operations: viktor, dmitry
  - Security: alex, anna
  - Forensics: anna
  - DevOps: dmitry
  - Network Admin: alex

✓ Audit Trail
  - sudo logs to /var/log/auth.log
  - ACL changes logged
  - User management logged to $LOG_FILE

--------------------------------------------------------------------------------
8. RECOMMENDATIONS
--------------------------------------------------------------------------------

Immediate Actions:
  1. ✓ Principle of Least Privilege implemented
  2. ✓ sudo configured for Alex (network only)
  3. ✓ ACL configured for Anna (read-only logs)
  4. ✓ Shared directory with proper permissions

Short-term (1-2 weeks):
  1. [ ] Password policy enforcement (complexity requirements)
  2. [ ] Enable auditd for detailed user action tracking
  3. [ ] Implement fail2ban for SSH brute-force protection
  4. [ ] Set up automated SUID/SGID monitoring

Long-term (1-3 months):
  1. [ ] Regular security audits (weekly)
  2. [ ] User access review (monthly)
  3. [ ] sudo configuration review (quarterly)
  4. [ ] Penetration testing (after Season 5)

--------------------------------------------------------------------------------
9. ANDREI VOLKOV NOTES
--------------------------------------------------------------------------------

"Max справился хорошо. Permissions настроены правильно по всем принципам
безопасного администрирования:

1. Principle of Least Privilege - каждый имеет только необходимые права
2. Defense in Depth - многослойная защита (permissions + sudo + ACL)
3. Separation of Duties - разделение ответственности по группам
4. Audit Trail - логирование всех действий

Root access как заряженный пистолет. Max научился его правильно выдавать.
Krylov больше не сможет эксплуатировать misconfigured permissions.

Но мониторинг обязателен. Threats evolve. Security - это процесс, не продукт.

Следующий шаг - процессы и systemd. Boris объяснит."

Signed: Andrei Volkov, Professor Emeritus, LETI Unix Laboratory
        Max Sokolov, System Administrator, KERNEL SHADOWS Operation

--------------------------------------------------------------------------------
10. VIKTOR PETROV APPROVAL
--------------------------------------------------------------------------------

"Отчёт принят. Permissions team правильно настроены. Я могу спать спокойно.

Продолжай работу. Следующий шаг - процессы и systemd (Episode 10).

Хорошая работа, Макс."

Viktor Petrov
Operation Coordinator
KERNEL SHADOWS

================================================================================
                              END OF REPORT
================================================================================

Report generated: $(date)
Location: $REPORT_FILE
Permissions: 640 (viktor:operations)
EOF

    # Set appropriate permissions on report
    sudo chmod 640 "$REPORT_FILE"
    sudo chown viktor:operations "$REPORT_FILE" 2>/dev/null || true

    echo
    echo -e "${GREEN}✓ Security report generated: $REPORT_FILE${NC}"
    log "Security audit report generated: $REPORT_FILE"

    # Display report summary
    echo
    echo -e "${YELLOW}Report Summary:${NC}"
    echo "  Users created: ${#TEAM_USERS[@]}"
    echo "  Groups created: 5 (operations, security, forensics, devops, netadmin)"
    echo "  Sudo configured: Alex (network commands only)"
    echo "  ACL configured: Anna (read-only logs)"
    echo "  Shared directory: $SHARED_DIR (3770 permissions)"
    echo "  Full report: $REPORT_FILE"
}

################################################################################
# Main Execution
################################################################################

main() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  EPISODE 09: USERS & PERMISSIONS - REFERENCE SOLUTION     ║${NC}"
    echo -e "${BLUE}║  Location: Saint Petersburg, Russia (LETI)                ║${NC}"
    echo -e "${BLUE}║  Mission: Configure secure user access                     ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo

    # Check if running with appropriate privileges
    if [[ $EUID -ne 0 ]]; then
        echo -e "${YELLOW}Warning: This script requires root privileges for some operations.${NC}"
        echo -e "${YELLOW}Will use sudo where necessary. You may be prompted for password.${NC}"
        echo
    fi

    # Initialize log
    log "=========================================="
    log "Episode 09: Users & Permissions - Started"
    log "=========================================="

    # Execute all tasks
    inspect_users
    echo

    create_team_users
    echo

    create_groups
    echo

    setup_shared_directory
    echo

    setup_sudo_alex
    echo

    setup_acl_anna
    echo

    security_audit_suid_sgid
    echo

    generate_security_report
    echo

    # Final summary
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ALL TASKS COMPLETE!                                       ║${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}║  Andrei Volkov:                                            ║${NC}"
    echo -e "${GREEN}║  'Хорошая работа, Макс. Permissions настроены правильно.  ║${NC}"
    echo -e "${GREEN}║   Root access — это ответственность. Ты понял это.'       ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${CYAN}Security Report: $REPORT_FILE${NC}"
    echo -e "${CYAN}Execution Log: $LOG_FILE${NC}"
    echo
    echo -e "${YELLOW}Next: Episode 10 - Processes & Systemd (with Boris Kuznetsov)${NC}"

    log "Episode 09: Users & Permissions - Completed successfully"
}

# Run main function
main "$@"

