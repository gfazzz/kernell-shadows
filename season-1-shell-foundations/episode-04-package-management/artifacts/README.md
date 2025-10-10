# Episode 04: Package Management — Artifacts

```
ОПЕРАЦИЯ: KERNEL SHADOWS
СЕЗОН: 1 — Shell & Foundations
ЭПИЗОД: 04 — Package Management
АРТЕФАКТЫ: Test data and resources
```

---

## 📦 Содержимое artifacts/

### 1. `required_tools.txt`

**Описание:** Список необходимых инструментов для операции от Viktor Petrov.

**Формат:**

```
# OPERATION KERNEL SHADOWS
# Required Tools for Infrastructure
# Viktor Petrov, 07 Oct 2025

# Security & Networking
nmap           # Network scanner
tcpdump        # Packet capture
wireshark      # Network analyzer (GUI)
fail2ban       # Intrusion prevention
ufw            # Uncomplicated Firewall

# Monitoring
htop           # Interactive process viewer
iotop          # Disk I/O monitor
nethogs        # Network bandwidth per process

# Development
git            # Version control
curl           # HTTP client
jq             # JSON processor

# Docker (требует manual installation from official repo)
# docker-ce
# docker-compose-plugin
```

**Использование:**

```bash
# Просмотр
cat required_tools.txt

# Убрать комментарии
grep -v '^#' required_tools.txt | grep -v '^$'

# Установка всех пакетов (ONE-LINER!)
grep -v '^#' required_tools.txt | grep -v '^$' | xargs sudo apt install -y

# Проверка что установлено
while read pkg; do
  [[ "$pkg" =~ ^# || -z "$pkg" ]] && continue
  dpkg -l "$pkg" 2>/dev/null | grep -q "^ii" && echo "✓ $pkg" || echo "✗ $pkg"
done < required_tools.txt
```

---

## 📖 Как использовать артефакты

### Type B Episode! Важные правила:

**Episode 04 = Type B** — это значит:
- ✅ **Используй apt/dpkg команды напрямую**
- ✅ **НЕ пиши bash wrapper на 300+ строк**
- ✅ **Финал = minimal ONE-LINER для отчёта (40-80 строк)**

**Философия:**

```
apt существует с 1998 года.
Установлен на миллионах серверов.
Оптимизирован и протестирован.

Переписывать apt в bash = переизобретение велосипеда.

Для 1 машины: команды apt
Для 50 машин: Ansible (Episode 16)

Bash wrapper на 355 строк = не нужен.
```

---

## 🎯 Workflow: Как проходить Episode 04

### Шаг 1: apt basics (Цикл 2)

```bash
# Update package index
sudo apt update

# Search for package
apt search nmap

# Show package info
apt show nmap

# Install single package
sudo apt install -y nmap

# Verify installation
which nmap
nmap --version
```

---

### Шаг 2: dpkg inspection (Цикл 3)

```bash
# List all installed packages
dpkg -l | grep "^ii"

# Package status
dpkg -s nmap

# Files installed by package
dpkg -L nmap

# Which package installed a file
dpkg -S /usr/bin/nmap

# Verify proper installation
dpkg -l nmap | grep "^ii"
```

---

### Шаг 3: Add Docker repository (Цикл 4)

```bash
# Install prerequisites
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update and install
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verify
docker --version
```

---

### Шаг 4: Batch installation (Цикл 5)

**ONE-LINER для установки всех пакетов из файла:**

```bash
# Вариант 1: Все пакеты разом (быстро)
grep -v '^#' artifacts/required_tools.txt | grep -v '^$' | xargs sudo apt install -y

# Вариант 2: По одному (надёжнее)
grep -v '^#' artifacts/required_tools.txt | grep -v '^$' | xargs -n 1 sudo apt install -y

# Вариант 3: С логированием
grep -v '^#' artifacts/required_tools.txt | grep -v '^$' | while read pkg; do
  echo "Installing $pkg..."
  sudo apt install -y "$pkg" && echo "✓ $pkg" || echo "✗ $pkg FAILED"
done
```

---

### Шаг 5: Verification (Цикл 6)

```bash
# Check each package from list
while read pkg; do
  [[ "$pkg" =~ ^# || -z "$pkg" ]] && continue
  if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
    version=$(dpkg -l "$pkg" | grep "^ii" | awk '{print $3}')
    echo "✓ $pkg ($version)"
  else
    echo "✗ $pkg (NOT INSTALLED)"
  fi
done < artifacts/required_tools.txt

# Check security updates
sudo apt update
apt list --upgradable

# Upgrade if needed
sudo apt upgrade -y
```

---

### Шаг 6: Cleanup (Цикл 6)

```bash
# Remove orphaned dependencies
sudo apt autoremove

# Clean cache
du -sh /var/cache/apt/archives/  # Before
sudo apt clean
du -sh /var/cache/apt/archives/  # After

# System statistics
dpkg -l | grep "^ii" | wc -l    # Total packages
df -h /                          # Disk usage
```

---

### Шаг 7: Generate report (Цикл 7)

**Финальное задание — создать отчёт для Viktor.**

**Вариант 1: Использовать starter.sh**

```bash
# Заполни TODOs в starter.sh
# Запусти:
bash starter.sh
```

**Вариант 2: Чистый ONE-LINER (без скрипта)**

```bash
{
  echo "═══════════════════════════════════════════════════════════════"
  echo "           PACKAGE INSTALLATION REPORT"
  echo "═══════════════════════════════════════════════════════════════"
  echo ""
  echo "Date: $(date '+%d %B %Y, %H:%M')"
  echo "System: $(lsb_release -ds)"
  echo "Kernel: $(uname -r)"
  echo "Architecture: $(dpkg --print-architecture)"
  echo ""
  echo "───────────────────────────────────────────────────────────────"
  echo "INSTALLED PACKAGES FROM required_tools.txt"
  echo "───────────────────────────────────────────────────────────────"
  echo ""

  while read pkg; do
    [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
    if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
      version=$(dpkg -l "$pkg" | grep "^ii" | awk '{print $3}')
      repo=$(apt-cache policy "$pkg" | grep -A 1 "Installed:" | tail -1 | awk '{print $2}')
      echo "  ✓ $pkg"
      echo "    Version: $version"
      echo "    Repository: $repo"
      echo ""
    else
      echo "  ✗ $pkg — NOT INSTALLED"
      echo ""
    fi
  done < artifacts/required_tools.txt

  echo "───────────────────────────────────────────────────────────────"
  echo "STATISTICS"
  echo "───────────────────────────────────────────────────────────────"
  echo ""
  echo "Total packages in system: $(dpkg -l | grep "^ii" | wc -l)"
  installed=$(while read p; do [[ "$p" =~ ^# || -z "$p" ]] && continue; dpkg -l "$p" 2>/dev/null | grep -q "^ii" && echo "1"; done < artifacts/required_tools.txt | wc -l)
  required=$(grep -v "^#" artifacts/required_tools.txt | grep -v "^$" | wc -l)
  echo "Packages from required list: $installed / $required"
  echo "Disk usage (apt cache): $(du -sh /var/cache/apt/archives/ 2>/dev/null | awk '{print $1}')"
  echo ""
  echo "═══════════════════════════════════════════════════════════════"
  echo "                      END OF REPORT"
  echo "═══════════════════════════════════════════════════════════════"
  echo ""
  echo "Generated by: Max Sokolov"
  echo "For: Viktor Petrov (OPERATION KERNEL SHADOWS)"
} > install_report.txt

echo "✓ Report saved: install_report.txt"
cat install_report.txt
```

**Это ~50 строк. НЕ 355!** ✅

---

## 🔧 Troubleshooting

### Проблема: Package not found

```bash
# Ошибка:
E: Unable to locate package nmap

# Решение:
sudo apt update    # Обнови индекс пакетов!
```

### Проблема: Permission denied

```bash
# Ошибка:
E: Could not open lock file

# Решение:
# Используй sudo для установки:
sudo apt install nmap
```

### Проблема: Dependency issues

```bash
# Ошибка:
The following packages have unmet dependencies:
  nmap: Depends: libpcap0.8 but it is not going to be installed

# Решение:
sudo apt install -f    # Fix broken dependencies
sudo apt update
sudo apt install nmap
```

### Проблема: GPG signature error

```bash
# Ошибка:
W: GPG error: ... The repository is not signed

# Решение:
# Убедись что добавил GPG key перед добавлением репозитория:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

### Проблема: Docker не запускается

```bash
# Ошибка:
permission denied while trying to connect to Docker daemon

# Решение:
# Добавь пользователя в группу docker:
sudo usermod -aG docker $USER
# Перелогинься или:
newgrp docker
```

---

## 💡 ONE-LINERS Cheat Sheet

### Установка

```bash
# Одиночный пакет
sudo apt install -y nmap

# Несколько пакетов
sudo apt install -y nmap tcpdump htop

# Из файла (все разом)
grep -v '^#' list.txt | grep -v '^$' | xargs sudo apt install -y

# Из файла (по одному)
grep -v '^#' list.txt | grep -v '^$' | xargs -n 1 sudo apt install -y
```

### Проверка

```bash
# Проверить один пакет
dpkg -l nmap | grep "^ii"

# Проверить список
while read p; do
  [[ "$p" =~ ^# || -z "$p" ]] && continue
  dpkg -l "$p" 2>/dev/null | grep -q "^ii" && echo "✓ $p" || echo "✗ $p"
done < list.txt

# Посчитать установленные
while read p; do
  [[ "$p" =~ ^# || -z "$p" ]] && continue
  dpkg -l "$p" 2>/dev/null | grep -q "^ii" && echo "1"
done < list.txt | wc -l
```

### Информация

```bash
# Версия пакета
dpkg -l nmap | grep "^ii" | awk '{print $3}'

# Откуда установлен
apt-cache policy nmap | grep -A 1 "Installed:" | tail -1

# Файлы пакета
dpkg -L nmap

# Какой пакет установил файл
dpkg -S /usr/bin/nmap
```

### Cleanup

```bash
# Удалить неиспользуемые зависимости
sudo apt autoremove -y

# Очистить cache
sudo apt clean

# Размер cache
du -sh /var/cache/apt/archives/
```

---

## 📚 Дополнительные ресурсы

### Man pages

```bash
man apt           # APT command reference
man apt-get       # Legacy apt-get
man apt-cache     # Package cache operations
man dpkg          # Low-level package manager
man sources.list  # Repository configuration
```

### Полезные пути

```bash
/etc/apt/sources.list         # Основные репозитории
/etc/apt/sources.list.d/      # Дополнительные репозитории
/etc/apt/keyrings/            # GPG keys
/var/lib/dpkg/status          # Database всех пакетов
/var/cache/apt/archives/      # Скачанные .deb files
/var/lib/apt/lists/           # Package lists (индексы)
```

### Онлайн документация

- Ubuntu Packages: https://packages.ubuntu.com/
- APT Manual: https://manpages.ubuntu.com/manpages/jammy/man8/apt.8.html
- Docker Installation: https://docs.docker.com/engine/install/ubuntu/
- Debian Wiki (APT): https://wiki.debian.org/Apt

---

## 🎯 Type B Validation

**Episode 04 соответствует Type B если:**

- ✅ **95%+ времени** — используются команды apt/dpkg напрямую
- ✅ **Финал** — minimal ONE-LINER для отчёта (40-80 строк max)
- ✅ **НЕТ bash wrapper** для установки пакетов (apt делает это!)
- ✅ **Фокус** — понимание package management, не bash programming

**Правильный баланс:**
- 95% Package Management (apt, dpkg, repositories)
- 5% Bash (minimal ONE-LINER для отчёта)

**Для массовой автоматизации (50 servers):**
- → Episode 16: Ansible
- → Infrastructure as Code
- → Idempotent playbooks

---

**Удачи с Episode 04!** 🚀

*"apt exists for a reason — use it, don't rewrite it." — LILITH*
