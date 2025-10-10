#!/bin/bash

################################################################################
# KERNEL SHADOWS: Episode 16 — Ansible & Infrastructure as Code
# Amsterdam → Berlin (Day 31-32) — SEASON 4 FINALE!
# Klaus Schmidt: "Configuration management is managing chaos."
#
# Mission: Automate configuration of 50 servers with Ansible
################################################################################

# Strict mode
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
PROJECT_DIR="$HOME/operation-shadow-ansible"

################################################################################
# Task 1: Install Ansible
################################################################################
task1_install_ansible() {
    echo -e "${BLUE}[Task 1]${NC} Installing Ansible..."

    # TODO: Update package list
    # Hint: sudo apt update

    # TODO: Install Ansible
    # Hint: sudo apt install -y ansible

    # TODO: Verify installation
    # Hint: ansible --version

    echo -e "${GREEN}✓${NC} Ansible installation template ready"
}

################################################################################
# Task 2: Create Inventory File
################################################################################
task2_create_inventory() {
    echo -e "${BLUE}[Task 2]${NC} Creating inventory file..."

    mkdir -p "$PROJECT_DIR"

    # TODO: Create inventory.ini with 50 servers in groups
    # Hint: See README.md Task 2 for complete structure
    # Groups needed:
    # - [web] — 10 servers (web-[01:10])
    # - [database] — 5 servers (db-[01:05])
    # - [cache] — 5 servers (cache-[01:05])
    # - [monitoring] — 2 servers
    # - [app] — 28 servers (app-[01:28])
    # - [production:children] — group of groups
    # - [production:vars] — common variables

    echo -e "${GREEN}✓${NC} Inventory template created"
}

################################################################################
# Task 3: Write Basic Playbook
################################################################################
task3_basic_playbook() {
    echo -e "${BLUE}[Task 3]${NC} Creating basic playbook..."

    # TODO: Create playbook.yml
    # Hint: Must include:
    # - name, hosts, become
    # - tasks: update apt, install packages, create user, configure firewall, install Docker
    # See README.md Task 3

    echo -e "${GREEN}✓${NC} Basic playbook template created"
}

################################################################################
# Task 4: Create Roles
################################################################################
task4_create_roles() {
    echo -e "${BLUE}[Task 4]${NC} Creating roles structure..."

    # TODO: Create role directories
    # Hint: mkdir -p roles/{common,webserver,database}/{tasks,handlers,templates,files,vars,defaults}

    # TODO: Create roles/common/tasks/main.yml
    # Hint: Update apt, install packages, create deploy user

    # TODO: Create roles/webserver/tasks/main.yml
    # Hint: Install nginx, copy config, start service

    # TODO: Create roles/webserver/handlers/main.yml
    # Hint: restart nginx handler

    echo -e "${GREEN}✓${NC} Roles structure created"
}

################################################################################
# Task 5: Use Variables
################################################################################
task5_variables() {
    echo -e "${BLUE}[Task 5]${NC} Setting up variables..."

    # TODO: Create group_vars directories
    # Hint: mkdir -p group_vars host_vars

    # TODO: Create group_vars/all.yml
    # Hint: Common variables (deploy_user, timezone, ntp_server)

    # TODO: Create group_vars/web.yml
    # Hint: Web-specific variables (nginx_port, nginx_worker_processes)

    # TODO: Create group_vars/database.yml
    # Hint: Database-specific variables (postgres_version, max_connections)

    echo -e "${GREEN}✓${NC} Variables configured"
}

################################################################################
# Task 6: Templates with Jinja2
################################################################################
task6_templates() {
    echo -e "${BLUE}[Task 6]${NC} Creating Jinja2 templates..."

    # TODO: Create roles/webserver/templates/nginx.conf.j2
    # Hint: See README.md Task 6 for complete template
    # Must use variables: {{ nginx_port }}, {{ nginx_worker_processes }}, {{ ansible_hostname }}

    echo -e "${GREEN}✓${NC} Templates created"
}

################################################################################
# Task 7: Handlers
################################################################################
task7_handlers() {
    echo -e "${BLUE}[Task 7]${NC} Configuring handlers..."

    # TODO: Update roles/webserver/handlers/main.yml
    # Hint: Add handlers: validate nginx config, restart nginx, reload nginx

    # TODO: Update roles/webserver/tasks/main.yml to notify handlers
    # Hint: Add "notify: restart nginx" to template task

    echo -e "${GREEN}✓${NC} Handlers configured"
}

################################################################################
# Task 8: Ansible Vault (Secrets)
################################################################################
task8_vault() {
    echo -e "${BLUE}[Task 8]${NC} Setting up Ansible Vault..."

    echo -e "${YELLOW}NOTE:${NC} Ansible Vault requires interactive password"
    echo "  Command: ansible-vault create secrets.yml"
    echo "  Password: operation-shadow-vault-2025"

    # TODO: Create encrypted secrets.yml
    # Hint: ansible-vault create secrets.yml
    # Add: db_password, api_key, ssh_private_key

    # TODO: Create .vault_pass file (for automation)
    # Hint: echo "operation-shadow-vault-2025" > ~/.vault_pass && chmod 600 ~/.vault_pass

    echo -e "${GREEN}✓${NC} Vault template ready"
}

################################################################################
# Task 9: Security Audit Playbook
################################################################################
task9_security_audit() {
    echo -e "${BLUE}[Task 9]${NC} Creating security audit playbook..."

    # TODO: Create audit.yml
    # Hint: See README.md Task 9 for complete playbook
    # Must check:
    # - Unauthorized users (UID 0)
    # - Empty passwords
    # - SSH configuration
    # - Suspicious processes
    # - Modified system files
    # - Open ports
    # - Firewall status
    # - SSH keys
    # - Recent logins
    # - Generate audit report

    echo -e "${GREEN}✓${NC} Security audit playbook created"
}

################################################################################
# Main execution
################################################################################
main() {
    echo ""
    echo "================================================================"
    echo "  KERNEL SHADOWS: Episode 16 — Ansible & IaC"
    echo "  Amsterdam → Berlin (SEASON 4 FINALE!)"
    echo "  Klaus Schmidt: 'Managing chaos.'"
    echo "================================================================"
    echo ""

    echo -e "${YELLOW}NOTE:${NC} This episode requires:"
    echo "  - Ansible installed (will be done in Task 1)"
    echo "  - SSH access to servers (or local simulation)"
    echo "  - Understanding of YAML syntax"
    echo ""
    echo -e "${YELLOW}TIP:${NC} For local testing without real servers:"
    echo "  - Use 'localhost' in inventory"
    echo "  - Add 'ansible_connection=local' to skip SSH"
    echo "  - Test playbooks with '--check' flag (dry run)"
    echo ""

    # Uncomment tasks as you complete them
    task1_install_ansible
    # task2_create_inventory
    # task3_basic_playbook
    # task4_create_roles
    # task5_variables
    # task6_templates
    # task7_handlers
    # task8_vault
    # task9_security_audit

    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Episode 16 starter tasks initialized!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Project directory: $PROJECT_DIR"
    echo ""
    echo "Next steps:"
    echo "  1. Complete Ansible installation (Task 1)"
    echo "  2. Create inventory.ini with 50 servers (Task 2)"
    echo "  3. Write playbooks and roles (Tasks 3-7)"
    echo "  4. Setup Vault for secrets (Task 8)"
    echo "  5. Create security audit automation (Task 9)"
    echo ""
    echo "Run tests:"
    echo "  cd ~/kernel-shadows/season-4-devops-automation/episode-16-ansible-iac"
    echo "  ./tests/test.sh"
    echo ""
    echo "Klaus Schmidt: '50 servers, 3 minutes, one command. That's Ansible.'"
    echo ""
}

# Run main function
main "$@"


