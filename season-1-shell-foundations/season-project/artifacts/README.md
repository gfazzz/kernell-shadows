# Artifacts — Season 1 Integration Project

## 📁 Файлы

### 1. required_packages.txt
Список пакетов, которые должны быть установлены на серверах операции.

**Формат:**
```
package_name  # Optional comment
```

**Использование:**
```bash
while IFS= read -r package; do
    # Skip comments and empty lines
    [[ "$package" =~ ^#.*$ || -z "$package" ]] && continue

    # Install package
    apt install -y "$package"
done < required_packages.txt
```

---

### 2. threat_database.txt
База известных угроз (IP адреса атакующих).

**Источники:**
- Предыдущие атаки из Episode 03
- Tor exit nodes
- Known malicious IPs

**Использование:**
```bash
# Check if IP is in threat database
while IFS= read -r threat_ip; do
    if grep -q "$threat_ip" /var/log/auth.log; then
        echo "THREAT DETECTED: $threat_ip"
    fi
done < threat_database.txt
```

---

### 3. critical_paths.txt
Критические пути, которые должны существовать на сервере.

**Категории:**
- System directories
- Configuration files
- Log files
- Application directories

**Использование:**
```bash
while IFS= read -r path; do
    if [[ ! -e "$path" ]]; then
        echo "WARNING: Critical path missing: $path"
    fi
done < critical_paths.txt
```

---

## 🧪 Тестовые данные

Эти файлы используются:
- В продакшн скрипте (`system_setup.sh`)
- В автотестах (`tests/test.sh`)

**NOTE:** В production вы можете адаптировать эти файлы под свои нужды.

---

## 🔐 Security Note

**threat_database.txt** содержит реальные IP адреса из предыдущих атак:
- 185.220.101.47 (Tor exit node из Episode 03)
- Другие suspicious IPs

Не используйте эти IP для атак. Ethical hacking only!

---

<div align="center">

*"Data without context is just noise. Context is everything."* — LILITH

</div>

