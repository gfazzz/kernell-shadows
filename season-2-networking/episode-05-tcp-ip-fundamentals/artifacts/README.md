# Artifacts — Episode 05: TCP/IP Fundamentals

## Содержимое

Эта папка содержит тестовые данные и конфигурационные файлы для Episode 05.

### Файлы:

#### 1. `network_map.txt`
**Описание:** Карта сети операции Виктора

**Содержимое:**
- IP адреса всех серверов операции в ЦОД "Москва-1"
- Внутренние имена хостов (*.ops.internal)
- Инфраструктурные серверы (gateway, switches, firewall)
- Мониторинг серверы (Prometheus, Grafana)

**Использование:**
```bash
# Просмотр карты сети
cat artifacts/network_map.txt

# Найти IP по hostname
grep "shadow-server-02" artifacts/network_map.txt

# Извлечь только IP адреса
awk '{print $1}' artifacts/network_map.txt | grep -E "^10\."
```

**Формат:**
```
IP_ADDRESS  HOSTNAME  DESCRIPTION
10.50.1.100  shadow-server-02.ops.internal  Viktor Primary Server (техническое имя сервера)
```

---

#### 2. `network_report.txt` (будет создан скриптом)
**Описание:** Отчёт network audit (генерируется вашим скриптом)

**Должен содержать:**
- IP адрес рабочей станции Макса
- IP сервера Viktor (shadow-server)
- Результаты ping
- Traceroute маршрут
- Открытые порты (локально и на сервере Viktor)
- Routing table

**Пример:**
```
═══════════════════════════════════════════════════════════════
           NETWORK AUDIT REPORT
═══════════════════════════════════════════════════════════════

Date:     2025-10-11 14:30:00
Operator: max_sokolov
Location: ЦОД "Москва-1", Россия

[1] WORKSTATION IP ADDRESS
    192.168.100.42

[2] VIKTOR SERVER
    Hostname: shadow-server-02.ops.internal
    IP:       10.50.1.100
    Status:   ONLINE ✓

[3] TRACEROUTE
    1  192.168.100.1  (Gateway)
    2  10.50.0.1      (ЦОД Switch)
    3  10.50.1.100    (Viktor Server)

...
```

---

## Локальная симуляция DNS

### Вариант 1: Использовать network_map.txt (рекомендуется)

Ваш скрипт может читать IP адреса из `network_map.txt`:

```bash
# В скрипте:
VIKTOR_IP=$(grep "shadow-server-02.ops.internal" artifacts/network_map.txt | awk '{print $1}')
echo "Viktor Server IP: $VIKTOR_IP"
```

### Вариант 2: Добавить в /etc/hosts (требует root)

Если хотите использовать реальные команды типа `ping shadow-server-02.ops.internal`:

```bash
# Добавить временно (требует sudo)
echo "10.50.1.100  shadow-server-02.ops.internal" | sudo tee -a /etc/hosts

# Проверка
ping -c 1 shadow-server-02.ops.internal

# Удалить после завершения эпизода
sudo sed -i '/shadow-server-02.ops.internal/d' /etc/hosts
```

**⚠️ Важно:** Не забудьте удалить эту запись после завершения эпизода!

### Вариант 3: Ping localhost (для тестирования команд)

Если не хотите редактировать `/etc/hosts`, используйте localhost для тестирования:

```bash
# localhost всегда доступен
ping -c 4 127.0.0.1

# Или Google DNS (если есть интернет)
ping -c 4 8.8.8.8
```

---

## Практика с командами

### IP адреса

```bash
# Ваш IP
ip a

# Короткий вывод (только IP)
hostname -I

# Конкретный интерфейс
ip a show eth0
```

### Ping

```bash
# Локальный ping (всегда работает)
ping -c 4 127.0.0.1

# Домашний роутер (обычно)
ping -c 4 192.168.1.1

# Google DNS (если есть интернет)
ping -c 4 8.8.8.8
```

### Traceroute

```bash
# К Google (если есть интернет)
tracepath google.com

# Или traceroute (требует sudo)
sudo traceroute google.com
```

### Открытые порты

```bash
# Все TCP и UDP listening порты
ss -tuln

# С процессами (требует sudo)
sudo ss -tulnp

# Только TCP
ss -tln
```

### Nmap сканирование

```bash
# Установка (если нет)
sudo apt install nmap

# Сканирование localhost
nmap 127.0.0.1

# Сканирование конкретных портов
nmap -p 22,80,443 127.0.0.1

# TOP-100 портов
nmap --top-ports 100 127.0.0.1

# ⚠️ Не сканируйте чужие серверы без разрешения!
```

### Routing

```bash
# Таблица маршрутизации
ip route show

# Default gateway
ip route | grep default

# Альтернатива
route -n
```

---

## Тестирование скрипта

### Шаг 1: Запустить starter.sh

```bash
cd ~/kernel-shadows/season-2-networking/episode-05-tcp-ip-fundamentals

# Сделать исполняемым
chmod +x starter.sh

# Запустить
./starter.sh
```

### Шаг 2: Проверить отчёт

```bash
# Отчёт должен быть создан
ls -lh artifacts/network_report.txt

# Прочитать отчёт
cat artifacts/network_report.txt
```

### Шаг 3: Запустить тесты

```bash
# Автотесты
./tests/test.sh
```

---

## Решение проблем

### Проблема: "ping: shadow-server-02.ops.internal: Name or service not known"

**Причина:** DNS не настроен (hostname не резолвится)

**Решение:**
1. Читайте IP из `network_map.txt` (рекомендуется)
2. Или добавьте в `/etc/hosts` (временно, с sudo)
3. Или используйте напрямую IP: `ping 10.50.1.100`

### Проблема: "ss: command not found"

**Причина:** Пакет `iproute2` не установлен

**Решение:**
```bash
sudo apt install iproute2
```

**Альтернатива:** Используйте `netstat`:
```bash
sudo apt install net-tools
netstat -tuln
```

### Проблема: "nmap: command not found"

**Причина:** nmap не установлен

**Решение:**
```bash
sudo apt install nmap
```

**Альтернатива:** Симулируйте вывод в скрипте:
```bash
echo "22/tcp  open  ssh"
echo "80/tcp  open  http"
echo "443/tcp open  https"
```

### Проблема: "traceroute: command not found"

**Причина:** Пакет не установлен

**Решение:**
```bash
# traceroute (требует sudo)
sudo apt install traceroute

# tracepath (не требует sudo, более простой)
# Обычно уже установлен в Ubuntu
```

**Альтернатива:** Симулируйте вывод

---

## Дополнительная практика

### 1. Исследуйте свою домашнюю сеть

```bash
# Найдите свой IP
ip a

# Найдите default gateway
ip route | grep default

# Ping gateway
ping -c 4 <GATEWAY_IP>

# Traceroute до Google
tracepath google.com

# Открытые порты на вашем компьютере
ss -tuln
```

### 2. Нарисуйте карту вашей сети

```
[Ваш компьютер] 192.168.1.100
       ↓
[Домашний роутер] 192.168.1.1
       ↓
[ISP Gateway] 10.0.0.1
       ↓
[Интернет]
```

### 3. Проверьте свой публичный IP

```bash
# Ваш публичный IP (как вас видит интернет)
curl ifconfig.me

# Или
curl icanhazip.com
```

### 4. Сравните с IP из `ip a`

- `ip a` показывает **локальный** IP (192.168.x.x, private)
- `curl ifconfig.me` показывает **публичный** IP (как вас видит Google)
- Разница из-за NAT (Network Address Translation) на роутере

---

## Полезные ресурсы

### Онлайн инструменты:
- [IPInfo.io](https://ipinfo.io/) — информация об IP адресах
- [Shodan.io](https://www.shodan.io/) — поисковик устройств в интернете
- [MXToolbox](https://mxtoolbox.com/) — диагностика сетей и DNS

### Визуализация:
- Попробуйте нарисовать топологию сети операции Viktor на бумаге
- Используйте `network_map.txt` как референс

### Man pages:
```bash
man ip
man ping
man traceroute
man ss
man nmap
```

---

<div align="center">

**KERNEL SHADOWS — Episode 05**

*"Каждый пакет рассказывает историю. Научись слушать."* — LILITH

**[← Episode 05 README](../README.md)**

</div>
