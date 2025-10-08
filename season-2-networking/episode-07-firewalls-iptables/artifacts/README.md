# Artifacts — Episode 07: Firewalls & iptables

Тестовые данные и артефакты для Episode 07.

---

## 📦 Файлы

### 1. `botnet_ips.txt`
**Описание:** Список IP адресов botnet, используемых в DDoS атаке.

**Источник:** Anna Kovaleva (forensics analysis)

**Формат:**
```
# Комментарии начинаются с #
185.220.101.47     # Tor exit node
91.219.237.244     # VPN exit
...
```

**Использование:**
```bash
# Прочитать и заблокировать каждый IP
while IFS= read -r ip; do
    [[ -z "$ip" || "$ip" =~ ^# ]] && continue
    ip_addr=$(echo "$ip" | awk '{print $1}')
    sudo iptables -I INPUT -s "$ip_addr" -j DROP
done < artifacts/botnet_ips.txt
```

**Количество:** 50 IP (в реальной атаке было 847)

**Примечание:**
- Некоторые IP относятся к Tor exit nodes
- Другие — скомпрометированные серверы
- 185.220.100.* — инфраструктура Krylov (C2 servers)

---

### 2. `blocked_ips.log` (создаётся скриптом)
**Описание:** Лог заблокированных IP адресов.

**Создание:**
```bash
echo "Blocked IPs - $(date)" > artifacts/blocked_ips.log
echo "185.220.101.47" >> artifacts/blocked_ips.log
```

**Использование:**
```bash
# Проверить количество заблокированных IP
wc -l < artifacts/blocked_ips.log

# Показать последние 10
tail -10 artifacts/blocked_ips.log
```

---

### 3. `firewall_audit_report.txt` (создаётся скриптом)
**Описание:** Финальный security audit report.

**Создание:**
Генерируется скриптом в Task 8.

**Содержит:**
- Incident summary
- Firewall configuration (UFW + iptables)
- Blocked IPs statistics
- Current system status
- Attack logs analysis
- Security assessment
- Recommendations

**Использование:**
```bash
# Просмотр отчёта
cat artifacts/firewall_audit_report.txt

# Поиск по ключевым словам
grep "CRITICAL" artifacts/firewall_audit_report.txt
grep "Blocked IPs" artifacts/firewall_audit_report.txt
```

---

## 🧪 Тестирование

### Проверка блокировки IP:
```bash
# Заблокировать первый IP из списка
first_ip=$(grep -v "^#" artifacts/botnet_ips.txt | head -1 | awk '{print $1}')
sudo iptables -I INPUT -s "$first_ip" -j DROP

# Проверить что правило создано
sudo iptables -L INPUT -n | grep "$first_ip"

# Удалить (для тестирования)
sudo iptables -D INPUT -s "$first_ip" -j DROP
```

### Симуляция атаки (локально):
```bash
# Генерация SYN пакетов (требует hping3)
sudo hping3 -S -p 80 --flood --rand-source localhost

# В другом терминале смотрите SYN_RECV:
watch 'netstat -an | grep SYN_RECV | wc -l'
```

**⚠️ Внимание:** Не запускайте flood атаки на production серверы!

---

## 📊 Ожидаемые результаты

### До применения firewall:
- Load Average: > 40
- SYN_RECV connections: > 800
- Status: CRITICAL

### После применения firewall:
- Load Average: < 5
- SYN_RECV connections: < 50
- Status: NORMAL
- Blocked packets: > 500,000

---

## 🔍 Forensics Notes (Anna)

**Анализ атаки:**

1. **Timing:** 03:47 Moscow time, Day 13
2. **Duration:** ~20 minutes
3. **Type:** TCP SYN Flood
4. **Source:** 847 unique IPs (50 в тесте)
5. **Target:** shadow-server-02.ops.internal
6. **Characteristics:**
   - Randomized source IPs (botnet)
   - High packet rate (50K pps peak)
   - Legitimate-looking SYN packets
   - No ACK completion (SYN flood signature)

**Attribution:**
- IP range 185.220.100.* связан с Krylov
- Tor exit nodes использовались для маскировки
- Атака координирована (все IP одновременно)
- Сообщение в TCP payload: "Соколов. Передай брату..."

**Рекомендации:**
- Немедленная блокировка всех обнаруженных IP
- Мониторинг на повторные атаки (IP могут меняться)
- Переход на защищённые каналы (VPN)
- Усиление forensics мониторинга

---

*"Логи не врут. Это была целенаправленная атака."* — Anna Kovaleva

---
