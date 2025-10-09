#!/bin/bash

################################################################################
# EPISODE 09: USERS & PERMISSIONS
# Season 3: System Administration
#
# Location: Saint Petersburg, Russia (LETI)
# Mentor: Andrei Volkov
# Mission: Configure secure user access for KERNEL SHADOWS operation
#
# Your task: Complete all TODO sections marked below
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TEAM_USERS=("viktor" "alex" "anna" "dmitry")
SHARED_DIR="/var/operations/shared"
REPORT_FILE="/var/operations/security_audit_ep09.txt"

################################################################################
# Task 1: Inspect Current Users
################################################################################

inspect_users() {
    echo -e "${BLUE}=== Task 1: Inspecting Users ===${NC}"

    # TODO: Display all users with shell access
    # Hint: Check /etc/passwd for users with /bin/bash or /bin/sh
    echo "Users with shell access:"
    # YOUR CODE HERE

    echo

    # TODO: Find users with UID 0 (root privileges) other than root
    # Hint: awk -F: '$3 == 0 ...'
    echo "⚠️  Users with UID 0 (besides root):"
    # YOUR CODE HERE

    echo
    echo -e "${GREEN}✓ User inspection complete${NC}"
}

################################################################################
# Task 2: Create Team Users
################################################################################

create_team_users() {
    echo -e "${BLUE}=== Task 2: Creating Team Users ===${NC}"

    for user in "${TEAM_USERS[@]}"; do
        # TODO: Check if user already exists
        # Hint: id "$user" &>/dev/null

        # TODO: Create user with home directory and bash shell
        # Hint: sudo useradd -m -s /bin/bash "$user"

        # TODO: Set temporary password and force change on first login
        # Hint: echo "$user:TempPass123!" | sudo chpasswd
        #       sudo chage -d 0 "$user"

        # YOUR CODE HERE

        echo "✓ User $user created"
    done

    echo -e "${GREEN}✓ All team users created${NC}"
}

################################################################################
# Task 3: Create Groups and Add Members
################################################################################

create_groups() {
    echo -e "${BLUE}=== Task 3: Creating Groups ===${NC}"

    # TODO: Define groups and their members
    # Groups needed:
    #   - operations: viktor, dmitry
    #   - security: alex, anna
    #   - forensics: anna
    #   - devops: dmitry
    #   - netadmin: alex

    # TODO: Create each group
    # Hint: sudo groupadd groupname

    # TODO: Add users to groups
    # Hint: sudo usermod -aG groupname username
    # WARNING: Use -aG (append), not -G (will overwrite)!

    # YOUR CODE HERE

    echo -e "${GREEN}✓ Groups created and members added${NC}"

    # Verification
    echo -e "\n${YELLOW}Group Membership Verification:${NC}"
    for user in "${TEAM_USERS[@]}"; do
        echo "$user: $(groups $user 2>/dev/null || echo 'user not found')"
    done
}

################################################################################
# Task 4: Setup Shared Directory with Permissions
################################################################################

setup_shared_directory() {
    echo -e "${BLUE}=== Task 4: Setting Up Shared Directory ===${NC}"

    # TODO: Create shared directory
    # Hint: sudo mkdir -p "$SHARED_DIR"

    # TODO: Set owner and group
    # Hint: sudo chown viktor:operations "$SHARED_DIR"

    # TODO: Set permissions with sticky bit and SGID
    # Requirements:
    #   - Owner (viktor): rwx (7)
    #   - Group (operations): rwx (7)
    #   - Others: no access (0)
    #   - Sticky bit (1): only owner can delete own files
    #   - SGID (2): new files inherit group
    # Hint: sudo chmod 3770 "$SHARED_DIR"

    # YOUR CODE HERE

    # Verification
    echo -e "\n${YELLOW}Shared directory permissions:${NC}"
    ls -ld "$SHARED_DIR" 2>/dev/null || echo "Directory not created"

    echo -e "${GREEN}✓ Shared directory configured${NC}"
}

################################################################################
# Task 5: Configure sudo for Alex (Network Commands Only)
################################################################################

setup_sudo_alex() {
    echo -e "${BLUE}=== Task 5: Configuring sudo for Alex ===${NC}"

    local sudoers_file="/etc/sudoers.d/alex"

    # TODO: Create sudoers configuration for Alex
    # Requirements:
    #   - Alex can run network commands: ip, ss, netstat, tcpdump, iptables, ufw
    #   - WITHOUT password (NOPASSWD)
    #   - Use Cmnd_Alias for organization

    # TODO: Write sudoers file
    # IMPORTANT: Use sudo tee to create file with proper permissions
    # Example:
    #   sudo tee "$sudoers_file" > /dev/null << 'EOF'
    #   # Your sudoers config here
    #   EOF

    # YOUR CODE HERE

    # TODO: Set correct permissions (440)
    # Hint: sudo chmod 440 "$sudoers_file"

    # TODO: Validate syntax
    # Hint: sudo visudo -c -f "$sudoers_file"

    # YOUR CODE HERE

    echo -e "${GREEN}✓ Sudo configured for Alex${NC}"
}

################################################################################
# Task 6: Configure ACL for Anna (Read-Only Log Access)
################################################################################

setup_acl_anna() {
    echo -e "${BLUE}=== Task 6: Configuring ACL for Anna ===${NC}"

    # TODO: Check if ACL tools are installed
    # Hint: command -v setfacl &>/dev/null || sudo apt-get install -y acl

    # TODO: Give Anna execute permission on /var/log (to access files inside)
    # Hint: sudo setfacl -m u:anna:rx /var/log

    # TODO: Give Anna read-only permission on log files
    # Logs to configure:
    #   - /var/log/auth.log
    #   - /var/log/syslog
    #   - /var/log/kern.log
    # Hint: sudo setfacl -m u:anna:r /var/log/auth.log

    # TODO: Set default ACL for new files
    # Hint: sudo setfacl -d -m u:anna:r /var/log

    # YOUR CODE HERE

    # Verification
    echo -e "\n${YELLOW}ACL verification:${NC}"
    getfacl /var/log 2>/dev/null | grep "user:anna" || echo "ACL not set"

    echo -e "${GREEN}✓ ACL configured for Anna${NC}"
}

################################################################################
# Task 7: Security Audit - Find SUID/SGID Files
################################################################################

security_audit_suid_sgid() {
    echo -e "${BLUE}=== Task 7: Security Audit (SUID/SGID) ===${NC}"

    # TODO: Find all SUID files (permission 4000)
    # Hint: find / -perm -4000 -type f 2>/dev/null

    # TODO: Find all SGID files (permission 2000)
    # Hint: find / -perm -2000 -type f 2>/dev/null

    # TODO: Compare with known safe SUID binaries
    # Safe SUID files typically include:
    #   /usr/bin/sudo, /usr/bin/passwd, /usr/bin/su, /usr/bin/mount, /usr/bin/ping

    # TODO: Count and report findings

    # YOUR CODE HERE

    echo -e "${GREEN}✓ Security audit complete${NC}"
}

################################################################################
# Task 8: Generate Final Security Audit Report
################################################################################

generate_security_report() {
    echo -e "${BLUE}=== Task 8: Generating Security Audit Report ===${NC}"

    # TODO: Create comprehensive security report
    # Report should include:
    #   1. Users created (with IDs)
    #   2. Groups and membership
    #   3. Sudo configuration (Alex)
    #   4. ACL configuration (Anna)
    #   5. Shared directory permissions
    #   6. SUID/SGID audit summary
    #   7. Security recommendations

    # TODO: Write report to $REPORT_FILE
    # Hint: Use cat > "$REPORT_FILE" << 'EOF' ... EOF

    # TODO: Set appropriate permissions on report
    # Hint: sudo chmod 640 "$REPORT_FILE"
    #       sudo chown viktor:operations "$REPORT_FILE"

    # YOUR CODE HERE

    echo -e "${GREEN}✓ Security report generated: $REPORT_FILE${NC}"
}

################################################################################
# Main Execution
################################################################################

main() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  EPISODE 09: USERS & PERMISSIONS                           ║${NC}"
    echo -e "${BLUE}║  Location: Saint Petersburg, Russia                        ║${NC}"
    echo -e "${BLUE}║  Mission: Configure secure user access                     ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo

    # Check if running as root or with sudo
    if [[ $EUID -ne 0 ]]; then
        echo -e "${YELLOW}Warning: Some operations require root privileges.${NC}"
        echo -e "${YELLOW}Script will use sudo where necessary.${NC}"
        echo
    fi

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
    echo -e "${GREEN}║  Andrei Volkov: 'Хорошая работа, Макс. Permissions       ║${NC}"
    echo -e "${GREEN}║  настроены правильно. Root access — это ответственность.'  ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${YELLOW}Next: Episode 10 - Processes & Systemd${NC}"
}

# Run main function
main "$@"

