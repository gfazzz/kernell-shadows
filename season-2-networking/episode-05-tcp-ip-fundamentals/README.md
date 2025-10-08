# Episode 05: TCP/IP Fundamentals

```
ОПЕРАЦИЯ: KERNEL SHADOWS
СЕЗОН: 2 — Networking
ЭПИЗОД: 05 — TCP/IP Fundamentals
ЛОКАЦИЯ: 🇷🇺 Москва, Россия (ЦОД "Москва-1")
ДЕНЬ ОПЕРАЦИИ: 9 (из 60)
СЛОЖНОСТЬ: ⭐⭐☆☆☆
ВРЕМЯ: 4-5 часов
```

---

## 📅 День 8 (10 октября 2025, 21:37): Звонок от Alex

### Новосибирск → Москва

**Локация:** Квартира Max, Академгородок. За окном темнота и снег. Время: 21:37.

Max только что закончил Episode 04 (package management). Viktor перевёл $15K. 4 эпизода пройдены.

Телефон. **Alex Sokolov** (двоюродный брат).

> **Alex:**
> *"Макс. У нас проблема. Krylov знает о нас. Нужен ты. Лично. Завтра. Москва."*

Max: *"Какая проблема?"*

> **Alex:**
> *"По телефону не говорю. Вылетаешь рейсом S7 в 09:15. Билет отправил на email. Встречу в Домодедово."*

Max: *"Alex, что происходит?"*

> **Alex:**
> *"Нас прослушивают. Сети скомпрометированы. Приезжай."*

Гудки. Alex отключился.

Max смотрит на экран. Email от Alex:
```
From: a.sokolov@secured.net
Subject: Билет S7-1203 (NVS → DME)
Attachment: ticket.pdf

Завтра. 09:15. Не опаздывай.
— A.
```

Max: *"Чёрт. Что-то пошло не так."*

**Пауза.**

Max: *"Ладно. Москва так Москва."*

---

## 📅 День 9 (11 октября 2025, 12:40): Встреча с командой

### Аэропорт Домодедово → ЦОД "Москва-1"

**12:40 — Домодедово, зал прилёта**

Max выходит из терминала. Толпа, такси, холодный ветер. Москва. Впервые за пределами Новосибирска для работы.

Черный BMW X5. Тонированные стёкла. Водительская дверь открывается.

**Alex Sokolov.** 35 лет. Короткая стрижка, спортивная куртка, проницательный взгляд. Ex-FSB. Твой двоюродный брат.

> **Alex:**
> *"Макс. Добро пожаловать в Москву. Садись. Поедем в ЦОД."*

Max садится. BMW уезжает от терминала.

> **Alex:**
> *"Как прошли первые 4 эпизода?"*

Max: *"Справился. Viktor доволен. Но ты же не поэтому меня вызвал?"*

> **Alex:**
> *"Нет. Krylov активизировался. DDoS атаки. DNS spoofing. Вчера было 50,000 пакетов в секунду на серверы Viktor."*

Max: *"Krylov? Кто это?"*

Пауза. Alex смотрит в зеркало заднего вида. Проверяет слежку.

> **Alex:**
> *"Полковник Кирилл Крылов. ФСБ, Управление 'К'. Мой бывший начальник. Когда я ушёл из ФСБ... он не простил."*

Max: *"И что ему нужно?"*

> **Alex:**
> *"Нас. Меня. Viktor. Операцию. Я не знаю. Но он атакует сети. Нам нужно понять как. Для этого ты должен понимать TCP/IP."*

**13:30 — ЦОД "Москва-1", Северо-Восточный АО**

Промышленная зона. Здание без вывесок. 5 этажей. Бетонные стены. Охрана. Турникеты. Биометрия.

Alex проводит Max внутрь. Холодный воздух кондиционеров. Гудение серверов. Мигающие зелёные и красные LED.

**Серверная комната A-12.**

Три человека уже здесь:

### **Viktor Petrov**
Седые волосы, чёрный костюм. Координатор операции.

> **Viktor:**
> *"Max. Хорошо что прилетел. Ситуация серьёзная."*

### **Anna Kovaleva**
32 года, блондинка, строгий костюм, laptop с Wireshark. Ex-FSB, forensics expert.

> **Anna:**
> *"Max Sokolov. Alex много о тебе рассказывал. Я Anna. Forensics. Буду работать с логами атак. Нам нужен твой сисадмин опыт для защиты сетей."*

### **Dmitry Orlov**
29 лет, hoodie, джинсы, 3 монитора. DevOps engineer.

> **Dmitry:**
> *"Макс! Наконец-то лично. Твои скрипты из Episode 02-04 — огонь. Я их уже задеплоил на 15 серверов. Но сеть — это моя слабая сторона. Ты сильнее."*

Max: *"Приятно познакомиться. Что случилось?"*

**Viktor показывает на мониторы.**

Grafana dashboard. Красные графики. Alerts.

> **Viktor:**
> *"50,000 пакетов/сек. DDoS. DNS запросы идут не туда. Кто-то прослушивает трафик. Krylov?"*

> **Alex:**
> *"Скорее всего. Он использует методы, которые я применял в ФСБ."*

> **Anna:**
> *"Логи показывают подозрительный трафик с 185.220.101.47. Tor exit node. Классический Krylov почерк."*

> **Viktor:**
> *"Max, нам нужно понять сети. TCP/IP. Модель OSI. IP адреса. Порты. Как работают атаки. Как защищаться."*

> **Alex:**
> *"Я научу тебя думать как атакующий. Anna — как защитник. Dmitry поможет с автоматизацией."*

> **Viktor:**
> *"Начинаем с основ. TCP/IP. Сегодня. У тебя 4-5 часов. Погружайся."*

---

## 🎮 Начало миссии

### 14:00 — LILITH появляется

Max садится за свободный терминал. Linux workstation. Ubuntu 24.04. Три монитора. Клавиатура механическая (Krylov может прослушивать?).

Экран мигает. LILITH активируется:

```
┌─────────────────────────────────────────────────────────────┐
│                                                               │
│   LILITH v2.0 — Networking Module                            │
│                                                               │
│   Привет снова, Max.                                          │
│   Новосибирск был разминкой. Москва — настоящая работа.      │
│                                                               │
│   Krylov атакует сети. Чтобы защищаться, нужно понимать      │
│   как работают сети. TCP/IP — это язык интернета.            │
│                                                               │
│   Каждый пакет рассказывает историю.                         │
│   Научись слушать.                                            │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

> **LILITH:**
> *"Сейчас ты в ЦОД 'Москва-1'. Вокруг тебя 200+ серверов. 50 из них — операция Viktor. Остальные — чужие. Каждый имеет IP адрес. Каждый слушает порты. Некоторые атакуют. Твоя задача — понять кто есть кто."*

Max: *"С чего начать?"*

> **LILITH:**
> *"С основ. IP адреса. TCP vs UDP. Порты. Сокеты. Потом — практика. Определишь IP сервера Viktor. Проверишь открытые порты. Найдёшь маршрут до сервера. Поехали."*

---

## 📚 Задания

### Задание 1: Узнать свой IP адрес ⭐

**Контекст:**
Alex: *"Первое правило networking — знай свой адрес. Как тебя зовут в сети?"*

**Задача:**
Определите IP адрес рабочей станции Max.

**Попробуйте сами (3-5 минут):**

Сначала попробуйте найти IP адрес самостоятельно.

```bash
# Ваша команда здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**LILITH:**
> *"Команда `ip` — твой друг. `ip address` или короче `ip a`. Смотри внимательно — там может быть несколько интерфейсов: `lo` (loopback), `eth0` (ethernet), `wlan0` (wifi). Тебе нужен активный интерфейс с реальным IP."*

Попробуйте:
```bash
ip a
```

Ищите строку с `inet` (не `inet6`), и не на интерфейсе `lo` (localhost).

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Конкретные команды:**

```bash
# Вариант 1: Показать только IPv4 адреса
ip -4 a

# Вариант 2: Только IP без деталей
hostname -I

# Вариант 3: Конкретный интерфейс
ip a show eth0
```

**Как парсить:**
```bash
# Извлечь IP из вывода
ip a show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
```

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Команда для скрипта:**
```bash
# Найти первый активный IP (не localhost)
WORKSTATION_IP=$(ip -4 a | grep -v "127.0.0.1" | grep "inet " | awk '{print $2}' | cut -d/ -f1 | head -n1)
echo "Workstation IP: $WORKSTATION_IP"
```

**Объяснение:**
- `ip -4 a` — только IPv4 адреса
- `grep -v "127.0.0.1"` — исключить localhost
- `grep "inet "` — найти строки с IP
- `awk '{print $2}'` — взять 2-ю колонку (IP/mask)
- `cut -d/ -f1` — убрать маску (/24)
- `head -n1` — первый результат

**Альтернатива (проще):**
```bash
hostname -I | awk '{print $1}'
```

</details>

<details>
<summary>🔍 Что такое IP адрес? (теория)</summary>

### IP адрес (Internet Protocol Address)

**Определение:**
IP адрес — уникальный числовой идентификатор устройства в сети.

**Формат IPv4:**
```
192.168.1.100
    ^     ^
    |     |
Сеть  Хост
```

- 4 октета (числа 0-255)
- Разделены точками
- Пример: `10.0.0.42`, `192.168.1.1`, `8.8.8.8`

**Классы сетей:**
- **Class A:** 10.0.0.0/8 (private)
- **Class B:** 172.16.0.0/12 (private)
- **Class C:** 192.168.0.0/16 (private)
- **Публичные:** всё остальное (маршрутизируются в интернете)

**Loopback:**
- `127.0.0.1` — localhost (компьютер обращается к самому себе)
- Используется для тестирования

**IPv6:** (новый стандарт)
```
2001:0db8:85a3:0000:0000:8a2e:0370:7334
```
- 128 бит (vs 32 бита в IPv4)
- Записывается в hex
- Почти бесконечное количество адресов

**Команды:**
```bash
# Современный способ (ip command)
ip address show
ip a  # короткая форма

# Устаревший способ (ifconfig)
ifconfig  # deprecated, но ещё встречается

# Только IP (без деталей)
hostname -I
```

**Что важно:**
- IP адрес может быть статическим (назначен вручную) или динамическим (DHCP)
- В локальной сети (192.168.x.x) адреса private (не видны из интернета)
- Публичные адреса маршрутизируются глобально

</details>

**Запишите IP адрес рабочей станции Max:**
```bash
# В вашем скрипте:
WORKSTATION_IP="???.???.???.???"
```

---

### Задание 2: Определить IP сервера Viktor ⭐

**Контекст:**
Viktor: *"У меня есть сервер в этом ЦОДе. Hostname: `shadow-server-02.ops.internal`. Узнай его IP адрес."*

**Задача:**
Определите IP адрес сервера Viktor по hostname.

**Попробуйте сами (3-5 минут):**

```bash
# Hostname сервера Viktor
shadow-server-02.ops.internal

# Ваша команда для определения IP здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**LILITH:**
> *"DNS (Domain Name System) переводит имена в IP адреса. Команды: `host`, `nslookup`, `dig`. Или просто `ping` — он покажет IP."*

Попробуйте:
```bash
ping -c 1 shadow-server-02.ops.internal
```

Или:
```bash
host shadow-server-02.ops.internal
```

**Примечание:** Если DNS не работает локально, проверьте `artifacts/network_map.txt` — там IP адреса всех серверов операции.

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Варианты команд:**

```bash
# Вариант 1: ping (покажет IP в первой строке)
ping -c 1 shadow-server-02.ops.internal | head -n1

# Вариант 2: host (DNS lookup)
host shadow-server-02.ops.internal

# Вариант 3: nslookup
nslookup shadow-server-02.ops.internal

# Вариант 4: dig (детальная информация)
dig shadow-server-02.ops.internal +short

# Вариант 5: Прочитать из network_map.txt
grep "shadow-server-02.ops.internal" artifacts/network_map.txt
```

**Парсинг IP из network_map.txt:**
```bash
grep "shadow-server-02" artifacts/network_map.txt | awk '{print $1}'
```

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Команда для скрипта:**
```bash
hostname="shadow-server-02.ops.internal"

# Попытка 1: Из network_map.txt (симуляция)
if [ -f "artifacts/network_map.txt" ]; then
    VIKTOR_IP=$(grep "$hostname" artifacts/network_map.txt | awk '{print $1}')
fi

# Попытка 2: DNS lookup (если предыдущее не сработало)
if [ -z "$VIKTOR_IP" ] && command -v host &>/dev/null; then
    VIKTOR_IP=$(host "$hostname" 2>/dev/null | grep "has address" | awk '{print $4}' | head -n1)
fi

# Fallback: известный IP
if [ -z "$VIKTOR_IP" ]; then
    VIKTOR_IP="10.50.1.100"
fi

echo "Viktor Server: $hostname → $VIKTOR_IP"
```

**Объяснение:**
- Сначала ищем в `network_map.txt` (симуляция DNS)
- Если не найдено — пробуем реальный DNS
- Если DNS не работает — используем fallback IP

**Простой вариант:**
```bash
# Из network_map.txt
grep "shadow-server-02" artifacts/network_map.txt | awk '{print $1}'
# Результат: 10.50.1.100
```

</details>

<details>
<summary>🔍 Что такое DNS? (теория)</summary>

### DNS (Domain Name System)

**Определение:**
DNS — система преобразования доменных имён (google.com) в IP адреса (142.250.185.46).

**Почему нужен:**
- Людям проще запоминать имена (`google.com`), чем числа (`142.250.185.46`)
- IP адреса могут меняться, имена остаются стабильными

**Как работает:**
```
1. Браузер: "Какой IP у google.com?"
2. DNS resolver: "Спрошу у DNS сервера..."
3. DNS сервер: "142.250.185.46"
4. Браузер: "Спасибо!" → подключается к 142.250.185.46
```

**Типы DNS записей:**
- **A record:** `example.com` → IPv4 (`192.168.1.1`)
- **AAAA record:** `example.com` → IPv6
- **CNAME:** alias (перенаправление на другое имя)
- **MX:** mail server
- **TXT:** текстовая информация (например, SPF для email)

**Файлы:**
- `/etc/hosts` — локальная DNS таблица (приоритет над DNS серверами)
- `/etc/resolv.conf` — какие DNS серверы использовать

**Команды:**
```bash
# Простой lookup
host google.com

# Детальный lookup
dig google.com

# Старый способ
nslookup google.com

# Редактировать локальный DNS
sudo nano /etc/hosts
```

**Security:**
- DNS spoofing — подмена ответов DNS (атака Krylov использует это!)
- DNSSEC — подписи для защиты от подмены
- DNS over TLS (DoT) — шифрование DNS запросов

</details>

**Симуляция (локально):**

Для практики, добавьте в `/etc/hosts` (временно):
```bash
# Создайте симуляцию DNS в artifacts/network_map.txt
echo "10.50.1.100  shadow-server-02.ops.internal" > artifacts/network_map.txt

# Или если у вас root:
# echo "127.0.0.1  shadow-server-02.ops.internal" | sudo tee -a /etc/hosts
```

**Запишите IP сервера Viktor:**
```bash
VIKTOR_SERVER_IP="10.50.1.100"  # Из DNS lookup
```

---

### Задание 3: Проверить доступность сервера (ping) ⭐

**Контекст:**
Alex: *"IP знаешь. Теперь проверь — сервер живой? Отвечает на запросы?"*

**Задача:**
Проверьте доступность сервера Viktor с помощью `ping`.

**Попробуйте сами (2-3 минуты):**

```bash
# IP сервера Viktor: 10.50.1.100
# Ваша команда ping здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 3 минуты)</summary>

**LILITH:**
> *"`ping` отправляет ICMP пакеты (Internet Control Message Protocol). Если сервер отвечает — он живой. Если нет — он down, firewall блокирует, или сеть разорвана."*

Попробуйте:
```bash
ping -c 4 10.50.1.100
```

Флаг `-c 4` означает отправить только 4 пакета (иначе будет бесконечно, нужно нажать Ctrl+C).

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 5 минут)</summary>

**Команды:**

```bash
# Отправить 4 ping по IP
ping -c 4 10.50.1.100

# Отправить 4 ping по hostname
ping -c 4 shadow-server-02.ops.internal

# С таймаутом (если сервер медленно отвечает)
ping -c 4 -W 2 10.50.1.100
```

**Проверка в скрипте (автоматизация):**
```bash
# Проверить exit code
ping -c 4 10.50.1.100 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Сервер доступен"
else
    echo "✗ Сервер недоступен"
fi
```

**Примечание:** Если ping не работает — это нормально, `shadow-server-02.ops.internal` не существует реально. Для практики используйте:
```bash
ping -c 4 127.0.0.1  # localhost (всегда работает)
ping -c 4 8.8.8.8    # Google DNS (если есть интернет)
```

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Команда для скрипта:**
```bash
server_ip="10.50.1.100"

echo "Проверка доступности сервера $server_ip..."

if ping -c 4 -W 2 "$server_ip" &>/dev/null; then
    echo "✓ Сервер доступен (ping successful)"
    
    # Показать latency
    latency=$(ping -c 4 -W 2 "$server_ip" 2>/dev/null | tail -1 | awk -F '/' '{print $5}')
    if [ -n "$latency" ]; then
        echo "  Average latency: ${latency}ms"
    fi
else
    echo "✗ Сервер недоступен (ping failed)"
    echo "  Возможные причины:"
    echo "    - Сервер выключен"
    echo "    - Firewall блокирует ICMP"
    echo "    - Сетевая проблема"
fi
```

**Объяснение:**
- `ping -c 4` — отправить 4 пакета
- `-W 2` — timeout 2 секунды
- `&>/dev/null` — скрыть вывод (проверяем только exit code)
- `$?` — exit code последней команды (0 = success)
- `tail -1 | awk -F '/' '{print $5}'` — извлечь average latency из последней строки

</details>

<details>
<summary>🔍 Что такое ping и ICMP? (теория)</summary>

### Ping и ICMP

**ping (Packet Internet Groper):**
- Утилита для проверки доступности хоста в сети
- Отправляет ICMP Echo Request
- Ждёт ICMP Echo Reply
- Показывает время ответа (latency) в миллисекундах

**Что показывает ping:**
```bash
PING google.com (142.250.185.46) 56(84) bytes of data.
64 bytes from lga34s34-in-f14.1e100.net (142.250.185.46): icmp_seq=1 ttl=117 time=15.2 ms
64 bytes from lga34s34-in-f14.1e100.net (142.250.185.46): icmp_seq=2 ttl=117 time=14.8 ms
```

- **IP адрес:** куда отправляется ping
- **icmp_seq:** номер пакета
- **ttl:** Time To Live (сколько роутеров может пройти пакет)
- **time:** время ответа (latency)

**ICMP (Internet Control Message Protocol):**
- Протокол для диагностики и ошибок
- Используется `ping` и `traceroute`
- Типы сообщений:
  - Type 0: Echo Reply (ответ на ping)
  - Type 3: Destination Unreachable
  - Type 8: Echo Request (ping)
  - Type 11: Time Exceeded (TTL истёк)

**Почему ping может не работать:**
- Firewall блокирует ICMP
- Сервер down
- Сетевая проблема (роутер, кабель, ISP)
- Rate limiting (защита от ping flood)

**Команды:**
```bash
# Отправить N пакетов
ping -c 5 google.com

# Бесконечный ping (Ctrl+C чтобы остановить)
ping google.com

# Изменить размер пакета
ping -s 1000 google.com

# Flood ping (осторожно! DDoS-подобное поведение)
# ping -f google.com  # требует root, не используй на чужих серверах!
```

**Анализ результатов:**
- **0% packet loss:** отлично, связь стабильна
- **5-10% packet loss:** плохая связь
- **100% packet loss:** нет связи или firewall блокирует
- **time < 10ms:** отличный latency (локальная сеть или близкий сервер)
- **time 50-100ms:** нормально (другой город/страна)
- **time > 200ms:** медленно (другой континент или плохая связь)

</details>

**Если ping не работает (локально):**
> Это нормально — `shadow-server-02.ops.internal` не существует реально. Для практики можете пинговать localhost:
```bash
ping -c 4 127.0.0.1  # всегда отвечает
ping -c 4 8.8.8.8    # Google DNS (если есть интернет)
```

**В скрипте запишите результат:**
```bash
# Проверка доступности
ping -c 4 "$VIKTOR_SERVER_IP" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Сервер Viktor доступен"
else
    echo "✗ Сервер недоступен (возможно firewall)"
fi
```

---

### Задание 4: Traceroute — маршрут до сервера ⭐⭐

**Контекст:**
Anna: *"Max, нам нужно знать маршрут до сервера Viktor. Через какие узлы идёт трафик? Сколько роутеров между нами и им?"*

**Задача:**
Определите маршрут (route) до сервера Viktor.

**Попробуйте сами (5 минут):**

```bash
# IP сервера Viktor: 10.50.1.100
# Ваша команда traceroute здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**LILITH:**
> *"`traceroute` показывает каждый роутер (hop) на пути к серверу. Это критично для диагностики: если атака идёт на 3-м hop, вы знаете где искать."*

Попробуйте:
```bash
# tracepath (не требует root)
tracepath 10.50.1.100

# или traceroute (требует sudo)
sudo traceroute 10.50.1.100
```

**Примечание:** Если `shadow-server-02.ops.internal` не существует реально (и это нормально), traceroute покажет только несколько hop'ов до вашего роутера. Для практики попробуйте:
```bash
tracepath google.com  # Если есть интернет
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Команды:**

```bash
# tracepath (проще, не требует root)
tracepath 10.50.1.100

# traceroute (требует sudo)
sudo traceroute 10.50.1.100

# С ограничением hops
tracepath -m 10 10.50.1.100

# Только IP (без DNS резолва имён)
tracepath -n 10.50.1.100
```

**Для скрипта (симуляция, если traceroute не работает):**
```bash
echo "Маршрут до сервера Viktor (10.50.1.100):"
echo "  1  192.168.100.1    1.2ms   (Home Gateway)"
echo "  2  10.50.0.1        2.5ms   (ЦОД 'Москва-1' Switch)"
echo "  3  10.50.1.100      3.1ms   (shadow-server-02.ops.internal)"
echo ""
echo "✓ 3 hops, последний узел в ЦОДе Москва-1"
```

**Для практики с реальным сервером:**
```bash
# Попробуйте traceroute до Google (если есть интернет)
tracepath google.com | head -n 10
```

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Команда для скрипта:**
```bash
server_ip="10.50.1.100"

echo "Маршрут до сервера Viktor ($server_ip):"

# Попытка использовать реальный tracepath
if command -v tracepath &>/dev/null; then
    echo "  (Используя tracepath...)"
    tracepath -n "$server_ip" 2>/dev/null | head -n 10 || echo "  (traceroute не прошёл)"
elif command -v traceroute &>/dev/null; then
    echo "  (Используя traceroute...)"
    timeout 10 traceroute -n -m 10 "$server_ip" 2>/dev/null | head -n 10 || echo "  (traceroute не прошёл)"
else
    # Симуляция (если команды недоступны или сервер несуществующий)
    echo "  (Симуляция traceroute)"
    echo "  1  192.168.100.1    1.2ms   (Home Gateway)"
    echo "  2  10.50.0.1        2.5ms   (ЦОД 'Москва-1' Switch)"
    echo "  3  $server_ip       3.1ms   (shadow-server-02.ops.internal)"
    echo ""
    echo "✓ 3 hops, последний узел в ЦОДе Москва-1"
fi
```

**Объяснение:**
- `tracepath` — простой вариант, не требует root
- `traceroute` — более мощный, требует sudo
- `-n` — не резолвить имена (быстрее)
- `-m 10` — максимум 10 hops
- `timeout 10` — ограничение времени
- Симуляция используется если команды недоступны или сервер не существует

**Интерпретация результата:**
- Каждая строка = один hop (роутер)
- Время = latency до этого hop'а
- `* * *` = роутер не отвечает (firewall блокирует ICMP)

</details>

<details>
<summary>🔍 Что такое traceroute? (теория)</summary>

### Traceroute

**Определение:**
Traceroute показывает маршрут (путь через роутеры) от вашего компьютера до целевого хоста.

**Как работает:**
1. Отправляет пакет с TTL=1 → первый роутер отбрасывает его и отвечает "TTL exceeded"
2. Отправляет пакет с TTL=2 → второй роутер отбрасывает его и отвечает
3. И так далее, пока не дойдёт до целевого хоста

**Пример вывода:**
```bash
traceroute to google.com (142.250.185.46), 30 hops max
 1  192.168.1.1 (192.168.1.1)  1.245 ms   # Домашний роутер
 2  10.0.0.1 (10.0.0.1)  5.123 ms         # ISP gateway
 3  72.14.213.1 (72.14.213.1)  12.456 ms  # ISP backbone
 4  * * *                                   # Firewall блокирует
 5  142.250.185.46 (142.250.185.46)  15.2 ms  # Google сервер
```

**Что показывает:**
- **Hop number:** порядковый номер роутера
- **IP адрес:** IP роутера
- **Hostname:** имя роутера (если есть reverse DNS)
- **Time:** время до этого роутера

**Что означают символы:**
- `*` — роутер не отвечает (firewall блокирует ICMP или настроен не отвечать)
- `* * *` — три попытки failed
- Hostname в скобках — reverse DNS успешен

**Зачем нужен:**
- Диагностика медленной сети (где происходит задержка?)
- Определение географии серверов
- Поиск проблемного роутера
- Forensics: откуда идёт атака? (какой hop подозрителен?)

**Команды:**
```bash
# Linux (ICMP, требует root)
sudo traceroute google.com

# Linux (UDP, не требует root)
traceroute -U google.com

# Linux (TCP, для обхода firewall)
sudo traceroute -T -p 80 google.com

# Linux (альтернатива без root)
tracepath google.com

# Ограничить количество hops
traceroute -m 10 google.com
```

**Интерпретация:**
- **1-2 hops:** локальная сеть (домашний роутер, ISP gateway)
- **3-5 hops:** региональная сеть (город)
- **6-10 hops:** межрегиональная (другой город/страна)
- **> 15 hops:** подозрительно много (возможно атака или плохая маршрутизация)

**Атаки:**
- Krylov может использовать hop'ы для Man-in-the-Middle атаки
- Если один из hop'ов скомпрометирован — весь трафик видим

</details>

**В скрипте запишите:**
```bash
# Traceroute (симуляция)
echo "Маршрут до сервера Viktor:"
echo "  1  192.168.1.1  1.2ms   (Home router)"
echo "  2  10.50.0.1    2.5ms   (ЦОД gateway)"
echo "  3  10.50.1.100  3.1ms   (shadow-server-02.ops.internal)"
echo "✓ 3 hops, последний узел в ЦОДе Москва-1"
```

---

### Задание 5: Проверить открытые порты (netstat) ⭐⭐

**Контекст:**
Dmitry: *"Max, нам нужно знать какие порты открыты на сервере Viktor. Какие сервисы работают? SSH? HTTP? База данных?"*

**Задача:**
Определите открытые порты на локальной машине (рабочая станция Max).

**Попробуйте сами (5 минут):**

```bash
# Ваша команда для проверки открытых портов здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**LILITH:**
> *"`netstat` и `ss` показывают сетевые соединения. Открытые порты = потенциальные точки входа для атаки. Каждый открытый порт должен быть оправдан."*

Попробуйте:
```bash
# Современная команда
ss -tuln

# Или старая
netstat -tuln
```

**Флаги:**
- `-t` — TCP соединения
- `-u` — UDP соединения
- `-l` — только LISTENING (слушающие)
- `-n` — числовой формат (не резолвить имена)

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Команды:**

```bash
# ss (современный, быстрее)
ss -tuln

# netstat (классический)
netstat -tuln

# С процессами (требует root)
sudo ss -tulnp
sudo netstat -tulnp

# Только TCP LISTEN
ss -tln

# Фильтр по порту
ss -tuln sport = :80  # порт источника 80
```

**Парсинг вывода:**
```bash
# Извлечь только открытые порты
ss -tuln | grep LISTEN
```

**Анализ:**
- Ищите порты 22 (SSH), 80 (HTTP), 443 (HTTPS), 3306 (MySQL)
- Если порт открыт на 0.0.0.0 — доступен извне
- Если на 127.0.0.1 — только localhost (безопаснее)

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Команда для скрипта:**
```bash
echo "Открытые порты на рабочей станции Max:"

# Используем ss если доступен
if command -v ss &>/dev/null; then
    echo "  (Используя ss -tuln)"
    ss -tuln | grep LISTEN | awk '{print "  " $1 "\t" $5}' | head -n 10
# Fallback: netstat
elif command -v netstat &>/dev/null; then
    echo "  (Используя netstat -tuln)"
    netstat -tuln | grep LISTEN | awk '{print "  " $1 "\t" $4}' | head -n 10
else
    echo "  ⚠ ss/netstat не найдены"
fi

echo ""
echo "⚠ Проверьте: нужны ли все эти порты?"
echo "  Каждый открытый порт = потенциальная уязвимость"
```

**Объяснение:**
- Проверяем наличие `ss` (более современный)
- Fallback на `netstat` если `ss` нет
- `grep LISTEN` — только слушающие порты
- `awk '{print $5}'` — извлекаем адрес:порт
- `head -n 10` — первые 10 результатов

**Интерпретация вывода:**
```
tcp   0.0.0.0:22    # SSH слушает на всех интерфейсах (небезопасно!)
tcp   127.0.0.1:3306 # MySQL только на localhost (хорошо)
```

**Security note:**
- Закройте ненужные порты
- Используйте firewall (Episode 07)
- Слушайте на 127.0.0.1 если сервис только для localhost

</details>

<details>
<summary>🔍 Что такое порты и netstat? (теория)</summary>

### Порты (Ports)

**Определение:**
Порт — числовой идентификатор (0-65535) для разных сервисов на одном IP адресе.

**Аналогия:**
- IP адрес = адрес здания (улица, дом)
- Порт = номер квартиры в здании

**Примеры портов:**
```
22   → SSH (удалённое управление)
80   → HTTP (веб-сервер без шифрования)
443  → HTTPS (веб-сервер с SSL/TLS)
3306 → MySQL (база данных)
5432 → PostgreSQL
6379 → Redis
8080 → Альтернативный HTTP (часто для development)
```

**Категории:**
- **Well-known ports:** 0-1023 (системные, требуют root)
- **Registered ports:** 1024-49151 (приложения)
- **Dynamic/Private ports:** 49152-65535 (временные, для клиентских соединений)

**Состояния портов:**
- **LISTEN:** порт открыт, сервис слушает входящие соединения
- **ESTABLISHED:** активное соединение
- **TIME_WAIT:** соединение закрыто, но ещё в памяти
- **CLOSE_WAIT:** соединение закрывается

---

### netstat (Network Statistics)

**Что показывает:**
- Активные соединения (кто с кем говорит)
- Слушающие порты (какие сервисы ждут подключений)
- Routing table (таблица маршрутизации)
- Network interfaces statistics

**Основные флаги:**
```bash
-t  # TCP соединения
-u  # UDP соединения
-l  # Только LISTENING (слушающие)
-n  # Числовой формат (не резолвить имена в IP)
-p  # Показать процесс (PID/Program name)
-a  # Все соединения (и listening, и established)
```

**Примеры:**
```bash
# Все TCP и UDP listening порты (числовой формат)
netstat -tuln

# С процессами
sudo netstat -tulnp

# Только established TCP соединения
netstat -tn

# Все соединения (listening + established)
netstat -tuna

# Routing table
netstat -r
```

**Пример вывода:**
```
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1234/sshd
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      5678/mysqld
tcp        0      0 192.168.1.100:45678     142.250.185.46:443      ESTABLISHED 9012/firefox
```

Интерпретация:
- **Line 1:** SSH сервер слушает на порту 22 (все интерфейсы 0.0.0.0)
- **Line 2:** MySQL слушает на 3306, но только localhost (127.0.0.1) → безопаснее
- **Line 3:** Firefox открыл соединение к Google (443 = HTTPS)

---

### ss (Socket Statistics)

**Современная замена netstat:**
- Быстрее
- Больше информации
- Синтаксис похож на netstat

**Примеры:**
```bash
# То же что netstat -tuln
ss -tuln

# С процессами
sudo ss -tulnp

# Показать только TCP ESTABLISHED
ss -t state established

# Фильтр по порту
ss -tuln sport = :80  # порт источника 80
ss -tuln dport = :443 # порт назначения 443
```

---

### Security implications

**Открытые порты = attack surface:**
- Каждый открытый порт — потенциальная уязвимость
- Если порт не нужен — закрой его (firewall или отключи сервис)

**Best practices:**
1. Открывай только необходимые порты
2. Слушай на localhost (127.0.0.1) если сервис нужен только локально
3. Используй firewall (ufw, iptables) для дополнительной защиты
4. Регулярно проверяй открытые порты: `ss -tuln`

**Пример атаки:**
- Krylov сканирует открытые порты с помощью `nmap`
- Находит открытый порт 8080 (debug interface)
- Эксплуатирует уязвимость в этом сервисе
- Получает shell на сервере

**Защита:**
- Закрой порт 8080 если он не нужен
- Firewall: разрешить только доверенным IP
- Обнови софт (патчи уязвимостей)

</details>

**В скрипте запишите:**
```bash
# Проверка открытых портов (на локальной машине)
echo "Открытые порты на рабочей станции Max:"
ss -tuln | grep LISTEN
```

**Анализ:**
- Какие порты открыты?
- Нужны ли они все?
- Есть ли подозрительные порты? (например, 8080, 3389-RDP, 23-telnet)

---

### Задание 6: Сканирование портов сервера Viktor (nmap) ⭐⭐⭐

**Контекст:**
Alex: *"Max, теперь нужно просканировать сервер Viktor. Узнать какие порты открыты на НЁМ. Это то, как атакующий видит сервер. Используй nmap."*

**⚠️ ВАЖНО:**
> Сканирование чужих серверов без разрешения — незаконно. Мы сканируем ТОЛЬКО серверы операции Viktor (у нас есть разрешение).

**Задача:**
Просканировать порты сервера Viktor.

**Попробуйте сами (5-7 минут):**

```bash
# IP сервера Viktor: 10.50.1.100
# Ваша команда nmap здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 5 минут)</summary>

**LILITH:**
> *"`nmap` (Network Mapper) — мощный инструмент для сканирования сетей. Он показывает открытые порты, версии сервисов, операционную систему. Krylov использует такие же инструменты."*

**Установка (если ещё нет):**
```bash
sudo apt install nmap
```

**Простое сканирование:**
```bash
nmap 10.50.1.100
```

**Примечание:** Если `10.50.1.100` не существует реально (и это нормально), nmap покажет что хост down или нет открытых портов. Для практики попробуйте:
```bash
nmap 127.0.0.1  # Сканировать localhost
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 10 минут)</summary>

**Команды:**

```bash
# Простое сканирование
nmap 10.50.1.100

# Конкретные порты
nmap -p 22,80,443 10.50.1.100

# TOP-100 портов (быстрее)
nmap --top-ports 100 10.50.1.100

# С версиями сервисов
nmap -sV 10.50.1.100

# Агрессивное (версии + ОС)
sudo nmap -A 10.50.1.100

# Без ping (если host down)
nmap -Pn 10.50.1.100
```

**Для скрипта (если nmap не установлен или сервер не существует):**
```bash
# Симуляция вывода nmap
echo "PORT     STATE  SERVICE"
echo "22/tcp   open   ssh"
echo "80/tcp   open   http"
echo "443/tcp  open   https"
echo ""
echo "✓ Обнаружено 3 открытых порта"
```

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Команда для скрипта:**
```bash
server_ip="10.50.1.100"

echo "Сканирование портов сервера Viktor ($server_ip):"

# Попытка использовать nmap если установлен
if command -v nmap &>/dev/null; then
    echo "  (Используя nmap --top-ports 100)"
    # Timeout 30 секунд для защиты
    timeout 30 nmap --top-ports 100 -T4 "$server_ip" 2>/dev/null | grep -E "^[0-9]+" || \
        echo "  (сервер недоступен или nmap не смог завершить сканирование)"
else
    # Симуляция (если nmap не установлен)
    echo "  (Симуляция nmap — установите nmap для реального сканирования)"
    echo ""
    echo "  PORT     STATE  SERVICE"
    echo "  22/tcp   open   ssh"
    echo "  80/tcp   open   http"
    echo "  443/tcp  open   https"
    echo ""
    echo "✓ Обнаружено 3 открытых порта"
fi

echo ""
echo "Analysis:"
echo "  ✓ SSH (22) — OK (нужен для управления)"
echo "  ⚠ HTTP (80) — зачем? Должен быть только HTTPS"
echo "  ✓ HTTPS (443) — OK (веб-интерфейс)"
```

**Объяснение:**
- `nmap --top-ports 100` — сканировать 100 самых популярных портов
- `-T4` — aggressive timing (быстрее, но более заметен)
- `timeout 30` — ограничение времени
- `grep -E "^[0-9]+"` — извлечь только строки с портами
- Симуляция используется если nmap не установлен или сервер не существует

**Интерпретация результата:**
```
22/tcp   open   ssh       # Хорошо - нужен для управления
80/tcp   open   http      # Плохо - должен быть только HTTPS
443/tcp  open   https     # Хорошо - безопасный веб
3306/tcp closed mysql     # Хорошо - база не должна быть доступна извне
```

**Security note:**
- Закройте HTTP (80), используйте только HTTPS
- База данных (3306) НЕ должна быть открыта извне
- Используйте firewall для ограничения доступа (Episode 07)

</details>

<details>
<summary>🔍 Что такое nmap? (теория)</summary>

### Nmap (Network Mapper)

**Определение:**
Nmap — утилита для сканирования сетей и аудита безопасности.

**Что может:**
- Обнаружить хосты в сети (кто онлайн?)
- Сканировать порты (какие сервисы запущены?)
- Определить версии сервисов (Apache 2.4.41, OpenSSH 8.2)
- Определить операционную систему (OS fingerprinting)
- Найти уязвимости (с помощью NSE scripts)

**Основные типы сканирования:**

1. **TCP Connect Scan** (по умолчанию):
```bash
nmap 192.168.1.1
```
- Полное TCP handshake (SYN → SYN-ACK → ACK)
- Медленнее, но надёжнее
- Не требует root

2. **SYN Scan** (stealth):
```bash
sudo nmap -sS 192.168.1.1
```
- Half-open scan (SYN → SYN-ACK → RST)
- Быстрее, менее заметен
- Требует root

3. **UDP Scan:**
```bash
sudo nmap -sU 192.168.1.1
```
- Сканирование UDP портов (DNS, SNMP, etc.)
- Очень медленно

4. **Aggressive Scan:**
```bash
sudo nmap -A 192.168.1.1
```
- Версии сервисов (-sV)
- OS detection (-O)
- Скрипты (-sC)
- Traceroute (--traceroute)

**Полезные флаги:**
```bash
-p <ports>    # Конкретные порты: -p 22,80,443
-p-           # Все 65535 портов (медленно!)
--top-ports N # TOP-N наиболее популярных портов
-sV           # Версии сервисов
-O            # Определить ОС
-A            # Агрессивное сканирование (всё сразу)
-T<0-5>       # Скорость (T0=paranoid, T5=insane)
-oN file.txt  # Сохранить в файл
```

**Пример вывода:**
```bash
$ nmap 10.50.1.100

Starting Nmap 7.80 ( https://nmap.org )
Nmap scan report for shadow-server-02.ops.internal (10.50.1.100)
Host is up (0.0012s latency).
Not shown: 996 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
443/tcp  open  https
3306/tcp open  mysql

Nmap done: 1 IP address (1 host up) scanned in 0.24 seconds
```

Интерпретация:
- Открыты порты: 22 (SSH), 80 (HTTP), 443 (HTTPS), 3306 (MySQL)
- 996 других портов закрыты
- Время сканирования: 0.24 секунды

**NSE Scripts (Nmap Scripting Engine):**
```bash
# Запустить стандартные скрипты
nmap -sC 10.50.1.100

# Конкретный скрипт
nmap --script=http-title 10.50.1.100

# Поиск уязвимостей
nmap --script vuln 10.50.1.100
```

**Этика и легальность:**
- ✅ Сканировать СВОИ серверы — OK
- ✅ Сканировать с разрешения владельца — OK
- ❌ Сканировать чужие серверы без разрешения — незаконно (может считаться атакой)
- ❌ Bug bounty программы — читай правила (некоторые разрешают сканирование)

**Защита от nmap:**
- Firewall (закрыть ненужные порты)
- Rate limiting (замедлить сканирование)
- IDS/IPS (обнаружение сканирования и блокировка IP)
- Port knocking (скрытие портов до секретной последовательности)

</details>

**В скрипте запишите:**
```bash
# Сканирование портов сервера Viktor (симуляция)
echo "Сканирование портов shadow-server-02.ops.internal..."
echo "  22/tcp   open  ssh"
echo "  80/tcp   open  http"
echo "  443/tcp  open  https"
echo "✓ Обнаружено 3 открытых порта"
```

**Анализ:**
- SSH (22) — OK (нужен для управления)
- HTTP (80) — зачем? Должен быть только HTTPS
- HTTPS (443) — OK
- Нет MySQL (3306) — хорошо (база данных не должна быть доступна извне)

---

### Задание 7: Проверить маршрутизацию (routing table) ⭐⭐

**Контекст:**
Dmitry: *"Max, нужно проверить routing table. Через какой gateway идёт трафик? Это важно для настройки VPN (Episode 08)."*

**Задача:**
Просмотрите таблицу маршрутизации (routing table) на рабочей станции Max.

**Попробуйте сами (3-5 минут):**

```bash
# Ваша команда для просмотра routing table здесь
```

<details>
<summary>💡 Подсказка 1 (если застряли > 3 минуты)</summary>

**LILITH:**
> *"Routing table определяет куда отправлять пакеты. Default gateway (0.0.0.0) = куда идти если конкретного маршрута нет (обычно домашний роутер или корпоративный gateway)."*

Попробуйте:
```bash
ip route show
```

Или короче:
```bash
ip r
```

Ищите строку с `default via` — это ваш default gateway.

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 5 минут)</summary>

**Команды:**

```bash
# Современный способ (ip command)
ip route show

# Короткая форма
ip r

# Старые способы
route -n
netstat -rn
```

**Парсинг default gateway:**
```bash
# Извлечь только default gateway
ip route | grep default

# Или только IP gateway
ip route | grep default | awk '{print $3}'
```

**Ищите в выводе:**
- `default via X.X.X.X` — ваш gateway
- `X.X.X.X/Y dev ethX` — маршруты к конкретным сетям
- `127.0.0.0/8 dev lo` — loopback

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Команда для скрипта:**
```bash
echo "Таблица маршрутизации:"

if command -v ip &>/dev/null; then
    ip route show | sed 's/^/  /'
else
    echo "  (ip команда не найдена)"
fi

echo ""

# Найти default gateway
gateway=$(ip route 2>/dev/null | grep default | awk '{print $3}' | head -n1)
if [ -n "$gateway" ]; then
    echo "✓ Default gateway: $gateway"
else
    echo "⚠ Default gateway не найден"
fi
```

**Объяснение:**
- `ip route show` — показать все маршруты
- `grep default` — найти default gateway
- `awk '{print $3}'` — извлечь IP gateway (3-я колонка)
- `sed 's/^/  /'` — добавить отступ для красоты

**Интерпретация вывода:**
```bash
default via 192.168.1.1 dev eth0 proto dhcp metric 100
# ↑ Default gateway: 192.168.1.1 через интерфейс eth0

10.50.0.0/16 dev eth1 proto kernel scope link src 10.50.1.42
# ↑ Сеть 10.50.0.0/16 доступна напрямую через eth1

127.0.0.0/8 dev lo scope link
# ↑ Loopback (localhost)

192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.100
# ↑ Локальная сеть 192.168.1.0/24 через eth0
```

**Что это значит:**
- Пакеты в сеть 10.50.0.0/16 → напрямую через eth1
- Пакеты в сеть 192.168.1.0/24 → напрямую через eth0
- Все остальные пакеты → через default gateway 192.168.1.1

</details>

<details>
<summary>🔍 Что такое routing table? (теория)</summary>

### Routing Table (Таблица маршрутизации)

**Определение:**
Routing table — таблица на компьютере/роутере, определяющая куда отправлять IP пакеты.

**Как работает:**
1. Компьютер хочет отправить пакет на IP 142.250.185.46
2. Проверяет routing table: есть ли маршрут для этой сети?
3. Если есть — отправить через конкретный interface/gateway
4. Если нет — отправить через default gateway (обычно домашний роутер)

**Пример вывода:**
```bash
$ ip route show

default via 192.168.1.1 dev eth0 proto dhcp metric 100
10.50.0.0/16 dev eth1 proto kernel scope link src 10.50.1.42
127.0.0.0/8 dev lo scope link
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.100
```

Интерпретация:
- **Line 1:** Default gateway — 192.168.1.1 (домашний роутер), через интерфейс eth0
- **Line 2:** Сеть 10.50.0.0/16 (внутренняя сеть ЦОДа) → через eth1
- **Line 3:** Loopback (127.0.0.1) → через интерфейс lo
- **Line 4:** Локальная сеть 192.168.1.0/24 → через eth0

**Ключевые концепции:**

**Default Gateway:**
```
default via 192.168.1.1
```
- Куда отправлять пакеты если нет конкретного маршрута
- Обычно домашний роутер или корпоративный gateway

**CIDR Notation:**
```
10.50.0.0/16
```
- `/16` = subnet mask 255.255.0.0
- Означает: все адреса 10.50.0.0 — 10.50.255.255

**Interface:**
```
dev eth0
dev eth1
```
- Через какой сетевой интерфейс отправлять

**Metric:**
```
metric 100
```
- Приоритет маршрута (меньше = выше приоритет)
- Если два маршрута к одной сети — выбирается с меньшим metric

**Команды:**
```bash
# Показать routing table
ip route show
route -n
netstat -rn

# Добавить маршрут (временно, до перезагрузки)
sudo ip route add 10.0.0.0/8 via 192.168.1.254

# Удалить маршрут
sudo ip route del 10.0.0.0/8

# Изменить default gateway
sudo ip route add default via 192.168.1.1
```

**Persistent routing (после перезагрузки):**

Ubuntu (Netplan):
```yaml
# /etc/netplan/01-network.yaml
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      routes:
        - to: 10.0.0.0/8
          via: 192.168.1.254
```

**Troubleshooting:**
- Нет интернета? Проверь default gateway: `ip route | grep default`
- Пинг работает локально, но не в интернет? Gateway проблема
- `ping 8.8.8.8` работает, но `ping google.com` нет? DNS проблема (не routing)

</details>

**В скрипте запишите:**
```bash
# Routing table
echo "Таблица маршрутизации:"
ip route show
```

---

### Задание 8: Финальный отчёт — Network Map ⭐⭐⭐

**Контекст:**
Viktor: *"Max, собери всё в отчёт. IP адреса, маршруты, открытые порты. Это наша карта сети. Она критична для защиты."*

**Задача:**
Создайте bash скрипт `network_audit.sh`, который интегрирует все предыдущие 7 заданий и генерирует детальный отчёт.

**Попробуйте сами (15-20 минут):**

Используйте всё, что изучили в заданиях 1-7:
- IP адрес рабочей станции
- IP сервера Viktor
- Ping проверка
- Traceroute
- Открытые порты (локально)
- Nmap сканирование
- Routing table
- Генерация отчёта

```bash
# Создайте скрипт network_audit.sh
# Используйте starter.sh как шаблон
```

<details>
<summary>💡 Подсказка 1 (если застряли > 10 минут)</summary>

**LILITH:**
> *"Интеграция — это не просто копипаст. Это понимание как части работают вместе. Каждая функция из заданий 1-7 должна стать функцией в вашем скрипте."*

**Структура скрипта:**
```bash
#!/bin/bash
set -e

# Функция 1: IP рабочей станции (из Задания 1)
get_workstation_ip() {
    # Ваш код из Задания 1
}

# Функция 2: IP сервера Viktor (из Задания 2)
get_viktor_server_ip() {
    # Ваш код из Задания 2
}

# Функция 3: Ping проверка (из Задания 3)
check_availability() {
    # Ваш код из Задания 3
}

# ... и так далее для всех 7 заданий

# Функция 8: Генерация отчёта
generate_report() {
    # Объединить все результаты в один файл
}

# Главная функция
main() {
    echo "Network Audit..."
    
    WORKSTATION_IP=$(get_workstation_ip)
    VIKTOR_IP=$(get_viktor_server_ip)
    
    check_availability "$VIKTOR_IP"
    # ... остальные вызовы
    
    generate_report "$WORKSTATION_IP" "$VIKTOR_IP"
}

main "$@"
```

</details>

<details>
<summary>💡 Подсказка 2 (если застряли > 20 минут)</summary>

**Конкретная реализация:**

```bash
#!/bin/bash
set -e

# Из Задания 1
get_workstation_ip() {
    ip -4 a | grep -v "127.0.0.1" | grep "inet " | awk '{print $2}' | cut -d/ -f1 | head -n1
}

# Из Задания 2
get_viktor_server_ip() {
    if [ -f "artifacts/network_map.txt" ]; then
        grep "shadow-server-02" artifacts/network_map.txt | awk '{print $1}'
    else
        echo "10.50.1.100"
    fi
}

# Из Задания 3
check_availability() {
    local ip="$1"
    if ping -c 4 -W 2 "$ip" &>/dev/null; then
        echo "ONLINE"
    else
        echo "OFFLINE"
    fi
}

# Генерация отчёта
generate_report() {
    local ws_ip="$1"
    local vik_ip="$2"
    
    {
        echo "=== NETWORK AUDIT REPORT ==="
        echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Operator: Max Sokolov"
        echo ""
        echo "[1] Workstation IP: $ws_ip"
        echo "[2] Viktor Server: $vik_ip"
        # ... остальные секции
        echo "=== END REPORT ==="
    } > artifacts/network_report.txt
}

main() {
    WORKSTATION_IP=$(get_workstation_ip)
    VIKTOR_IP=$(get_viktor_server_ip)
    
    echo "[1] Workstation IP: $WORKSTATION_IP"
    echo "[2] Viktor Server: $VIKTOR_IP"
    
    generate_report "$WORKSTATION_IP" "$VIKTOR_IP"
    echo "✓ Отчёт: artifacts/network_report.txt"
}

main "$@"
```

</details>

<details>
<summary>✅ Решение (если совсем застряли)</summary>

**Посмотрите референсное решение:**
```bash
cat solution/network_audit.sh
```

Или запустите:
```bash
./solution/network_audit.sh
```

**Ключевые моменты решения:**
1. **Модульность:** Каждое задание = отдельная функция
2. **Error handling:** Проверка exit codes, fallback'ы
3. **Красивый вывод:** Цвета, форматирование
4. **Детальный отчёт:** Все 7 заданий интегрированы

**Формат отчёта:**
```
═══════════════════════════════════════════════════════════════
           NETWORK AUDIT REPORT
═══════════════════════════════════════════════════════════════

Date:     2025-10-11 14:30:00
Operator: Max Sokolov
Location: ЦОД "Москва-1", Россия
Day:      9 of 60 (KERNEL SHADOWS Operation)

════════════════════════════════════════════════════════════════

[1] WORKSTATION IP ADDRESS
    192.168.100.42

[2] VIKTOR SERVER
    Hostname: shadow-server-02.ops.internal
    IP:       10.50.1.100
    Status:   ONLINE ✓

[3] TRACEROUTE
    Route to Viktor Server:
    1  192.168.100.1    (Gateway)
    2  10.50.0.1        (ЦОД Switch)
    3  10.50.1.100      (Viktor Server)

[4] OPEN PORTS (Local Workstation)
    22/tcp    ssh
    80/tcp    http

[5] OPEN PORTS (Viktor Server)
    22/tcp    open    ssh
    80/tcp    open    http
    443/tcp   open    https

[6] ROUTING TABLE
    default via 192.168.100.1 dev eth0

════════════════════════════════════════════════════════════════

ANALYSIS & RECOMMENDATIONS:

  ✓ Workstation IP identified: 192.168.100.42
  ✓ Viktor server located: 10.50.1.100
  ✓ Server is reachable (ping successful)

  Security Notes:
    - Close unnecessary ports on local workstation
    - HTTP port 80 on Viktor server should redirect to HTTPS
    - Consider VPN for all communications (Episode 08)
    - Monitor for unusual connections (Krylov surveillance)

════════════════════════════════════════════════════════════════

END OF REPORT

Generated by: network_audit.sh
Episode: 05 — TCP/IP Fundamentals
Next: Episode 06 — DNS & Name Resolution (Stockholm, Sweden)
```

**Что проверить в вашем решении:**
- ✅ Все 7 функций реализованы
- ✅ Отчёт генерируется в `artifacts/network_report.txt`
- ✅ Корректная структура отчёта
- ✅ Error handling (что если команда не найдена?)
- ✅ Читаемый вывод (форматирование, отступы)

</details>

**Требования к финальному скрипту:**
1. Интегрирует ВСЕ 7 предыдущих заданий
2. Генерирует детальный отчёт
3. Обрабатывает ошибки (fallback'ы)
4. Красивое форматирование
5. Анализ и рекомендации

---

## 📚 Теория: TCP/IP Model

<details>
<summary>🔍 TCP/IP vs OSI Model (click to expand)</summary>

### Модель TCP/IP (4 слоя)

TCP/IP — это протокол стек (набор протоколов) для работы интернета.

**Слои:**
```
4. Application Layer   (HTTP, FTP, SSH, DNS)
3. Transport Layer     (TCP, UDP)
2. Internet Layer      (IP, ICMP, ARP)
1. Link Layer          (Ethernet, Wi-Fi)
```

**Сравнение с OSI (7 слоёв):**
```
OSI Model                TCP/IP Model
---------                ------------
7. Application      →    4. Application
6. Presentation     →
5. Session          →
4. Transport        →    3. Transport
3. Network          →    2. Internet
2. Data Link        →    1. Link
1. Physical         →
```

### Layer 1: Link Layer (Канальный)

**Что делает:**
- Передача данных между соседними узлами в локальной сети
- MAC адреса (физические адреса сетевых карт)

**Протоколы:**
- Ethernet
- Wi-Fi (802.11)
- PPP (Point-to-Point Protocol)

**Пример:**
- Твой компьютер отправляет Ethernet frame на MAC адрес роутера

### Layer 2: Internet Layer (Сетевой)

**Что делает:**
- Маршрутизация пакетов между сетями
- IP адресация

**Протоколы:**
- **IP (Internet Protocol):** основной протокол, адресация и маршрутизация
- **ICMP:** диагностика (ping, traceroute)
- **ARP:** преобразование IP → MAC адрес

**Пример:**
- IP пакет от 192.168.1.100 (ты) → 142.250.185.46 (Google)
- Роутеры решают куда его направить

### Layer 3: Transport Layer (Транспортный)

**Что делает:**
- Надёжная доставка данных
- Контроль ошибок
- Сегментация данных

**Протоколы:**

**TCP (Transmission Control Protocol):**
- Надёжный (гарантирует доставку)
- Connection-oriented (устанавливается соединение)
- Медленнее
- Используется для: HTTP, HTTPS, SSH, FTP

**UDP (User Datagram Protocol):**
- Ненадёжный (может потерять пакеты)
- Connectionless (нет соединения)
- Быстрее
- Используется для: DNS, видео-стриминг, игры

**Порты:**
- Идентифицируют конкретное приложение
- 22 = SSH, 80 = HTTP, 443 = HTTPS

### Layer 4: Application Layer (Прикладной)

**Что делает:**
- Протоколы для конкретных приложений

**Протоколы:**
- **HTTP/HTTPS:** веб
- **SSH:** удалённое управление
- **FTP:** передача файлов
- **SMTP:** отправка email
- **DNS:** преобразование имён в IP

---

### Как всё работает вместе: Пример

**Сценарий:** Ты открываешь https://google.com в браузере

**1. Application Layer (Layer 4):**
- Браузер делает HTTP GET request: `GET / HTTP/1.1`
- Использует HTTPS (HTTP over TLS) → нужен TCP

**2. Transport Layer (Layer 3):**
- TCP устанавливает соединение (3-way handshake):
  - SYN → SYN-ACK → ACK
- Порт источника: 54321 (random)
- Порт назначения: 443 (HTTPS)

**3. Internet Layer (Layer 2):**
- IP пакет создаётся:
  - Source IP: 192.168.1.100 (твой)
  - Destination IP: 142.250.185.46 (Google)
- Роутеры маршрутизируют пакет через интернет

**4. Link Layer (Layer 1):**
- Ethernet frame отправляется на MAC адрес роутера
- Роутер пересылает дальше

**5. Обратный путь:**
- Google отвечает → пакет идёт обратно
- TCP доставляет данные в правильном порядке
- Браузер показывает страницу

---

### Encapsulation (Инкапсуляция)

Каждый слой добавляет свои headers:

```
[HTTP Data]                              ← Application Layer
[TCP Header | HTTP Data]                 ← Transport Layer
[IP Header | TCP Header | HTTP Data]    ← Internet Layer
[Ethernet | IP | TCP | HTTP | Ethernet] ← Link Layer
         Header        Data      Trailer
```

**Decapsulation** (обратный процесс):
- Получатель снимает headers по слоям
- Ethernet → IP → TCP → HTTP
- Приложение получает чистые данные

</details>

---

## 🎯 Что дальше?

### 17:30 — Результаты миссии

Max завершает отчёт. Команда собирается вокруг мониторов.

> **Viktor:**
> *"Отлично, Max. Ты понял основы. Теперь мы знаем нашу сеть."*

> **Anna:**
> *"Krylov атакует через DNS. Следующий эпизод — DNS & Name Resolution. Нужно понять как он подменяет ответы."*

> **Alex:**
> *"Max, завтра летишь в Стокгольм. Erik Johansson встретит. Он эксперт по DNS и BGP. Баhnhof datacenter — бывший ядерный бункер. Там безопаснее."*

Max: *"Стокгольм? Я ни разу не был за границей..."*

> **Viktor:**
> *"Будешь. Билет на утренний рейс. Операция global, Max. Привыкай."*

> **LILITH:**
> *"Новосибирск был разминкой. Москва — первый бой. Стокгольм — следующий уровень. TCP/IP ты знаешь. DNS — следующий. Каждый пакет рассказывает историю. Ты научился слушать."*

---

## 📚 Что вы изучили

### Команды:
- ✅ `ip a` — IP адрес
- ✅ `ping` — проверка доступности
- ✅ `traceroute` — маршрут до хоста
- ✅ `netstat` / `ss` — открытые порты и соединения
- ✅ `nmap` — сканирование портов
- ✅ `ip route` — таблица маршрутизации

### Концепции:
- ✅ TCP/IP модель (4 слоя)
- ✅ IP адреса (IPv4, private vs public, loopback)
- ✅ Порты (well-known, registered, dynamic)
- ✅ TCP vs UDP
- ✅ ICMP (ping, traceroute)
- ✅ Routing (default gateway, routing table)
- ✅ DNS basics (hostname → IP)

### Навыки:
- ✅ Диагностика сети (ping, traceroute)
- ✅ Аудит безопасности (открытые порты)
- ✅ Network mapping (IP, routes, services)
- ✅ Bash скрипты для автоматизации network аудита

---

## 📊 Самопроверка

Ответь на эти вопросы без подглядывания:

1. **Что такое IP адрес и зачем он нужен?**
2. **В чём разница между TCP и UDP?**
3. **Что показывает команда `netstat -tuln`?**
4. **Зачем нужен traceroute?**
5. **Что такое default gateway?**
6. **Какие порты считаются well-known?**
7. **Что означает 127.0.0.1?**
8. **В чём опасность открытых портов?**

<details>
<summary>✅ Ответы</summary>

1. IP адрес — уникальный числовой идентификатор устройства в сети (как адрес дома)
2. TCP — надёжный, connection-oriented; UDP — быстрый, connectionless
3. Все TCP/UDP слушающие порты в числовом формате
4. Показывает маршрут (через какие роутеры) до целевого хоста
5. Роутер, через который идёт весь трафик по умолчанию (обычно домашний роутер)
6. Порты 0-1023 (SSH=22, HTTP=80, HTTPS=443)
7. Loopback адрес (localhost) — компьютер обращается к самому себе
8. Каждый открытый порт = потенциальная точка входа для атаки

</details>

---

## 🔧 Проверка выполнения

Запусти автотест:

```bash
cd ~/kernel-shadows/season-2-networking/episode-05-tcp-ip-fundamentals
./tests/test.sh
```

Тесты проверят:
- ✓ Создан ли скрипт `network_audit.sh`
- ✓ Исполняемый ли он (`chmod +x`)
- ✓ Использует ли команды `ip`, `ping`, `ss`/`netstat`
- ✓ Генерирует ли отчёт `artifacts/network_report.txt`
- ✓ Корректность формата отчёта

---

## 🎯 Следующий эпизод

**Episode 06: DNS & Name Resolution**

**Локация:** 🇸🇪 Стокгольм, Швеция (Bahnhof Pionen Datacenter — ядерный бункер)

**Персонажи:** Erik Johansson (network engineer), Katarina Lindström (cryptography expert)

**Миссия:** Понять как работает DNS. Настроить DNS для скрытия инфраструктуры. Обнаружить и заблокировать DNS spoofing атаку от Krylov.

> **LILITH:**
> *"TCP/IP ты освоил. Но пакеты бесполезны если ты не знаешь куда их отправлять. DNS — телефонная книга интернета. Krylov это знает. И эксплуатирует. Следующая остановка — Стокгольм. Холодный, северный, параноидальный. Как раз для нас."*

---

## 📚 Дополнительные материалы

### Man Pages
```bash
man ip
man ping
man traceroute
man netstat
man ss
man nmap
```

### Полезные ресурсы
- [IPvFoo](https://github.com/pmarks-net/ipvfoo) — IPv4/IPv6 индикатор для браузера
- [IPInfo.io](https://ipinfo.io/) — информация об IP адресах
- [Wireshark](https://www.wireshark.org/) — анализ сетевого трафика
- [TCP/IP Illustrated](https://en.wikipedia.org/wiki/TCP/IP_Illustrated) — классическая книга

### Практика
- Просканируй свою домашнюю сеть: `nmap 192.168.1.0/24`
- Найди свой публичный IP: `curl ifconfig.me`
- Проверь traceroute до любимого сайта
- Изучи Wireshark (GUI для анализа пакетов)

### Настройка lab среды
Для глубокой практики можешь настроить виртуальную сеть:
```bash
# VirtualBox + несколько Ubuntu VM
# Настроить internal network
# Практиковаться в routing, firewall, DNS
```

---

<div align="center">

**OPERATION KERNEL SHADOWS**
*Episode 05 — TCP/IP Fundamentals*

*"Каждый пакет рассказывает историю. Научись слушать."* — LILITH

**[← Season 2](../README.md) | [Episode 06 →](../episode-06-dns-name-resolution/README.md)**

</div>
