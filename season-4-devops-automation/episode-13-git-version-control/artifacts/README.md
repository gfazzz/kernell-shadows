# Episode 13: Git & Version Control — Artifacts

## 📁 Artifacts для Episode 13

Episode 13 создаёт Git repository (`~/operation-shadow-infrastructure/`) со всеми необходимыми файлами.

Artifacts этого эпизода — это **сам репозиторий**, который создаётся в процессе выполнения заданий.

---

## 🎯 Что будет создано

### 1. Git Repository Structure

После выполнения всех заданий у вас будет:

```
~/operation-shadow-infrastructure/
├── .git/                      # Git metadata (hidden)
├── .gitignore                 # Secrets protection
├── README.md                  # Main documentation
├── EPISODE13_COMPLETION.md    # Completion report
├── git_audit_report.txt       # Audit report
├── .env.example               # Secret template (safe to commit)
├── .env                       # Actual secrets (ignored)
│
├── ansible/
│   ├── README.md
│   ├── playbooks/
│   │   └── webservers.yml     # Nginx playbook
│   ├── roles/
│   └── inventory/
│
├── docker/
│   ├── README.md
│   ├── web/
│   │   ├── Dockerfile         # Nginx container
│   │   └── nginx.conf         # Custom config
│   ├── api/
│   └── database/
│
├── terraform/
│
├── scripts/
│   ├── deploy.sh              # Deployment template
│   └── git_audit.sh           # Audit script
│
└── docs/
    ├── README.md
    ├── BRANCHING_STRATEGY.md  # Git workflow
    └── SECRETS_MANAGEMENT.md  # Security guide
```

### 2. Git Branches

- `main` — production-ready
- `development` — integration branch
- `feature/episode13-git`
- `feature/episode14-docker`
- `feature/episode15-cicd`
- `feature/episode16-ansible`

### 3. Commits

Minimum 10+ commits with proper Conventional Commits format:
- `chore:` — repository setup
- `feat:` — new infrastructure files
- `docs:` — documentation
- `fix:` — corrections (if any)

---

## 🧪 Testing Your Work

### 1. Check Git Repository

```bash
cd ~/operation-shadow-infrastructure

# Verify Git is initialized
ls -la .git

# Check current branch
git branch --show-current

# View commit history
git log --oneline --graph --all

# View all branches
git branch -a
```

### 2. Verify .gitignore Works

```bash
# .env should be ignored
git status | grep .env
# Should NOT show .env (only .env.example)

# Test git check-ignore
git check-ignore -v .env
# Should output: .gitignore:2:.env    .env
```

### 3. Check Secrets Protection

```bash
# These files should exist but NOT be tracked:
ls -la .env                    # Exists in working directory
git ls-files | grep "^\.env$"  # Should be empty (not tracked)

# Template should be tracked:
git ls-files | grep .env.example  # Should show .env.example
```

### 4. Review Audit Report

```bash
cat git_audit_report.txt
```

### 5. Run Tests

```bash
cd ~/kernel-shadows/season-4-devops-automation/episode-13-git-version-control
./tests/test.sh
```

---

## 📖 Working with the Repository

### Clone (for team members)

```bash
# If repository was pushed to GitHub/GitLab
git clone git@github.com:operation-shadow/infrastructure.git
cd infrastructure

# Copy template and add secrets
cp .env.example .env
# Edit .env with real secrets
```

### Daily Workflow

```bash
# 1. Start new feature
git checkout development
git pull origin development
git checkout -b feature/my-feature

# 2. Make changes
# ... edit files ...

# 3. Commit with proper message
git add .
git commit -m "feat: add new ansible role for database"

# 4. Push feature branch
git push origin feature/my-feature

# 5. Create Pull Request (on GitHub/GitLab)
# 6. After review, merge to development
```

### Merge to Main (Production)

```bash
# When development is stable and tested:
git checkout main
git pull origin main
git merge development

# Tag release
git tag -a v1.0.0 -m "Release v1.0.0: Initial infrastructure"

# Push to remote
git push origin main --tags
```

---

## 🔒 Security Notes

### Protected Files (in .gitignore)

Never commit these files:
- `.env` — environment variables with secrets
- `*.pem`, `*.key` — private keys
- `passwords.txt`, `secrets.yml` — credential files
- `.vault_pass` — Ansible vault password
- `*.tfstate` — Terraform state (may contain secrets)

### If You Leaked a Secret

**Emergency procedure:**

```bash
# 1. Rotate the secret IMMEDIATELY in production!

# 2. Remove from Git history with BFG
bfg --delete-files secrets.txt
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 3. Force push (⚠️ rewrites history!)
git push --force --all

# 4. Notify team to re-clone
```

---

## 🎓 Learning Objectives

By working with these artifacts, you'll learn:

✅ Initialize and configure Git repositories
✅ Create effective .gitignore for infrastructure projects
✅ Use branching strategies for team collaboration
✅ Write proper commit messages (Conventional Commits)
✅ Protect secrets from accidental commits
✅ Audit repository for security issues
✅ Infrastructure as Code best practices

---

## 🚀 Next Steps

After completing Episode 13, the repository will be used in:

- **Episode 14 (Docker):** Dockerfiles and docker-compose.yml added to repository
- **Episode 15 (CI/CD):** `.github/workflows/` or `.gitlab-ci.yml` for automation
- **Episode 16 (Ansible):** Expanded `ansible/` directory with full playbooks

All infrastructure code will be versioned in Git throughout Season 4-8.

---

## 💡 Tips & Tricks

### View Beautiful Git Log

```bash
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all
```

Save as alias:
```bash
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"

# Use:
git lg
```

### Check Repository Health

```bash
# Verify repository integrity
git fsck

# Check for large objects
git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sed -n 's/^blob //p' | sort -k2 -n | tail -10

# Optimize repository
git gc --aggressive --prune=now
```

### Search Git History

```bash
# Find commits mentioning "password"
git log -S "password" --oneline

# Find who changed a file
git log --follow -- ansible/playbooks/webservers.yml

# Show changes in commit
git show <commit-hash>
```

---

## 📚 References

- [Git Official Documentation](https://git-scm.com/doc)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
- [GitHub Guides](https://guides.github.com/)
- [Pro Git Book (free)](https://git-scm.com/book/en/v2)

---

## 🎬 Scenario Context

**Hans Müller (Chaos Computer Club):**
> "This repository is your foundation. Everything else builds on this. Treat it like sacred text. Version everything. Document everything. Protect secrets. Welcome to Infrastructure as Code."

**LILITH:**
> "Git is not just version control. It's your time machine, your audit trail, your collaboration protocol. Master it, and you control your infrastructure's destiny."

---

<div align="center">

**Episode 13 Artifacts — Infrastructure as Code Foundation**

*Berlin, Germany • Chaos Computer Club • Git Mastery*

[⬆️ Back to Episode README](../README.md)

</div>


