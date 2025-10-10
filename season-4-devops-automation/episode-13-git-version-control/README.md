# EPISODE 13: GIT & VERSION CONTROL 📦🇩🇪

> **"Code is law. Version control is constitution. Without Git, you have anarchy."**
> — Hans Müller, Chaos Computer Club

---

## 📍 Контекст операции

**День:** 25-26 из 60
**Локация:** 🇩🇪 Берлин, Германия (Chaos Computer Club, hackerspace)
**Время:** 4-5 часов
**Сложность:** ⭐⭐⭐☆☆

**Предыдущий эпизод:** [Episode 12: Backup & Recovery](../../season-3-system-administration/episode-12-backup-recovery/README.md) (Tallinn, Estonia)
**Следующий эпизод:** Episode 14: Docker Basics (Amsterdam, Netherlands)

---

## 🎬 Сюжет

### Переход Season 3 → Season 4

**Viktor (видеозвонок, конец Episode 12):**
> *"Max, ты справился с системным администрированием. Backup спас операцию. Но теперь — масштаб. У нас 50 серверов. Через месяц будет 100. Управлять конфигами вручную невозможно. Нужна автоматизация. DevOps. Летишь в Берлин. Dmitry встретит."*

**Dmitry Orlov (звонок на следующий день):**
> *"Макс, привет. Я Dmitry, DevOps-инженер команды. Я последние 2 недели настраивал Docker, Ansible, CI/CD, но мне нужна помощь. В Берлине есть Hans Müller — один из лучших DevOps в Европе, участник CCC. Он научит нас infrastructure as code. Начнём с Git."*

### День 25: Прилёт в Берлин

**15:00 — Tegel Airport**

Max выходит из терминала. Берлин — индустриальный, холодный, graffiti на стенах, но энергичный.

Dmitry Orlov (30 лет, русский акцент, backpack с наклейками Docker/Kubernetes/Ansible) встречает у выхода.

**Dmitry:**
> *"Max? Добро пожаловать в Берлин. Chaos Computer Club через час. Hans ждёт. Поехали. О, и кстати — Hans педантичен. Если увидит что мы не используем Git для конфигов, будет лекция на 2 часа. Предупреждён — значит вооружён."*

**17:00 — Chaos Computer Club (CCC)**

Хакерспейс в индустриальном здании. Серверы, множество мониторов, механические клавиатуры, Open Source постеры, анархистская эстетика встречает немецкую точность.

Hans Müller (35 лет, CCC hoodie, серьёзный) печатает код. На экране — Git commit message:

```
feat: add infrastructure automation for operation shadow

- ansible playbooks for server provisioning
- docker-compose for microservices
- CI/CD pipeline for automated deployment

Signed-off-by: Hans Müller <hans@ccc.de>
```

**Hans (не отрываясь от экрана):**
> *"Ты, должно быть, Max. Viktor много рассказывал о тебе."*

(оборачивается)

> *"Но Viktor также сказал, что ты управляешь конфигами 50 серверов **без version control**. Это... проблематично. Нет, это преступление."*

**Max (защищается):**
> *"Я знаю что я делаю. У меня backup'ы. Я помню все изменения."*

**Hans:**
> *"Сейчас помнишь. А через месяц? После 1000 изменений? Память ненадёжна. Люди ненадёжны. **Git надёжен**."*

(поворачивается к доске, рисует схему)

```
Git → Docker → CI/CD → Ansible → Kubernetes
 ↑
 └── Everything starts here
```

> *"Infrastructure as Code. Version control для всего: конфигов, скриптов, документации. If it's not in Git, it doesn't exist. Welcome to DevOps. Let's begin."*

### ИНЦИДЕНТ (происходит в середине Episode)

**21:30 — Emergency звонок от Anna**

**Anna (паника в голосе):**
> *"Max! EMERGENCY! Кто-то из команды закоммитил **пароль от production сервера** в Git repository! Public repository! GitHub! Полчаса назад! Krylov уже знает! У нас 10 минут до атаки!"*

**Hans (мгновенно серьёзный):**
> *"Scheisse. Классическая ошибка. Git никогда не забывает. Даже если удалишь commit, он останется в истории. Нужен git filter-branch. НЕМЕДЛЕННО."*

**Задача:**
- Найти leaked secret в Git history
- Удалить из истории (git filter-branch или BFG Repo-Cleaner)
- Force push (осторожно!)
- Ротация паролей (немедленно!)
- Audit: кто закоммитил? когда? почему не было .gitignore?

**Resolution:**
- 5 минут: Git history cleaned
- 3 минуты: Password rotated
- 2 минуты: Anna блокирует попытку Krylov (IP 185.220.101.52, Tor node)

**Hans (после):**
> *"Вот почему у нас есть `.gitignore`. Вот почему мы НИКОГДА не коммитим secrets. Git мощный. Но сила требует ответственности. Усвоили урок?"*

**Max:**
> *"Жёсткий урок. Но усвоен."*

**LILITH:**
> *"Secrets в Git — как заряженный пистолет в детской комнате. Не делайте так. Никогда."*

### Финал Episode 13

**23:00 — Debriefing**

**Viktor (видеозвонок):**
> *"Crisis averted. Password rotated. No breach. Good work. Hans, thank you."*

**Hans:**
> *"Не проблема. Но Max, Dmitry — вам нужно изучить **весь pipeline**. Git — это фундамент. Дальше: Docker (Sophie в Амстердаме), потом CI/CD (я помогу удалённо), затем Ansible (Klaus). Четыре эпизода. Две недели. Готовы?"*

**Max:**
> *"Готовы. Автоматизируем всё."*

**Dmitry:**
> *"Welcome to DevOps, Max. Automation или смерть на масштабе."*

**Cliffhanger:**

**Alex (текстовое сообщение):**
> *"Макс. Krylov пытался атаковать через leaked password. Но это была **отвлекающая атака**. Что-то большее готовится. Supply chain attack. Будь осторожен в Амстердаме. Docker images — легко компрометировать. — A."*

---

## 🎯 Миссия Episode 13

**Основная задача:** Организовать Git repository для конфигов операции, настроить branching strategy, научиться защищать secrets.

**Конкретные задания:**

1. ✅ **Инициализировать Git репозиторий** для конфигов операции
2. ✅ **Создать структуру папок** (configs/, scripts/, docs/, ansible/, docker/)
3. ✅ **Настроить .gitignore** (secrets, logs, temporary files)
4. ✅ **Branching strategy** (main, development, feature branches)
5. ✅ **Commit с правильными сообщениями** (conventional commits)
6. ✅ **Simulate merge conflict** и разрешение
7. ✅ **Secrets management** (git-crypt, .env.example, HashiCorp Vault integration)
8. ✅ **Audit leaked secret** (найти, удалить из истории, ротировать пароль)
9. ✅ **Generate Git audit report** (commits, branches, security)

**Финальный артефакт:**
- Чистый Git repository
- `.gitignore` со всеми правилами
- Branching strategy документирована
- Secrets защищены
- Audit report сгенерирован

---

## 📚 Теория: Git & Version Control

### Зачем нужен Git?

**Проблемы без версионирования:**
- ❌ Потеря истории изменений ("Кто это сломал? Когда?")
- ❌ Невозможность отката ("Раньше работало, что изменилось?")
- ❌ Конфликты при совместной работе ("Я правил config, ты правил config, чья версия правильная?")
- ❌ Нет резервного копирования (если сервер умер, конфиги потеряны)
- ❌ Нет audit trail (compliance, security)

**С Git:**
- ✅ Полная история ("git log" показывает кто, когда, что изменил)
- ✅ Простой откат ("git revert", "git reset")
- ✅ Совместная работа ("git branch", "git merge", разрешение конфликтов)
- ✅ Распределённое резервное копирование (каждый clone = полная копия истории)
- ✅ Audit trail (commits подписываются, GPG signatures)

### Git basics

<details>
<summary><strong>📖 1. Repository & initialization</strong></summary>

**Repository** — это папка + скрытая папка `.git` с историей всех изменений.

```bash
# Инициализировать новый репозиторий
git init

# Или клонировать существующий
git clone https://github.com/user/repo.git

# Проверить статус
git status
```

**Три зоны Git:**
1. **Working Directory** — твои файлы (редактируешь здесь)
2. **Staging Area (Index)** — подготовка к commit (`git add`)
3. **Repository (.git)** — история commits (`git commit`)

```
Working Directory  →  Staging Area  →  Repository
     (edit)         git add             git commit
                                            ↓
                                       git push → Remote
```

</details>

<details>
<summary><strong>📖 2. Basic commands</strong></summary>

```bash
# 1. Добавить файлы в Staging Area
git add file.txt           # Один файл
git add configs/           # Вся папка
git add .                  # Всё (осторожно! используй .gitignore)

# 2. Commit (сохранить snapshot)
git commit -m "Add server configs"

# Лучше: multi-line commit message
git commit
# Откроется редактор:
# Subject line (50 chars max): Add server configs for operation
#
# Body (wrap at 72 chars):
# - Added nginx.conf for web servers
# - Added postgresql.conf for database
# - Configured firewall rules

# 3. Проверить историю
git log                    # Полная история
git log --oneline          # Краткая (1 commit = 1 line)
git log --graph --all      # Визуализация branches

# 4. Проверить изменения
git diff                   # Working Directory vs Staging
git diff --staged          # Staging vs последний commit
git diff HEAD~1            # Текущая vs предыдущая версия

# 5. Отменить изменения
git checkout -- file.txt   # Отменить изменения в файле (Working Dir)
git reset file.txt         # Убрать из Staging (но изменения остаются)
git reset --hard HEAD      # ОПАСНО: отменить все изменения (необратимо)
```

**Best practice: Commit messages**

❌ Плохо:
```
git commit -m "fix"
git commit -m "update config"
git commit -m "stuff"
```

✅ Хорошо (Conventional Commits):
```
git commit -m "feat: add nginx load balancing config"
git commit -m "fix: correct firewall rule for port 8080"
git commit -m "docs: update README with deployment instructions"
git commit -m "refactor: simplify ansible playbook structure"
```

**Format:**
```
<type>: <subject>

<body (optional)>

<footer (optional)>
```

**Types:**
- `feat`: new feature
- `fix`: bug fix
- `docs`: documentation
- `style`: formatting (не меняет код)
- `refactor`: code refactoring
- `test`: adding tests
- `chore`: maintenance

</details>

<details>
<summary><strong>📖 3. Branches</strong></summary>

**Branch** — это независимая линия разработки.

**Зачем branches?**
- Параллельная разработка features
- Изоляция экспериментов
- Code review перед merge в main
- Откат без затрагивания main branch

```bash
# Посмотреть branches
git branch                 # Локальные
git branch -a              # Все (включая remote)

# Создать branch
git branch feature-ansible
git checkout feature-ansible    # Переключиться на branch

# Или короче (create + switch):
git checkout -b feature-ansible

# Работать в branch:
# ... edit files ...
git add .
git commit -m "feat: add ansible playbook"

# Переключиться обратно на main
git checkout main

# Merge branch в main
git merge feature-ansible

# Удалить branch (после merge)
git branch -d feature-ansible
```

**Branching strategies:**

**1. Feature Branch Workflow:**
```
main (production-ready)
 ├── feature-docker (Max работает)
 ├── feature-ansible (Dmitry работает)
 └── hotfix-password-leak (urgent fix)
```

**2. GitFlow:**
```
main (production releases)
 └── develop (integration branch)
      ├── feature/docker
      ├── feature/ansible
      └── release/1.0
```

**3. Trunk-Based Development:**
```
main (single branch, short-lived feature branches)
 ├── feature (< 2 days, quick merge)
 └── feature2 (< 2 days, quick merge)
```

**Для KERNEL SHADOWS операции:**
- `main` — production configs
- `development` — testing configs
- `feature/episodeXX` — новые features
- `hotfix/security` — urgent fixes

</details>

<details>
<summary><strong>📖 4. Merge conflicts</strong></summary>

**Merge conflict** — когда два branches изменили одну и ту же строку файла.

**Пример:**

**Branch A:**
```nginx
server {
    listen 80;           # Changed by Max
}
```

**Branch B:**
```nginx
server {
    listen 8080;         # Changed by Dmitry
}
```

**Git merge result:**
```nginx
server {
<<<<<<< HEAD
    listen 80;           # Your version (Max)
=======
    listen 8080;         # Their version (Dmitry)
>>>>>>> feature-branch
}
```

**Разрешение:**
```bash
# 1. Открыть файл, manually resolve:
server {
    listen 80;           # Выбрали версию Max (или 8080, или обе)
}

# 2. Удалить markers (<<<<<<<, =======, >>>>>>>)

# 3. Commit resolution:
git add file
git commit -m "fix: resolve merge conflict (chose port 80)"
```

**Инструменты для разрешения конфликтов:**
- `git mergetool` — визуальный diff
- VS Code, IntelliJ — встроенные редакторы слияния
- `vimdiff`, `meld` — консольные инструменты

</details>

<details>
<summary><strong>📖 5. .gitignore</strong></summary>

**`.gitignore`** — файл, который говорит Git **игнорировать** определённые файлы.

**Зачем?**
- ❌ Не коммитить secrets (.env, passwords, keys)
- ❌ Не коммитить временные файлы (логи, кеш, артефакты сборки)
- ❌ Не коммитить OS junk (.DS_Store, Thumbs.db)

**Пример `.gitignore` для infrastructure:**

```gitignore
# Secrets (НИКОГДА НЕ КОММИТИТЬ!)
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

# Ansible
*.retry
.vault_pass
.vault_password

# Terraform
*.tfstate
*.tfstate.backup
.terraform/

# Logs
*.log
logs/
*.log.*

# OS files
.DS_Store
Thumbs.db
desktop.ini

# Temporary files
*.tmp
*.swp
*.swo
*~
.cache/

# Backup files
*.bak
*.backup
*.old

# IDE
.vscode/
.idea/
*.sublime-*
```

**Best practices:**
1. Create `.gitignore` **первым делом** при `git init`
2. Use templates: https://github.com/github/gitignore
3. Never commit secrets (даже на 1 секунду!)
4. If leaked: `git filter-branch` to remove from history

</details>

<details>
<summary><strong>📖 6. Remote repositories</strong></summary>

**Remote** — это Git repository на другом сервере (GitHub, GitLab, Bitbucket, self-hosted).

```bash
# Добавить remote
git remote add origin https://github.com/user/repo.git

# Проверить remotes
git remote -v

# Push (отправить commits на remote)
git push origin main

# Pull (получить commits с remote)
git pull origin main

# Fetch (получить commits, но не merge)
git fetch origin
git merge origin/main
```

**GitHub/GitLab workflow:**
```
Local repo  →  git push  →  GitHub/GitLab  →  git pull  →  Other team members
```

**SSH vs HTTPS:**

**HTTPS:**
```bash
git clone https://github.com/user/repo.git
# Требует username/password (или token)
```

**SSH (recommended):**
```bash
git clone git@github.com:user/repo.git
# Требует SSH key (более безопасно)

# Setup SSH key:
ssh-keygen -t ed25519 -C "max@operation-shadow.net"
cat ~/.ssh/id_ed25519.pub   # Copy to GitHub/GitLab
```

</details>

<details>
<summary><strong>📖 7. Secrets management</strong></summary>

**Проблема:** Как хранить secrets (пароли, API keys) если Git repository public?

**Solutions:**

**1. `.env` files + `.gitignore` (простое):**
```bash
# Commit .env.example (template) — OK
echo "DB_PASSWORD=your_password_here" > .env.example
git add .env.example

# Actual .env — в .gitignore (NOT committed)
echo "DB_PASSWORD=SuperSecret123!" > .env
echo ".env" >> .gitignore
git add .gitignore
```

**2. git-crypt (encryption):**
```bash
# Encrypt files in repo
sudo apt install git-crypt
git-crypt init
git-crypt add-gpg-user max@operation-shadow.net

# .gitattributes:
secrets.yml filter=git-crypt diff=git-crypt
*.key filter=git-crypt diff=git-crypt

git add .gitattributes secrets.yml
git commit -m "Add encrypted secrets"
```

**3. HashiCorp Vault (production):**
```bash
# Store secrets in Vault, reference in code
DB_PASSWORD=$(vault kv get -field=password secret/database)
```

**4. Environment variables (CI/CD):**
```yaml
# GitHub Actions secrets
- name: Deploy
  env:
    DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
```

**If leaked:**
```bash
# 1. Rotate secret immediately (change password!)
# 2. Remove from Git history:
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch secrets.txt" \
  --prune-empty --tag-name-filter cat -- --all

# Or use BFG Repo-Cleaner (faster):
bfg --delete-files secrets.txt
git push --force --all
```

</details>

<details>
<summary><strong>📖 8. Git for Infrastructure as Code</strong></summary>

**Infrastructure as Code (IaC):**
- Серверы описываются кодом (Ansible, Terraform)
- Конфиги версионируются в Git
- Changes через Git workflow (branch → review → merge)
- Rollback = git revert

**Структура репозитория:**
```
operation-shadow-infrastructure/
├── ansible/
│   ├── playbooks/
│   │   ├── webservers.yml
│   │   ├── databases.yml
│   │   └── monitoring.yml
│   ├── roles/
│   │   ├── nginx/
│   │   ├── postgresql/
│   │   └── prometheus/
│   └── inventory/
│       ├── production
│       ├── staging
│       └── development
├── docker/
│   ├── web/
│   │   ├── Dockerfile
│   │   └── docker-compose.yml
│   └── api/
│       ├── Dockerfile
│       └── docker-compose.yml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── scripts/
│   ├── deploy.sh
│   ├── backup.sh
│   └── monitor.sh
├── docs/
│   ├── README.md
│   ├── DEPLOYMENT.md
│   └── TROUBLESHOOTING.md
├── .gitignore
├── .gitlab-ci.yml        # CI/CD pipeline
└── README.md
```

**Workflow:**
```
1. Developer creates branch: git checkout -b feature-ansible
2. Makes changes: edit ansible/playbooks/webservers.yml
3. Commits: git commit -m "feat: add nginx load balancing"
4. Pushes: git push origin feature-ansible
5. Creates Pull Request/Merge Request
6. Code review by team
7. CI/CD runs tests
8. Merge to main
9. Automated deployment to production
```

**Benefits:**
- ✅ Version control для всей инфраструктуры
- ✅ Процесс code review
- ✅ Audit trail (кто что изменил)
- ✅ Простой откат (git revert)
- ✅ Совместная работа (несколько инженеров)
- ✅ Интеграция с CI/CD

</details>

---

## 💻 Практика: 9 заданий

### Задание 1: Initialize Git repository

**Миссия:** Создать Git repository для конфигов операции.

**Задача:**
```bash
# 1. Создать папку для infrastructure
mkdir -p ~/operation-shadow-infrastructure
cd ~/operation-shadow-infrastructure

# 2. Инициализировать Git
git init

# 3. Configure Git (если еще не настроен)
git config user.name "Max Sokolov"
git config user.email "max@operation-shadow.net"

# 4. Проверить статус
git status
```

**Expected output:**
```
Initialized empty Git repository in .git/
On branch main
No commits yet
```

<details>
<summary>💡 Hint 1: Git configuration (если застряли > 5 минут)</summary>

Git нужно знать кто ты (для информации об авторе коммита).

```bash
# Глобально (для всех репозиториев):
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Или только для этого репозитория:
git config user.name "Max Sokolov"
git config user.email "max@operation-shadow.net"
```

Проверить:
```bash
git config user.name
git config user.email
```

</details>

<details>
<summary>💡 Hint 2: Common issues (если застряли > 10 минут)</summary>

**Problem:** "fatal: not a git repository"
**Solution:** Убедись что выполнил `git init` в правильной папке.

**Problem:** "Author identity unknown"
**Solution:** Настрой `git config user.name` и `user.email`.

**Problem:** `.git` папка не видна
**Solution:** Это нормально! `.git` скрытая. Проверить: `ls -la | grep .git`

</details>

<details>
<summary>✅ Solution (если застряли > 15 минут)</summary>

```bash
#!/bin/bash

# Create directory structure
mkdir -p ~/operation-shadow-infrastructure
cd ~/operation-shadow-infrastructure

# Initialize Git repository
git init

# Configure Git (if not configured globally)
git config user.name "Max Sokolov"
git config user.email "max@operation-shadow.net"

# Verify
echo "Git initialized!"
git status
```

**Explanation:**
- `git init` создаёт скрытую папку `.git` с метаданными
- `git config` настраивает информацию об авторе для коммитов
- `git status` показывает текущее состояние репозитория

</details>

---

### Задание 2: Create directory structure

**Миссия:** Создать организованную структуру папок для infrastructure code.

**Задача:**
```bash
# В ~/operation-shadow-infrastructure/ создать:
mkdir -p ansible/{playbooks,roles,inventory}
mkdir -p docker/{web,api,database}
mkdir -p terraform
mkdir -p scripts
mkdir -p docs

# Создать README файлы
echo "# Operation Shadow Infrastructure" > README.md
echo "# Documentation" > docs/README.md
echo "# Ansible Playbooks" > ansible/README.md
echo "# Docker Containers" > docker/README.md

# Проверить структуру
tree -L 2  # или ls -R если tree нет
```

**Expected structure:**
```
operation-shadow-infrastructure/
├── ansible/
│   ├── playbooks/
│   ├── roles/
│   ├── inventory/
│   └── README.md
├── docker/
│   ├── web/
│   ├── api/
│   ├── database/
│   └── README.md
├── terraform/
├── scripts/
├── docs/
│   └── README.md
└── README.md
```

<details>
<summary>💡 Hint: Commit structure</summary>

После создания структуры — commit!

```bash
git add .
git commit -m "chore: initialize infrastructure directory structure"
git log --oneline
```

</details>

---

### Задание 3: Create .gitignore

**Миссия:** Защитить репозиторий от случайного коммита секретов и временных файлов.

**Задача:**
```bash
# Создать .gitignore в корне repo
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

# Commit .gitignore
git add .gitignore
git commit -m "chore: add .gitignore for secrets and temp files"
```

**Test:**
```bash
# Try to create a secret file
echo "PASSWORD=SuperSecret123" > .env
git status   # Should show ".env" as untracked BUT ignored

# Verify .env is ignored
git add .env   # Should fail or warn: "The following paths are ignored by one of your .gitignore files"
```

<details>
<summary>💡 Hint: .gitignore patterns</summary>

**Patterns:**
- `*.log` — все файлы, заканчивающиеся на .log
- `logs/` — вся папка logs/
- `!important.log` — exception (do NOT ignore important.log)
- `**/secrets.txt` — secrets.txt в любой папке (recursive)

**Check if file is ignored:**
```bash
git check-ignore -v .env
# Output: .gitignore:2:.env    .env
```

</details>

---

### Задание 4: Branching strategy

**Миссия:** Настроить branching strategy для команды (Max, Dmitry, Alex, Anna).

**Задача:**
```bash
# 1. Create development branch
git checkout -b development

# 2. Create feature branches
git checkout -b feature/episode13-git
git checkout -b feature/episode14-docker
git checkout -b feature/episode15-cicd
git checkout -b feature/episode16-ansible

# 3. Switch back to main
git checkout main

# 4. List all branches
git branch -a

# 5. Create BRANCHING_STRATEGY.md documentation
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

# Commit branching docs
git add docs/BRANCHING_STRATEGY.md
git commit -m "docs: add branching strategy documentation"
```

<details>
<summary>💡 Hint: Branch naming</summary>

**Good branch names:**
- `feature/ansible-webservers`
- `fix/nginx-config-typo`
- `hotfix/password-leak`
- `docs/update-readme`

**Bad branch names:**
- `test`
- `my-branch`
- `branch1`
- `asdfgh`

</details>

---

### Задание 5: Commits with proper messages

**Миссия:** Practice proper commit messages (Conventional Commits).

**Задача:**
```bash
# 1. Create sample config files
cat > ansible/playbooks/webservers.yml << 'EOF'
---
- hosts: webservers
  become: yes
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
EOF

cat > docker/web/Dockerfile << 'EOF'
FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

# 2. Add and commit with proper message
git add ansible/playbooks/webservers.yml
git commit -m "feat: add ansible playbook for nginx webservers"

git add docker/web/Dockerfile
git commit -m "feat: add nginx Dockerfile for web containers"

# 3. View commit history
git log --oneline
git log --graph --all --oneline
```

**Expected log:**
```
a1b2c3d (HEAD -> main) feat: add nginx Dockerfile for web containers
e4f5g6h feat: add ansible playbook for nginx webservers
i7j8k9l docs: add branching strategy documentation
m0n1o2p chore: add .gitignore for secrets and temp files
q3r4s5t chore: initialize infrastructure directory structure
```

<details>
<summary>💡 Hint: Multi-line commit messages</summary>

Для подробных сообщений коммита (рекомендуется):

```bash
git commit
# Откроется редактор (vim/nano):

feat: add ansible playbook for nginx webservers

- Configured nginx with SSL/TLS
- Added load balancing for 5 backend servers
- Enabled HTTP/2 support
- Configured logging to /var/log/nginx/

Related: Episode 13 (Git basics)
```

**Format:**
- Line 1: Subject (50 chars max)
- Line 2: Blank
- Line 3+: Body (wrap at 72 chars)

</details>

---

### Задание 6: Simulate merge conflict

**Миссия:** Создать merge conflict и научиться его разрешать.

**Scenario:** Max и Dmitry одновременно правят один и тот же файл.

**Задача:**
```bash
# 1. Max creates branch and changes nginx port
git checkout -b max-nginx-fix
cat > ansible/playbooks/webservers.yml << 'EOF'
---
- hosts: webservers
  become: yes
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
    - name: Configure nginx port
      lineinfile:
        path: /etc/nginx/nginx.conf
        regexp: 'listen'
        line: '    listen 80;'   # Max chose port 80
EOF
git add ansible/playbooks/webservers.yml
git commit -m "fix: configure nginx to listen on port 80"

# 2. Switch to main, simulate Dmitry's changes
git checkout main
cat > ansible/playbooks/webservers.yml << 'EOF'
---
- hosts: webservers
  become: yes
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
    - name: Configure nginx port
      lineinfile:
        path: /etc/nginx/nginx.conf
        regexp: 'listen'
        line: '    listen 8080;'   # Dmitry chose port 8080
EOF
git add ansible/playbooks/webservers.yml
git commit -m "fix: configure nginx to listen on port 8080"

# 3. Try to merge Max's branch
git merge max-nginx-fix
# ⚠️ CONFLICT!
```

**Expected output:**
```
Auto-merging ansible/playbooks/webservers.yml
CONFLICT (content): Merge conflict in ansible/playbooks/webservers.yml
Automatic merge failed; fix conflicts and then commit the result.
```

**Resolution:**
```bash
# 1. Open conflicted file
cat ansible/playbooks/webservers.yml
# You'll see:
# <<<<<<< HEAD
#     listen 8080;   # Dmitry's version
# =======
#     listen 80;     # Max's version
# >>>>>>> max-nginx-fix

# 2. Edit file manually, choose one version (or combine)
# Let's say we decide: port 80 for production
cat > ansible/playbooks/webservers.yml << 'EOF'
---
- hosts: webservers
  become: yes
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
    - name: Configure nginx port
      lineinfile:
        path: /etc/nginx/nginx.conf
        regexp: 'listen'
        line: '    listen 80;'   # Resolved: chose port 80
EOF

# 3. Mark as resolved and commit
git add ansible/playbooks/webservers.yml
git commit -m "fix: resolve merge conflict (chose port 80 for production)"

# 4. Verify
git log --oneline --graph --all
```

<details>
<summary>💡 Hint: Merge conflict markers</summary>

```
<<<<<<< HEAD
Your current branch changes
=======
Incoming branch changes
>>>>>>> branch-name
```

**Steps:**
1. Find markers (`<<<<<<<`, `=======`, `>>>>>>>`)
2. Choose version (yours, theirs, or both)
3. Delete markers
4. `git add` resolved file
5. `git commit` to complete merge

</details>

---

### Задание 7: Secrets management

**Миссия:** Настроить безопасное хранение secrets (passwords, API keys).

**Задача:**
```bash
# 1. Create .env.example (template — OK to commit)
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

# 2. Create actual .env with real secrets (NOT committed due to .gitignore)
cat > .env << 'EOF'
DB_HOST=10.20.30.40
DB_PORT=5432
DB_NAME=operation_shadow
DB_USER=max_sokolov
DB_PASSWORD=SuperSecret123!

GITHUB_TOKEN=ghp_abc123def456
AWS_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE
EOF

# 3. Verify .env is ignored
git status   # .env should NOT appear (because of .gitignore)

# 4. Commit .env.example
git add .env.example
git commit -m "chore: add .env.example template for secrets"

# 5. Create docs/SECRETS_MANAGEMENT.md
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
   - Remove from Git history:
     ```
     git filter-branch --force --index-filter \
       "git rm --cached --ignore-unmatch .env" \
       --prune-empty -- --all
     ```

## Current secrets locations:
- Database credentials: `.env` (local only)
- SSH keys: `~/.ssh/` (NOT in repo)
- Ansible vault: `ansible/.vault_pass` (in .gitignore)
EOF

git add docs/SECRETS_MANAGEMENT.md
git commit -m "docs: add secrets management guidelines"
```

<details>
<summary>💡 Hint: Ansible Vault (bonus)</summary>

Ansible has built-in encryption:

```bash
# Create encrypted file
ansible-vault create ansible/secrets.yml
# Enter password: ****

# Edit encrypted file
ansible-vault edit ansible/secrets.yml

# Use in playbook:
ansible-playbook playbook.yml --ask-vault-pass
```

</details>

---

### Задание 8: INCIDENT — Find and remove leaked secret

**‼️ EMERGENCY SCENARIO ‼️**

**Anna (звонок, 21:30):**
> *"Max! Кто-то закоммитил пароль в Git! Public repo! Krylov может уже знать! У нас 10 минут!"*

**Leaked file:**
```bash
# Simulate: someone committed secrets.txt
cat > secrets.txt << 'EOF'
# Production Database Password
DB_PASSWORD=ProdSecret2024!
DB_HOST=10.20.30.40

# Viktor SSH key
SSH_KEY=-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
EOF

git add secrets.txt
git commit -m "Add production secrets" # ❌ MISTAKE!
git log --oneline   # secret is in history!
```

**Tasks:**

1. **Find the leaked secret in Git history:**
```bash
# Search Git history for "password"
git log --all --full-history -- secrets.txt
git log -S "DB_PASSWORD" --all
```

2. **Remove from Git history (⚠️ DANGEROUS operation):**

**Option A: BFG Repo-Cleaner (recommended, faster):**
```bash
# Install BFG
sudo apt install bfg   # or download from https://rtyley.github.io/bfg-repo-cleaner/

# Remove file from all history
bfg --delete-files secrets.txt
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

**Option B: git filter-branch (slower but built-in):**
```bash
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch secrets.txt" \
  --prune-empty --tag-name-filter cat -- --all

git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

3. **Force push (if already pushed to remote):**
```bash
# ⚠️ WARNING: Force push rewrites history! Notify team!
git push --force --all
```

4. **Rotate password IMMEDIATELY:**
```bash
# In real scenario: change password in database NOW!
echo "Password rotated: ProdSecret2024_NEW!" >> rotation_log.txt
```

5. **Add to .gitignore (prevent future leaks):**
```bash
echo "secrets.txt" >> .gitignore
git add .gitignore
git commit -m "fix: add secrets.txt to .gitignore after leak incident"
```

6. **Audit: Who committed?**
```bash
git log --all --oneline | grep "Add production secrets"
# Output: a1b2c3d Add production secrets
git show a1b2c3d   # See who, when, what
```

**Hans (после incident):**
> *"Вот почему `.gitignore` сначала, commit потом. НИКОГДА наоборот. Усвоили урок?"*

<details>
<summary>💡 Hint: git reflog (если удалил лишнее)</summary>

If you accidentally deleted wrong commits:

```bash
# View reflog (history of HEAD movements)
git reflog

# Restore:
git reset --hard HEAD@{N}   # N = number from reflog
```

But если уже `git push --force` — too late!

</details>

---

### Задание 9: Generate Git audit report

**Миссия:** Создать comprehensive отчёт о Git repository (commits, branches, security).

**Задача:**
```bash
# Script: scripts/git_audit.sh

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

# 1. Repository info
echo "## REPOSITORY INFORMATION" >> "$REPORT"
echo "Repository: $(basename $(git rev-parse --show-toplevel))" >> "$REPORT"
echo "Current branch: $(git branch --show-current)" >> "$REPORT"
echo "Total commits: $(git rev-list --count HEAD)" >> "$REPORT"
echo "Total branches: $(git branch | wc -l)" >> "$REPORT"
echo "" >> "$REPORT"

# 2. Recent commits
echo "## RECENT COMMITS (last 10)" >> "$REPORT"
git log --oneline -10 >> "$REPORT"
echo "" >> "$REPORT"

# 3. Branches
echo "## BRANCHES" >> "$REPORT"
git branch -a >> "$REPORT"
echo "" >> "$REPORT"

# 4. Contributors
echo "## CONTRIBUTORS" >> "$REPORT"
git log --format='%an' | sort | uniq -c | sort -rn >> "$REPORT"
echo "" >> "$REPORT"

# 5. Files changed (top 10 most modified)
echo "## MOST MODIFIED FILES" >> "$REPORT"
git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -10 >> "$REPORT"
echo "" >> "$REPORT"

# 6. Security check: search for potentially leaked secrets
echo "## SECURITY AUDIT" >> "$REPORT"
echo "Checking for potential secrets in repository..." >> "$REPORT"

# Check for password patterns
if git log --all -S "password" --oneline | head -1 > /dev/null 2>&1; then
    echo "⚠️ WARNING: Found 'password' in commit history!" >> "$REPORT"
    git log --all -S "password" --oneline | head -5 >> "$REPORT"
else
    echo "✅ No 'password' found in commit messages" >> "$REPORT"
fi

# Check for API keys
if git log --all -S "api_key" --oneline | head -1 > /dev/null 2>&1; then
    echo "⚠️ WARNING: Found 'api_key' in commit history!" >> "$REPORT"
else
    echo "✅ No 'api_key' found in commit history" >> "$REPORT"
fi

# Check .gitignore exists
if [ -f .gitignore ]; then
    echo "✅ .gitignore exists ($(wc -l < .gitignore) lines)" >> "$REPORT"
else
    echo "❌ ERROR: .gitignore NOT FOUND!" >> "$REPORT"
fi

echo "" >> "$REPORT"

# 7. Repository size
echo "## REPOSITORY SIZE" >> "$REPORT"
echo "Total size: $(du -sh .git | cut -f1)" >> "$REPORT"
echo "" >> "$REPORT"

echo "========================================" >> "$REPORT"
echo "   END OF AUDIT REPORT" >> "$REPORT"
echo "========================================" >> "$REPORT"

echo "✅ Audit report generated: $REPORT"
cat "$REPORT"
EOF

chmod +x scripts/git_audit.sh
./scripts/git_audit.sh
```

**Expected output:**
```
========================================
   GIT AUDIT REPORT
   Operation Shadow Infrastructure
   Generated: 2025-10-10 18:45:32
========================================

## REPOSITORY INFORMATION
Repository: operation-shadow-infrastructure
Current branch: main
Total commits: 15
Total branches: 5

## RECENT COMMITS (last 10)
a1b2c3d docs: add secrets management guidelines
e4f5g6h fix: resolve merge conflict (chose port 80)
...

## BRANCHES
* main
  development
  feature/episode13-git
  ...

## CONTRIBUTORS
    12 Max Sokolov
     3 Dmitry Orlov

## MOST MODIFIED FILES
      5 ansible/playbooks/webservers.yml
      3 .gitignore
      ...

## SECURITY AUDIT
Checking for potential secrets in repository...
⚠️ WARNING: Found 'password' in commit history!
✅ No 'api_key' found in commit history
✅ .gitignore exists (35 lines)

## REPOSITORY SIZE
Total size: 1.2M

========================================
   END OF AUDIT REPORT
========================================
```

<details>
<summary>💡 Hint: Advanced Git log queries</summary>

```bash
# Find who changed a specific file
git log --follow -- path/to/file

# Find commits containing specific text
git log -S "searchterm"

# Find commits by specific author
git log --author="Max Sokolov"

# Find commits in date range
git log --since="2 weeks ago" --until="1 week ago"

# Show file diff in commit
git show <commit-hash>
```

</details>

---

## 🏆 Финальная проверка

**После выполнения всех 9 заданий у вас должно быть:**

✅ Git repository инициализирован
✅ Структура папок (ansible/, docker/, terraform/, scripts/, docs/)
✅ `.gitignore` настроен (secrets защищены)
✅ Branching strategy документирована
✅ 10+ коммитов с правильными сообщениями
✅ Merge conflict разрешён
✅ Secrets management настроен (.env.example)
✅ Leaked secret найден и удалён из истории
✅ Git audit report сгенерирован

**Запустите тест:**
```bash
cd ~/kernel-shadows/season-4-devops-automation/episode-13-git-version-control
./tests/test.sh
```

---

## 📖 Команды Git: Справочник

<details>
<summary><strong>🔹 Основные команды</strong></summary>

```bash
# Initialization
git init                    # Create new repo
git clone <url>             # Clone existing repo

# Status & Info
git status                  # Show working tree status
git log                     # Show commit history
git log --oneline           # Compact log
git log --graph --all       # Visual branch graph
git diff                    # Show changes

# Staging & Committing
git add <file>              # Stage file
git add .                   # Stage all changes
git commit -m "message"     # Commit with message
git commit                  # Commit with editor

# Branching
git branch                  # List branches
git branch <name>           # Create branch
git checkout <branch>       # Switch branch
git checkout -b <branch>    # Create + switch
git merge <branch>          # Merge branch
git branch -d <branch>      # Delete branch

# Remote
git remote add origin <url> # Add remote
git push origin <branch>    # Push to remote
git pull origin <branch>    # Pull from remote
git fetch                   # Fetch without merge

# Undo changes
git checkout -- <file>      # Discard changes in file
git reset <file>            # Unstage file
git reset --hard HEAD       # Discard all changes (dangerous!)
git revert <commit>         # Revert commit (safe)

# History manipulation (dangerous!)
git reset --hard <commit>   # Reset to commit (lose changes)
git filter-branch ...       # Rewrite history
```

</details>

<details>
<summary><strong>🔹 .gitignore patterns</strong></summary>

```gitignore
# Ignore specific file
secrets.txt

# Ignore all .log files
*.log

# Ignore directory
logs/

# Ignore in any subdirectory
**/secrets.txt

# Exception (do NOT ignore)
!important.log

# Comments
# This is a comment
```

</details>

<details>
<summary><strong>🔹 Conventional Commits</strong></summary>

```
<type>: <subject>

<body (optional)>

<footer (optional)>
```

**Types:**
- `feat:` — new feature
- `fix:` — bug fix
- `docs:` — documentation
- `style:` — formatting
- `refactor:` — code refactoring
- `test:` — tests
- `chore:` — maintenance

**Examples:**
```
feat: add ansible playbook for nginx
fix: correct firewall rule for port 8080
docs: update README with deployment steps
```

</details>

---

## 🧪 Тестирование

Автоматические тесты проверят:

1. ✅ Git repository инициализирован
2. ✅ Directory structure создана
3. ✅ `.gitignore` существует и содержит secrets patterns
4. ✅ Минимум 10 commits
5. ✅ Минимум 3 branches
6. ✅ Conventional Commits формат
7. ✅ Secrets НЕ committed
8. ✅ Audit report сгенерирован

**Запуск тестов:**
```bash
cd ~/kernel-shadows/season-4-devops-automation/episode-13-git-version-control
./tests/test.sh
```

---

## 💬 Цитаты Episode 13

**Hans Müller:**
> "В Chaos Computer Club у нас три правила: 1) Hack the planet. 2) Share the knowledge. 3) Version control everything. Git — это не опция. Git — это жизнь."

**Dmitry:**
> "Макс, в России мы говорим: 'Работает — не трогай.' В DevOps мы говорим: 'Работает — автоматизируй, версионируй, тестируй.' Разница."

**LILITH:**
> "Git history — как русская зима. Суровая, беспощадная, но абсолютно необходимая для выживания. Коммить нужно мудро. Из логов ничего не удалишь."

**Hans (после инцидента с утечкой пароля):**
> "Вот почему `.gitignore` сначала, код потом. НИКОГДА наоборот. Git помнит всё. Даже когда ты хотел бы, чтобы не помнил."

**Max (evolution):**
- Start: "Зачем Git для конфигов? Я и так помню что менял."
- После инцидента: "Понял. Git — это не опция. Это инструмент выживания."

---

## 🎓 Что вы узнали

После Episode 13 вы умеете:

✅ Инициализировать Git repository
✅ Создавать и управлять branches
✅ Писать правильные commit messages (Conventional Commits)
✅ Разрешать merge conflicts
✅ Защищать secrets через `.gitignore`
✅ Находить и удалять leaked secrets из истории
✅ Аудитировать Git repository
✅ Infrastructure as Code принципы

**Эти навыки будут использоваться в:**
- Episode 14: Docker (Dockerfiles в Git)
- Episode 15: CI/CD (GitHub Actions workflows)
- Episode 16: Ansible (Playbooks в Git)
- Season 5: Security (Code review workflow)

---

## 🚀 Следующий шаг

**Episode 14: Docker Basics** (Amsterdam, Netherlands)

**Sophie van Dijk (видеозвонок в конце Episode 13):**
> *"Max, Dmitry, Hans сказал мне, что вы готовы. Приезжайте в Амстердам завтра. Мы контейнеризируем всё. Docker — это LEGO для инфраструктуры. Простые блоки, сложные системы. Увидимся в Science Park datacenter. — Sophie"*

**Alex (текстовое сообщение):**
> *"Предупреждение о supply chain attack. Docker images легко скомпрометировать. Будь осторожен. — A."*

---

<div align="center">

**Episode 13: Git & Version Control — COMPLETE!**

*"Code is law. Version control is constitution."*

🇩🇪 Berlin • Chaos Computer Club • Infrastructure as Code

[⬅️ Episode 12: Backup & Recovery](../../season-3-system-administration/episode-12-backup-recovery/README.md) | [⬆️ Season 4 Overview](../README.md) | [➡️ Episode 14: Docker Basics](../episode-14-docker-basics/README.md)

</div>


