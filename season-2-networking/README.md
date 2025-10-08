# SEASON 2: NETWORKING

```
KERNEL SHADOWS — Season 2
Тема: TCP/IP, DNS, Firewalls, VPN
Локации: 🇷🇺 Москва → 🇸🇪 Стокгольм, Швеция
Дни операции: 9-16 (из 60)
Сложность: ⭐⭐☆☆☆
Время: 15-18 часов
```

---

## 📖 О сезоне

### Переход на следующий уровень

**Day 8 (21:37) — Звонок от Alex:**

> *"Макс. У нас проблема. Krylov знает о нас. Нужен ты. Лично. Завтра. Москва."*

**Season 1** был разминкой — работа из дома в Новосибирске, базовые навыки shell.

**Season 2** — настоящая операция:
- Первый раз в Москве для работы
- Встреча с командой лично (Alex, Anna, Dmitry, Viktor)
- DDoS атаки от Krylov (50,000 пакетов/сек)
- DNS spoofing
- Первый раз за границей (Стокгольм, Швеция)

### Кто такой Krylov?

**Полковник Кирилл Крылов** — бывший начальник Alex в ФСБ (Управление "К" — киберпреступность).

Когда Alex ушёл из ФСБ и отказался фабриковать дела, Krylov не простил. Теперь охотится на Alex, Viktor, и всю операцию.

**Методы атак:**
- DDoS (Distributed Denial of Service)
- DNS spoofing (подмена DNS ответов)
- Network surveillance (прослушивание трафика)
- Social engineering

**IP адрес Krylov (предположительно):** 185.220.101.47 (Tor exit node)

---

## 🌍 География

### Локация 1: Москва, Россия 🇷🇺

**ЦОД "Москва-1"** (Северо-Восточный АО)

**Атмосфера:**
- Промышленная зона, здание без вывесок, бетонные стены
- Серверная комната A-12: гудение серверов, холодный воздух кондиционеров
- Напряжение — Krylov где-то рядом, паранойя
- Grafana мониторы показывают атаки в реальном времени

**Персонажи в Москве:**
- **Viktor Petrov** — координатор операции, седые волосы, чёрный костюм
- **Alex Sokolov** — твой двоюродный брат, ex-FSB, security expert
- **Anna Kovaleva** — ex-FSB, forensics expert, blue team lead
- **Dmitry Orlov** — DevOps engineer, embedded specialist

**Эпизоды:**
- Episode 05: TCP/IP Fundamentals (Москва)
- Episode 07: Firewalls (Москва — возврат)

### Локация 2: Стокгольм, Швеция 🇸🇪

**Bahnhof Pionen Datacenter** — бывший ядерный бункер времён холодной войны, 30 метров под землёй

**Атмосфера:**
- Футуристичный дизайн внутри скалы
- Искусственный водопад, неоновое освещение, холод
- Privacy культура (после WikiLeaks, Bahnhof refused government pressure)
- Северная эстетика — холодный минимализм, всё работает идеально

**Персонажи в Стокгольме:**
- **Erik Johansson** — шведский network engineer, BGP/DNS expert, Bahnhof employee
- **Katarina Lindström** — криптография, Stockholm University, DNS over TLS expert

**Эпизоды:**
- Episode 06: DNS & Name Resolution (Стокгольм)
- Episode 08: VPN & SSH Tunneling (Стокгольм + Москва)

**Культурный контраст:**
- **Россия:** Chaos, improvisation, "работает — не трогай", паранойя
- **Швеция:** Порядок, privacy by design, минимализм, спокойствие

Max впервые за границей. Культурный шок. Но technology speaks a universal language.

---

## 📚 Эпизоды

### Episode 05: TCP/IP Fundamentals ✅
**Локация:** 🇷🇺 Москва (ЦОД "Москва-1")
**День:** 9 из 60
**Время:** 4-5ч
**Сложность:** ⭐⭐☆☆☆

**Миссия:** Понять основы сетей, чтобы защитить инфраструктуру от атак Krylov.

**Теория:**
- TCP/IP модель (4 слоя)
- IP адреса (IPv4, IPv6, private vs public, loopback)
- TCP vs UDP
- Порты и сокеты
- ICMP (ping, traceroute)
- Routing (default gateway, routing table)

**Практика:**
- Определить IP адрес рабочей станции Max
- Определить IP сервера Viktor по hostname
- Проверить доступность (ping)
- Traceroute — маршрут до сервера
- Проверить открытые порты (netstat, ss)
- Сканировать порты сервера Viktor (nmap)
- Routing table
- Создать network audit отчёт

**Команды:**
- `ip a` — IP адрес
- `ping` — проверка доступности
- `traceroute` / `tracepath` — маршрут
- `netstat` / `ss` — открытые порты
- `nmap` — сканирование портов
- `ip route` — таблица маршрутизации

**Сюжет:**
- Max прилетает в Москву
- Первая встреча с командой (Alex, Anna, Dmitry, Viktor)
- DDoS атака от Krylov (50,000 пакетов/сек)
- LILITH v2.0 — Networking Module

---

### Episode 06: DNS & Name Resolution 🚧
**Локация:** 🇸🇪 Стокгольм (Bahnhof Pionen Datacenter)
**День:** 10-12 из 60
**Время:** 3-4ч
**Сложность:** ⭐⭐☆☆☆

**Миссия:** Настроить DNS для скрытия инфраструктуры. Обнаружить DNS spoofing атаку от Krylov.

**Теория:**
- Как работает DNS
- A, AAAA, CNAME, MX, TXT записи
- `dig`, `nslookup`, `host`
- `/etc/hosts` и `/etc/resolv.conf`
- DNS spoofing и защита (DNSSEC, DNS over TLS)

**Практика:**
- Настроить локальный DNS через `/etc/hosts`
- Проверить DNS записи сервера Viktor
- Обнаружить DNS spoofing атаку (cache poisoning)
- Настроить DoT (DNS over TLS)

**Персонажи:**
- **Erik Johansson** — network engineer, BGP/DNS expert
- **Katarina Lindström** — криптография, Stockholm University

**Сюжет:**
- Max первый раз за границей (культурный шок)
- Bahnhof Pionen — ядерный бункер 30м под землёй
- DNS атаки усиливаются
- Erik: "In Sweden we take privacy seriously"

---

### Episode 07: Firewalls (iptables/ufw) 🚧
**Локация:** 🇷🇺 Москва (возврат из Стокгольма)
**День:** 13-14 из 60
**Время:** 4-5ч
**Сложность:** ⭐⭐⭐☆☆

**Миссия:** Защитить серверы от DDoS атаки Krylov.

**Теория:**
- Netfilter и iptables
- Chains: INPUT, OUTPUT, FORWARD
- Правила: ACCEPT, DROP, REJECT
- UFW (Uncomplicated Firewall)
- nftables
- Rate limiting

**Практика:**
- Настроить UFW: закрыть все порты кроме SSH (22)
- Создать правила iptables для защиты от DDoS
- Rate limiting: `iptables -m limit`
- Логирование попыток атак
- Автоматическая блокировка атакующих IP

**Сюжет:**
- **INCIDENT:** DDoS атака на ЦОД "Москва-1" — 50K пакетов/сек
- Alex: "Файрвол. Сейчас. У нас 5 минут до падения сервера."
- Паника. Max применяет знания. UFW + iptables rate limiting.
- **Twist:** Krylov оставляет сообщение в логах: *"Соколов, передай брату — я найду вас. Обоих."*

---

### Episode 08: VPN & SSH Tunneling 🚧
**Локация:** 🇸🇪 Стокгольм (повторный визит) + 🇷🇺 Москва
**День:** 15-16 из 60
**Время:** 4-5ч
**Сложность:** ⭐⭐⭐☆☆

**Миссия:** Настроить VPN для безопасной коммуникации команды.

**Теория:**
- Что такое VPN, зачем нужен
- OpenVPN vs WireGuard
- SSH tunneling: local, remote, dynamic
- SSH config: `~/.ssh/config`
- SSH keys: `ssh-keygen`, `ssh-copy-id`

**Практика:**
- Настроить OpenVPN сервер (в Цюрихе, Швейцария)
- Создать конфиги для команды (Viktor, Alex, Anna, Dmitry)
- SSH tunnel для доступа к закрытому серверу
- Автоматизировать подключение через скрипт

**Персонажи:**
- **Katarina Lindström** — криптография, консультация по SSL/TLS

**Сюжет:**
- Alex: "Krylov перехватывает трафик. Все коммуникации через VPN. Сейчас."
- Viktor: "У меня есть сервер в Цюрихе. Настрой его как VPN шлюз."
- Результат: Безопасная коммуникация через швейцарский сервер
- **Личное:** Alex открывается Max о прошлом: *"Я покинул ФСБ из-за Krylov. Он фабриковал дела. Я отказался. Теперь он охотится."*

---

## 🎯 Цели сезона

### Технические навыки:
- ✅ TCP/IP модель
- ✅ IP адресация и subnetting
- ✅ Диагностика сетей (ping, traceroute)
- ✅ Порты и сервисы (netstat, ss, nmap)
- 🔲 DNS (dig, nslookup, DNSSEC, DoT)
- 🔲 Firewalls (ufw, iptables, rate limiting)
- 🔲 VPN (OpenVPN, WireGuard)
- 🔲 SSH (tunneling, port forwarding, keys)

### Личный рост Max:
- ✅ Первая командная работа (Alex, Anna, Dmitry, Viktor)
- ✅ Первая поездка в Москву для работы
- 🔲 Первый раз за границей (Стокгольм)
- 🔲 Адаптация к международной команде
- 🔲 Работа под давлением (DDoS атаки, Krylov)

### Сюжетная линия:
- ✅ Знакомство с командой лично
- ✅ Понимание угрозы Krylov
- 🔲 Первые серьёзные атаки
- 🔲 Международное сотрудничество (Erik, Katarina)
- 🔲 Развитие отношений с Alex (брат, ментор)

---

## 📊 Прогресс

**Эпизоды:** 1/4 (25%)

| Episode | Название | Локация | Прогресс | Статус |
|---------|----------|---------|----------|--------|
| 05 | TCP/IP Fundamentals | Москва 🇷🇺 | 100% | ✅ Ready |
| 06 | DNS & Name Resolution | Стокгольм 🇸🇪 | 0% | 🚧 Planned |
| 07 | Firewalls | Москва 🇷🇺 | 0% | 🚧 Planned |
| 08 | VPN & SSH | Стокгольм/Москва | 0% | 🚧 Planned |

---

## 🎭 Основные персонажи

### Core Team (постоянные):

#### Viktor Petrov
- **Роль:** Координатор операции, заказчик
- **Возраст:** ~55 лет
- **Внешность:** Седые волосы, чёрный костюм, проницательный взгляд
- **Локация:** Москва (штаб-квартира)
- **Характер:** Деловой, немногословный, контролирует всё

#### Alex Sokolov
- **Роль:** Security expert, offensive security, ex-FSB
- **Возраст:** 35 лет
- **Родство:** Двоюродный брат Max
- **Прошлое:** ФСБ Управление "К" (киберпреступность), покинул из-за конфликта с Krylov
- **Навыки:** Penetration testing, offensive security, тактика атакующих
- **Характер:** Параноидальный, циничный, надёжный

#### Anna Kovaleva
- **Роль:** Forensics expert, blue team lead, ex-FSB
- **Возраст:** 32 года
- **Прошлое:** ФСБ (та же команда что и Alex), ушла вместе с Alex
- **Навыки:** Digital forensics, log analysis, incident response
- **Характер:** Спокойная, методичная, профессиональная

#### Dmitry Orlov
- **Роль:** DevOps engineer, embedded specialist
- **Возраст:** 29 лет
- **Внешность:** Hoodie, джинсы, 3 монитора
- **Навыки:** Docker, Kubernetes, Ansible, embedded Linux
- **Характер:** Энтузиаст, friendly, любит автоматизацию

### Local Experts (Season 2):

#### Erik Johansson (Episode 06)
- **Роль:** Network engineer, Bahnhof employee
- **Локация:** Стокгольм, Швеция
- **Специализация:** BGP routing, DNS, datacenter infrastructure
- **Характер:** Профессиональный, privacy-focused, Swedish pragmatism
- **Цитата:** *"In Sweden we take privacy seriously. After WikiLeaks, Bahnhof refused government pressure."*

#### Katarina Lindström (Episode 08)
- **Роль:** Криптография researcher, Stockholm University
- **Локация:** Стокгольм, Швеция
- **Специализация:** SSL/TLS, DNS over TLS, cryptographic protocols
- **Характер:** Академичная, строгая к security, mathematics-driven
- **Цитата:** *"Encryption is mathematics. Mathematics doesn't lie. Unlike people."*

### Antagonist:

#### Полковник Krylov
- **Роль:** Главный антагонист Season 2
- **Организация:** ФСБ Управление "К" (киберпреступность)
- **Прошлое:** Бывший начальник Alex и Anna
- **Мотивация:** Месть Alex за "предательство" (отказ фабриковать дела)
- **Методы:** DDoS, DNS spoofing, network surveillance, social engineering
- **IP:** 185.220.101.47 (Tor exit node, предположительно)

---

## 💡 Философия сезона

### "Packets tell stories. Learn to listen."

Каждый сетевой пакет несёт информацию:
- Откуда пришёл (source IP)
- Куда идёт (destination IP)
- Что хочет (порт, протокол)
- Когда (timestamp)

Networking — это не просто технология. Это **коммуникация**.

Понимание сетей = понимание как системы общаются = понимание как защищать или атаковать.

### Security vs Usability

**Season 2 исследует трейдофф:**
- Полная безопасность = неудобство (VPN замедляет, firewall блокирует)
- Полное удобство = уязвимость (открытые порты, незашифрованный трафик)

**Баланс — ключ.**

### Культурные различия в tech подходах

- **Россия:** Chaos, improvisation, "работает — не трогай", срочность
- **Швеция:** Порядок, privacy by design, минимализм, long-term thinking

Max учится адаптироваться к разным культурам. Technology transcends borders.

---

## 🔧 Инструменты сезона

### Сетевые утилиты:
```bash
ip a              # IP адреса
ping              # Проверка доступности
traceroute        # Маршрут до хоста
netstat / ss      # Открытые порты
nmap              # Сканирование портов
dig / nslookup    # DNS lookup
tcpdump           # Захват пакетов
wireshark         # Анализ трафика (GUI)
```

### Firewall:
```bash
ufw               # Uncomplicated Firewall
iptables          # Firewall правила
nftables          # Новое поколение firewall
```

### VPN & SSH:
```bash
ssh               # Secure Shell
ssh-keygen        # Генерация ключей
openvpn           # OpenVPN клиент/сервер
wireguard         # Современный VPN
```

### Мониторинг:
- Prometheus — сбор метрик
- Grafana — визуализация
- Alertmanager — алерты

---

## 📖 Рекомендуемые ресурсы

### Книги:
- **TCP/IP Illustrated** by W. Richard Stevens — классика
- **Practical Packet Analysis** by Chris Sanders — Wireshark
- **The Practice of Network Security Monitoring** by Richard Bejtlich

### Онлайн курсы:
- [Introduction to Networking](https://www.coursera.org/learn/computer-networking) (Coursera)
- [Wireshark Tutorial](https://www.wireshark.org/docs/wsug_html_chunked/) (официальная документация)

### Практика:
- [OverTheWire: Bandit](https://overthewire.org/wargames/bandit/) — SSH практика
- [HackTheBox](https://www.hackthebox.eu/) — networking challenges
- [TryHackMe: Network Fundamentals](https://tryhackme.com/) — интерактивные задания

### Tools:
- [Wireshark](https://www.wireshark.org/) — анализ пакетов (GUI)
- [nmap](https://nmap.org/) — сканирование сетей
- [tcpdump](https://www.tcpdump.org/) — захват пакетов (CLI)

---

## ⏭️ Следующий сезон

**SEASON 3: SYSTEM ADMINISTRATION**

**Локации:** 🇷🇺 Санкт-Петербург → 🇪🇪 Таллин, Эстония
**Дни:** 17-24 из 60
**Тема:** Users & Permissions, Processes, Disk Management, Backup

**Кризис:** Один из серверов взломан (backdoor от Krylov). Anna: *"Нужен полный контроль над системами."*

---

<div align="center">

**KERNEL SHADOWS — Season 2: Networking**

*"Каждый пакет рассказывает историю. Научись слушать."* — LILITH

**[← Season 1](../season-1-shell-foundations/README.md) | [Season 3 →](../season-3-system-administration/README.md)**

**[Episode 05 →](episode-05-tcp-ip-fundamentals/README.md)**

</div>
