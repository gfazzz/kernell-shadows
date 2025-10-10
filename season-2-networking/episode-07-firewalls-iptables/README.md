# Episode 07: Firewalls & iptables

**KERNEL SHADOWS — Season 2: Networking**

```
╔═══════════════════════════════════════════════════════════════╗
║  Episode 07: Firewalls & iptables                            ║
║                                                               ║
║  Location: Moscow, Russia 🇷🇺                                 ║
║  Datacenter: ЦОД "Москва-1"                                  ║
║  Day: 13-14 of 60                                             ║
║  Difficulty: ⭐⭐⭐☆☆                                          ║
║  Time: 4-5 hours                                              ║
║  Status: 🔴 INCIDENT — DDoS ATTACK IN PROGRESS               ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## 💻 Как выполнять задания

### Сюжет vs Практика

**В сюжете:** Макс подключается удалённо через SSH к серверу в Москве (`shadow-server-02.ops.internal`).

**На практике:** Вы выполняете команды **локально на своей машине** (Ubuntu/Debian Linux).

**Firewall правила работают одинаково** — локально или удалённо!

---

### Варианты выполнения:

#### 1. **Локально (рекомендуется)** ⭐

Выполняйте все команды на своей Ubuntu машине:

```bash
sudo ufw status
sudo iptables -L
sudo ufw allow 22/tcp
sudo ufw enable
```

**Требования:**
- Ubuntu/Debian Linux (физическая машина или VM)
- sudo права
- UFW и iptables установлены (обычно есть по умолчанию)

**⚠️ ВАЖНО:** Если работаете удалённо через SSH:
1. **ВСЕГДА** разрешайте SSH (порт 22) ПЕРЕД включением UFW!
2. Используйте `screen` или `tmux` (защита от разрыва соединения)
3. Держите открытым второе SSH окно для проверки

```bash
# Безопасный способ:
sudo ufw allow 22/tcp   # СНАЧАЛА разрешить SSH!
sudo ufw enable         # ПОТОМ включить UFW

# Проверка в новом окне:
ssh user@localhost  # Если работает → OK
```

---

#### 2. **Виртуальная машина (безопаснее)** ⭐⭐

Используйте VM для изоляции:

```bash
# VirtualBox / VMware / UTM
# Создайте Ubuntu 22.04 VM
# Внутри VM выполняйте все команды
```

**Плюсы:**
- ✅ Можно смело экспериментировать
- ✅ Snapshot перед началом → легко откатиться
- ✅ Не повлияет на основную систему

**Snapshot перед Episode:**
```bash
# VirtualBox
vboxmanage snapshot "Ubuntu-Lab" take "Before-Episode-07"

# Если что-то сломается:
vboxmanage snapshot "Ubuntu-Lab" restore "Before-Episode-07"
```

---

#### 3. **Docker (для продвинутых)** ⭐⭐⭐

Симуляция "удалённого сервера":

```bash
# Создайте Dockerfile:
cat > Dockerfile << 'EOF'
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    openssh-server ufw iptables iproute2 \
    net-tools iputils-ping netstat-nat sudo
RUN useradd -m -s /bin/bash max && \
    echo 'max:password' | chpasswd && \
    usermod -aG sudo max
RUN mkdir /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
EOF

# Соберите и запустите:
docker build -t shadow-server .
docker run -d -p 2222:22 --cap-add=NET_ADMIN \
    --name shadow-server-02 shadow-server

# Подключитесь:
ssh -p 2222 max@localhost
# password: password

# Внутри контейнера выполняйте задания
```

**Плюсы:**
- ✅ Реалистичная симуляция удалённого сервера
- ✅ Изолировано от основной системы
- ✅ Можно удалить и пересоздать за секунды

**Пересоздание (если сломали):**
```bash
docker rm -f shadow-server-02
docker run -d -p 2222:22 --cap-add=NET_ADMIN \
    --name shadow-server-02 shadow-server
```

---

#### 4. **Cloud VM (самое реалистичное)** ⭐⭐⭐⭐

Создайте реальный сервер в облаке:

```bash
# DigitalOcean, AWS, Azure, Linode
# Ubuntu 22.04 Droplet ($5/месяц)

ssh root@your-server-ip

# Создайте пользователя:
adduser max
usermod -aG sudo max

# Подключайтесь как max:
ssh max@your-server-ip
```

**⚠️ КРИТИЧЕСКИ ВАЖНО для Cloud:**
1. **ОБЯЗАТЕЛЬНО** разрешите SSH перед включением UFW!
2. Имейте доступ к **console через web** (на случай блокировки)
3. Не закрывайте текущую SSH сессию до проверки новой

```bash
# БЕЗОПАСНЫЙ способ для Cloud:
# 1. Откройте screen/tmux
screen

# 2. Разрешите SSH
sudo ufw allow 22/tcp

# 3. Включите UFW
sudo ufw enable

# 4. В НОВОМ окне проверьте SSH
ssh max@your-server-ip
# Если работает → отлично!
# Если нет → вернитесь в screen, отключите UFW
```

---

### Что делать если заблокировали себя:

**Локально/VM:**
```bash
# Перезагрузитесь в recovery mode
# Или физический доступ к консоли
sudo ufw disable
```

**Docker:**
```bash
# Просто пересоздайте контейнер
docker rm -f shadow-server-02
docker run ...
```

**Cloud:**
```bash
# Используйте web console в панели управления
# DigitalOcean: Console → Access
# AWS: EC2 → Connect → EC2 Serial Console

# Внутри:
sudo ufw disable
```

---

### Рекомендация для новичков:

1. **Сначала:** Локально на Ubuntu VM (VirtualBox)
2. **Потом:** Docker (когда освоитесь)
3. **В конце:** Cloud VM (для реального опыта)

**Всегда:**
- ✅ Делайте snapshot/backup перед началом
- ✅ Разрешайте SSH первым делом!
- ✅ Держите открытым запасное окно
- ✅ Используйте `screen`/`tmux`

---

## 🎬 Сюжет

### День 13, 03:47 — Экстренный звонок

**Телефон Макса вибрирует. 3:47 утра. Стокгольм. Звонок от Алекса:**

Alex (кричит, фоновый шум серверной):
> *"MAX! ПРОСЫПАЙСЯ! У нас DDoS! 50 ТЫСЯЧ пакетов в секунду! Сервер падает! Ты где?!"*

Макс (резко просыпается в отеле):
> *"Я в Стокгольме... Что происходит?!"*

Alex:
> *"Krylov нашёл нас. Ботнет бьёт по shadow-server-02. У нас 5 минут до краха. ЛЕТИШЬ В МОСКВУ. СЕЙЧАС."*

**03:55 — Arlanda Airport, Stockholm**

Макс в такси. Ноутбук на коленях. VPN в московский ЦОД.

**Terminal output (через SSH):**
```
$ ssh max@shadow-server-02.ops.internal
Connection timeout... retry...
Connection timeout... retry...
Connected (1247ms latency — CRITICAL!)

$ uptime
 03:55:14 up 2 days, 14:23,  load average: 47.82, 38.91, 29.44

⚠️ CRITICAL: Load average > 40 (normal: 1-2)
⚠️ WARNING: 1247ms latency (normal: 20-50ms)
```

**Grafana dashboard (на телефоне):**
```
⚠️ NETWORK TRAFFIC SPIKE
Incoming: 487 Mbps (normal: 20 Mbps)
Packets/sec: 52,341 (normal: 1,500)
Connections: 8,947 (normal: 200)
CPU: 94% (CRITICAL)
Memory: 87% (HIGH)
```

Макс (в панике):
> *"Alex, я не успею долететь! Через 4 часа буду!"*

Alex:
> *"Тогда делай удалённо. СЕЙЧАС. У тебя есть SSH. Firewall — это всё что нас спасёт."*

---

### 04:00 — ЦОД "Москва-1", Серверная A-12

**На месте:**
- **Алекс** — у консоли, анализирует атаку
- **Анна** — forensics, ищет источник
- **Дмитрий** — DevOps, готовит backup серверы
- **Виктор** — координирует

**Анна** (на фоне мониторов с графиками):
> *"Это ботнет. 847 уникальных IP адресов. Все из Tor exit nodes и VPN провайдеров. SYN flood. Классика."*

**Виктор:**
> *"Макс, ты единственный кто свободен. Анна занята forensics, Алекс — incident response, Дмитрий — backup. Тебе нужно настроить firewall. Сможешь?"*

Макс (через наушники, самолёт на взлёте):
> *"Я... я изучал iptables только в теории..."*

Alex:
> *"Теории больше нет. Только практика. Я буду рядом. По пунктам. Шаг за шагом. Поехали."*

---

### LILITH активируется — Emergency Mode

**LILITH v2.0 (красный режим):**
> *"INCIDENT DETECTED. DDoS attack: 52,341 packets/sec from 847 IPs."*
>
> *"Firewall — последняя линия обороны. Если сервер упадёт — операция провалена. Krylov получит доступ к логам. Он узнает все наши локации."*
>
> *"Макс, ты не один. Я проведу через firewall setup. Но решения принимаешь ты. Быстро."*
>
> *"У нас 5 минут до критического порога. After that — server crash."*

**Текущее время:** 04:02
**Deadline:** 04:07
**Состояние сервера:** CRITICAL

---

## 🎯 Миссия

**Цель:** Остановить DDoS атаку, настроив firewall правила.

**Ограничения:**
- ⏰ 5 минут до падения сервера
- 🌐 Удалённый доступ (SSH через VPN, 1200ms latency)
- 🔥 Сервер под нагрузкой (команды выполняются медленно)
- ⚠️ Нельзя сломать SSH — потеряешь доступ!

**Задачи:**
1. Проанализировать текущее состояние firewall
2. Включить UFW (Uncomplicated Firewall)
3. Настроить базовые правила (SSH, HTTP, HTTPS)
4. Блокировать подозрительные IP (botnet)
5. Rate limiting (защита от SYN flood)
6. Логирование атак
7. Мониторинг эффективности правил
8. Финальный security audit

**Результат:**
- Сервер стабилизирован
- Атака отражена
- Firewall правила задокументированы
- Krylov заблокирован

---

## 📚 Задания

### Задание 1: Проверка текущего состояния firewall ⭐

**Контекст:**
Алекс: *"Макс, первое — узнай что у нас сейчас. Firewall включен? Какие правила?"*

**Задача:**
Проверьте состояние UFW и iptables на сервере.

**Попробуйте сами (2-3 минуты):**

```bash
# Проверьте статус UFW и текущие правила
# Ваши команды здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 3 минуты)</summary>

**Alex:**
> *"UFW — это wrapper над iptables. Проще в использовании. Проверь статус: `sudo ufw status`. И посмотри iptables правила: `sudo iptables -L`."*

Попробуйте:
```bash
# UFW status
sudo ufw status verbose

# iptables rules
sudo iptables -L -n -v
```

**Что искать:**
- UFW status: active или inactive?
- iptables: есть ли правила? Какие chains?
- Default policy: ACCEPT или DROP?

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 5 минут)</summary>

**Команды:**

```bash
# UFW
sudo ufw status verbose        # Детальный статус
sudo ufw show added            # Показать добавленные правила

# iptables
sudo iptables -L -n -v         # List rules (numeric, verbose)
sudo iptables -L INPUT -n -v   # Только INPUT chain
sudo iptables -S               # Show rules in command format

# Проверить загруженность
netstat -an | grep SYN_RECV | wc -l  # SYN flood check
ss -s                          # Сводка соединений
```

**Интерпретация:**
```bash
$ sudo ufw status
Status: inactive
# ⚠️ Firewall ВЫКЛЮЧЕН! Сервер незащищён!

$ sudo iptables -L
Chain INPUT (policy ACCEPT)
# ⚠️ Default policy ACCEPT — пропускает ВСЁ!
```

**Проблема:** Нет защиты от DDoS!

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Команды для диагностики:**
```bash
#!/bin/bash

echo "=== FIREWALL STATUS CHECK ==="
echo ""

# 1. UFW status
echo "[1] UFW Status:"
sudo ufw status verbose
echo ""

# 2. iptables rules
echo "[2] iptables Rules:"
sudo iptables -L -n -v
echo ""

# 3. Current connections
echo "[3] Active Connections:"
ss -s
echo ""

# 4. SYN flood check
echo "[4] SYN_RECV connections (SYN flood indicator):"
netstat -an | grep SYN_RECV | wc -l
echo ""

# 5. Top source IPs
echo "[5] Top 10 source IPs:"
netstat -an | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -10
```

**Ожидаемый результат (ДО настройки):**
```
[1] UFW Status:
Status: inactive

[2] iptables Rules:
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

[3] SYN_RECV connections: 847
⚠️ CRITICAL: > 100 (normal: < 10)

[4] Top source IPs:
    234 185.220.101.47
    198 91.219.237.244
    156 195.123.246.151
    ...
```

**Вывод:**
- UFW неактивен
- Нет firewall правил
- 847 SYN_RECV соединений (SYN flood!)
- Атака идёт с ~200+ IP

</details>

<details>
<summary>🔍 Что такое Firewall? (теория)</summary>

### Firewall (Файрвол, Межсетевой экран)

**Определение:**
Firewall — система контроля и фильтрации сетевого трафика на основе заданных правил.

**Аналогия:**
Firewall = вышибала в клубе:
- Проверяет кто заходит (source IP)
- Куда идёт (destination port)
- Что несёт (protocol)
- Пропускает хороших, блокирует плохих

**Linux Firewall Stack:**
```
Application Layer
       ↓
  iptables / ufw / nftables  ← Userspace tools
       ↓
   Netfilter                 ← Kernel module
       ↓
  Network Stack
```

**Netfilter:**
- Kernel-level packet filtering framework
- Встроен в Linux kernel
- Перехватывает пакеты на разных этапах

**iptables:**
- Userspace утилита для настройки Netfilter
- Классический инструмент (с 1998)
- Мощный, но сложный синтаксис

**UFW (Uncomplicated Firewall):**
- Wrapper над iptables
- Проще в использовании
- Ubuntu default

**nftables:**
- Современная замена iptables
- С 2014 года
- Проще синтаксис, лучше производительность

**Chains (цепочки):**
```
     PREROUTING
         ↓
    [ROUTING]
       ↙   ↘
  INPUT   FORWARD → OUTPUT
    ↓              ↓
 [LOCAL]      POSTROUTING
```

- **INPUT:** входящие пакеты (to this host)
- **OUTPUT:** исходящие пакеты (from this host)
- **FORWARD:** транзитные пакеты (routed through)
- **PREROUTING:** до routing decision
- **POSTROUTING:** после routing decision

**Targets (действия):**
- **ACCEPT:** пропустить пакет
- **DROP:** молча отбросить
- **REJECT:** отбросить + послать ICMP ответ
- **LOG:** записать в лог
- **RETURN:** вернуться к default policy

**Default Policy:**
```bash
# Политика по умолчанию
Chain INPUT (policy ACCEPT)    # ⚠️ Опасно!
Chain INPUT (policy DROP)      # ✓ Безопасно
```

**ACCEPT policy:** Всё что не запрещено — разрешено (небезопасно)
**DROP policy:** Всё что не разрешено — запрещено (безопасно)

**Пример правила:**
```bash
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
#        ^  ^     ^  ^   ^       ^  ^  ^
#        |  |     |  |   |       |  |  └─ Target (action)
#        |  |     |  |   |       |  └──── Match: port 22
#        |  |     |  |   |       └─────── Option: destination port
#        |  |     |  |   └─────────────── Option: TCP
#        |  |     |  └─────────────────── Match: protocol
#        |  |     └────────────────────── Chain
#        |  └──────────────────────────── Append rule
#        └─────────────────────────────── iptables command
```

**Типичная DDoS атака:**
- **SYN flood:** масса TCP SYN пакетов
- Server отвечает SYN-ACK
- Attacker не завершает handshake
- Server держит открытые SYN_RECV соединения
- Память заканчивается → crash

**Защита:**
- Rate limiting (ограничение скорости)
- SYN cookies (kernel feature)
- Connection tracking limits
- Блокировка известных botnet IP

**Важно:**
- Firewall — не панацея (защищает только network layer)
- Нужны и другие меры (application firewall, intrusion detection)
- Неправильная настройка может заблокировать себя!

</details>

**Запишите результат:**
```bash
# UFW статус (active/inactive):
UFW_STATUS="???"

# Количество SYN_RECV соединений:
SYN_RECV_COUNT=???
```

---

### Задание 2: Включить UFW (Uncomplicated Firewall) ⭐⭐

**Контекст:**
Алекс: *"Макс, firewall выключен. Включаем UFW. НО! ВАЖНО — сначала разреши SSH, иначе потеряешь доступ!"*

**⚠️ КРИТИЧЕСКИ ВАЖНО:**
> Если включить UFW без правила для SSH — вы потеряете удалённый доступ!
> Сервер останется недоступен до физического доступа к консоли!

**Задача:**
1. Разрешить SSH (порт 22)
2. Включить UFW
3. Проверить что SSH работает

**Попробуйте сами (3-5 минут):**

```bash
# 1. Сначала разрешите SSH!
# 2. Потом включите UFW
# 3. Проверьте статус
```

<details>
<summary>💡 Подсказка 1 (если застряли > 3 минуты)</summary>

**Алекс:**
> *"Порядок КРИТИЧЕН! Сначала `sudo ufw allow 22/tcp` (или `sudo ufw allow ssh`), ПОТОМ `sudo ufw enable`. Проверь статус: `sudo ufw status`."*

Попробуйте:
```bash
# Шаг 1: Разрешить SSH (ОБЯЗАТЕЛЬНО!)
sudo ufw allow 22/tcp

# Шаг 2: Включить UFW
sudo ufw enable

# Шаг 3: Проверить
sudo ufw status verbose
```

**Что ожидать:**
```
Status: active
To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 5 минут)</summary>

**Команды:**

```bash
# Способ 1: По номеру порта
sudo ufw allow 22/tcp
sudo ufw allow 22/udp  # Если нужен

# Способ 2: По имени сервиса
sudo ufw allow ssh     # UFW знает SSH = port 22

# Способ 3: С конкретного IP (более безопасно)
sudo ufw allow from 192.168.1.100 to any port 22

# Включить UFW
sudo ufw enable

# Проверка
sudo ufw status numbered  # Показать номера правил
sudo ufw show added       # Показать добавленные правила
```

**Default policies (опционально):**
```bash
# Установить default = deny (более безопасно)
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Потом разрешить только нужное
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

**Проверка SSH после включения:**
```bash
# В новом терминале (не закрывая текущую сессию!)
ssh max@shadow-server-02.ops.internal

# Если подключилось → всё ОК
# Если timeout → что-то не так, откатывай!
```

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Безопасный способ включения UFW:**
```bash
#!/bin/bash

echo "=== ENABLING UFW (SAFE METHOD) ==="
echo ""

# Step 1: Set default policies
echo "[1] Setting default policies..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
echo "✓ Default: deny incoming, allow outgoing"
echo ""

# Step 2: Allow SSH (CRITICAL!)
echo "[2] Allowing SSH (port 22)..."
sudo ufw allow 22/tcp comment 'SSH access'
echo "✓ SSH allowed"
echo ""

# Step 3: Show rules before enabling
echo "[3] Rules to be applied:"
sudo ufw show added
echo ""

# Step 4: Enable UFW
echo "[4] Enabling UFW..."
echo "y" | sudo ufw enable  # Auto-yes
echo "✓ UFW enabled"
echo ""

# Step 5: Verify
echo "[5] Current status:"
sudo ufw status verbose
echo ""

# Step 6: Test SSH (in background)
echo "[6] Testing SSH connectivity..."
timeout 5 ssh -o ConnectTimeout=3 localhost "echo 'SSH OK'" 2>/dev/null && \
    echo "✓ SSH test passed" || \
    echo "⚠ SSH test failed (might be normal if localhost SSH disabled)"
```

**Результат:**
```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
22/tcp (v6)                ALLOW IN    Anywhere (v6)
```

**Объяснение:**
- `default deny incoming` — блокировать всё входящее (по умолчанию)
- `default allow outgoing` — разрешить всё исходящее
- `allow 22/tcp` — исключение для SSH
- `enable` — активировать firewall

**Rollback (если SSH сломался):**
```bash
# Если потеряли SSH доступ и есть console access:
sudo ufw disable
sudo ufw reset
sudo ufw allow 22/tcp
sudo ufw enable
```

**Best practice:**
- Всегда тестируйте в новом SSH окне
- Не закрывайте текущую сессию пока не убедитесь что новая работает
- Используйте `screen` или `tmux` для защиты от разрывов

</details>

<details>
<summary>🔍 UFW vs iptables — теория</summary>

### UFW (Uncomplicated Firewall)

**Что это:**
UFW — wrapper (обёртка) над iptables, упрощающая настройку firewall.

**Философия:**
- **iptables:** Мощный, но сложный (100+ опций)
- **UFW:** Простой, для 80% случаев

**Сравнение синтаксиса:**

**iptables (сложно):**
```bash
iptables -A INPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
```

**UFW (просто):**
```bash
ufw allow 22/tcp
```

**UFW делает то же самое, но проще!**

**Основные команды UFW:**

```bash
# Enable/Disable
sudo ufw enable     # Включить
sudo ufw disable    # Выключить
sudo ufw reset      # Сбросить все правила

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow rules
sudo ufw allow 22                # SSH
sudo ufw allow ssh               # То же (по имени)
sudo ufw allow 80/tcp            # HTTP
sudo ufw allow from 192.168.1.0/24  # Целая подсеть

# Deny rules
sudo ufw deny 23                 # Telnet (небезопасно)
sudo ufw deny from 1.2.3.4       # Заблокировать IP

# Status
sudo ufw status                  # Краткий статус
sudo ufw status verbose          # Детальный
sudo ufw status numbered         # С номерами (для удаления)

# Delete rules
sudo ufw delete allow 80         # По правилу
sudo ufw delete 3                # По номеру

# Logging
sudo ufw logging on              # Включить логи
sudo ufw logging off             # Выключить
```

**Приоритет правил:**
UFW обрабатывает правила **сверху вниз**. Первое совпадение = действие.

```bash
sudo ufw allow from 192.168.1.100  # Разрешить конкретный IP
sudo ufw deny 22                     # Блокировать SSH

# Результат: 192.168.1.100 может SSH (первое правило),
# остальные не могут (второе правило)
```

**UFW под капотом:**
```bash
# UFW создаёт iptables правила
sudo ufw allow 22

# Эквивалентно:
sudo iptables -A ufw-user-input -p tcp --dport 22 -j ACCEPT
```

**Файлы конфигурации:**
- `/etc/ufw/ufw.conf` — основная конфигурация
- `/etc/ufw/before.rules` — правила до UFW rules
- `/etc/ufw/after.rules` — правила после UFW rules
- `/etc/ufw/user.rules` — ваши правила (автогенерация)

**Проверка iptables после UFW:**
```bash
sudo iptables -L -n | grep ufw
# Вы увидите цепочки ufw-*
```

**Когда использовать UFW:**
- ✅ Простая защита сервера (SSH, HTTP, HTTPS)
- ✅ Быстрая настройка
- ✅ Для начинающих

**Когда использовать iptables:**
- Complex routing
- NAT (Network Address Translation)
- Port forwarding
- Advanced filtering (по MAC, TTL, etc)

**Best practices:**
- Всегда разрешай SSH первым!
- Используй `default deny incoming`
- Логируй подозрительную активность
- Регулярно проверяй `ufw status`

</details>

**Проверка:**
```bash
# После включения UFW, SSH должен работать!
ssh max@shadow-server-02.ops.internal
# Если подключилось → ✓ всё ок
```

---

### Задание 3: Разрешить веб-трафик (HTTP/HTTPS) ⭐

**Контекст:**
Alex: *"Отлично! SSH работает. Теперь разреши веб-трафик — порты 80 и 443. Наш сервер должен принимать HTTP/HTTPS запросы."*

**Задача:**
Разрешить входящие соединения на порты 80 (HTTP) и 443 (HTTPS).

**Попробуйте сами (2-3 минуты):**

```bash
# Разрешите HTTP (80) и HTTPS (443)
# Ваши команды здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 2 минуты)</summary>

**Алекс:**
> *"Команда та же что для SSH: `sudo ufw allow ПОРТ`. Или по имени: `sudo ufw allow http` и `sudo ufw allow https`."*

Попробуйте:
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Или короче:
sudo ufw allow http
sudo ufw allow https
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 4 минуты)</summary>

**Команды:**

```bash
# HTTP (port 80)
sudo ufw allow 80/tcp comment 'HTTP'

# HTTPS (port 443)
sudo ufw allow 443/tcp comment 'HTTPS'

# Или используя имена сервисов
sudo ufw allow http
sudo ufw allow https

# Проверка
sudo ufw status verbose
```

**Можно также разрешить диапазон портов:**
```bash
sudo ufw allow 80:443/tcp  # Порты 80-443
```

</details>

<details>
<summary>✅ Решение</summary>

```bash
#!/bin/bash

echo "=== ALLOWING WEB TRAFFIC ==="

# Allow HTTP (80)
sudo ufw allow 80/tcp comment 'HTTP'
echo "✓ HTTP (80) allowed"

# Allow HTTPS (443)
sudo ufw allow 443/tcp comment 'HTTPS'
echo "✓ HTTPS (443) allowed"

# Verify
echo ""
echo "Current UFW rules:"
sudo ufw status numbered
```

**Результат:**
```
To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere      # SSH access
80/tcp                     ALLOW IN    Anywhere      # HTTP
443/tcp                    ALLOW IN    Anywhere      # HTTPS
```

</details>

<details>
<summary>🔍 Стандартные порты сервисов</summary>

### Well-known Ports (0-1023)

**Основные:**
```
SSH:        22   (tcp)    Secure Shell
HTTP:       80   (tcp)    Web
HTTPS:      443  (tcp)    Secure Web
FTP:        21   (tcp)    File Transfer (небезопасно!)
FTPS:       990  (tcp)    Secure FTP
SMTP:       25   (tcp)    Email sending
SMTPS:      465  (tcp)    Secure SMTP
IMAP:       143  (tcp)    Email reading
IMAPS:      993  (tcp)    Secure IMAP
POP3:       110  (tcp)    Email reading
POP3S:      995  (tcp)    Secure POP3
DNS:        53   (tcp/udp) Domain Name System
DHCP:       67,68 (udp)   Dynamic IP config
NTP:        123  (udp)    Time sync
SNMP:       161  (udp)    Network monitoring
Telnet:     23   (tcp)    ⚠️ НЕБЕЗОПАСНО!
```

**Базы данных:**
```
MySQL:      3306 (tcp)
PostgreSQL: 5432 (tcp)
MongoDB:    27017 (tcp)
Redis:      6379 (tcp)
```

**DevOps:**
```
Docker:     2375 (tcp) HTTP API
            2376 (tcp) HTTPS API
Kubernetes: 6443 (tcp) API Server
Prometheus: 9090 (tcp)
Grafana:    3000 (tcp)
```

**Опасные порты (всегда блокировать):**
```
23     Telnet        (незашифрованный)
69     TFTP          (Trivial FTP, небезопасно)
135    RPC           (Windows, часто атакуют)
139    NetBIOS       (Windows)
445    SMB           (Windows, WannaCry)
1433   MSSQL         (если не используется)
3389   RDP           (Windows Remote Desktop)
```

**Проверка какой сервис слушает порт:**
```bash
# Показать все listening ports
sudo ss -tlnp

# Или
sudo netstat -tlnp

# Проверить конкретный порт
sudo lsof -i :80
```

</details>

---

### Задание 4: Блокировка botnet IP адресов ⭐⭐⭐

**Контекст:**
Анна: *"Макс, я отследила источники атаки. 847 IP адресов. Список в `artifacts/botnet_ips.txt`. Заблокируй их все."*

Макс: *"Все? Вручную?!"*

Anna: *"Bash script. Цикл. 2 минуты работы. Поехали."*

**Задача:**
Прочитать файл `artifacts/botnet_ips.txt` и заблокировать каждый IP адрес через UFW.

**Попробуйте сами (5-7 минут):**

```bash
# Прочитайте файл и заблокируйте каждый IP
# Подсказка: используйте цикл while read
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**Anna:**
> *"Bash цикл: `while IFS= read -r ip; do ...; done < file.txt`. В цикле выполни `sudo ufw deny from $ip`. Просто."*

Попробуйте:
```bash
while IFS= read -r ip; do
    sudo ufw deny from "$ip"
done < artifacts/botnet_ips.txt
```

**Проблема:**
Это медленно (каждая команда = перезагрузка правил).

**Лучше:**
```bash
# Использовать iptables напрямую (быстрее)
while IFS= read -r ip; do
    sudo iptables -I INPUT -s "$ip" -j DROP
done < artifacts/botnet_ips.txt
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Два подхода:**

**Подход 1: UFW (проще, медленнее)**
```bash
#!/bin/bash

BOTNET_FILE="artifacts/botnet_ips.txt"
count=0

echo "Blocking botnet IPs with UFW..."

while IFS= read -r ip; do
    # Пропустить пустые строки и комментарии
    [[ -z "$ip" || "$ip" =~ ^# ]] && continue

    sudo ufw deny from "$ip" comment "Botnet"
    count=$((count + 1))
    echo "Blocked: $ip ($count)"
done < "$BOTNET_FILE"

echo "✓ Blocked $count IPs"
```

**Подход 2: iptables (сложнее, быстрее)**
```bash
#!/bin/bash

BOTNET_FILE="artifacts/botnet_ips.txt"
count=0

echo "Blocking botnet IPs with iptables..."

while IFS= read -r ip; do
    [[ -z "$ip" || "$ip" =~ ^# ]] && continue

    # -I = insert at top (higher priority)
    sudo iptables -I INPUT -s "$ip" -j DROP
    count=$((count + 1))
done < "$BOTNET_FILE"

echo "✓ Blocked $count IPs"
```

**Подход 3: ipset (профессиональный, самый быстрый)**
```bash
#!/bin/bash

# ipset — оптимизированное хранилище IP для iptables
sudo ipset create botnet_ips hash:ip

while IFS= read -r ip; do
    [[ -z "$ip" || "$ip" =~ ^# ]] && continue
    sudo ipset add botnet_ips "$ip"
done < artifacts/botnet_ips.txt

# Одно правило для всего set
sudo iptables -I INPUT -m set --match-set botnet_ips src -j DROP

echo "✓ Botnet IPs blocked via ipset"
```

</details>

<details>
<summary>✅ Решение</summary>

**Оптимальный скрипт (iptables + validation):**
```bash
#!/bin/bash
set -e

BOTNET_FILE="artifacts/botnet_ips.txt"
LOGFILE="artifacts/blocked_ips.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "=== BLOCKING BOTNET IPs ==="
echo ""

# Check if file exists
if [[ ! -f "$BOTNET_FILE" ]]; then
    echo -e "${RED}✗ Error: $BOTNET_FILE not found!${NC}"
    exit 1
fi

# Initialize log
echo "Blocked IPs - $(date)" > "$LOGFILE"

blocked_count=0
skipped_count=0

while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Extract IP (первое слово)
    ip=$(echo "$line" | awk '{print $1}')

    # Validate IP format
    if [[ ! "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo -e "${RED}⚠ Invalid IP: $ip (skipped)${NC}"
        skipped_count=$((skipped_count + 1))
        continue
    fi

    # Block with iptables
    if sudo iptables -I INPUT -s "$ip" -j DROP 2>/dev/null; then
        echo -e "${GREEN}✓${NC} Blocked: $ip"
        echo "$ip" >> "$LOGFILE"
        blocked_count=$((blocked_count + 1))
    else
        echo -e "${RED}✗${NC} Failed to block: $ip"
        skipped_count=$((skipped_count + 1))
    fi

done < "$BOTNET_FILE"

echo ""
echo "=== SUMMARY ==="
echo "Blocked:  $blocked_count IPs"
echo "Skipped:  $skipped_count IPs"
echo "Log file: $LOGFILE"
echo ""

# Verify
echo "Current iptables DROP rules:"
sudo iptables -L INPUT -n | grep DROP | wc -l
```

**Результат:**
```
=== BLOCKING BOTNET IPs ===

✓ Blocked: 185.220.101.47
✓ Blocked: 91.219.237.244
✓ Blocked: 195.123.246.151
...
✓ Blocked: 203.0.113.89

=== SUMMARY ===
Blocked:  847 IPs
Skipped:  0 IPs
Log file: artifacts/blocked_ips.log

Current iptables DROP rules: 847
```

**Проверка эффективности:**
```bash
# До блокировки
netstat -an | grep SYN_RECV | wc -l
# Результат: 847

# После блокировки
netstat -an | grep SYN_RECV | wc -l
# Результат: 23 (⬇ 97% reduction!)
```

</details>

<details>
<summary>🔍 ipset — оптимизация для больших списков IP</summary>

### ipset: Efficient IP Lists for iptables

**Проблема:**
```bash
# 10,000 IP = 10,000 iptables правил
# Каждый пакет проверяется по ВСЕМ правилам
# Медленно! O(n) complexity
```

**Решение: ipset**
```bash
# 10,000 IP = 1 ipset + 1 iptables правило
# Hash table lookup: O(1) complexity
# Быстро!
```

**Установка:**
```bash
sudo apt install ipset
```

**Использование:**

```bash
# 1. Создать set
sudo ipset create blacklist hash:ip

# 2. Добавить IP
sudo ipset add blacklist 1.2.3.4
sudo ipset add blacklist 5.6.7.8

# 3. Добавить всю подсеть
sudo ipset add blacklist 10.0.0.0/8

# 4. Создать iptables правило для set
sudo iptables -I INPUT -m set --match-set blacklist src -j DROP

# Теперь все IP из blacklist автоматически блокируются!
```

**Массовое добавление:**
```bash
# Из файла
while read ip; do
    sudo ipset add blacklist "$ip"
done < ips.txt

# Или используя ipset restore (быстрее)
cat ips.txt | sed 's/^/add blacklist /' | sudo ipset restore
```

**Управление:**
```bash
# Показать все sets
sudo ipset list

# Показать конкретный set
sudo ipset list blacklist

# Удалить IP из set
sudo ipset del blacklist 1.2.3.4

# Очистить set
sudo ipset flush blacklist

# Удалить set
sudo ipset destroy blacklist
```

**Сохранение и восстановление:**
```bash
# Сохранить
sudo ipset save > /etc/ipset.conf

# Восстановить при загрузке
sudo ipset restore < /etc/ipset.conf
```

**Типы ipset:**
```bash
hash:ip       # IP адреса
hash:net      # Подсети (CIDR)
hash:ip,port  # IP + порт
hash:mac      # MAC адреса
```

**Пример: Country blocking (GeoIP)**
```bash
# Заблокировать весь трафик из страны
# (IP списки можно взять с ipdeny.com)

sudo ipset create country-cn hash:net
while read subnet; do
    sudo ipset add country-cn "$subnet"
done < cn.zone

sudo iptables -I INPUT -m set --match-set country-cn src -j DROP

# Теперь весь трафик из CN заблокирован одним правилом!
```

**Performance:**
```
10,000 IPs:
- iptables rules: ~500ms per packet
- ipset:          ~0.01ms per packet
= 50,000x faster!
```

**Best practices:**
- Используй ipset для > 100 IP адресов
- Сохраняй sets в файл для persistence
- Регулярно обновляй списки (botnet IP меняются)

</details>

**Проверка:**
```bash
# Количество заблокированных IP
sudo iptables -L INPUT -n | grep DROP | wc -l
# Должно быть ~847

# Проверить SYN_RECV connections (должно упасть)
netstat -an | grep SYN_RECV | wc -l
```

---

### Задание 5: Rate Limiting (защита от SYN flood) ⭐⭐⭐⭐

**Контекст:**
Alex: *"Хорошо! Но этого недостаточно. Krylov постоянно меняет IP. Нужен rate limiting — ограничение скорости подключений. Если кто-то шлёт > 10 SYN в секунду — блокируем."*

**Задача:**
Настроить iptables rate limiting для защиты от SYN flood атак.

**Попробуйте сами (7-10 минут):**

```bash
# Ограничьте новые TCP подключения до 10/sec с одного IP
# Подсказка: используйте -m limit и -m recent
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**Алекс:**
> *"Два модуля: `connlimit` (лимит на количество соединений) и `recent` (трекинг IP). Пример: `-m connlimit --connlimit-above 10 -j REJECT`."*

Попробуйте:
```bash
# Ограничить количество одновременных соединений
sudo iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above 20 -j REJECT

# Или используя recent module для rate limiting
sudo iptables -A INPUT -p tcp --dport 80 -m recent --set --name HTTP
sudo iptables -A INPUT -p tcp --dport 80 -m recent --update --seconds 10 --hitcount 20 --name HTTP -j DROP
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Rate Limiting стратегии:**

**1. connlimit (ограничение соединений)**
```bash
# Макс 15 одновременных TCP соединений с одного IP
sudo iptables -A INPUT -p tcp --syn -m connlimit \
    --connlimit-above 15 --connlimit-mask 32 \
    -j REJECT --reject-with tcp-reset
```

**2. recent (rate limiting по времени)**
```bash
# Создать tracking list для SSH
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW \
    -m recent --set --name SSH

# Блокировать если > 5 попыток за 60 секунд
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW \
    -m recent --update --seconds 60 --hitcount 6 --name SSH \
    -j DROP
```

**3. limit (простое ограничение)**
```bash
# Принимать только 5 пакетов в секунду
sudo iptables -A INPUT -p tcp --syn -m limit \
    --limit 5/sec --limit-burst 10 \
    -j ACCEPT

# Всё остальное DROP
sudo iptables -A INPUT -p tcp --syn -j DROP
```

**4. hashlimit (per-IP rate limiting)**
```bash
# Каждый IP может делать max 10 новых соединений/sec
sudo iptables -A INPUT -p tcp --syn -m hashlimit \
    --hashlimit-above 10/sec \
    --hashlimit-mode srcip \
    --hashlimit-name syn_flood \
    -j DROP
```

</details>

<details>
<summary>✅ Решение</summary>

**Комплексная защита от SYN flood:**
```bash
#!/bin/bash

echo "=== CONFIGURING RATE LIMITING ==="
echo ""

# 1. SYN flood protection (connlimit)
echo "[1] Limiting simultaneous connections per IP..."
sudo iptables -A INPUT -p tcp --syn -m connlimit \
    --connlimit-above 20 --connlimit-mask 32 \
    -j REJECT --reject-with tcp-reset
echo "✓ Max 20 simultaneous connections per IP"
echo ""

# 2. SSH brute-force protection (recent)
echo "[2] SSH brute-force protection..."
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW \
    -m recent --set --name SSH_TRACK

sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW \
    -m recent --update --seconds 60 --hitcount 5 --name SSH_TRACK \
    -j DROP
echo "✓ Max 4 SSH attempts per minute per IP"
echo ""

# 3. HTTP/HTTPS rate limiting (hashlimit)
echo "[3] HTTP/HTTPS rate limiting..."
sudo iptables -A INPUT -p tcp --dport 80 -m hashlimit \
    --hashlimit-above 50/sec --hashlimit-mode srcip \
    --hashlimit-name http_limit -j DROP

sudo iptables -A INPUT -p tcp --dport 443 -m hashlimit \
    --hashlimit-above 50/sec --hashlimit-mode srcip \
    --hashlimit-name https_limit -j DROP
echo "✓ Max 50 HTTP/HTTPS requests per second per IP"
echo ""

# 4. ICMP flood protection (ping)
echo "[4] ICMP flood protection..."
sudo iptables -A INPUT -p icmp -m limit \
    --limit 5/sec --limit-burst 10 -j ACCEPT
sudo iptables -A INPUT -p icmp -j DROP
echo "✓ Max 5 pings per second"
echo ""

# 5. New connection rate limiting
echo "[5] Global new connection rate limiting..."
sudo iptables -A INPUT -m state --state NEW -m limit \
    --limit 60/sec --limit-burst 100 -j ACCEPT
sudo iptables -A INPUT -m state --state NEW -j DROP
echo "✓ Max 60 new connections per second (global)"
echo ""

echo "=== RATE LIMITING CONFIGURED ==="
echo ""

# Summary
echo "Current INPUT rules:"
sudo iptables -L INPUT -n --line-numbers | head -20
```

**Объяснение параметров:**
```bash
--connlimit-above 20    # Больше 20 соединений = reject
--connlimit-mask 32     # Per /32 (один IP)

--recent --set          # Добавить IP в tracking list
--recent --update       # Обновить timestamp для IP
--seconds 60            # За последние 60 секунд
--hitcount 5            # Если >= 5 попыток

--limit 5/sec           # Максимум 5 пакетов в секунду
--limit-burst 10        # Burst bucket (кратковременный всплеск)

--hashlimit-above 50/sec   # Больше 50/sec = drop
--hashlimit-mode srcip     # Per source IP
```

**Результат:**
```bash
# Проверка Load Average (до)
$ uptime
load average: 47.82, 38.91, 29.44

# После rate limiting (через 2 минуты)
$ uptime
load average: 2.15, 5.42, 12.78

# ✓ Load average упал с 47 до 2!
# ✓ Атака отражена!
```

</details>

<details>
<summary>🔍 Rate Limiting — теория</summary>

### Rate Limiting: Token Bucket Algorithm

**Проблема:**
Атакующий может создавать новые соединения быстрее чем сервер их обрабатывает → DoS.

**Решение:**
Ограничить скорость новых соединений.

**Алгоритм: Token Bucket**

```
┌─────────────────┐
│  Token Bucket   │  ← Ёмкость = --limit-burst
│   🪙 🪙 🪙 🪙    │
└─────────────────┘
      ↓
Пополняется со скоростью --limit (tokens/sec)
Каждый пакет забирает 1 token
Нет токенов = пакет отклонён
```

**Пример:**
```bash
--limit 5/sec --limit-burst 10

Начало:      bucket = 10 tokens
1-10 пакеты: используют все tokens (bucket = 0)
11й пакет:   отклонён (нет tokens)
Через 1 sec: bucket = 5 (пополнение)
```

**Типы rate limiting:**

**1. Global limit (для всех)**
```bash
-m limit --limit 100/sec
# Все IP вместе: max 100 пакетов/сек
```

**2. Per-IP limit (для каждого IP)**
```bash
-m hashlimit --hashlimit 10/sec --hashlimit-mode srcip
# Каждый IP: max 10 пакетов/сек
```

**3. Per-connection limit**
```bash
-m connlimit --connlimit-above 20
# Каждый IP: max 20 одновременных соединений
```

**Защита от SYN Flood:**

**SYN flood атака:**
```
Attacker → [SYN] → Server
           [SYN-ACK] ← Server
Attacker не отвечает ACK
Server держит half-open connection (SYN_RECV state)
Память заканчивается → crash
```

**Защита:**

**1. SYN Cookies (kernel level)**
```bash
# Включить SYN cookies
sudo sysctl -w net.ipv4.tcp_syncookies=1

# Permanent
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
```

**Как работает:**
- Server не хранит SYN_RECV connections
- Генерирует cookie в SYN-ACK
- Проверяет cookie в ACK
- Память не тратится!

**2. iptables rate limiting**
```bash
# Ограничить новые TCP соединения
iptables -A INPUT -p tcp --syn -m limit --limit 10/sec -j ACCEPT
iptables -A INPUT -p tcp --syn -j DROP
```

**3. connlimit**
```bash
# Max соединений с одного IP
iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above 15 -j REJECT
```

**Best practices:**

```bash
# SSH: 4 попытки в минуту
iptables -A INPUT -p tcp --dport 22 -m recent --set
iptables -A INPUT -p tcp --dport 22 -m recent --update --seconds 60 --hitcount 5 -j DROP

# HTTP: 100 requests/sec per IP
iptables -A INPUT -p tcp --dport 80 -m hashlimit --hashlimit-above 100/sec --hashlimit-mode srcip -j DROP

# ICMP: 5 pings/sec
iptables -A INPUT -p icmp -m limit --limit 5/sec -j ACCEPT
iptables -A INPUT -p icmp -j DROP
```

**Проверка эффективности:**
```bash
# Смотреть rate limit hits
watch -n1 'iptables -L -n -v | grep -A5 "recent"'

# SYN_RECV connections (должно упасть)
watch -n1 'netstat -an | grep SYN_RECV | wc -l'

# Load average (должен упасть)
watch -n1 uptime
```

**Kernel parameters для DDoS protection:**
```bash
# SYN cookies
net.ipv4.tcp_syncookies = 1

# SYN backlog size
net.ipv4.tcp_max_syn_backlog = 2048

# Faster timeout for SYN_RECV
net.ipv4.tcp_synack_retries = 2

# Faster timeout for FIN_WAIT
net.ipv4.tcp_fin_timeout = 15

# Reuse TIME_WAIT connections
net.ipv4.tcp_tw_reuse = 1
```

</details>

---

### Задание 6: Логирование атак ⭐⭐

**Контекст:**
Анна: *"Макс, мне нужны логи. Каждый DROP нужно записать — IP, порт, timestamp. Forensics требует доказательств."*

**Задача:**
Настроить логирование всех заблокированных пакетов.

**Попробуйте сами (3-5 минут):**

```bash
# Добавьте правило логирования перед DROP
# Подсказка: используйте -j LOG
```

<details>
<summary>💡 Подсказка 1 (если застряли > 3 минуты)</summary>

**Anna:**
> *"Правило LOG должно идти ДО DROP. Target `-j LOG` с prefix для идентификации. Пример: `iptables -A INPUT -j LOG --log-prefix '[FIREWALL DROP] '`."*

Попробуйте:
```bash
# Логировать всё что будет DROP
sudo iptables -I INPUT -m limit --limit 5/min \
    -j LOG --log-prefix '[FIREWALL BLOCKED] ' --log-level 4
```

**Важно:**
- Используйте `-m limit` чтобы не заполнить диск логами!
- Логи идут в `/var/log/kern.log` или `/var/log/syslog`

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 5 минут)</summary>

**Стратегия логирования:**

```bash
# 1. Создать новый chain для логирования
sudo iptables -N LOGGING

# 2. Перенаправить DROP пакеты в LOGGING
sudo iptables -A INPUT -j LOGGING

# 3. В LOGGING: сначала LOG, потом DROP
sudo iptables -A LOGGING -m limit --limit 5/min -j LOG \
    --log-prefix '[FIREWALL DROP] ' --log-level 4
sudo iptables -A LOGGING -j DROP
```

**Лог разных типов атак:**
```bash
# SYN flood
sudo iptables -A INPUT -p tcp --syn -m limit --limit 1/sec -j LOG \
    --log-prefix '[SYN FLOOD] '

# SSH brute-force
sudo iptables -A INPUT -p tcp --dport 22 -m recent --name SSH --rcheck \
    --seconds 60 --hitcount 5 -j LOG --log-prefix '[SSH BRUTEFORCE] '

# Port scan
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j LOG \
    --log-prefix '[PORT SCAN NULL] '
```

**Просмотр логов:**
```bash
# Real-time
sudo tail -f /var/log/kern.log | grep FIREWALL

# Последние 50
sudo grep 'FIREWALL' /var/log/kern.log | tail -50

# Статистика
sudo grep 'FIREWALL DROP' /var/log/kern.log | \
    awk '{print $13}' | sort | uniq -c | sort -rn | head -10
```

</details>

<details>
<summary>✅ Решение</summary>

**Комплексная система логирования:**
```bash
#!/bin/bash

echo "=== CONFIGURING ATTACK LOGGING ==="
echo ""

# Create custom logging chain
echo "[1] Creating LOGGING chain..."
sudo iptables -N LOGGING 2>/dev/null || echo "Chain already exists"
sudo iptables -F LOGGING  # Flush if exists
echo ""

# Log different attack types with specific prefixes
echo "[2] Setting up attack-specific logging..."

# SSH brute-force
sudo iptables -A INPUT -p tcp --dport 22 -m recent --name SSH_TRACK \
    --rcheck --seconds 60 --hitcount 5 \
    -j LOG --log-prefix '[SSH BRUTEFORCE] ' --log-level 4

# SYN flood
sudo iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above 20 \
    -m limit --limit 2/min \
    -j LOG --log-prefix '[SYN FLOOD] ' --log-level 4

# Port scanning detection
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -m limit --limit 1/min \
    -j LOG --log-prefix '[PORT SCAN NULL] ' --log-level 4
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -m limit --limit 1/min \
    -j LOG --log-prefix '[PORT SCAN XMAS] ' --log-level 4

# Blocked botnet IPs
sudo iptables -A INPUT -m recent --name BOTNET --rcheck -m limit --limit 5/min \
    -j LOG --log-prefix '[BOTNET BLOCKED] ' --log-level 4

echo "✓ Attack-specific logging configured"
echo ""

# Configure rsyslog for firewall logs
echo "[3] Configuring rsyslog..."
cat << 'EOF' | sudo tee /etc/rsyslog.d/10-firewall.conf > /dev/null
# Firewall logs to separate file
:msg, contains, "[FIREWALL" /var/log/firewall.log
:msg, contains, "[SSH BRUTEFORCE]" /var/log/firewall-attacks.log
:msg, contains, "[SYN FLOOD]" /var/log/firewall-attacks.log
:msg, contains, "[BOTNET" /var/log/firewall-attacks.log
& stop
EOF

sudo systemctl restart rsyslog
echo "✓ Firewall logs → /var/log/firewall.log"
echo "✓ Attack logs → /var/log/firewall-attacks.log"
echo ""

# Log rotation
echo "[4] Configuring log rotation..."
cat << 'EOF' | sudo tee /etc/logrotate.d/firewall > /dev/null
/var/log/firewall.log
/var/log/firewall-attacks.log
{
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    postrotate
        /usr/lib/rsyslog/rsyslog-rotate
    endscript
}
EOF
echo "✓ Logs will rotate daily, keep 7 days"
echo ""

echo "=== LOGGING CONFIGURED ==="
echo ""
echo "View logs:"
echo "  sudo tail -f /var/log/firewall.log"
echo "  sudo tail -f /var/log/firewall-attacks.log"
echo "  sudo grep 'SYN FLOOD' /var/log/firewall-attacks.log"
```

**Анализ логов:**
```bash
# Real-time monitoring
sudo tail -f /var/log/firewall-attacks.log

# Top attacking IPs
sudo awk '/FIREWALL/ {print $(NF-2)}' /var/log/firewall.log | \
    sort | uniq -c | sort -rn | head -10

# Attack types summary
sudo grep -o '\[.*\]' /var/log/firewall-attacks.log | \
    sort | uniq -c | sort -rn

# Hourly attack statistics
sudo awk '/FIREWALL/ {print $1, $2, $3}' /var/log/firewall.log | \
    cut -d':' -f1 | uniq -c
```

**Результат:**
```
=== /var/log/firewall-attacks.log ===
Jan 15 04:03:42 shadow-server-02 kernel: [SSH BRUTEFORCE] IN=eth0 SRC=185.220.101.47 DST=10.50.1.1 PROTO=TCP DPT=22
Jan 15 04:03:45 shadow-server-02 kernel: [SYN FLOOD] IN=eth0 SRC=91.219.237.244 DST=10.50.1.1 PROTO=TCP DPT=80
Jan 15 04:03:48 shadow-server-02 kernel: [BOTNET BLOCKED] IN=eth0 SRC=195.123.246.151 DST=10.50.1.1
...
```

</details>

<details>
<summary>🔍 Linux Logging система</summary>

### Logging в Linux

**Архитектура:**
```
Application → syslog() → rsyslog/syslog-ng → /var/log/*
Kernel     → printk()  → klogd           → /var/log/kern.log
```

**Основные логи:**
```bash
/var/log/syslog       # Всё подряд (Debian/Ubuntu)
/var/log/messages     # Всё подряд (RHEL/CentOS)
/var/log/kern.log     # Kernel messages (iptables тут!)
/var/log/auth.log     # Authentication (SSH, sudo)
/var/log/apache2/     # Apache веб-сервер
/var/log/nginx/       # Nginx веб-сервер
```

**Journald (systemd):**
```bash
# Просмотр всех логов
journalctl

# Только kernel
journalctl -k

# Real-time
journalctl -f

# За последний час
journalctl --since "1 hour ago"

# Для конкретного service
journalctl -u ssh.service
```

**iptables logging:**

**Формат:**
```bash
iptables -j LOG --log-prefix 'PREFIX' --log-level LEVEL
```

**Log levels:**
```
0 - emerg   (system unusable)
1 - alert   (action must be taken)
2 - crit    (critical conditions)
3 - err     (error conditions)
4 - warning (warning conditions)    ← типичное
5 - notice  (normal but significant)
6 - info    (informational)
7 - debug   (debug-level messages)
```

**Пример лог-записи:**
```
Jan 15 04:03:42 hostname kernel: [12345.678] [FIREWALL DROP] IN=eth0 OUT= MAC=... SRC=1.2.3.4 DST=5.6.7.8 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=12345 DF PROTO=TCP SPT=54321 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0

Расшифровка:
- Jan 15 04:03:42: timestamp
- hostname: сервер
- kernel: источник
- [FIREWALL DROP]: наш prefix
- IN=eth0: входящий интерфейс
- SRC=1.2.3.4: IP атакующего
- DST=5.6.7.8: наш IP
- PROTO=TCP: протокол
- SPT=54321: source port
- DPT=22: destination port (SSH)
- SYN: TCP flags
```

**Парсинг логов:**
```bash
# Extract source IPs
awk '/FIREWALL DROP/ {for(i=1;i<=NF;i++) if($i~/^SRC=/) print substr($i,5)}' /var/log/kern.log

# Count by port
awk '/FIREWALL DROP/ {for(i=1;i<=NF;i++) if($i~/^DPT=/) print substr($i,5)}' /var/log/kern.log | \
    sort | uniq -c | sort -rn

# Top attackers
awk '/FIREWALL DROP/ {for(i=1;i<=NF;i++) if($i~/^SRC=/) print substr($i,5)}' /var/log/kern.log | \
    sort | uniq -c | sort -rn | head -10
```

**rsyslog фильтрация:**
```bash
# /etc/rsyslog.d/10-firewall.conf
:msg, contains, "[FIREWALL" /var/log/firewall.log
& stop  # Не дублировать в syslog
```

**Log rotation:**
```bash
# /etc/logrotate.d/firewall
/var/log/firewall.log {
    daily            # Ежедневно
    rotate 7         # Хранить 7 дней
    compress         # Сжимать старые
    delaycompress    # Кроме последнего
    missingok        # OK если файла нет
    notifempty       # Не ротировать пустые
    postrotate       # После ротации
        /usr/lib/rsyslog/rsyslog-rotate
    endscript
}
```

**Best practices:**
- Используйте `-m limit` чтобы не заполнить диск
- Отдельные файлы для разных типов логов
- Log rotation (logrotate)
- Централизованное логирование (syslog server)
- Мониторинг логов (fail2ban, OSSEC)

</details>

---

### Задание 7: Мониторинг эффективности firewall ⭐⭐

**Контекст:**
Виктор (через наушники): *"Макс, статус? Атака продолжается?"*

Макс: *"Firewall настроен. Но... как проверить что он работает?"*

Alex: *"Мониторинг. Смотри Load Average, SYN_RECV соединения, iptables счётчики. Если цифры падают — ты выиграл."*

**Задача:**
Создать скрипт для мониторинга эффективности firewall в реальном времени.

**Попробуйте сами (5-7 минут):**

```bash
# Создайте скрипт который показывает:
# 1. Load average
# 2. SYN_RECV connections count
# 3. iptables rule hit counters
# 4. Top attacking IPs
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**Алекс:**
> *"Используй `uptime` для load, `netstat | grep SYN_RECV | wc -l` для соединений, `iptables -L -n -v` для счётчиков пакетов."*

Попробуйте:
```bash
#!/bin/bash

while true; do
    clear
    echo "=== FIREWALL MONITORING ==="
    echo ""

    # Load Average
    echo "Load Average:"
    uptime | awk -F'load average:' '{print $2}'
    echo ""

    # SYN_RECV connections
    echo "SYN_RECV connections:"
    netstat -an | grep SYN_RECV | wc -l
    echo ""

    # iptables hit counters
    echo "iptables DROP rules:"
    sudo iptables -L INPUT -n -v | grep DROP

    sleep 5
done
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Полный мониторинг скрипт:**

```bash
#!/bin/bash

# Monitoring script for firewall effectiveness

INTERVAL=5  # seconds between updates

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

while true; do
    clear
    echo "═══════════════════════════════════════════════════════"
    echo "        FIREWALL MONITORING - Real-time"
    echo "═══════════════════════════════════════════════════════"
    echo ""

    # 1. Server Load
    echo "[1] SERVER LOAD:"
    load=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)
    echo "    Current: $load"
    if (( $(echo "$load > 10" | bc -l) )); then
        echo -e "    Status: ${RED}CRITICAL${NC}"
    elif (( $(echo "$load > 5" | bc -l) )); then
        echo -e "    Status: ${YELLOW}HIGH${NC}"
    else
        echo -e "    Status: ${GREEN}NORMAL${NC}"
    fi
    echo ""

    # 2. SYN_RECV connections
    echo "[2] SYN_RECV CONNECTIONS:"
    syn_count=$(netstat -an 2>/dev/null | grep SYN_RECV | wc -l)
    echo "    Count: $syn_count"
    if [ "$syn_count" -gt 100 ]; then
        echo -e "    Status: ${RED}UNDER ATTACK${NC}"
    elif [ "$syn_count" -gt 50 ]; then
        echo -e "    Status: ${YELLOW}ELEVATED${NC}"
    else
        echo -e "    Status: ${GREEN}NORMAL${NC}"
    fi
    echo ""

    # 3. Total connections
    echo "[3] TOTAL CONNECTIONS:"
    established=$(ss -s | grep TCP | head -1 | awk '{print $2}')
    echo "    Established: $established"
    echo ""

    # 4. iptables hit counters
    echo "[4] FIREWALL RULES (top 5):"
    sudo iptables -L INPUT -n -v --line-numbers | grep -v "^Chain" | grep -v "^num" | head -5
    echo ""

    # 5. Blocked packets count
    echo "[5] BLOCKED PACKETS:"
    blocked=$(sudo iptables -L INPUT -n -v | grep DROP | awk '{sum+=$1} END {print sum}')
    echo "    Total: ${blocked:-0}"
    echo ""

    # 6. Top attacking IPs
    echo "[6] TOP ATTACKING IPs (last 1 minute):"
    netstat -an 2>/dev/null | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | grep -v "0.0.0.0" | head -5
    echo ""

    echo "Updating every ${INTERVAL}s... (Ctrl+C to stop)"
    sleep "$INTERVAL"
done
```

</details>

<details>
<summary>✅ Решение</summary>

**Professional monitoring script:**

```bash
#!/bin/bash

# firewall_monitor.sh - Real-time firewall monitoring
# Usage: ./firewall_monitor.sh [interval_seconds]

INTERVAL=${1:-5}  # Default 5 seconds

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# History for trend detection
declare -a LOAD_HISTORY
declare -a SYN_HISTORY

# Function: Get load average (1 min)
get_load() {
    uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs
}

# Function: Get SYN_RECV count
get_syn_count() {
    netstat -an 2>/dev/null | grep -c SYN_RECV || echo 0
}

# Function: Get status color based on value and threshold
status_color() {
    local value=$1
    local warn=$2
    local crit=$3

    if (( $(echo "$value >= $crit" | bc -l 2>/dev/null || echo 0) )); then
        echo -e "${RED}CRITICAL${NC}"
    elif (( $(echo "$value >= $warn" | bc -l 2>/dev/null || echo 0) )); then
        echo -e "${YELLOW}WARNING${NC}"
    else
        echo -e "${GREEN}NORMAL${NC}"
    fi
}

# Function: Draw trend indicator
draw_trend() {
    local -n arr=$1
    local length=${#arr[@]}

    if [ "$length" -lt 2 ]; then
        echo "━"
        return
    fi

    local last=${arr[$((length-1))]}
    local prev=${arr[$((length-2))]}

    if (( $(echo "$last > $prev" | bc -l 2>/dev/null || echo 0) )); then
        echo -e "${RED}▲${NC}"  # Increasing (bad)
    elif (( $(echo "$last < $prev" | bc -l 2>/dev/null || echo 0) )); then
        echo -e "${GREEN}▼${NC}"  # Decreasing (good)
    else
        echo "━"  # Stable
    fi
}

# Main monitoring loop
while true; do
    clear

    # Header
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         FIREWALL MONITORING - Real-time Status           ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Time: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo ""

    # 1. Server Load
    load=$(get_load)
    LOAD_HISTORY+=("$load")
    [ ${#LOAD_HISTORY[@]} -gt 10 ] && LOAD_HISTORY=("${LOAD_HISTORY[@]:1}")

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${YELLOW}[1] SERVER LOAD${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    Current:  $load"
    echo "    Status:   $(status_color "$load" 5 10)"
    echo "    Trend:    $(draw_trend LOAD_HISTORY)"
    echo ""

    # 2. SYN_RECV connections
    syn_count=$(get_syn_count)
    SYN_HISTORY+=("$syn_count")
    [ ${#SYN_HISTORY[@]} -gt 10 ] && SYN_HISTORY=("${SYN_HISTORY[@]:1}")

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${YELLOW}[2] SYN_RECV CONNECTIONS (DDoS Indicator)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    Count:    $syn_count"
    echo "    Status:   $(status_color "$syn_count" 50 100)"
    echo "    Trend:    $(draw_trend SYN_HISTORY)"
    echo ""

    # 3. Total connections
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${YELLOW}[3] CONNECTION SUMMARY${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    ss -s | grep -A5 "TCP:" | sed 's/^/    /'
    echo ""

    # 4. iptables counters
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${YELLOW}[4] FIREWALL RULES (packets/bytes)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sudo iptables -L INPUT -n -v --line-numbers 2>/dev/null | head -10 | sed 's/^/    /'
    echo ""

    # 5. Blocked statistics
    blocked_packets=$(sudo iptables -L INPUT -n -v 2>/dev/null | awk '/DROP/ {sum+=$1} END {print sum+0}')
    blocked_bytes=$(sudo iptables -L INPUT -n -v 2>/dev/null | awk '/DROP/ {sum+=$2} END {print sum+0}')

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${YELLOW}[5] BLOCKED TRAFFIC${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    Packets:  $blocked_packets"
    echo "    Bytes:    $blocked_bytes"
    echo ""

    # 6. Top attacking IPs
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${YELLOW}[6] TOP ATTACKING IPs (current connections)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    netstat -an 2>/dev/null | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | \
        grep -v "0.0.0.0" | grep -v "127.0.0.1" | grep -v "Address" | head -5 | \
        awk '{printf "    %5d  %s\n", $1, $2}'
    echo ""

    # 7. Recent firewall logs
    if [ -f /var/log/firewall-attacks.log ]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo -e "${YELLOW}[7] RECENT ATTACKS (last 3)${NC}"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        tail -3 /var/log/firewall-attacks.log 2>/dev/null | sed 's/^/    /' || echo "    No recent attacks logged"
        echo ""
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${CYAN}Updating every ${INTERVAL}s... (Ctrl+C to stop)${NC}"

    sleep "$INTERVAL"
done
```

**Usage:**
```bash
# Run with default 5 sec interval
./firewall_monitor.sh

# Run with custom interval
./firewall_monitor.sh 10  # Update every 10 seconds
```

**Output example (during attack):**
```
╔═══════════════════════════════════════════════════════════╗
║         FIREWALL MONITORING - Real-time Status           ║
╚═══════════════════════════════════════════════════════════╝

Time: 2025-01-15 04:05:42

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[1] SERVER LOAD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Current:  2.15
    Status:   NORMAL
    Trend:    ▼  (decreasing - good!)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[2] SYN_RECV CONNECTIONS (DDoS Indicator)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Count:    12
    Status:   NORMAL
    Trend:    ▼  (decreasing - good!)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[5] BLOCKED TRAFFIC
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Packets:  523847
    Bytes:    31430820

[6] TOP ATTACKING IPs (current connections)
    23  185.220.101.47
    18  91.219.237.244
    15  195.123.246.151
```

**Output example (attack stopped):**
```
[1] SERVER LOAD: 0.85  ✓ NORMAL  ▼
[2] SYN_RECV:    3     ✓ NORMAL  ▼
```

</details>

---

### Задание 8: Финальный Security Audit ⭐⭐⭐

**Контекст:**

**04:07 — Ровно 5 минут прошло**

Алекс (спокойно): *"Макс. Посмотри на Load Average."*

```bash
$ uptime
 04:07:23 up 2 days, 14:35,  load average: 1.92, 3.45, 8.67
```

Макс (не верит): *"1.92?! Было 47!"*

Alex: *"Ты отразил DDoS. Поздравляю. Теперь задокументируй всё. Viktor требует отчёт."*

**Задача:**
Создать финальный security audit report — полная документация firewall правил и результатов.

**Попробуйте сами (5-10 минут):**

```bash
# Создайте скрипт который генерирует отчёт:
# 1. Текущие firewall rules (UFW + iptables)
# 2. Статистика заблокированных IP
# 3. Атаки detected
# 4. Рекомендации
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**Алекс:**
> *"Отчёт должен содержать: `ufw status`, `iptables -L -n -v`, статистику из логов, итоговые метрики. Структурируй."*

Начните с шаблона:
```bash
#!/bin/bash

REPORT_FILE="artifacts/firewall_audit_report.txt"

{
    echo "═══════════════════════════════════════════════════════"
    echo "       FIREWALL SECURITY AUDIT REPORT"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "Date: $(date)"
    echo "Server: $(hostname)"
    echo ""

    echo "[1] UFW STATUS:"
    sudo ufw status verbose
    echo ""

    echo "[2] IPTABLES RULES:"
    sudo iptables -L -n -v
    echo ""

    echo "[3] BLOCKED IPS:"
    wc -l < artifacts/blocked_ips.log
    echo ""

    echo "[4] CURRENT SYSTEM STATUS:"
    uptime
    netstat -an | grep SYN_RECV | wc -l

} > "$REPORT_FILE"

echo "✓ Report generated: $REPORT_FILE"
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Comprehensive report structure:**

```bash
#!/bin/bash

REPORT_FILE="artifacts/firewall_audit_report.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

generate_report() {
    cat << EOF
╔═══════════════════════════════════════════════════════════╗
║         FIREWALL SECURITY AUDIT REPORT                   ║
║         Episode 07: Firewalls & iptables                 ║
╚═══════════════════════════════════════════════════════════╝

Date:     $TIMESTAMP
Server:   $(hostname)
Location: ЦОД "Москва-1", Серверная A-12
Operator: max_sokolov
Incident: DDoS Attack - Day 13/60

════════════════════════════════════════════════════════════
[1] INCIDENT SUMMARY
════════════════════════════════════════════════════════════

Start Time:    03:47 (Emergency call from Alex)
End Time:      04:07 (Attack mitigated)
Duration:      20 minutes
Attack Type:   DDoS (SYN Flood)
Source IPs:    847 unique botnet nodes
Peak Load:     47.82 (CRITICAL)
Final Load:    $(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1)

STATUS: ✓ ATTACK MITIGATED

════════════════════════════════════════════════════════════
[2] FIREWALL CONFIGURATION
════════════════════════════════════════════════════════════

UFW Status:
$(sudo ufw status verbose 2>/dev/null | head -20)

iptables INPUT Chain (first 15 rules):
$(sudo iptables -L INPUT -n -v --line-numbers 2>/dev/null | head -17)

════════════════════════════════════════════════════════════
[3] BLOCKED IPS STATISTICS
════════════════════════════════════════════════════════════

Total IPs blocked:    $(wc -l < artifacts/blocked_ips.log 2>/dev/null || echo 0)
Source:               artifacts/botnet_ips.txt (Anna's forensics)
Method:               iptables DROP rules

Top 5 blocked IPs:
$(head -5 artifacts/blocked_ips.log 2>/dev/null || echo "No blocked IPs logged")

════════════════════════════════════════════════════════════
[4] CURRENT SYSTEM STATUS
════════════════════════════════════════════════════════════

Load Average:         $(uptime | awk -F'load average:' '{print $2}')
SYN_RECV connections: $(netstat -an 2>/dev/null | grep -c SYN_RECV)
Total connections:    $(ss -s | grep TCP | head -1 | awk '{print $2}')
Memory usage:         $(free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2 }')
CPU usage:            $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%

════════════════════════════════════════════════════════════
[5] ATTACK LOGS ANALYSIS
════════════════════════════════════════════════════════════

Attack types detected:
$(grep -o '\[.*\]' /var/log/firewall-attacks.log 2>/dev/null | sort | uniq -c | sort -rn || echo "No attacks logged")

Top attacking IPs (from logs):
$(awk '/FIREWALL/ {for(i=1;i<=NF;i++) if($i~/^SRC=/) print substr($i,5)}' /var/log/kern.log 2>/dev/null | sort | uniq -c | sort -rn | head -5 || echo "No attack logs found")

════════════════════════════════════════════════════════════
[6] SECURITY MEASURES IMPLEMENTED
════════════════════════════════════════════════════════════

✓ UFW enabled with default deny policy
✓ SSH (22), HTTP (80), HTTPS (443) allowed
✓ 847 botnet IPs blocked via iptables
✓ Rate limiting configured:
  - Max 20 simultaneous connections per IP
  - SSH: 4 attempts per minute
  - HTTP/HTTPS: 50 requests/sec per IP
  - ICMP: 5 pings/sec
✓ Attack logging enabled
✓ rsyslog configured for firewall logs
✓ Log rotation configured (7 days retention)

════════════════════════════════════════════════════════════
[7] SECURITY ASSESSMENT
════════════════════════════════════════════════════════════

Overall Status: ✓ SECURE

Strengths:
  + Effective DDoS mitigation
  + Comprehensive rate limiting
  + Attack detection and logging
  + Zero false positives (legitimate traffic unaffected)

Recommendations:
  1. Monitor firewall logs daily
  2. Update botnet IP list regularly (IPs change)
  3. Consider fail2ban for automated banning
  4. Implement IDS/IPS (Snort, Suricata)
  5. Enable kernel-level protections (SYN cookies)
  6. Backup iptables rules: iptables-save > /etc/iptables.rules
  7. Document incident in SIEM system

════════════════════════════════════════════════════════════
[8] NEXT STEPS
════════════════════════════════════════════════════════════

Immediate:
  - Share report with Viktor and Anna
  - Monitor for 24h for repeat attacks
  - Analyze attack vectors with Anna (forensics)

Short-term (1-7 days):
  - Episode 08: VPN & SSH Tunneling
  - Secure communication channels
  - Encrypted traffic to protect from Krylov

Long-term:
  - Deploy WAF (Web Application Firewall)
  - Geographic IP filtering
  - CDN integration (DDoS protection)

════════════════════════════════════════════════════════════
END OF REPORT

Generated by: firewall_audit.sh
Episode: 07 — Firewalls & iptables
Location: Moscow, Russia 🇷🇺
Operation: KERNEL SHADOWS (Day 13/60)
════════════════════════════════════════════════════════════
EOF
}

# Generate report
generate_report > "$REPORT_FILE"

echo "✓ Firewall Audit Report generated: $REPORT_FILE"
echo ""
echo "Summary:"
echo "  Blocked IPs:   $(wc -l < artifacts/blocked_ips.log 2>/dev/null || echo 0)"
echo "  Load Average:  $(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1)"
echo "  SYN_RECV:      $(netstat -an 2>/dev/null | grep -c SYN_RECV)"
echo ""
echo "Status: ✓ ATTACK MITIGATED"
```

</details>

<details>
<summary>✅ Решение (full professional report)</summary>

**See Hint 2 above — это полное решение.**

**Запуск:**
```bash
chmod +x firewall_audit.sh
./firewall_audit.sh
```

**Результат:**
```
✓ Firewall Audit Report generated: artifacts/firewall_audit_report.txt

Summary:
  Blocked IPs:   847
  Load Average:  1.92
  SYN_RECV:      12

Status: ✓ ATTACK MITIGATED
```

</details>

---

## 🎬 Завершение эпизода

### 04:08 — Тишина после бури

**Макс смотрит на экран. Графики Grafana зелёные. Load стабилен.**

Макс (выдохнул):
> *"Получилось..."*

Alex (голос через наушники):
> *"Не просто получилось. Ты отразил профессиональную DDoS атаку. За 20 минут. Удалённо. Из самолёта."*

Viktor (подключился к видеозвонку):
> *"Отчёт получил. Впечатляюще. Сервер работает, данные в безопасности. Макс, ты справился."*

Anna (на фоне серверной):
> *"Я проанализировала IP. Все из сети Krylov. Он знал что мы в Москве. Это была целенаправленная атака."*

**Макс смотрит в окно самолёта. Москва далеко внизу.**

---

### 04:15 — Сообщение в логах

**Anna (тревожно):**
> *"Макс... там ещё что-то. В логах."*

```bash
$ sudo tail -1 /var/log/firewall-attacks.log

Jan 15 04:14:58 shadow-server-02 kernel: [BOTNET BLOCKED] IN=eth0
SRC=185.220.101.47 DST=10.50.1.1
MSG="Соколов. Передай брату: я найду вас. Обоих. - К."
```

**Silence.**

**Макс (тихо):**
> *"Это... сообщение в логах? Как?!"*

Alex (голос напряжён):
> *"TCP payload. Он встроил текст в пакеты. Это не просто атака. Это... угроза."*

Viktor:
> *"Алекс, мы переходим на защищённые каналы. Немедленно. Episode 08 — VPN и шифрование. Макс, отдохни пока долетишь. Вечером briefing."*

**Макс закрывает ноутбук. Руки дрожат.**

---

### 06:00 — Приземление в Москве

**Sheremetyevo Airport. Макс выходит из самолёта. Телефон вибрирует.**

**SMS от Viktor:**
```
Хорошая работа. Firewall держится.
Krylov знает про нас больше чем мы думали.
Следующий шаг — VPN. Шифрование всего трафика.
Встреча завтра 10:00. Локация в личку.
- V
```

**Макс смотрит на экран. Думает об угрозе в логах.**

**LILITH (уведомление):**
```
Episode 07 Complete.
Krylov escalates. Security must escalate too.
Next: Episode 08 - VPN & SSH Tunneling.
Stay sharp. Stay hidden. Stay alive.
```

---

## ✅ Что вы изучили

### Технические навыки:
- ✅ **UFW (Uncomplicated Firewall)** — настройка и управление
- ✅ **iptables** — создание правил, chains, targets
- ✅ **Rate limiting** — защита от DDoS (connlimit, recent, hashlimit)
- ✅ **IP blocking** — массовая блокировка botnet IPs
- ✅ **Logging** — iptables logging, rsyslog, анализ атак
- ✅ **Мониторинг** — real-time firewall эффективности
- ✅ **Incident response** — действия под давлением, 5 минут deadline

### Soft skills:
- ✅ Работа под давлением (DDoS в реальном времени)
- ✅ Удалённое администрирование (SSH через VPN, высокая latency)
- ✅ Collaboration (Alex, Anna, Viktor — каждый свою роль)
- ✅ Documentation (security audit report)

### Сюжет:
- ✅ Первый серьёзный incident (DDoS атака)
- ✅ Макс доказал что может работать под давлением
- ✅ Крылов эскалирует — угроза лично Алексу и Максу
- ✅ Переход к защищённым каналам (VPN в следующем эпизоде)

---

## 🔍 Проверка понимания

Прежде чем продолжать, убедитесь что вы понимаете:

1. ✅ Разницу между UFW и iptables
2. ✅ Что такое chains (INPUT, OUTPUT, FORWARD)
3. ✅ Targets: ACCEPT, DROP, REJECT, LOG
4. ✅ Rate limiting vs IP blocking
5. ✅ Как работает SYN flood атака
6. ✅ Как защитить SSH от brute-force
7. ✅ Зачем нужен `-m limit` в логировании
8. ✅ Как проверить эффективность firewall

**Тест:** Попробуйте объяснить:
- Почему нужно разрешить SSH ПЕРЕД включением UFW?
- Чем connlimit отличается от hashlimit?
- Что будет если использовать LOG без -m limit?

---

## 📚 Дополнительные материалы

<details>
<summary>🔥 fail2ban — автоматическая защита</summary>

### fail2ban: Automated Intrusion Prevention

**Что это:**
fail2ban мониторит логи и автоматически банит IP при обнаружении подозрительной активности.

**Установка:**
```bash
sudo apt update
sudo apt install fail2ban
```

**Базовая конфигурация:**
```bash
# /etc/fail2ban/jail.local
[DEFAULT]
bantime = 3600      # 1 час
findtime = 600      # 10 минут
maxretry = 5        # 5 попыток

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3        # SSH: только 3 попытки

[nginx-limit-req]
enabled = true
filter = nginx-limit-req
logpath = /var/log/nginx/error.log
```

**Проверка:**
```bash
# Status
sudo fail2ban-client status

# Banned IPs
sudo fail2ban-client status sshd

# Unban IP
sudo fail2ban-client set sshd unbanip 1.2.3.4
```

**Интеграция с iptables:**
fail2ban автоматически создаёт iptables правила:
```bash
sudo iptables -L -n | grep fail2ban
```

**Best practice:**
- Установи fail2ban на всех публичных серверах
- Настрой для SSH, HTTP, SMTP
- Мониторь banned IPs
- Используй whitelist для своих IP

</details>

<details>
<summary>🌐 nftables — modern firewall</summary>

### nftables: iptables Replacement

**Что это:**
nftables — современная замена iptables (с 2014, kernel 3.13+).

**Преимущества:**
- Проще синтаксис
- Быстрее (меньше kernel calls)
- Atomic updates (все правила сразу)
- IPv4 и IPv6 в одном правиле

**Сравнение:**

**iptables:**
```bash
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT  # Отдельно для IPv6!
```

**nftables:**
```bash
nft add rule inet filter input tcp dport {22, 80} accept
# Работает для IPv4 и IPv6!
```

**Базовая конфигурация:**
```bash
#!/usr/sbin/nft -f

# Flush all rules
flush ruleset

# Define table
table inet filter {
    # Input chain
    chain input {
        type filter hook input priority 0; policy drop;

        # Allow established/related
        ct state established,related accept

        # Allow loopback
        iif lo accept

        # Allow SSH, HTTP, HTTPS
        tcp dport {22, 80, 443} accept

        # Rate limiting
        tcp dport 22 ct state new limit rate 4/minute accept

        # Drop everything else (policy drop)
    }

    # Output chain
    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

**Сохранение/восстановление:**
```bash
# Save
sudo nft list ruleset > /etc/nftables.conf

# Restore
sudo nft -f /etc/nftables.conf
```

**Migration from iptables:**
```bash
# Export iptables rules
sudo iptables-save > iptables.rules

# Convert to nftables
sudo iptables-restore-translate -f iptables.rules > nftables.rules

# Load nftables rules
sudo nft -f nftables.rules
```

</details>

---

*"Firewall — это не стена. Это вышибала. Хороший вышибала знает кого впускать, кого выкинуть, а кого просто наблюдать."* — Alex Sokolov

**Episode 07 Complete!** ✓

**Next:** Episode 08 — VPN & SSH Tunneling (secure communication) 🔒

---

