# Episode 03: Artifacts

## 📁 Файлы

### `access.log`
Лог веб-сервера за последние 24 часа. Симулированный лог, содержащий:
- Легитимный трафик (~80%)
- Попытки SQL injection
- Сканирование портов
- Попытки brute-force атак
- DDoS трафик

**Формат:** Apache Combined Log Format
```
IP - - [timestamp] "METHOD /path HTTP/1.1" status size "referer" "user-agent"
```

### `suspicious_ips.txt`
База известных вредоносных IP адресов (threat intelligence feed).
Один IP на строку.

### `report_template.txt`
Шаблон для финального отчёта Анны Ковалевой.

---

## 🔧 Как использовать

1. **Копируйте файлы в рабочую директорию:**
   ```bash
   cp artifacts/* ~/log_analysis/
   cd ~/log_analysis/
   ```

2. **Проверьте размер лога:**
   ```bash
   wc -l access.log
   ls -lh access.log
   ```

3. **Начните анализ!**

---

## 🎯 Цель

Найти IP адреса атакующих, проанализировать их активность, создать отчёт.

---

*"Логи не врут. Люди — врут."* — LILITH

