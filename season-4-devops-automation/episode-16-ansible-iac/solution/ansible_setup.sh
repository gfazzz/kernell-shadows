#!/bin/bash

################################################################################
# KERNEL SHADOWS: Episode 16 Solution
# Ansible & Infrastructure as Code
# Klaus Schmidt — "Managing chaos."
################################################################################

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="$HOME/operation-shadow-ansible"

################################################################################
# Install Ansible
################################################################################
install_ansible() {
    echo -e "${BLUE}Installing Ansible...${NC}"

    if command -v ansible > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Ansible already installed: $(ansible --version | head -1)"
        return
    fi

    sudo apt update
    sudo apt install -y ansible

    ansible --version
    echo -e "${GREEN}✓${NC} Ansible installed"
}

################################################################################
# Create Inventory
################################################################################
create_inventory() {
    echo -e "${BLUE}Creating inventory file...${NC}"

    mkdir -p "$PROJECT_DIR"

    cat > "$PROJECT_DIR/inventory.ini" << 'EOF'
# Operation Shadow Infrastructure Inventory
# 50 servers across multiple roles

[web]
web-[01:10].operation-shadow.net

[database]
db-[01:05].operation-shadow.net

[cache]
cache-[01:05].operation-shadow.net

[monitoring]
monitor-01.operation-shadow.net
monitor-02.operation-shadow.net

[app]
app-[01:28].operation-shadow.net

# Group of groups
[production:children]
web
database
cache
monitoring
app

# Common variables for all production servers
[production:vars]
ansible_user=deploy
ansible_ssh_private_key_file=~/.ssh/deploy_key
ansible_python_interpreter=/usr/bin/python3
environment=production

# For local testing (no real servers)
[local]
localhost ansible_connection=local
EOF

    echo -e "${GREEN}✓${NC} Inventory created: $PROJECT_DIR/inventory.ini"
}

################################################################################
# Create Basic Playbook
################################################################################
create_playbook() {
    echo -e "${BLUE}Creating basic playbook...${NC}"

    cat > "$PROJECT_DIR/playbook.yml" << 'EOF'
---
- name: Configure operation-shadow servers
  hosts: production
  become: yes
  gather_facts: yes

  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
        cache_valid_time: 3600
      tags: packages

    - name: Install essential packages
      apt:
        name:
          - vim
          - git
          - curl
          - htop
          - net-tools
          - ufw
        state: present
      tags: packages

    - name: Create deploy user
      user:
        name: deploy
        groups: sudo
        shell: /bin/bash
        create_home: yes
        password: "{{ 'operation-shadow' | password_hash('sha512') }}"
      tags: users

    - name: Set up SSH directory for deploy user
      file:
        path: /home/deploy/.ssh
        state: directory
        owner: deploy
        group: deploy
        mode: '0700'
      tags: users

    - name: Configure firewall - Allow SSH
      ufw:
        rule: allow
        port: '22'
        proto: tcp
      tags: firewall

    - name: Configure firewall - Allow HTTP
      ufw:
        rule: allow
        port: '80'
        proto: tcp
      tags: firewall

    - name: Configure firewall - Allow HTTPS
      ufw:
        rule: allow
        port: '443'
        proto: tcp
      tags: firewall

    - name: Enable UFW
      ufw:
        state: enabled
        policy: deny
      tags: firewall

    - name: Install Docker
      apt:
        name: docker.io
        state: present
      tags: docker

    - name: Start Docker service
      service:
        name: docker
        state: started
        enabled: yes
      tags: docker

    - name: Add deploy user to docker group
      user:
        name: deploy
        groups: docker
        append: yes
      tags: docker
EOF

    echo -e "${GREEN}✓${NC} Playbook created: $PROJECT_DIR/playbook.yml"
}

################################################################################
# Create Roles
################################################################################
create_roles() {
    echo -e "${BLUE}Creating roles...${NC}"

    # Create directory structure
    mkdir -p "$PROJECT_DIR/roles"/{common,webserver,database}/{tasks,handlers,templates,files,vars,defaults}

    # Common role
    cat > "$PROJECT_DIR/roles/common/tasks/main.yml" << 'EOF'
---
- name: Update apt cache
  apt:
    update_cache: yes
    cache_valid_time: 3600

- name: Install essential packages
  apt:
    name:
      - vim
      - git
      - curl
      - htop
      - net-tools
    state: present

- name: Set timezone
  timezone:
    name: "{{ timezone | default('UTC') }}"

- name: Create deploy user
  user:
    name: "{{ deploy_user }}"
    groups: sudo
    shell: /bin/bash
    create_home: yes
EOF

    cat > "$PROJECT_DIR/roles/common/defaults/main.yml" << 'EOF'
---
deploy_user: deploy
timezone: Europe/Berlin
EOF

    # Webserver role
    cat > "$PROJECT_DIR/roles/webserver/tasks/main.yml" << 'EOF'
---
- name: Install nginx
  apt:
    name: nginx
    state: present

- name: Copy nginx configuration
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: '0644'
    validate: 'nginx -t -c %s'
  notify: restart nginx

- name: Create web root directory
  file:
    path: /var/www/html
    state: directory
    owner: www-data
    group: www-data
    mode: '0755'

- name: Deploy index page
  copy:
    content: |
      <!DOCTYPE html>
      <html>
      <head><title>Operation Shadow</title></head>
      <body>
        <h1>Operation Shadow - {{ ansible_hostname }}</h1>
        <p>Managed by Ansible - Episode 16</p>
      </body>
      </html>
    dest: /var/www/html/index.html
    owner: www-data
    group: www-data
    mode: '0644'

- name: Ensure nginx is started and enabled
  service:
    name: nginx
    state: started
    enabled: yes
EOF

    cat > "$PROJECT_DIR/roles/webserver/handlers/main.yml" << 'EOF'
---
- name: restart nginx
  service:
    name: nginx
    state: restarted

- name: reload nginx
  service:
    name: nginx
    state: reloaded
EOF

    cat > "$PROJECT_DIR/roles/webserver/templates/nginx.conf.j2" << 'EOF'
user www-data;
worker_processes {{ nginx_worker_processes | default('auto') }};
pid /run/nginx.pid;

events {
    worker_connections {{ nginx_worker_connections | default(1024) }};
}

http {
    sendfile on;
    tcp_nopush on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size {{ max_upload_size | default('100M') }};

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;

    server {
        listen {{ nginx_port | default(80) }};
        server_name {{ ansible_hostname }};

        root /var/www/html;
        index index.html;

        location / {
            try_files $uri $uri/ =404;
        }

        location /health {
            access_log off;
            return 200 "OK - {{ ansible_hostname }}\n";
            add_header Content-Type text/plain;
        }
    }
}
EOF

    cat > "$PROJECT_DIR/roles/webserver/defaults/main.yml" << 'EOF'
---
nginx_port: 80
nginx_worker_processes: auto
nginx_worker_connections: 1024
max_upload_size: 100M
EOF

    # Database role
    cat > "$PROJECT_DIR/roles/database/tasks/main.yml" << 'EOF'
---
- name: Install PostgreSQL
  apt:
    name:
      - postgresql
      - postgresql-contrib
      - python3-psycopg2
    state: present

- name: Ensure PostgreSQL is started and enabled
  service:
    name: postgresql
    state: started
    enabled: yes

- name: Create application database
  postgresql_db:
    name: operation_shadow
    state: present
  become_user: postgres
EOF

    echo -e "${GREEN}✓${NC} Roles created"
}

################################################################################
# Create Variables
################################################################################
create_variables() {
    echo -e "${BLUE}Creating variables...${NC}"

    mkdir -p "$PROJECT_DIR/group_vars" "$PROJECT_DIR/host_vars"

    cat > "$PROJECT_DIR/group_vars/all.yml" << 'EOF'
---
# Common variables for all servers
deploy_user: deploy
timezone: Europe/Berlin
ntp_server: pool.ntp.org
EOF

    cat > "$PROJECT_DIR/group_vars/web.yml" << 'EOF'
---
# Web server specific variables
nginx_port: 80
nginx_worker_processes: auto
nginx_worker_connections: 1024
max_upload_size: 100M
EOF

    cat > "$PROJECT_DIR/group_vars/database.yml" << 'EOF'
---
# Database specific variables
postgres_version: 14
postgres_max_connections: 200
postgres_shared_buffers: 256MB
EOF

    echo -e "${GREEN}✓${NC} Variables created"
}

################################################################################
# Create Security Audit Playbook
################################################################################
create_audit_playbook() {
    echo -e "${BLUE}Creating security audit playbook...${NC}"

    cat > "$PROJECT_DIR/audit.yml" << 'EOF'
---
- name: Security Audit - All Servers
  hosts: production
  become: yes
  gather_facts: yes

  tasks:
    - name: Check for unauthorized users (UID 0)
      shell: awk -F: '$3 == 0 {print $1}' /etc/passwd
      register: uid_zero_users
      changed_when: false

    - name: Warn if multiple UID 0 users found
      debug:
        msg: "WARNING: Multiple UID 0 users found: {{ uid_zero_users.stdout_lines }}"
      when: uid_zero_users.stdout_lines | length > 1

    - name: Check for users with empty passwords
      shell: awk -F: '($2 == "" || $2 == "!") {print $1}' /etc/shadow
      register: empty_passwords
      changed_when: false
      failed_when: false

    - name: Check SSH PermitRootLogin
      shell: grep "^PermitRootLogin" /etc/ssh/sshd_config || echo "not set"
      register: ssh_permit_root
      changed_when: false

    - name: Check SSH PasswordAuthentication
      shell: grep "^PasswordAuthentication" /etc/ssh/sshd_config || echo "not set"
      register: ssh_password_auth
      changed_when: false

    - name: Check for suspicious processes
      shell: ps aux | grep -E "nc|ncat|socat|/bin/sh -i|bash -i" | grep -v grep || echo "none"
      register: suspicious_processes
      changed_when: false

    - name: Check for modified system binaries
      shell: which debsums > /dev/null 2>&1 && debsums -c 2>&1 | head -20 || echo "debsums not installed"
      register: modified_files
      changed_when: false
      failed_when: false

    - name: Check open ports
      shell: ss -tulpn | grep LISTEN
      register: open_ports
      changed_when: false

    - name: Check firewall status
      shell: ufw status verbose 2>&1 || echo "UFW not installed"
      register: firewall_status
      changed_when: false

    - name: Check for unauthorized SSH keys
      shell: find /home /root -name authorized_keys -exec cat {} \; 2>/dev/null || echo "none"
      register: ssh_keys
      changed_when: false

    - name: Check last logins
      shell: last -20 2>/dev/null || echo "last command not available"
      register: last_logins
      changed_when: false

    - name: Check for suspicious cron jobs
      shell: cat /etc/crontab /etc/cron.d/* /var/spool/cron/crontabs/* 2>/dev/null | grep -v "^#" | grep -v "^$" || echo "none"
      register: cron_jobs
      changed_when: false
      failed_when: false

    - name: Generate audit report
      copy:
        content: |
          ═══════════════════════════════════════════════════════════════════
          SECURITY AUDIT REPORT — Operation Shadow
          Server: {{ ansible_hostname }} ({{ ansible_default_ipv4.address | default('N/A') }})
          Date: {{ ansible_date_time.iso8601 }}
          OS: {{ ansible_distribution }} {{ ansible_distribution_version }}
          ═══════════════════════════════════════════════════════════════════

          [1] UID 0 Users (should only be 'root'):
          {{ uid_zero_users.stdout }}
          {% if uid_zero_users.stdout_lines | length > 1 %}
          ⚠️  WARNING: Multiple UID 0 users detected!
          {% endif %}

          [2] Empty Password Accounts:
          {{ empty_passwords.stdout | default("None", true) }}

          [3] SSH Configuration:
          PermitRootLogin: {{ ssh_permit_root.stdout }}
          PasswordAuthentication: {{ ssh_password_auth.stdout }}

          [4] Suspicious Processes:
          {{ suspicious_processes.stdout }}

          [5] Modified System Files (first 20):
          {{ modified_files.stdout }}

          [6] Open Ports:
          {{ open_ports.stdout }}

          [7] Firewall Status:
          {{ firewall_status.stdout }}

          [8] SSH Keys:
          {{ ssh_keys.stdout | truncate(500) }}

          [9] Recent Logins (last 20):
          {{ last_logins.stdout }}

          [10] Cron Jobs:
          {{ cron_jobs.stdout | truncate(500) }}

          ═══════════════════════════════════════════════════════════════════
          Audit completed by Ansible — Episode 16
          Klaus Schmidt: "Any manual change is a red flag."
          ═══════════════════════════════════════════════════════════════════
        dest: "/tmp/audit_{{ ansible_hostname }}_{{ ansible_date_time.date }}.txt"
        mode: '0644'

    - name: Fetch audit reports to control node
      fetch:
        src: "/tmp/audit_{{ ansible_hostname }}_{{ ansible_date_time.date }}.txt"
        dest: "{{ playbook_dir }}/audit_reports/{{ ansible_hostname }}_{{ ansible_date_time.date }}.txt"
        flat: yes
      failed_when: false

- name: Create summary report
  hosts: localhost
  connection: local
  gather_facts: no

  tasks:
    - name: Consolidate audit reports
      shell: |
        mkdir -p audit_reports
        if [ -n "$(ls -A audit_reports/*.txt 2>/dev/null)" ]; then
          cat audit_reports/*.txt > audit_reports/SUMMARY_{{ lookup('pipe', 'date +%Y%m%d_%H%M%S') }}.txt
          echo "✓ Audit complete. Reports in: audit_reports/"
        else
          echo "⚠ No audit reports found (servers may not be accessible)"
        fi
      args:
        chdir: "{{ playbook_dir }}"
      register: summary
      changed_when: false

    - name: Display summary
      debug:
        msg: "{{ summary.stdout_lines }}"
EOF

    echo -e "${GREEN}✓${NC} Security audit playbook created"
}

################################################################################
# Create site.yml (main orchestration)
################################################################################
create_site_playbook() {
    echo -e "${BLUE}Creating site.yml (main orchestration)...${NC}"

    cat > "$PROJECT_DIR/site.yml" << 'EOF'
---
# Main site orchestration playbook
# Run all roles across appropriate servers

- name: Configure all servers with common setup
  hosts: production
  become: yes
  roles:
    - common

- name: Configure web servers
  hosts: web
  become: yes
  roles:
    - webserver

- name: Configure database servers
  hosts: database
  become: yes
  roles:
    - database
EOF

    echo -e "${GREEN}✓${NC} site.yml created"
}

################################################################################
# Create ansible.cfg
################################################################################
create_ansible_cfg() {
    echo -e "${BLUE}Creating ansible.cfg...${NC}"

    cat > "$PROJECT_DIR/ansible.cfg" << 'EOF'
[defaults]
inventory = inventory.ini
roles_path = roles
host_key_checking = False
retry_files_enabled = False
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 3600
callback_whitelist = profile_tasks, timer

[ssh_connection]
pipelining = True
ssh_args = -o ControlMaster=auto -o ControlPersist=60s

[colors]
highlight = white
verbose = blue
warn = bright purple
error = red
debug = dark gray
deprecate = purple
skip = cyan
unreachable = red
ok = green
changed = yellow
EOF

    echo -e "${GREEN}✓${NC} ansible.cfg created"
}

################################################################################
# Create README
################################################################################
create_readme() {
    echo -e "${BLUE}Creating README...${NC}"

    cat > "$PROJECT_DIR/README.md" << 'EOF'
# Operation Shadow — Ansible Infrastructure

**Episode 16: Infrastructure as Code**
**Klaus Schmidt:** "Configuration management is managing chaos."

## Structure

```
.
├── ansible.cfg              # Ansible configuration
├── inventory.ini            # 50 servers inventory
├── playbook.yml             # Basic configuration playbook
├── site.yml                 # Main orchestration playbook
├── audit.yml                # Security audit playbook
├── group_vars/              # Group-specific variables
│   ├── all.yml
│   ├── web.yml
│   └── database.yml
├── host_vars/               # Host-specific variables (if needed)
└── roles/                   # Reusable roles
    ├── common/              # Common configuration
    ├── webserver/           # Nginx web server
    └── database/            # PostgreSQL database

```

## Quick Start

### 1. Test inventory
```bash
ansible all -i inventory.ini --list-hosts
```

### 2. Ping all servers
```bash
ansible all -i inventory.ini -m ping
```

### 3. Run basic playbook
```bash
ansible-playbook playbook.yml --check  # Dry run
ansible-playbook playbook.yml          # Apply
```

### 4. Run site orchestration
```bash
ansible-playbook site.yml
```

### 5. Run security audit
```bash
ansible-playbook audit.yml
# Check results in: audit_reports/
```

## Commands Cheat Sheet

**Ad-hoc commands:**
```bash
# Run command on all servers
ansible all -i inventory.ini -m shell -a "uptime" -b

# Check disk space
ansible all -i inventory.ini -m shell -a "df -h /" -b

# Update packages
ansible all -i inventory.ini -m apt -a "update_cache=yes" -b
```

**Playbook execution:**
```bash
# Check mode (dry run)
ansible-playbook playbook.yml --check

# Show differences
ansible-playbook playbook.yml --check --diff

# Limit to specific hosts
ansible-playbook playbook.yml --limit web

# Run specific tags
ansible-playbook playbook.yml --tags firewall

# Verbose output
ansible-playbook playbook.yml -v
```

**Vault (secrets):**
```bash
# Create encrypted file
ansible-vault create secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Run playbook with vault
ansible-playbook playbook.yml --ask-vault-pass
```

## Results

- **50 servers** configured in **3 minutes**
- **Idempotent** — can run multiple times safely
- **Consistent** — all servers identical
- **Fast recovery** — rebuild server in 30 minutes

Klaus Schmidt: *"Manual configuration: 25 hours. Ansible: 3 minutes. That's 500× efficiency."*
EOF

    echo -e "${GREEN}✓${NC} README created"
}

################################################################################
# Generate completion report
################################################################################
generate_report() {
    echo -e "${BLUE}Generating completion report...${NC}"

    cat > "$PROJECT_DIR/ANSIBLE_SETUP_COMPLETE.txt" << EOF
═══════════════════════════════════════════════════════════════════
  KERNEL SHADOWS: Episode 16 — Ansible & IaC
  Klaus Schmidt: "Configuration management is managing chaos."
  SEASON 4 FINALE COMPLETE!
═══════════════════════════════════════════════════════════════════

PROJECT: Operation Shadow Ansible Infrastructure
DATE: $(date +"%Y-%m-%d %H:%M:%S")
LOCATION: Amsterdam → Berlin

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

COMPLETED TASKS:

✓ Ansible installed and verified
✓ Inventory file created (50 servers, 5 groups)
✓ Basic playbook created (packages, users, firewall, Docker)
✓ Roles created (common, webserver, database)
✓ Variables configured (group_vars, host_vars)
✓ Templates created (nginx.conf.j2 with Jinja2)
✓ Handlers configured (restart nginx, reload nginx)
✓ Security audit playbook created
✓ Site orchestration playbook created
✓ ansible.cfg configured
✓ Documentation created

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FILE STATISTICS:

$(cd "$PROJECT_DIR" && find . -type f -name "*.yml" -o -name "*.yaml" -o -name "*.j2" -o -name "*.ini" | wc -l) configuration files created
$(cd "$PROJECT_DIR" && find roles -type d -name tasks -o -name handlers -o -name templates | wc -l) role components
$(cd "$PROJECT_DIR" && wc -l inventory.ini | awk '{print $1}') lines in inventory

Roles:
  - common (essential packages, deploy user)
  - webserver (nginx with Jinja2 templates)
  - database (PostgreSQL setup)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NEXT STEPS:

1. Test inventory:
   cd $PROJECT_DIR
   ansible all -i inventory.ini --list-hosts

2. Run basic playbook (if servers available):
   ansible-playbook playbook.yml --check  # Dry run first
   ansible-playbook playbook.yml          # Apply

3. Run site orchestration:
   ansible-playbook site.yml

4. Run security audit:
   ansible-playbook audit.yml
   # Check results in audit_reports/

5. For local testing (without real servers):
   ansible-playbook playbook.yml -i "localhost," --connection=local

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

KLAUS SCHMIDT'S WISDOM:

"50 servers. 3 minutes. Identical configuration. Zero human error.
 That's Infrastructure as Code. That's Ansible."

"Server compromised? Rebuild in 30 minutes. Manual configuration?
 8 hours + mistakes. IaC = insurance against chaos."

"Episode 13: Git. Episode 14: Docker. Episode 15: CI/CD.
 Episode 16: Ansible. Together = Infrastructure as Code.
 Everything versioned, automated, reproducible."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SEASON 4: DEVOPS & AUTOMATION — COMPLETE! 🎉

✓ Episode 13: Git & Version Control
✓ Episode 14: Docker Basics
✓ Episode 15: CI/CD Pipelines
✓ Episode 16: Ansible & IaC

**You are now a DevOps engineer.** Infrastructure as Code flows in
your veins. 50 servers → 3 minutes. Manual → Automated. Chaos → Order.

NEXT: Season 5: Security & Pentesting (Zürich, Switzerland 🇨🇭)
      Eva Zimmerman — ex-NSA penetration tester
      "Secure your infrastructure before Krylov does."

═══════════════════════════════════════════════════════════════════
Ansible Setup Complete!
═══════════════════════════════════════════════════════════════════
EOF

    echo -e "${GREEN}✓${NC} Report generated: $PROJECT_DIR/ANSIBLE_SETUP_COMPLETE.txt"
}

################################################################################
# Main execution
################################################################################
main() {
    echo "═══════════════════════════════════════════════════════════"
    echo "  KERNEL SHADOWS: Episode 16 Solution"
    echo "  Ansible & Infrastructure as Code"
    echo "  SEASON 4 FINALE!"
    echo "═══════════════════════════════════════════════════════════"
    echo ""

    install_ansible
    create_inventory
    create_playbook
    create_roles
    create_variables
    create_audit_playbook
    create_site_playbook
    create_ansible_cfg
    create_readme
    generate_report

    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Ansible Infrastructure Setup Complete!${NC}"
    echo -e "${GREEN}  SEASON 4: DEVOPS & AUTOMATION — COMPLETE! 🎉${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Project directory: $PROJECT_DIR"
    echo "Report: $PROJECT_DIR/ANSIBLE_SETUP_COMPLETE.txt"
    echo ""
    echo "Klaus Schmidt: '50 servers, 3 minutes, one command. Chaos → Order.'"
    echo ""
    echo "Season 5 awaits: Zürich, Switzerland 🇨🇭"
    echo "Eva Zimmerman: 'Now we secure what you built.'"
}

main "$@"


