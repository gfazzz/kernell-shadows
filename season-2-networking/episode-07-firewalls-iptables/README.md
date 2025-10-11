# Episode 07: Firewalls & iptables

**KERNEL SHADOWS — Season 2: Networking**

```
╔═══════════════════════════════════════════════════════════════╗
║  Episode 07: Firewalls & iptables                            ║
║                                                               ║
║  Location: Moscow, Russia 🇷🇺                                 ║
║  Datacenter: ЦОД "Москва-1"                                  ║
║  Day: 13-14 of 60                                             ║
║  Difficulty: ⭐⭐⭐⭐☆                                         ║
║  Time: 5-6 hours (8 micro-cycles)                            ║
║  Status: 🔴 INCIDENT — DDoS ATTACK IN PROGRESS               ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## 🎯 Type B Episode: "ufw exists → use it, don't wrap it"

**Философия:**
```
Episode 04 (Package Management):  apt exists → use it ✅
Episode 06 (DNS):                 dig exists → use it ✅
Episode 07 (Firewall):            ufw exists → use it ✅
```

**Вы будете:**
- ✅ Использовать UFW и iptables **напрямую** в терминале
- ✅ Конфигурировать firewall правила руками
- ✅ Анализировать результаты
- ❌ НЕ писать bash wrapper вокруг ufw (это Type A — неправильно!)

**Type B vs Type A:**

| Task | Type A ❌ | Type B ✅ |
|------|----------|----------|
| Enable firewall | `bash function enable_ufw()` | `sudo ufw enable` напрямую |
| Allow port | `bash wrapper allow_web()` | `sudo ufw allow 80/tcp` напрямую |
| Block IPs | `bash loop в скрипте` | Ручной loop или `ufw deny` |
| Report | `bash генерирует отчёт` | `bash генерирует отчёт` (OK!) |

**Linux SysAdmin конфигурирует firewall напрямую, не пишет bash wrappers.** 🔧

---

## 💻 Setup: Как выполнять задания

### Варианты выполнения:

**1. Локально (рекомендуется) ⭐**

Выполняйте команды на своей Ubuntu машине:
```bash
sudo ufw status
sudo iptables -L
sudo ufw allow 22/tcp
sudo ufw enable
```

**⚠️ КРИТИЧЕСКИ ВАЖНО:**
- **ВСЕГДА** разрешайте SSH (порт 22) ПЕРЕД включением UFW!
- Используйте `screen` или `tmux` для защиты от разрывов
- Держите открытым второе SSH окно для проверки

```bash
# Безопасный способ:
sudo ufw allow 22/tcp   # СНАЧАЛА!
sudo ufw enable         # ПОТОМ!
```

**2. VM (безопаснее для экспериментов) ⭐⭐**
- Создайте snapshot перед началом
- Можно смело ломать и откатывать

**3. Docker (реалистичная симуляция) ⭐⭐⭐**
```bash
# Dockerfile для shadow-server-02
cat > Dockerfile << 'EOF'
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    openssh-server ufw iptables iproute2 \
    net-tools iputils-ping sudo
RUN useradd -m -s /bin/bash max && \
    echo 'max:password' | chpasswd && \
    usermod -aG sudo max
RUN mkdir /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
EOF

docker build -t shadow-server .
docker run -d -p 2222:22 --cap-add=NET_ADMIN \
    --name shadow-server-02 shadow-server

ssh -p 2222 max@localhost  # password: password
```

**4. Cloud VM (самое реалистичное) ⭐⭐⭐⭐**
- DigitalOcean / AWS / Azure
- **ОБЯЗАТЕЛЬНО** имейте web console доступ на случай SSH lockout!

### Recovery если заблокировали SSH:

**Локально/VM:** физический доступ к консоли → `sudo ufw disable`

**Docker:** `docker rm -f shadow-server-02 && docker run ...`

**Cloud:** используйте web console в панели управления

---

## 🎬 Сюжет: День 13, 03:47 — Экстренный звонок

**Телефон Макса вибрирует. 3:47 утра. Стокгольм. Звонок от Алекса:**

**Алекс** (кричит, фоновый шум серверной):
> *"МАКС! ПРОСЫПАЙСЯ! У нас DDoS! 50 ТЫСЯЧ пакетов в секунду! Сервер падает! Ты где?!"*

**Макс** (резко просыпается в отеле):
> *"Я в Стокгольме... Что происходит?!"*

**Алекс:**
> *"Крылов нашёл нас. Ботнет бьёт по shadow-server-02. У нас 5 минут до краха. ЛЕТИШЬ В МОСКВУ. СЕЙЧАС."*

---

**03:55 — Arlanda Airport, Stockholm**

Макс в такси. Ноутбук на коленях. VPN в московский ЦОД.

**Terminal output:**
```
$ ssh max@shadow-server-02.ops.internal
Connection timeout... retry...
Connected (1247ms latency — CRITICAL!)

$ uptime
 03:55:14 up 2 days, 14:23,  load average: 47.82, 38.91, 29.44

⚠️ CRITICAL: Load average > 40 (normal: 1-2)
⚠️ WARNING: 1247ms latency (normal: 20-50ms)
```

**Grafana dashboard:**
```
⚠️ NETWORK TRAFFIC SPIKE
Incoming: 487 Mbps (normal: 20 Mbps)
Packets/sec: 52,341 (normal: 1,500)
CPU: 94% (CRITICAL)
```

**Макс** (в панике):
> *"Алекс, я не успею долететь! Через 4 часа буду!"*

**Алекс:**
> *"Тогда делай удалённо. СЕЙЧАС. У тебя есть SSH. Firewall — это всё что нас спасёт."*

---

**04:00 — ЦОД "Москва-1", Серверная A-12**

**На месте:**
- **Алекс** — у консоли, анализирует атаку
- **Анна** — forensics, ищет источник
- **Дмитрий** — DevOps, готовит backup серверы
- **Виктор** — координирует

**Анна:**
> *"Это ботнет. 847 уникальных IP адресов. Все из Tor exit nodes и VPN провайдеров. SYN flood. Классика."*

**Виктор:**
> *"Макс, ты единственный кто свободен. Тебе нужно настроить firewall. Сможешь?"*

**Макс** (через наушники, самолёт на взлёте):
> *"Я... я изучал iptables только в теории..."*

**Алекс:**
> *"Теории больше нет. Только практика. Я буду рядом. По пунктам. Шаг за шагом. Поехали."*

---

### LILITH активируется — Emergency Mode

**LILITH v2.0 (красный режим):**
> *"INCIDENT DETECTED. DDoS attack: 52,341 packets/sec from 847 IPs."*
>
> *"Firewall — последняя линия обороны. Если сервер упадёт — операция провалена. Крылов получит доступ к логам. Он узнает все наши локации."*
>
> *"Макс, ты не один. Я проведу через firewall setup. Но решения принимаешь ты. Быстро."*
>
> *"У нас 5 минут до критического порога. After that — server crash."*

**Текущее время:** 04:02
**Deadline:** 04:07
**Состояние сервера:** CRITICAL

---

## 📚 Micro-Cycles: 8 циклов × 10-15 минут

### Цикл 1: UFW Status Check (10 минут) 🔍

#### 🎬 Сюжет (2 мин)

**Алекс:**
> *"Макс, первое — узнай что у нас сейчас. Firewall включен? Какие правила?"*

**Макс:**
> *"Как проверить?"*

**Алекс:**
> *"UFW. Это wrapper над iptables. Проще в использовании. Команда `sudo ufw status`."*

---

#### 📚 Теория: Что такое Firewall? (5 мин)

**🎭 МЕТАФОРА #1: Firewall = Охранник ночного клуба**

```
          🏢 Server (клуб)
              ↑
              |
         [Firewall] 👮 Охранник
              |
         ┌────┴────┐
         ↓         ↓
    ✅ VIP      ❌ Botnet
   (allowed)   (blocked)
```

**Охранник проверяет:**
- 🆔 Кто ты? (source IP)
- 🚪 Куда идёшь? (destination port)
- 📦 Что несёшь? (protocol, packet content)
- 📝 Есть в списке? (whitelist / blacklist)

**Правила клуба = Firewall rules:**
- VIP гости → пропускаем (ACCEPT)
- Черный список → не пускаем (DROP)
- Слишком много друзей → лимит (rate limiting)
- Каждый вход записываем → лог (LOG)

**LILITH:**
> *"Firewall — не стена. Это вышибала. Хороший вышибала знает кого впустить, кого выкинуть, а на кого просто насрать. Плохой — блокирует всех, включая себя."*

---

**Linux Firewall Stack:**

```
┌─────────────────────┐
│  Application Layer  │  nginx, ssh, apache
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  ufw / iptables     │  ← Userspace tools (здесь работаем мы)
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│   Netfilter         │  ← Kernel module (packet filtering)
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  Network Stack      │  TCP/IP, routing
└─────────────────────┘
```

**UFW (Uncomplicated Firewall):**
- Wrapper над iptables
- Проще в использовании
- Ubuntu default

**iptables:**
- Мощный, но сложный
- Прямой доступ к Netfilter

---

#### 💻 Практика: Проверка статуса (3 мин)

**Задание:** Проверьте текущий статус firewall.

```bash
# 1. UFW status
sudo ufw status verbose

# 2. iptables rules
sudo iptables -L -n -v

# 3. SYN_RECV connections (индикатор SYN flood)
netstat -an | grep SYN_RECV | wc -l
```

**Ожидаемый результат (ДО настройки):**
```
UFW: Status: inactive
iptables: Chain INPUT (policy ACCEPT) — нет правил!
SYN_RECV: 847 (⚠️ CRITICAL! normal < 10)
```

**LILITH:**
> *"Вижу. Firewall выключен. Default policy ACCEPT — пропускает ВСЁ. Ботнет гуляет свободно. Исправляем."*

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** Что означает `Chain INPUT (policy ACCEPT)`?

a) Все входящие пакеты блокируются
b) Все входящие пакеты пропускаются (если нет других правил)
c) Firewall активен

<details>
<summary>💡 Думай 30 секунд перед проверкой</summary>

**Ответ: b) Все входящие пакеты пропускаются**

`policy ACCEPT` = default policy: если пакет не подошёл ни под одно правило — **пропустить**.

**Проблема:** Если правил нет (как сейчас) → пропускается ВСЁ!

**Безопасно:** `policy DROP` — блокировать всё что не разрешено явно.

**LILITH:**
> *"ACCEPT policy — это открытые двери. DROP policy — закрытые двери с VIP списком. Всегда используй DROP."*

</details>

---

### Цикл 2: Enable UFW Safely (12 минут) 🔓

#### 🎬 Сюжет (2 мин)

**Алекс:**
> *"Макс, firewall выключен. Включаем UFW. НО! КРИТИЧНО — сначала разреши SSH, иначе потеряешь доступ!"*

**Макс:**
> *"А что будет если не разрешить?"*

**Алекс:**
> *"Потеряешь SSH. Сервер станет недоступен. Придётся лететь в Москву физически. 4 часа. Сервер упадёт через 3 минуты."*

**Макс:**
> *"Понял. SSH первый. Потом UFW."*

**LILITH:**
> *"88% новичков блокируют сами себя при первом включении UFW. Ты не будешь 89-м."*

---

#### 📚 Теория: UFW Basics (6 мин)

**🎭 МЕТАФОРА #2: Default Policy = Настройка охранника**

```
Policy ACCEPT (небезопасно):
  Охранник: "Пускай все, кроме кого запретим"
  → Забыли запретить botnet? Прошли!

Policy DENY (безопасно):
  Охранник: "Блокируй всех, кроме кого разрешим"
  → Забыли разрешить SSH? Заблокирован! (но botnet тоже)
```

**Best practice:**
```bash
# 1. Default: запретить входящие
sudo ufw default deny incoming

# 2. Default: разрешить исходящие
sudo ufw default allow outgoing

# 3. Явно разрешить нужное (SSH, HTTP, HTTPS)
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# 4. Включить
sudo ufw enable
```

---

**Порядок критичен!**

```
❌ НЕПРАВИЛЬНО:
1. sudo ufw enable         # Включили UFW
2. sudo ufw allow 22/tcp   # Разрешили SSH
→ Между шагом 1 и 2 вы заблокированы!

✅ ПРАВИЛЬНО:
1. sudo ufw allow 22/tcp   # Разрешили SSH
2. sudo ufw enable         # Включили UFW
→ SSH работает всегда!
```

**LILITH:**
> *"Порядок команд = жизнь или смерть SSH. Запомни: allow ПЕРЕД enable. Всегда."*

---

**💡 AHA Moment: UFW ≠ активен сразу**

```bash
# Добавили правило
sudo ufw allow 22/tcp
# Вывод: Rule added ✓

# НО! Правило НЕ работает пока не включим UFW
sudo ufw status
# Status: inactive ⚠️

# Включаем
sudo ufw enable
# Now: Status: active ✓ + правило работает!
```

**Зачем так?** Безопасность! Можешь настроить все правила, проверить, **потом** активировать одной командой.

---

#### 💻 Практика: Включение UFW (3 мин)

**Задание:** Включите UFW безопасно (не потеряв SSH).

```bash
# Шаг 1: Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Шаг 2: Разрешить SSH (КРИТИЧНО!)
sudo ufw allow 22/tcp comment 'SSH access'

# Шаг 3: Проверить что будет добавлено
sudo ufw show added

# Шаг 4: Включить UFW
echo "y" | sudo ufw enable  # Auto-yes

# Шаг 5: Проверить статус
sudo ufw status verbose
```

**Ожидаемый результат:**
```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing)

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere    # SSH access
```

**LILITH:**
> *"Хорошо. UFW активен. SSH работает. Default deny — умно. Теперь ботнет заблокирован... кроме 80 и 443. Это следующий шаг."*

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** Почему важно использовать `comment` в правилах?

```bash
sudo ufw allow 22/tcp comment 'SSH access'
```

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:** Документация!

Через месяц ты забудешь зачем разрешил порт 8080. Comment напомнит:
```
8080/tcp    ALLOW    # Prometheus monitoring
```

**LILITH:**
> *"Комментарии — для будущего себя. Ты через 3 месяца — это другой человек. Помоги ему."*

**Best practice:** Всегда comment для не-стандартных портов!

</details>

---

### Цикл 3: Allow Web Traffic (10 минут) 🌐

#### 🎬 Сюжет (2 мин)

**Алекс:**
> *"Отлично! SSH работает. Теперь разреши веб-трафик — порты 80 и 443. Наш сервер должен принимать HTTP/HTTPS запросы."*

**Макс:**
> *"Просто allow 80 и 443?"*

**Алекс:**
> *"Да. UFW знает стандартные порты. Можешь даже `sudo ufw allow http` — он сам поймёт что это 80."*

---

#### 📚 Теория: Standard Ports (5 мин)

**Well-known Ports (0-1023):**

| Service | Port | Protocol | Use case |
|---------|------|----------|----------|
| **SSH** | 22 | TCP | Remote access |
| **HTTP** | 80 | TCP | Web (unencrypted) |
| **HTTPS** | 443 | TCP | Web (encrypted) |
| DNS | 53 | UDP/TCP | Name resolution |
| FTP | 21 | TCP | File transfer ⚠️ unsecure |
| SMTP | 25 | TCP | Email sending |
| MySQL | 3306 | TCP | Database |
| PostgreSQL | 5432 | TCP | Database |

**LILITH:**
> *"22, 80, 443 — святая троица web сервера. SSH для админов, HTTP/HTTPS для пользователей. Всё остальное — закрыто."*

---

**🎭 МЕТАФОРА #3: Порты = Двери в здании**

```
        🏢 Server
    ┌──────────────┐
    │ :22   SSH    │ ← Служебный вход (только admin)
    │ :80   HTTP   │ ← Главный вход (публичный)
    │ :443  HTTPS  │ ← VIP вход (зашифрованный)
    │ :3306 MySQL  │ ← Задний двор (закрыт для внешних)
    │ :8080 ???    │ ← Запасной выход (зачем открыт?)
    └──────────────┘
```

**Минимизация attack surface:**
- Открыто только **необходимое**
- Всё остальное — закрыто
- MySQL? Только с localhost или VPN
- Random порты? Если не знаешь зачем — закрой!

---

**💡 AHA Moment: UFW знает имена сервисов**

```bash
# Два способа:
sudo ufw allow 22/tcp     # По номеру
sudo ufw allow ssh        # По имени (UFW знает ssh = 22)

sudo ufw allow 80/tcp
sudo ufw allow http       # То же самое!

sudo ufw allow 443/tcp
sudo ufw allow https      # То же самое!

# Откуда UFW знает?
cat /etc/services | grep -E "^ssh|^http"
```

Вывод: `ssh    22/tcp`, `http   80/tcp`

**LILITH:**
> *"Имена удобнее. Но я предпочитаю номера — explicitness. Видишь 22 — сразу понятно."*

---

#### 💻 Практика: Разрешение веб-трафика (2 мин)

**Задание:** Разрешите HTTP (80) и HTTPS (443).

```bash
# Способ 1: По номеру порта
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# Способ 2: По имени (короче)
sudo ufw allow http
sudo ufw allow https

# Проверка
sudo ufw status numbered
```

**Результат:**
```
To                         Action      From
--                         ------      ----
[ 1] 22/tcp                 ALLOW IN    Anywhere      # SSH access
[ 2] 80/tcp                 ALLOW IN    Anywhere      # HTTP
[ 3] 443/tcp                ALLOW IN    Anywhere      # HTTPS
```

**LILITH:**
> *"Хорошо. Теперь legitimate пользователи могут зайти на сайт. Но ботнет тоже может бить по 80/443. Rate limiting — позже."*

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** Нужно ли открывать port 80 если есть 443 (HTTPS)?

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:** Да, обычно нужны ОБА!

**Зачем?**
- **Port 80:** HTTP → перенаправление на HTTPS (301 redirect)
- **Port 443:** HTTPS → реальный трафик

**Пример:**
```
User → http://example.com:80
     → 301 redirect
     → https://example.com:443 ✓
```

Если закрыть 80 → пользователь вводит `example.com` → браузер пробует 80 → timeout!

**Исключение:** Если 100% пользователей знают адрес с `https://` — можно закрыть 80.

**LILITH:**
> *"В реальности: 80 открыт всегда. Люди ленивы набирать https://."*

</details>

---

### Цикл 4: Block Botnet IPs (15 минут) 🚫

#### 🎬 Сюжет (3 мин)

**Анна:**
> *"Макс, я отследила источники атаки. 847 IP адресов. Список в `artifacts/botnet_ips.txt`. Заблокируй их все."*

**Макс:**
> *"Все? Вручную?!"*

**Анна:**
> *"Bash loop. While read. 2 минуты работы."*

**Макс:**
> *"Но... это же Type B episode! Мы не должны писать bash wrappers!"*

**Анна:**
> *"Loop ≠ wrapper. Loop — это automation одной команды. Wrapper — это замена инструмента. Разница."*

**LILITH:**
> *"Правильно. Type B: используй ufw/iptables напрямую. Bash loop — просто повторение команды 847 раз. Ты же не будешь вводить вручную?"*

---

#### 📚 Теория: UFW vs iptables для блокировки (6 мин)

**Два подхода:**

**1. UFW (проще, медленнее)**
```bash
sudo ufw deny from 185.220.101.47
sudo ufw deny from 91.219.237.244
# ... 847 раз
```

**Проблема:** Каждая команда = перезагрузка правил (медленно!)

**2. iptables (сложнее, быстрее)**
```bash
sudo iptables -I INPUT -s 185.220.101.47 -j DROP
sudo iptables -I INPUT -s 91.219.237.244 -j DROP
# ... 847 раз
```

**Быстрее:** Прямое добавление в kernel (без reload)

---

**🎭 МЕТАФОРА #4: UFW = Менеджер, iptables = Исполнитель**

```
           UFW
            ↓
    [перезагрузка правил]
            ↓
        iptables
            ↓
        Netfilter (kernel)
```

**UFW:** "Добавь правило" → reload всех правил → медленно

**iptables:** "Добавь правило" → прямо в kernel → быстро

**Когда использовать что:**
- **UFW:** < 100 правил, простота
- **iptables:** > 100 правил, скорость
- **ipset:** > 1000 IP, оптимально (advanced)

---

**💡 AHA Moment: -A vs -I**

```bash
# -A = Append (в конец chain)
sudo iptables -A INPUT -s 1.2.3.4 -j DROP

# -I = Insert (в начало chain)
sudo iptables -I INPUT -s 1.2.3.4 -j DROP
```

**Разница:**
```
Chain INPUT:
1. ACCEPT 10.0.0.0/8 (trusted network)
2. DROP    1.2.3.4   (botnet) ← Insert сюда (-I)
3. ACCEPT  22/tcp    (SSH)
...
99. DROP   5.6.7.8   (botnet) ← Append сюда (-A)
```

**Правила проверяются сверху вниз** — первое совпадение = action!

**Для блокировки:** `-I` (insert) — проверяется раньше → быстрее DROP

**LILITH:**
> *"-I для блокировки. Чем раньше DROP — тем меньше CPU тратим на проверку остальных правил."*

---

#### 💻 Практика: Блокировка botnet IPs (5 мин)

**Задание:** Заблокируйте все IP из `artifacts/botnet_ips.txt`.

**Файл содержит:**
```
# Botnet IPs from Krylov's attack
185.220.101.52    # Tor exit node
45.142.120.10     # VPN provider
...
```

**Скрипт (Type B approach — loop с прямыми командами):**

```bash
#!/bin/bash
# block_botnet.sh - Type B: direct iptables commands

BOTNET_FILE="artifacts/botnet_ips.txt"
count=0

echo "Blocking botnet IPs with iptables..."

while IFS= read -r line; do
    # Пропустить пустые строки и комментарии
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Извлечь IP (первое слово)
    ip=$(echo "$line" | awk '{print $1}')

    # Валидация IP
    if [[ ! "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo "⚠ Invalid IP: $ip (skipped)"
        continue
    fi

    # Блокировка через iptables (Type B: direct command!)
    sudo iptables -I INPUT -s "$ip" -j DROP
    count=$((count + 1))

    # Progress каждые 50 IP
    if ((count % 50 == 0)); then
        echo "  Blocked: $count IPs..."
    fi

done < "$BOTNET_FILE"

echo "✓ Blocked $count IPs total"
echo ""

# Проверка
echo "Verification:"
echo "  iptables DROP rules: $(sudo iptables -L INPUT -n | grep -c DROP)"
echo "  SYN_RECV connections: $(netstat -an 2>/dev/null | grep -c SYN_RECV)"
```

**Запуск:**
```bash
chmod +x block_botnet.sh
./block_botnet.sh
```

**Результат:**
```
Blocking botnet IPs with iptables...
  Blocked: 50 IPs...
  Blocked: 100 IPs...
  ...
  Blocked: 847 IPs...
✓ Blocked 847 IPs total

Verification:
  iptables DROP rules: 847
  SYN_RECV connections: 23  (было 847!)
```

**LILITH:**
> *"Неплохо. SYN_RECV с 847 упал до 23. Это 97% reduction. Но Крылов умён — он постоянно меняет IP. Rate limiting — следующий шаг."*

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** Почему мы используем bash loop здесь, если это Type B episode?

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:** Loop ≠ Wrapper!

**Type A (плохо):**
```bash
# Функция-wrapper заменяет ufw
block_ip() {
    local ip="$1"
    sudo ufw deny from "$ip"
    # + ещё 50 строк логики
}
```
→ Скрыли инструмент, создали свой API

**Type B (хорошо):**
```bash
# Loop просто повторяет прямую команду
while read ip; do
    sudo iptables -I INPUT -s "$ip" -j DROP  # Прямая команда!
done < file.txt
```
→ Видна прямая команда, просто автоматизация

**LILITH:**
> *"Type B = используй инструменты напрямую. Bash для automation — OK. Bash вместо инструмента — NOT OK."*

</details>

---

### Цикл 5: Rate Limiting (15 минут) ⚡

#### 🎬 Сюжет (2 мин)

**Алекс:**
> *"Хорошо! Но этого недостаточно. Крылов постоянно меняет IP. Нужен rate limiting — ограничение скорости подключений. Если кто-то шлёт > 20 SYN в секунду — блокируем."*

**Макс:**
> *"Как это сделать?"*

**Алекс:**
> *"iptables modules: connlimit, recent, hashlimit. Каждый для своей задачи."*

---

#### 📚 Теория: Rate Limiting Types (7 мин)

**🎭 МЕТАФОРА #5: Rate Limiting = Ограничение потока в клубе**

```
🏢 Клуб (capacity: 100 человек)

Без rate limiting:
  1000 человек пытаются зайти сразу
  → Давка, кто-то упал, клуб закрылся

С rate limiting:
  Максимум 5 человек/минуту
  → Очередь, но все живы, клуб работает
```

**SYN Flood = Фальшивые бронирования:**
- Attacker бронирует 1000 столиков
- Не приходит
- Real guests не могут забронировать
- Ресторан теряет деньги

**Rate limiting = "Максимум 3 бронирования с одного номера"**

---

**3 типа rate limiting в iptables:**

**1. connlimit — лимит одновременных соединений**
```bash
# Максимум 20 TCP соединений с одного IP
sudo iptables -A INPUT -p tcp --syn -m connlimit \
    --connlimit-above 20 --connlimit-mask 32 \
    -j REJECT --reject-with tcp-reset
```

**Use case:** Защита от connection exhaustion

---

**2. recent — трекинг попыток по времени**
```bash
# Трекинг SSH подключений
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW \
    -m recent --set --name SSH

# Блокировка если > 4 попыток за 60 секунд
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW \
    -m recent --update --seconds 60 --hitcount 5 --name SSH \
    -j DROP
```

**Use case:** SSH brute-force protection

---

**3. hashlimit — per-IP rate limiting**
```bash
# Каждый IP: максимум 50 HTTP requests/sec
sudo iptables -A INPUT -p tcp --dport 80 -m hashlimit \
    --hashlimit-above 50/sec \
    --hashlimit-mode srcip \
    --hashlimit-name http_limit \
    -j DROP
```

**Use case:** DDoS protection для веб-сервиса

---

**💡 AHA Moment: Token Bucket Algorithm**

```
Rate limit = ведро с токенами

┌──────────────┐
│  🪙 🪙 🪙 🪙  │  ← Bucket (capacity = burst)
└──────────────┘
       ↓
Пополняется: 10 tokens/sec (rate)
Каждый пакет забирает 1 token
Нет токенов → DROP

Пример: --limit 10/sec --limit-burst 20
  Start: 20 tokens
  Request 1-20: используют все токены (bucket = 0)
  Request 21: DROP (нет tokens)
  Через 1 sec: +10 tokens (bucket = 10)
  Request 22-31: используют 10 tokens
```

**LILITH:**
> *"Token bucket = справедливо. Можешь burst (всплеск), но не бесконечно. Токены кончаются — жди."*

---

#### 💻 Практика: Настройка rate limiting (5 мин)

**Задание:** Настройте rate limiting для защиты от SYN flood.

```bash
#!/bin/bash
# rate_limiting.sh - Type B: direct iptables

echo "=== CONFIGURING RATE LIMITING ==="
echo ""

# 1. Limit simultaneous connections (connlimit)
echo "[1] Connection limit: 20 per IP..."
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

# 3. HTTP rate limiting (hashlimit)
echo "[3] HTTP/HTTPS rate limiting..."
sudo iptables -A INPUT -p tcp --dport 80 -m hashlimit \
    --hashlimit-above 50/sec --hashlimit-mode srcip \
    --hashlimit-name http_limit -j DROP

sudo iptables -A INPUT -p tcp --dport 443 -m hashlimit \
    --hashlimit-above 50/sec --hashlimit-mode srcip \
    --hashlimit-name https_limit -j DROP
echo "✓ Max 50 HTTP/HTTPS req/sec per IP"
echo ""

# 4. ICMP flood protection
echo "[4] ICMP (ping) flood protection..."
sudo iptables -A INPUT -p icmp -m limit \
    --limit 5/sec --limit-burst 10 -j ACCEPT
sudo iptables -A INPUT -p icmp -j DROP
echo "✓ Max 5 pings/sec"
echo ""

echo "=== RATE LIMITING CONFIGURED ==="
```

**Результат:**
```
Load Average (before): 47.82
Load Average (after):  2.15  (⬇ 95% reduction!)

SYN_RECV (before): 847
SYN_RECV (after):  8    (⬇ 99% reduction!)
```

**LILITH:**
> *"Excellent. Load с 47 упал до 2. Атака отражена. Rate limiting работает."*

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** В чём разница между connlimit и hashlimit?

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:**

**connlimit:**
- Считает **одновременные** соединения
- "Сколько connections открыто СЕЙЧАС с этого IP?"
- Max 20 connections → 21-е REJECT

**hashlimit:**
- Считает **скорость** новых подключений
- "Сколько NEW connections в секунду/минуту?"
- > 50/sec → DROP

**Пример:**
```
Легитимный пользователь:
  - 10 открытых connections (connlimit OK)
  - 2 new connections/sec (hashlimit OK)
  → ALLOW

Botnet:
  - 5 открытых connections (connlimit OK)
  - 1000 new connections/sec (hashlimit DROP!)
  → BLOCKED
```

**LILITH:**
> *"connlimit = сколько столиков занял. hashlimit = как быстро бронируешь новые. Оба нужны."*

</details>

---

### Цикл 6: Logging & Monitoring (12 минут) 📊

#### 🎬 Сюжет (2 мин)

**Анна:**
> *"Макс, мне нужны логи. Каждый DROP нужно записать — IP, порт, timestamp. Forensics требует доказательств."*

**Макс:**
> *"Как логировать iptables?"*

**Анна:**
> *"Target LOG. Ставишь правило перед DROP — оно пишет в `/var/log/kern.log`. Только не забудь `-m limit`, иначе диск заполнится за минуту."*

---

#### 📚 Теория: iptables Logging (5 мин)

**Log target:**
```bash
sudo iptables -A INPUT -j LOG \
    --log-prefix '[FIREWALL] ' \
    --log-level 4
```

**Parameters:**
- `--log-prefix`: Метка для фильтрации (max 29 символов)
- `--log-level`: 0-7 (4 = warning, стандарт)

**Важно:** LOG ≠ terminal action (ACCEPT/DROP/REJECT)

```bash
# Правильно: LOG + DROP
iptables -A INPUT -s 1.2.3.4 -j LOG --log-prefix '[BOTNET] '
iptables -A INPUT -s 1.2.3.4 -j DROP

# Неправильно: только LOG (пакет пройдёт!)
iptables -A INPUT -s 1.2.3.4 -j LOG
```

---

**💡 AHA Moment: Зачем -m limit для логов?**

**Без limit:**
```bash
iptables -A INPUT -j LOG --log-prefix '[DROP] '
iptables -A INPUT -j DROP
```

**Атака:** 50,000 packets/sec
**Результат:** 50,000 лог-записей/sec = **180 MB/sec**

Диск 100GB заполнится за 10 минут!

**С limit:**
```bash
iptables -A INPUT -m limit --limit 5/min \
    -j LOG --log-prefix '[DROP] '
iptables -A INPUT -j DROP
```

**Результат:** Максимум 5 записей/минуту = **безопасно**

**LILITH:**
> *"Логировать без limit = DDoS самого себя. Диск заполнится быстрее чем сервер упадёт."*

---

**Лог формат:**
```
Jan 15 04:03:42 shadow-server-02 kernel: [FIREWALL DROP] \
IN=eth0 OUT= SRC=185.220.101.47 DST=10.50.1.1 \
PROTO=TCP SPT=54321 DPT=22 WINDOW=65535 SYN
```

**Парсинг:**
- `SRC=` — IP атакующего
- `DPT=` — destination port (какой порт атакуют)
- `SYN` — TCP flag (SYN flood indicator)

---

#### 💻 Практика: Настройка логирования (4 мин)

```bash
#!/bin/bash
# logging.sh - Type B approach

echo "=== CONFIGURING ATTACK LOGGING ==="
echo ""

# 1. Log SSH brute-force attempts
echo "[1] SSH brute-force logging..."
sudo iptables -A INPUT -p tcp --dport 22 -m recent --name SSH_TRACK \
    --rcheck --seconds 60 --hitcount 5 \
    -m limit --limit 2/min \
    -j LOG --log-prefix '[SSH BRUTEFORCE] ' --log-level 4
echo "✓ SSH attacks logged"
echo ""

# 2. Log SYN flood
echo "[2] SYN flood logging..."
sudo iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above 20 \
    -m limit --limit 2/min \
    -j LOG --log-prefix '[SYN FLOOD] ' --log-level 4
echo "✓ SYN flood logged"
echo ""

# 3. Configure rsyslog for separate firewall log
echo "[3] Configuring rsyslog..."
cat << 'EOF' | sudo tee /etc/rsyslog.d/10-firewall.conf > /dev/null
:msg, contains, "[FIREWALL" /var/log/firewall.log
:msg, contains, "[SSH BRUTEFORCE]" /var/log/firewall-attacks.log
:msg, contains, "[SYN FLOOD]" /var/log/firewall-attacks.log
& stop
EOF

sudo systemctl restart rsyslog
echo "✓ Logs: /var/log/firewall.log"
echo "✓ Attacks: /var/log/firewall-attacks.log"
echo ""

# 4. View recent attacks
echo "[4] Recent attacks (last 5):"
sudo tail -5 /var/log/firewall-attacks.log 2>/dev/null || echo "  (no attacks yet)"
```

**Анализ логов:**
```bash
# Real-time monitoring
sudo tail -f /var/log/firewall-attacks.log

# Top attacking IPs
sudo awk '/FIREWALL/ {for(i=1;i<=NF;i++) if($i~/^SRC=/) print substr($i,5)}' \
    /var/log/firewall.log | sort | uniq -c | sort -rn | head -10
```

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** Что означает `& stop` в rsyslog конфиге?

```
:msg, contains, "[FIREWALL" /var/log/firewall.log
& stop
```

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:** "Не дублировать в другие логи"

**Без `& stop`:**
```
[FIREWALL] запись → /var/log/firewall.log
                   → /var/log/syslog (дубль!)
                   → /var/log/kern.log (дубль!)
```

**С `& stop`:**
```
[FIREWALL] запись → /var/log/firewall.log
                   → STOP (не писать дальше)
```

**Зачем?** Экономия места + легче искать (один файл вместо трёх).

**LILITH:**
> *"& stop = 'хватит дублировать'. Один лог-файл на тип события — чисто и понятно."*

</details>

---

### Цикл 7: Final Security Audit (12 минут) ✅

#### 🎬 Сюжет (3 мин)

**04:07 — Ровно 5 минут прошло**

**Алекс** (спокойно):
> *"Макс. Посмотри на Load Average."*

```bash
$ uptime
 04:07:23 up 2 days, 14:35,  load average: 1.92, 3.45, 8.67
```

**Макс** (не верит):
> *"1.92?! Было 47!"*

**Алекс:**
> *"Ты отразил DDoS. Поздравляю. Теперь задокументируй всё. Виктор требует отчёт."*

**LILITH:**
> *"Load average: 47.82 → 1.92. That's 96% reduction. Attack mitigated. Now prove it with data."*

---

#### 📚 Теория: Security Audit Components (4 мин)

**Что включает audit report:**

1. **Incident Summary**
   - Start/end time
   - Attack type
   - Source IPs count
   - Peak metrics

2. **Firewall Configuration**
   - UFW status
   - iptables rules count
   - Blocked IPs

3. **System Metrics**
   - Load average (before/after)
   - SYN_RECV count
   - Memory/CPU usage

4. **Effectiveness Assessment**
   - Attack reduction %
   - False positives?
   - Legitimate traffic OK?

5. **Recommendations**
   - Next steps
   - Improvements
   - Monitoring plan

---

#### 💻 Практика: Generate Audit Report (4 мин)

**Задание:** Сгенерируйте final security audit report.

```bash
#!/bin/bash
# audit_report.sh - Type B: collect results YOU configured

REPORT_FILE="artifacts/firewall_audit_report.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

{
    echo "═══════════════════════════════════════════════════════════"
    echo "         FIREWALL SECURITY AUDIT REPORT"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "Date:     $TIMESTAMP"
    echo "Location: ЦОД 'Москва-1', Серверная A-12 🇷🇺"
    echo "Operator: Max Sokolov"
    echo "Incident: DDoS Attack Response (Day 13 of 60)"
    echo ""

    echo "═══════════════════════════════════════════════════════════"
    echo " [1] INCIDENT SUMMARY"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "Start Time:   03:47 (emergency call)"
    echo "End Time:     04:07 (attack mitigated)"
    echo "Duration:     20 minutes"
    echo "Attack Type:  DDoS (SYN Flood)"
    echo "Source IPs:   847 botnet nodes"
    echo "Peak Load:    47.82 (CRITICAL)"
    echo "Final Load:   $(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1)"
    echo ""
    echo "STATUS: ✓ ATTACK MITIGATED"
    echo ""

    echo "═══════════════════════════════════════════════════════════"
    echo " [2] FIREWALL CONFIGURATION"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    sudo ufw status verbose 2>/dev/null
    echo ""
    echo "iptables DROP rules: $(sudo iptables -L INPUT -n | grep -c DROP)"
    echo ""

    echo "═══════════════════════════════════════════════════════════"
    echo " [3] CURRENT METRICS"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "Load Average:    $(uptime | awk -F'load average:' '{print $2}')"
    echo "SYN_RECV count:  $(netstat -an 2>/dev/null | grep -c SYN_RECV)"
    echo "Memory usage:    $(free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2}')"
    echo ""

    echo "═══════════════════════════════════════════════════════════"
    echo " [4] SECURITY MEASURES IMPLEMENTED"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "✓ UFW enabled (default deny incoming)"
    echo "✓ SSH (22), HTTP (80), HTTPS (443) allowed"
    echo "✓ 847 botnet IPs blocked (iptables)"
    echo "✓ Rate limiting:"
    echo "    - Max 20 connections per IP"
    echo "    - SSH: 4 attempts/minute"
    echo "    - HTTP/HTTPS: 50 req/sec per IP"
    echo "✓ Attack logging enabled"
    echo "✓ Logs: /var/log/firewall-attacks.log"
    echo ""

    echo "═══════════════════════════════════════════════════════════"
    echo " [5] RECOMMENDATIONS"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "1. Monitor logs daily: sudo tail -f /var/log/firewall-attacks.log"
    echo "2. Update botnet IP list weekly (IPs change)"
    echo "3. Consider fail2ban for automation"
    echo "4. Backup rules: sudo iptables-save > /etc/iptables.rules"
    echo "5. Episode 08: VPN for encrypted communications"
    echo ""

    echo "═══════════════════════════════════════════════════════════"
    echo " END OF REPORT"
    echo "═══════════════════════════════════════════════════════════"

} > "$REPORT_FILE"

echo "✓ Report generated: $REPORT_FILE"
cat "$REPORT_FILE"
```

**Результат:** Comprehensive audit report с доказательствами эффективности.

---

#### 🤔 Проверка понимания (1 мин)

**Вопрос:** Почему audit report важен?

<details>
<summary>💡 Думай перед проверкой</summary>

**Ответ:** Документация + доказательства!

**Зачем:**
1. **Forensics:** Анна нужны данные для расследования
2. **Compliance:** Виктор отчитывается перед заказчиком
3. **Future reference:** Следующая атака — смотришь что работало
4. **Learning:** Показать что делал, получить feedback

**LILITH:**
> *"Без документации — ты не сделал ничего. Код без комментариев, firewall без audit report — одна хуйня."*

</details>

---

### Цикл 8: Завершение + Advanced Topics (10 минут) 🎓

#### 🎬 Сюжет: Завершение эпизода (3 мин)

**04:08 — Тишина после бури**

**Макс смотрит на экран. Графики Grafana зелёные.**

**Алекс:**
> *"Не просто получилось. Ты отразил профессиональную DDoS атаку. За 20 минут. Удалённо. Из самолёта."*

**Виктор:**
> *"Отчёт получил. Впечатляюще. Сервер работает, данные в безопасности. Макс, ты справился."*

**Анна:**
> *"Я проанализировала IP. Все из сети Крылова. Он знал что мы в Москве. Это была целенаправленная атака."*

---

**04:15 — Сообщение в логах**

```bash
$ sudo tail -1 /var/log/firewall-attacks.log

Jan 15 04:14:58 shadow-server-02 kernel: [BOTNET BLOCKED]
SRC=185.220.101.47 DST=10.50.1.1
MSG="Соколов. Передай брату: я найду вас. Обоих. - К."
```

**Макс** (тихо):
> *"Это... сообщение в логах? Как?!"*

**Алекс** (голос напряжён):
> *"TCP payload. Он встроил текст в пакеты. Это не просто атака. Это... угроза."*

**Виктор:**
> *"Мы переходим на защищённые каналы. Немедленно. Episode 08 — VPN и шифрование."*

**LILITH:**
```
Episode 07 Complete.
Krylov escalates. Security must escalate too.
Next: Episode 08 - VPN & SSH Tunneling.
Stay sharp. Stay hidden. Stay alive.
```

---

#### 📚 Advanced Topics (5 мин)

**Что дальше изучать:**

**1. fail2ban** — автоматическое банирование
```bash
sudo apt install fail2ban
# Мониторит логи → автоматически банит IP
```

**2. ipset** — эффективное хранение больших списков IP
```bash
# 10,000 IP = 1 правило вместо 10,000
sudo ipset create blacklist hash:ip
sudo iptables -I INPUT -m set --match-set blacklist src -j DROP
```

**3. nftables** — современная замена iptables
- Проще синтаксис
- IPv4 и IPv6 в одном правиле
- Atomic updates

**4. IDS/IPS** — Intrusion Detection/Prevention
- Snort
- Suricata
- OSSEC

**5. WAF** — Web Application Firewall
- ModSecurity
- Cloudflare
- AWS WAF

---

#### 🤔 Final Quiz (2 мин)

**Вопрос 1:** Что важнее сделать ПЕРВЫМ при включении UFW?

<details>
<summary>Ответ</summary>

**Разрешить SSH (port 22)!**

```bash
sudo ufw allow 22/tcp  # FIRST!
sudo ufw enable        # THEN!
```

Иначе — lockout.

</details>

---

**Вопрос 2:** В чём разница между DROP и REJECT?

<details>
<summary>Ответ</summary>

- **DROP:** Молча отбрасывает пакет (attacker не знает что заблокирован)
- **REJECT:** Отбрасывает + отправляет ICMP "port unreachable"

**Для security:** DROP лучше (не даёт информацию attackers).

</details>

---

**Вопрос 3:** Зачем `-m limit` при логировании?

<details>
<summary>Ответ</summary>

**Защита от заполнения диска!**

Без limit: 50,000 packets/sec → 50,000 лог-записей/sec → диск полный за минуты.

С limit: max 5 записей/минуту → безопасно.

</details>

---

## ✅ Что вы изучили

### Технические навыки:
- ✅ **UFW** — настройка, enable/disable, allow/deny
- ✅ **iptables** — chains, targets, правила
- ✅ **Rate limiting** — connlimit, recent, hashlimit
- ✅ **IP blocking** — массовая блокировка через loop
- ✅ **Logging** — iptables LOG, rsyslog, анализ
- ✅ **Monitoring** — load average, SYN_RECV, metrics
- ✅ **Type B approach** — использование инструментов напрямую

### Soft skills:
- ✅ Работа под давлением (5 минут deadline)
- ✅ Удалённое администрирование (высокая latency)
- ✅ Incident response
- ✅ Documentation (audit reports)

### Сюжет:
- ✅ Первый серьёзный incident (DDoS)
- ✅ Макс доказал навыки под давлением
- ✅ Крылов эскалирует — угроза Алексу и Максу
- ✅ Переход к VPN (Episode 08)

---

## 📁 Solution Files (Type B)

Ваше решение должно включать:

```
solution/
├── configs/
│   ├── ufw_rules.sh             # UFW configuration (NOT wrapper!)
│   └── iptables_backup.sh       # iptables alternative (advanced)
├── scripts/
│   └── generate_firewall_report.sh  # Report generator (~100 lines)
└── README.md                    # Type B documentation
```

**Философия:** Прямые команды UFW/iptables, НЕ bash wrappers!

**Проверка решения:**
```bash
# 1. Применить UFW rules
sudo ./solution/configs/ufw_rules.sh

# 2. Или использовать iptables
sudo ./solution/configs/iptables_backup.sh

# 3. Проверка
sudo ufw status verbose
sudo iptables -L -v -n

# 4. Generate report
./solution/scripts/generate_firewall_report.sh
```

**Type B Success Criteria:**
- ✅ Использовал ufw/iptables напрямую (не wrapper!)
- ✅ Bash loop для bulk operations (OK!)
- ✅ Production-ready конфиги
- ✅ Report generator < 150 строк

---

## 📖 Ресурсы

**Man pages:**
```bash
man ufw
man iptables
man iptables-extensions  # connlimit, recent, hashlimit
```

**Файлы:**
```
/etc/ufw/ufw.conf          # UFW config
/var/log/ufw.log           # UFW logs
/var/log/kern.log          # iptables logs
```

**Online:**
- UFW Documentation: https://help.ubuntu.com/community/UFW
- iptables Tutorial: https://www.netfilter.org/documentation/

---

*"Firewall — это не стена. Это вышибала. Хороший вышибала знает кого впускать, кого выкинуть, а кого просто наблюдать."* — Алекс Соколов

**Episode 07 Complete!** ✓

**Next:** Episode 08 — VPN & SSH Tunneling 🔒

---
