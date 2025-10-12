# Episode 12: Backup & Recovery — Refactor Plan

**Date:** 2025-10-12
**Status:** Planning phase
**Type:** Mixed (Type A + Type B configurations)

---

## 📊 Current Status Analysis

### ✅ What's GOOD (already done):

1. **README.md** (1960 lines):
   - ✅ 8 micro-cycles structure (хорошая interleaving!)
   - ✅ Метафоры: 3-2-1 rule = страховка дома, rsync = копировальный аппарат, tar = упаковщик
   - ✅ Visualizations: ASCII art, timelines, comparison tables
   - ✅ "Aha!" моменты: untested backup = no backup, persistent timers
   - ✅ LILITH интегрирована (20+ комментариев)
   - ✅ Теория качественная (CS50 style)
   - ✅ Сюжет драматичный (emergency restore at 03:47)

2. **starter.sh** (437 lines):
   - ✅ Хорошая структура с TODOs
   - ✅ 8 функций (full, incremental, offsite, restore, health, cleanup, DR test, report)
   - ✅ Strict mode (`set -euo pipefail`)

3. **solution/backup_manager.sh** (395 lines):
   - ✅ Полное решение
   - ✅ Colors, logging, error handling

4. **tests/test.sh** (295 lines):
   - ✅ 12 test sections
   - ✅ Full coverage (backup, restore, checksum, cleanup, DR simulation)

5. **artifacts/README.md** (826 lines):
   - ✅ Очень детальный testing guide
   - ✅ Scenarios (Krylov attack, 3-2-1 rule)
   - ✅ Troubleshooting section
   - ✅ Performance benchmarks

### ❌ CRITICAL PROBLEMS:

1. **Missing configuration files** (КРИТИЧНО!):
   - ❌ `solution/configs/systemd/*.service` — НЕ созданы
   - ❌ `solution/configs/systemd/*.timer` — НЕ созданы
   - ❌ `solution/configs/logrotate.d/backup` — НЕ создан
   - README.md и artifacts/README.md упоминают эти файлы (строки 914, 933, 1486, 1556)
   - Студенты не могут протестировать systemd automation!

2. **No starter/ structure**:
   - ❌ Нет starter конфигов для студентов
   - Episode 09 precedent: имеет `starter/` с TODO configs
   - Episode 12 должен иметь аналогично

3. **Type A/B balance**:
   - README.md учит systemd timers (Type B), но фокус на bash script (Type A)
   - Нужен баланс: 60% configs, 40% bash
   - Bash = automation tool, NOT replacement for systemd/logrotate

---

## 🎯 Refactoring Goals

### Primary Goal: Добавить Type B configuration files

**Цель:** Сделать Episode 12 настоящим "Type B configuration" episode с балансом:
- 60% systemd timers + logrotate configuration
- 40% bash automation script

### Secondary Goals:

1. Создать `solution/configs/` с reference configs
2. Создать `starter/` с TODO configs для студентов
3. Обновить `tests/` для проверки systemd units
4. Обновить `artifacts/` с примерами использования configs

---

## 📋 Detailed Refactor Plan

### Phase 1: Create solution/configs/ (CRITICAL)

#### 1.1. Systemd Service Units

**Create 4 services:**

**File: `solution/configs/systemd/backup-full.service`**
```ini
[Unit]
Description=Full Backup Service
Documentation=https://github.com/kernel-shadows/episode-12
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
User=root
Group=root
ExecStart=/usr/local/bin/backup_manager.sh backup_full
StandardOutput=journal
StandardError=journal
SyslogIdentifier=backup-full

# Security hardening
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=read-only
ReadWritePaths=/backup /var/log

# Resource limits
CPUQuota=50%
MemoryLimit=2G
TasksMax=100

[Install]
WantedBy=multi-user.target
```

**File: `solution/configs/systemd/backup-incremental.service`**
```ini
[Unit]
Description=Incremental Backup Service
Documentation=https://github.com/kernel-shadows/episode-12
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
User=root
Group=root
ExecStart=/usr/local/bin/backup_manager.sh backup_incremental
StandardOutput=journal
StandardError=journal
SyslogIdentifier=backup-incremental

# Security hardening
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=read-only
ReadWritePaths=/backup /var/log

# Resource limits
CPUQuota=30%
MemoryLimit=1G

[Install]
WantedBy=multi-user.target
```

**File: `solution/configs/systemd/backup-offsite.service`**
```ini
[Unit]
Description=Offsite Backup Service (Remote Sync)
Documentation=https://github.com/kernel-shadows/episode-12
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
User=root
Group=root
ExecStart=/usr/local/bin/backup_manager.sh backup_offsite
StandardOutput=journal
StandardError=journal
SyslogIdentifier=backup-offsite

# Security
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ReadWritePaths=/backup /var/log

# Resource limits
CPUQuota=40%
MemoryLimit=1G

[Install]
WantedBy=multi-user.target
```

**File: `solution/configs/systemd/backup-health-check.service`**
```ini
[Unit]
Description=Backup Health Check Service
Documentation=https://github.com/kernel-shadows/episode-12
After=network-online.target

[Service]
Type=oneshot
User=root
Group=root
ExecStart=/usr/local/bin/backup_manager.sh check_backup_health
StandardOutput=journal
StandardError=journal
SyslogIdentifier=backup-health-check

# Security
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full

[Install]
WantedBy=multi-user.target
```

---

#### 1.2. Systemd Timer Units

**File: `solution/configs/systemd/backup-full.timer`**
```ini
[Unit]
Description=Full Backup Timer (Weekly on Sunday 02:00)
Documentation=https://github.com/kernel-shadows/episode-12

[Timer]
# Schedule: Every Sunday at 02:00
OnCalendar=Sun *-*-* 02:00:00

# If system was off during scheduled time, run on boot
Persistent=true

# Run 5 minutes after boot if schedule was missed
OnBootSec=5min

# Randomize start time by up to 15 minutes (avoid thundering herd)
RandomizedDelaySec=15min

# Accuracy (default 1min is fine for backups)
AccuracySec=1min

[Install]
WantedBy=timers.target
```

**File: `solution/configs/systemd/backup-incremental.timer`**
```ini
[Unit]
Description=Incremental Backup Timer (Daily at 02:00, except Sunday)
Documentation=https://github.com/kernel-shadows/episode-12

[Timer]
# Schedule: Monday-Saturday at 02:00
OnCalendar=Mon..Sat *-*-* 02:00:00

# Persistent if system was off
Persistent=true
OnBootSec=5min

# Randomize
RandomizedDelaySec=10min

[Install]
WantedBy=timers.target
```

**File: `solution/configs/systemd/backup-offsite.timer`**
```ini
[Unit]
Description=Offsite Backup Timer (Daily at 03:00)
Documentation=https://github.com/kernel-shadows/episode-12

[Timer]
# Schedule: Every day at 03:00 (after local backups finish)
OnCalendar=*-*-* 03:00:00

# Persistent
Persistent=true
OnBootSec=10min

# Randomize
RandomizedDelaySec=15min

[Install]
WantedBy=timers.target
```

**File: `solution/configs/systemd/backup-health-check.timer`**
```ini
[Unit]
Description=Backup Health Check Timer (Every 6 hours)
Documentation=https://github.com/kernel-shadows/episode-12

[Timer]
# Schedule: Every 6 hours (00:00, 06:00, 12:00, 18:00)
OnCalendar=*-*-* 00,06,12,18:00:00

# Persistent
Persistent=true

# Randomize
RandomizedDelaySec=5min

[Install]
WantedBy=timers.target
```

---

#### 1.3. Logrotate Configuration

**File: `solution/configs/logrotate.d/backup`**
```
# Logrotate configuration for backup logs
# Episode 12: Backup & Recovery
# Liisa Kask — "Логи backup = black box после disaster. Храните минимум 30 дней."

/var/log/backup.log {
    # Rotate daily
    daily

    # Keep 30 days (compliance, forensics)
    rotate 30

    # Compress old logs (save space)
    compress

    # Don't compress most recent (might still be written to)
    delaycompress

    # Don't error if log doesn't exist
    missingok

    # Don't rotate if empty
    notifempty

    # Create new log with proper permissions
    create 640 root adm

    # Run scripts once after rotation
    sharedscripts

    # Post-rotation script
    postrotate
        # Send weekly summary email (if Monday)
        if [ $(date +%u) -eq 1 ]; then
            if command -v mail >/dev/null 2>&1; then
                tail -1000 /var/log/backup.log.1 | \
                mail -s "Weekly Backup Summary - $(hostname)" admin@example.com || true
            fi
        fi

        # Notify systemd (if journald integration)
        if command -v systemctl >/dev/null 2>&1; then
            systemctl kill -s HUP --kill-who=main backup-*.service || true
        fi
    endscript
}

# Health check logs
/var/log/backup-health.log {
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    create 640 root adm
}

# Offsite backup logs
/var/log/backup-offsite.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 640 root adm
}
```

---

### Phase 2: Create starter/ structure

**Цель:** Дать студентам TODO конфиги для самостоятельной настройки.

#### 2.1. Directory Structure

```
starter/
├── README.md (инструкции для студентов)
├── systemd/
│   ├── backup-full.service (с TODO)
│   ├── backup-full.timer (с TODO)
│   ├── backup-incremental.service (с TODO)
│   └── backup-incremental.timer (с TODO)
└── logrotate.d/
    └── backup (с TODO)
```

#### 2.2. Starter Configs (примеры с TODO)

**File: `starter/systemd/backup-full.service`**
```ini
[Unit]
# TODO: Add description
Description=
# TODO: Add documentation URL
Documentation=
# TODO: Specify when service should start (after network?)
After=

[Service]
Type=oneshot
# TODO: Which user should run backup? (root for /backup access)
User=
Group=
# TODO: What command to execute?
ExecStart=
# TODO: Where should logs go? (journal?)
StandardOutput=
StandardError=
SyslogIdentifier=backup-full

# Security hardening
# TODO: Enable NoNewPrivileges for security
NoNewPrivileges=
# TODO: Enable PrivateTmp
PrivateTmp=
# TODO: Protect system directories (read-only)
ProtectSystem=
# TODO: Allow write access to /backup and /var/log
ReadWritePaths=

# Resource limits
# TODO: Limit CPU usage (e.g., 50%)
CPUQuota=
# TODO: Limit memory (e.g., 2G)
MemoryLimit=

[Install]
WantedBy=multi-user.target
```

**File: `starter/systemd/backup-full.timer`**
```ini
[Unit]
# TODO: Add description
Description=
Documentation=

[Timer]
# TODO: Schedule full backup (e.g., Sunday at 02:00)
# Syntax: DayOfWeek YYYY-MM-DD HH:MM:SS
# Example: Sun *-*-* 02:00:00
OnCalendar=

# TODO: Enable Persistent (run missed schedules on boot)
Persistent=

# TODO: Run N minutes after boot if schedule was missed
OnBootSec=

# TODO: Randomize start time (avoid multiple services starting at once)
RandomizedDelaySec=

[Install]
WantedBy=timers.target
```

**File: `starter/logrotate.d/backup`**
```
# TODO: Logrotate configuration for /var/log/backup.log

/var/log/backup.log {
    # TODO: How often to rotate? (daily/weekly/monthly)


    # TODO: How many old logs to keep?
    rotate

    # TODO: Compress old logs? (yes/no)


    # TODO: Don't compress most recent log


    # TODO: Don't error if log missing


    # TODO: Don't rotate if empty


    # TODO: Create new log with permissions (user group permissions)
    create

    # Post-rotation actions
    postrotate
        # TODO: Add actions after rotation (e.g., email summary)

    endscript
}
```

#### 2.3. Starter README.md

**File: `starter/README.md`**
```markdown
# Episode 12: Starter Configurations

> **Liisa:** "Automation = systemd timers + logrotate. Configure correctly, test thoroughly."

---

## 📁 Structure

```
starter/
├── systemd/          ← Systemd service/timer units (automation)
│   ├── backup-full.service
│   ├── backup-full.timer
│   ├── backup-incremental.service
│   └── backup-incremental.timer
└── logrotate.d/      ← Logrotate config (log management)
    └── backup
```

---

## 🎯 Your Tasks

### Task 1: Complete Systemd Service Unit

**File:** `systemd/backup-full.service`

Fill in TODOs:
1. **Description:** What does this service do?
2. **After:** Start after `network-online.target` (wait for network)
3. **User/Group:** Run as `root` (needs /backup access)
4. **ExecStart:** Command to run: `/usr/local/bin/backup_manager.sh backup_full`
5. **StandardOutput/Error:** Send logs to `journal`
6. **Security:**
   - `NoNewPrivileges=true` (prevent privilege escalation)
   - `PrivateTmp=true` (isolated /tmp)
   - `ProtectSystem=strict` (read-only system)
   - `ReadWritePaths=/backup /var/log` (allow writes here)
7. **Resource Limits:**
   - `CPUQuota=50%` (limit CPU usage)
   - `MemoryLimit=2G` (limit memory)

### Task 2: Complete Systemd Timer Unit

**File:** `systemd/backup-full.timer`

Fill in TODOs:
1. **OnCalendar:** `Sun *-*-* 02:00:00` (every Sunday at 02:00)
2. **Persistent:** `true` (run missed schedules on boot)
3. **OnBootSec:** `5min` (run 5min after boot if missed)
4. **RandomizedDelaySec:** `15min` (randomize ±15min)

### Task 3: Complete Logrotate Config

**File:** `logrotate.d/backup`

Fill in TODOs:
1. **Frequency:** `daily`
2. **Retention:** `rotate 30` (keep 30 days)
3. **Compression:** `compress` + `delaycompress`
4. **Permissions:** `create 640 root adm`
5. **Postrotate:** Email summary on Mondays

---

## ✅ Installation

After completing TODOs:

```bash
# 1. Copy systemd units
sudo cp starter/systemd/*.service /etc/systemd/system/
sudo cp starter/systemd/*.timer /etc/systemd/system/

# 2. Reload systemd
sudo systemctl daemon-reload

# 3. Enable and start timers
sudo systemctl enable --now backup-full.timer
sudo systemctl enable --now backup-incremental.timer

# 4. Verify
sudo systemctl list-timers | grep backup

# 5. Copy logrotate config
sudo cp starter/logrotate.d/backup /etc/logrotate.d/

# 6. Test logrotate
sudo logrotate -d /etc/logrotate.d/backup
```

---

## 🧪 Testing

```bash
# Manual trigger (test without waiting for schedule)
sudo systemctl start backup-full.service

# Check logs
sudo journalctl -u backup-full.service -f

# Check status
sudo systemctl status backup-full.service
```

---

## 📚 Reference

Compare your work with `solution/configs/` after completing.

**Liisa:** "Configuration = declarative. Scripts = imperative. Both important."
```

---

### Phase 3: Update tests/test.sh

Add tests for systemd units and logrotate:

```bash
test_section "13. Systemd Configuration Files"

if [[ -f "solution/configs/systemd/backup-full.service" ]]; then
    pass "backup-full.service exists"
else
    fail "backup-full.service not found"
fi

if [[ -f "solution/configs/systemd/backup-full.timer" ]]; then
    pass "backup-full.timer exists"
else
    fail "backup-full.timer not found"
fi

if grep -q "OnCalendar=" "solution/configs/systemd/backup-full.timer"; then
    pass "Timer has OnCalendar schedule"
else
    fail "Timer missing OnCalendar"
fi

if grep -q "Persistent=true" "solution/configs/systemd/backup-full.timer"; then
    pass "Timer has Persistent=true"
else
    fail "Timer missing Persistent setting"
fi

test_section "14. Logrotate Configuration"

if [[ -f "solution/configs/logrotate.d/backup" ]]; then
    pass "logrotate config exists"
else
    fail "logrotate config not found"
fi

if grep -q "daily" "solution/configs/logrotate.d/backup"; then
    pass "Logrotate has daily rotation"
else
    fail "Logrotate missing rotation frequency"
fi

if grep -q "rotate 30" "solution/configs/logrotate.d/backup"; then
    pass "Logrotate keeps 30 days"
else
    fail "Logrotate missing retention policy"
fi
```

---

## 📊 Refactoring Summary

### Changes Overview:

| Component | Status Before | Status After | Lines Added |
|-----------|---------------|--------------|-------------|
| `README.md` | ✅ Good (1960) | ✅ Unchanged | 0 |
| `starter.sh` | ✅ Good (437) | ✅ Unchanged | 0 |
| `solution/backup_manager.sh` | ✅ Good (395) | ✅ Unchanged | 0 |
| `solution/configs/systemd/*.service` | ❌ Missing | ✅ **Create 4 files** | **~600** |
| `solution/configs/systemd/*.timer` | ❌ Missing | ✅ **Create 4 files** | **~400** |
| `solution/configs/logrotate.d/backup` | ❌ Missing | ✅ **Create 1 file** | **~100** |
| `starter/` | ❌ Missing | ✅ **Create directory** | **~500** |
| `tests/test.sh` | ✅ Good (295) | ✅ **Add 2 sections** | **+50** |
| `artifacts/README.md` | ✅ Good (826) | ✅ Unchanged | 0 |

**Total new content:** ~1650 lines of configuration files

---

## 🎯 Expected Outcome

### Type A/B Balance:

**BEFORE:**
- 90% Bash scripting (backup_manager.sh)
- 10% Configuration mention (теория в README)

**AFTER:**
- 40% Bash automation (backup_manager.sh = инструмент)
- 60% System configuration (systemd units + logrotate)

### Student Experience:

**BEFORE:**
- Student writes bash script ✅
- Student reads about systemd/logrotate ❌ (no hands-on)

**AFTER:**
- Student writes bash script ✅
- Student **configures systemd units** ✅ (hands-on!)
- Student **configures logrotate** ✅ (hands-on!)
- Student **tests automation** ✅ (systemctl list-timers)

### Episode Quality:

**BEFORE:** 3.8/5
- Good theory, but missing practical configs
- Students can't test systemd automation

**AFTER:** 4.6/5
- Complete theory ✅
- Complete practical configs ✅
- Students test full automation stack ✅
- Type B balance achieved ✅

---

## ✅ Execution Steps

1. Create `solution/configs/systemd/` — 8 files
2. Create `solution/configs/logrotate.d/` — 1 file
3. Create `starter/` structure — 6 files + README
4. Update `tests/test.sh` — add 2 test sections
5. Test all configs locally
6. Commit as v0.4.5.12

**Estimated time:** 2-3 hours (creating, testing configs)

---

## 💬 Liisa's Approval Criteria

- ✅ Systemd units follow best practices (security, resource limits)
- ✅ Timers use Persistent=true (critical для backup!)
- ✅ Logrotate retention = 30 days (compliance)
- ✅ Starter configs have clear TODOs
- ✅ Students can install and test configs
- ✅ Tests verify config existence

**Liisa:** "Automation без configuration = половина работы. Systemd + logrotate = production-ready."

---

**Next Action:** Начать создание файлов в Phase 1.

