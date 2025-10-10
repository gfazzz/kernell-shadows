#!/bin/bash

################################################################################
# KERNEL SHADOWS: Episode 13 — Git & Version Control
# Berlin, Germany (Day 25-26)
# Hans Müller, Chaos Computer Club
#
# Mission: Set up Git repository for infrastructure as code,
#          configure branching strategy, protect secrets
################################################################################

# Strict mode
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_NAME="operation-shadow-infrastructure"
REPO_PATH="$HOME/$REPO_NAME"

################################################################################
# Task 1: Initialize Git repository
################################################################################
task1_init_git() {
    echo -e "${BLUE}[Task 1]${NC} Initializing Git repository..."

    # TODO: Create directory for infrastructure
    # Hint: mkdir -p "$REPO_PATH"

    # TODO: Navigate to directory
    # Hint: cd "$REPO_PATH"

    # TODO: Initialize Git repository
    # Hint: git init

    # TODO: Configure Git user (if not configured globally)
    # Hint: git config user.name "Max Sokolov"
    # Hint: git config user.email "max@operation-shadow.net"

    echo -e "${GREEN}✓${NC} Git repository initialized at $REPO_PATH"
}

################################################################################
# Task 2: Create directory structure
################################################################################
task2_create_structure() {
    echo -e "${BLUE}[Task 2]${NC} Creating directory structure..."

    cd "$REPO_PATH" || exit 1

    # TODO: Create ansible directories
    # Hint: mkdir -p ansible/{playbooks,roles,inventory}

    # TODO: Create docker directories
    # Hint: mkdir -p docker/{web,api,database}

    # TODO: Create other directories
    # Hint: mkdir -p terraform scripts docs

    # TODO: Create README files
    # Hint: echo "# Operation Shadow Infrastructure" > README.md
    # Hint: echo "# Ansible Playbooks" > ansible/README.md
    # Hint: echo "# Docker Containers" > docker/README.md
    # Hint: echo "# Documentation" > docs/README.md

    # TODO: Commit structure
    # Hint: git add .
    # Hint: git commit -m "chore: initialize infrastructure directory structure"

    echo -e "${GREEN}✓${NC} Directory structure created"
}

################################################################################
# Task 3: Create .gitignore
################################################################################
task3_create_gitignore() {
    echo -e "${BLUE}[Task 3]${NC} Creating .gitignore..."

    cd "$REPO_PATH" || exit 1

    # TODO: Create .gitignore with secrets patterns
    # Hint: See README.md Task 3 for complete .gitignore
    # Must include:
    # - .env, *.pem, *.key (secrets)
    # - *.log, logs/ (logs)
    # - .DS_Store, Thumbs.db (OS files)
    # - *.tmp, *.swp, *~ (temporary files)
    # - Ansible, Terraform specific patterns

    cat > .gitignore << 'EOF'
# Secrets (NEVER commit!)
.env
.env.local
.env.production
*.pem
*.key
*_rsa
*_rsa.pub
passwords.txt
secrets.yml
credentials.json
vault_password.txt

# Ansible
*.retry
.vault_pass

# Terraform
*.tfstate
*.tfstate.backup
.terraform/
terraform.tfvars

# Logs
*.log
logs/

# OS files
.DS_Store
Thumbs.db

# Temporary
*.tmp
*.swp
*~
.cache/
EOF

    # TODO: Commit .gitignore
    # Hint: git add .gitignore
    # Hint: git commit -m "chore: add .gitignore for secrets and temp files"

    echo -e "${GREEN}✓${NC} .gitignore created"
}

################################################################################
# Task 4: Branching strategy
################################################################################
task4_branching_strategy() {
    echo -e "${BLUE}[Task 4]${NC} Setting up branching strategy..."

    cd "$REPO_PATH" || exit 1

    # TODO: Create development branch
    # Hint: git checkout -b development

    # TODO: Switch back to main
    # Hint: git checkout main

    # TODO: Create feature branches (but don't switch to them)
    # Hint: git branch feature/episode13-git
    # Hint: git branch feature/episode14-docker
    # Hint: git branch feature/episode15-cicd
    # Hint: git branch feature/episode16-ansible

    # TODO: Create BRANCHING_STRATEGY.md documentation
    cat > docs/BRANCHING_STRATEGY.md << 'EOF'
# Branching Strategy for Operation Shadow

## Branches

- **main** — production-ready infrastructure
- **development** — integration branch for testing
- **feature/episodeXX-name** — feature branches (short-lived)
- **hotfix/description** — urgent fixes

## Workflow

1. Create feature branch from `development`:
   ```
   git checkout development
   git checkout -b feature/new-feature
   ```

2. Make changes and commit:
   ```
   git add .
   git commit -m "feat: add new feature"
   ```

3. Merge to development:
   ```
   git checkout development
   git merge feature/new-feature
   ```

4. When ready for production, merge development → main:
   ```
   git checkout main
   git merge development
   ```

## Commit Message Convention

Use **Conventional Commits**:
- `feat:` — new feature
- `fix:` — bug fix
- `docs:` — documentation
- `chore:` — maintenance

Example: `feat: add ansible playbook for nginx`
EOF

    # TODO: Commit branching docs
    # Hint: git add docs/BRANCHING_STRATEGY.md
    # Hint: git commit -m "docs: add branching strategy documentation"

    echo -e "${GREEN}✓${NC} Branching strategy configured"
}

################################################################################
# Task 5: Proper commit messages
################################################################################
task5_proper_commits() {
    echo -e "${BLUE}[Task 5]${NC} Creating sample files with proper commits..."

    cd "$REPO_PATH" || exit 1

    # TODO: Create ansible playbook
    cat > ansible/playbooks/webservers.yml << 'EOF'
---
- hosts: webservers
  become: yes
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present

    - name: Start nginx
      systemd:
        name: nginx
        state: started
        enabled: yes
EOF

    # TODO: Commit with proper message (Conventional Commits)
    # Hint: git add ansible/playbooks/webservers.yml
    # Hint: git commit -m "feat: add ansible playbook for nginx webservers"

    # TODO: Create Dockerfile
    cat > docker/web/Dockerfile << 'EOF'
FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

    # TODO: Commit Dockerfile
    # Hint: git add docker/web/Dockerfile
    # Hint: git commit -m "feat: add nginx Dockerfile for web containers"

    echo -e "${GREEN}✓${NC} Sample files created with proper commits"
}

################################################################################
# Task 6: Simulate merge conflict (Advanced)
################################################################################
task6_merge_conflict() {
    echo -e "${BLUE}[Task 6]${NC} Simulating merge conflict..."

    cd "$REPO_PATH" || exit 1

    # TODO: See README.md Task 6 for complete merge conflict simulation
    # This is an advanced task - recommend reading the guide first

    echo -e "${YELLOW}⚠${NC}  Merge conflict task: See README.md Task 6"
    echo -e "    This requires manual intervention for educational purposes"
}

################################################################################
# Task 7: Secrets management
################################################################################
task7_secrets_management() {
    echo -e "${BLUE}[Task 7]${NC} Setting up secrets management..."

    cd "$REPO_PATH" || exit 1

    # TODO: Create .env.example (template — safe to commit)
    cat > .env.example << 'EOF'
# Database credentials
DB_HOST=localhost
DB_PORT=5432
DB_NAME=operation_shadow
DB_USER=your_username_here
DB_PASSWORD=your_password_here

# API keys
GITHUB_TOKEN=your_github_token_here
AWS_ACCESS_KEY=your_aws_key_here
EOF

    # TODO: Create actual .env with fake secrets (will be ignored by .gitignore)
    cat > .env << 'EOF'
DB_HOST=10.20.30.40
DB_PORT=5432
DB_NAME=operation_shadow
DB_USER=max_sokolov
DB_PASSWORD=SuperSecret123!

GITHUB_TOKEN=ghp_abc123def456
AWS_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE
EOF

    # TODO: Verify .env is ignored
    # Hint: git status should NOT show .env

    # TODO: Commit .env.example
    # Hint: git add .env.example
    # Hint: git commit -m "chore: add .env.example template for secrets"

    # TODO: Create SECRETS_MANAGEMENT.md documentation
    cat > docs/SECRETS_MANAGEMENT.md << 'EOF'
# Secrets Management

## ⚠️ NEVER commit secrets to Git!

### Files that MUST be in .gitignore:
- `.env`
- `*.pem`, `*.key`
- `passwords.txt`
- `credentials.json`

### Safe practices:

1. **Use .env files:**
   - Commit `.env.example` (template)
   - Actual `.env` in `.gitignore`

2. **For production:**
   - Use HashiCorp Vault
   - Use GitHub Secrets (for CI/CD)
   - Use AWS Secrets Manager

3. **If leaked:**
   - Rotate secret immediately!
   - Remove from Git history (see docs)

## Current secrets locations:
- Database credentials: `.env` (local only)
- SSH keys: `~/.ssh/` (NOT in repo)
- Ansible vault: `ansible/.vault_pass` (in .gitignore)
EOF

    # TODO: Commit secrets documentation
    # Hint: git add docs/SECRETS_MANAGEMENT.md
    # Hint: git commit -m "docs: add secrets management guidelines"

    echo -e "${GREEN}✓${NC} Secrets management configured"
}

################################################################################
# Task 8: INCIDENT — Leaked secret simulation (Optional/Advanced)
################################################################################
task8_leaked_secret() {
    echo -e "${YELLOW}[Task 8 — INCIDENT]${NC} Leaked secret handling..."

    echo -e "${YELLOW}⚠${NC}  This is an advanced incident response task"
    echo -e "    See README.md Task 8 for complete guide"
    echo -e "    Requires: git filter-branch or BFG Repo-Cleaner"

    # This task is intentionally left for manual execution
    # to avoid accidental repository corruption
}

################################################################################
# Task 9: Generate Git audit report
################################################################################
task9_audit_report() {
    echo -e "${BLUE}[Task 9]${NC} Generating Git audit report..."

    cd "$REPO_PATH" || exit 1

    # TODO: Create audit script
    cat > scripts/git_audit.sh << 'EOF'
#!/bin/bash

# Git Audit Report Generator
# For Operation Shadow Infrastructure Repository

REPORT="git_audit_report.txt"

echo "========================================" > "$REPORT"
echo "   GIT AUDIT REPORT" >> "$REPORT"
echo "   Operation Shadow Infrastructure" >> "$REPORT"
echo "   Generated: $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT"
echo "========================================" >> "$REPORT"
echo "" >> "$REPORT"

# Repository info
echo "## REPOSITORY INFORMATION" >> "$REPORT"
echo "Repository: $(basename $(git rev-parse --show-toplevel))" >> "$REPORT"
echo "Current branch: $(git branch --show-current)" >> "$REPORT"
echo "Total commits: $(git rev-list --count HEAD 2>/dev/null || echo '0')" >> "$REPORT"
echo "Total branches: $(git branch | wc -l)" >> "$REPORT"
echo "" >> "$REPORT"

# Recent commits
echo "## RECENT COMMITS (last 10)" >> "$REPORT"
git log --oneline -10 >> "$REPORT" 2>/dev/null || echo "No commits yet" >> "$REPORT"
echo "" >> "$REPORT"

# Branches
echo "## BRANCHES" >> "$REPORT"
git branch -a >> "$REPORT"
echo "" >> "$REPORT"

# Contributors
echo "## CONTRIBUTORS" >> "$REPORT"
git log --format='%an' | sort | uniq -c | sort -rn >> "$REPORT" 2>/dev/null || echo "No commits yet" >> "$REPORT"
echo "" >> "$REPORT"

# Security check
echo "## SECURITY AUDIT" >> "$REPORT"
if [ -f .gitignore ]; then
    echo "✅ .gitignore exists ($(wc -l < .gitignore) lines)" >> "$REPORT"
else
    echo "❌ ERROR: .gitignore NOT FOUND!" >> "$REPORT"
fi

# Check for potential secrets
if git log --all -S "password" --oneline 2>/dev/null | head -1 | grep -q .; then
    echo "⚠️ WARNING: Found 'password' in commit history!" >> "$REPORT"
else
    echo "✅ No 'password' found in commit messages" >> "$REPORT"
fi

echo "" >> "$REPORT"

# Repository size
echo "## REPOSITORY SIZE" >> "$REPORT"
echo "Total size: $(du -sh .git 2>/dev/null | cut -f1 || echo 'N/A')" >> "$REPORT"
echo "" >> "$REPORT"

echo "========================================" >> "$REPORT"
echo "   END OF AUDIT REPORT" >> "$REPORT"
echo "========================================" >> "$REPORT"

echo "✅ Audit report generated: $REPORT"
EOF

    # TODO: Make script executable
    # Hint: chmod +x scripts/git_audit.sh

    # TODO: Run audit script
    # Hint: ./scripts/git_audit.sh

    # TODO: Commit audit script
    # Hint: git add scripts/git_audit.sh
    # Hint: git commit -m "feat: add git audit report generator"

    echo -e "${GREEN}✓${NC} Git audit report generated"
}

################################################################################
# Main execution
################################################################################
main() {
    echo ""
    echo "================================================================"
    echo "  KERNEL SHADOWS: Episode 13 — Git & Version Control"
    echo "  Berlin, Germany (Chaos Computer Club)"
    echo "  Hans Müller: 'Code is law. Version control is constitution.'"
    echo "================================================================"
    echo ""

    echo -e "${YELLOW}NOTE:${NC} This starter script provides templates."
    echo -e "      Uncomment TODO sections and implement tasks."
    echo -e "      See README.md for detailed instructions."
    echo ""

    # Uncomment tasks as you complete them
    task1_init_git
    task2_create_structure
    task3_create_gitignore
    task4_branching_strategy
    task5_proper_commits
    # task6_merge_conflict  # Advanced: manual task
    task7_secrets_management
    # task8_leaked_secret   # Advanced: manual task
    task9_audit_report

    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Episode 13 starter tasks completed!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Repository location: $REPO_PATH"
    echo ""
    echo "Next steps:"
    echo "  1. cd $REPO_PATH"
    echo "  2. git log --oneline --graph --all  # View history"
    echo "  3. Read git_audit_report.txt        # Review audit"
    echo "  4. Complete advanced tasks 6 & 8    # Merge conflicts, leaked secrets"
    echo ""
    echo "Run tests:"
    echo "  cd ~/kernel-shadows/season-4-devops-automation/episode-13-git-version-control"
    echo "  ./tests/test.sh"
    echo ""
}

# Run main function
main "$@"


