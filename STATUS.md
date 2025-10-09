# KERNEL SHADOWS: Статус проекта

**Версия:** 0.3.1 (Season 3: SYSTEM ADMINISTRATION — Episode 10! 🇷🇺⚙️)
**Дата:** 9 октября 2025
**Обновлено:** 9 октября 2025 (Episode 10: Processes & SystemD — Boris Kuznetsov)
**Статус:** Season 3 Episode 10 Ready! (10/32 episodes, 31% done)

---

## 📊 Общий прогресс: 31% (10/32 episodes)

### v0.3.1 — Episode 10: Processes & SystemD ⚙️🇷🇺
- [x] **Season 3 Episode 10** (100%) — Processes & SystemD (Санкт-Петербург, дни 19-20)
  - Интегрированный README.md (2,000+ строк):
    - Сюжет: Boris Kuznetsov (ex-Red Hat, SystemD архитектор), продолжение в СПб
    - Кризис: Backdoor процесс маскируется под sshd (sshd_backup, PID trick)
    - 7 последовательных заданий с progressive hints:
      1. Hunt for backdoor process (ps, pgrep, /proc inspection)
      2. Kill backdoor (SIGTERM → SIGKILL escalation)
      3. Create systemd monitoring service (shadow-monitor.service)
      4. Create systemd timer for backups (shadow-backup.timer, hourly)
      5. Analyze logs with journalctl (filtering, forensics)
      6. Monitor system health (load, memory, CPU, failed services)
      7. Generate comprehensive audit report
    - Полная теория:
      - Processes: ps, top, pgrep/pkill, /proc filesystem, PID, PPID, states
      - Signals: SIGTERM, SIGKILL, SIGHUP, signal handling
      - SystemD: init system, unit files, services, timers, targets
      - Service Units: [Unit], [Service], [Install], Type, ExecStart, Restart
      - Timer Units: OnCalendar, Persistent, timers vs cron
      - Journalctl: -u, -p, --since, -f, forensics queries
      - System monitoring: uptime, free, CPU/memory analysis
    - Персонажи: Boris Kuznetsov (SystemD architect, ex-Red Hat contributor)
    - Boris's wisdom: "Init scripts — это прошлое. SystemD — это настоящее. И настоящее."
    - Философия: SystemD как unified control plane всей системы
  - starter.sh (357 строк) — шаблон с TODO для всех 7 задач
  - solution/process_manager.sh (1,165 строк) — complete reference solution:
    - Backdoor process hunt (pattern matching, /proc inspection)
    - Process killing with proper signal escalation
    - Shadow-monitor service (continuous monitoring script + unit file)
    - Shadow-backup timer (backup script + service + timer units)
    - Journalctl analysis (multiple filtering techniques)
    - System health monitoring (load, memory, CPU, services)
    - Comprehensive audit report (14 sections, production-ready)
  - artifacts/:
    - README.md (547 строк) — testing guide, simulation, troubleshooting, pro tips
  - tests/test.sh (808 строк) — 10 test categories:
    1. File structure (scripts, units, directories)
    2. Script content (shebang, loops, logger usage)
    3. SystemD service units (structure, ExecStart, Restart, journal logging)
    4. SystemD timer (OnCalendar, Persistent, Type=oneshot)
    5. Service runtime (active, enabled, process running, scheduled)
    6. Logging (journal entries, journalctl commands)
    7. Backups (directory, files created, permissions)
    8. Process management (ps, pgrep, top, kill, systemctl)
    9. Report (exists, content, sections, permissions)
    10. Integration (service restart, manual backup trigger, health check)

### v0.3.0 — Season 3: SYSTEM ADMINISTRATION BEGINS! 🇷🇺🎓
- [x] **Season 3 Episode 09** (100%) — Users & Permissions (Санкт-Петербург, дни 17-18) **SEASON 3 PREMIERE!**
  - Интегрированный README.md (1,000+ строк):
    - Сюжет: Белые ночи СПб, ЛЭТИ, встреча с Andrei Volkov (ex-профессор Unix)
    - Кризис: Сервер взломан через misconfigured permissions (backdoor от Krylov)
    - 8 последовательных заданий с progressive hints:
      1. Инспекция пользователей (поиск backdoor accounts с UID 0)
      2. Создание team users (viktor, alex, anna, dmitry)
      3. Создание групп (operations, security, forensics, devops, netadmin)
      4. Shared directory с sticky bit + SGID (3770 permissions)
      5. sudo для Alex (network commands only - Principle of Least Privilege)
      6. ACL для Anna (read-only log access - forensics requirements)
      7. SUID/SGID security audit (baseline + monitoring)
      8. Comprehensive security audit report
    - Полная теория:
      - Users & Groups: useradd, usermod, /etc/passwd, /etc/shadow, /etc/group
      - Permissions: chmod, chown, UGO model, rwx, octal notation
      - Special Bits: SUID (4000), SGID (2000), Sticky Bit (1000)
      - sudo: /etc/sudoers, visudo, Cmnd_Alias, NOPASSWD
      - ACL: setfacl, getfacl, granular permissions
      - Security: Principle of Least Privilege, Defense in Depth
    - Персонажи: Andrei Volkov (LETI professor, Unix mentor)
    - Andrei's wisdom: "Root access как заряженный пистолет. Не давай его кому попало."
    - Философия: Unix permissions - это не команды, это философия безопасности
  - starter.sh (400+ строк) — шаблон с TODO для всех 8 задач
  - solution/user_management.sh (800+ строк) — complete reference solution:
    - User inspection + backdoor detection
    - Team user creation with password policy
    - Group structure (5 groups, role-based)
    - Shared directory (sticky bit + SGID)
    - sudo configuration for Alex (network only)
    - ACL setup for Anna (read-only logs)
    - SUID/SGID audit (baseline comparison)
    - Comprehensive security report generation
  - artifacts/:
    - README.md (300+ строк) — testing guide, troubleshooting
    - team_list.txt — team members with roles
    - requirements.txt (500+ строк) — complete security policy document
  - tests/test.sh (600+ строк) — 10 test categories:
    1. File structure
    2. User creation (home, shell, UID validation)
    3. Groups & membership (5 groups, role mapping)
    4. Shared directory permissions (3770, sticky bit, SGID)
    5. sudo configuration (Alex network-only)
    6. ACL configuration (Anna read-only logs)
    7. SUID/SGID security audit
    8. Final security report (comprehensive validation)
    9. Script execution (syntax, best practices)
    10. Documentation quality
    11. Integration tests

### v0.2.4 — Season 2: NETWORKING COMPLETE! 🎉🔒
- [x] **Season 2 Episode 08** (100%) — VPN & SSH Tunneling (Стокгольм → Москва → Цюрих, дни 15-16) **SEASON 2 FINALE!**
  - Интегрированный README.md (3,458+ строк!) — самый большой эпизод:
    - Сюжет: Эмоциональный финал Season 2 (разговор Alex о его прошлом в ФСБ, Krylov эскалирует)
    - 7 последовательных заданий с progressive hints:
      1. SSH keys generation (ed25519)
      2. SSH config automation (~/.ssh/config, ProxyJump)
      3. SSH tunneling (Local Forward: Grafana, PostgreSQL)
      4. SOCKS proxy (Dynamic Forward: browser через VPN)
      5. VPN configuration (OpenVPN vs WireGuard comparison + WireGuard setup)
      6. VPN monitoring & testing (bandwidth, leak tests)
      7. Final Security Audit (итог всего Season 2)
    - Полная теория:
      - SSH: Keys (ed25519 vs RSA), Config, Tunneling (L/R/D forward), SOCKS proxy, Best practices
      - VPN: Концепты, OpenVPN vs WireGuard, Encryption (ChaCha20-Poly1305, Curve25519), Setup, Monitoring
      - Security: End-to-end encryption, Perfect Forward Secrecy, DNS/IP leak protection
    - Персонажи: Viktor, Alex (эмоциональный backstory), Anna, Dmitry, Katarina Lindström (криптография)
    - Katarina's wisdom: "Encryption is mathematics. Mathematics doesn't lie. Unlike people."
    - Alex's confession: История почему покинул ФСБ из-за Krylov (фабрикация дел)
    - LILITH v2.0 Security Mode — encryption focused
    - Twist: Вся команда переходит на защищённые каналы после угрозы Krylov
  - starter.sh (400+ строк) — шаблон с TODO для всех 7 задач (8 функций)
  - solution/vpn_setup.sh (600+ строк) — complete reference solution:
    - SSH key generation (ed25519 для 5 членов команды)
    - SSH config with ProxyJump (VPN gateway → Moscow servers)
    - SSH tunnel examples (Local, Dynamic forward)
    - WireGuard full setup (server + 5 clients)
    - VPN monitoring scripts
    - Security testing (IP leak, DNS leak)
    - Comprehensive Season 2 Final Audit Report
  - artifacts/:
    - README.md (450+ строк) — detailed installation, troubleshooting, security practices
    - ssh_keys/ (генерируются) — ed25519 keys для команды
    - wireguard/ (генерируются) — server_wg0.conf + client configs
    - ssh_config (генерируется) — automation config
    - season2_final_audit.txt (генерируется) — итоговый отчёт Season 2
  - tests/test.sh (650+ строк) — 10 test categories:
    1. File structure
    2. SSH keys generation (5 members)
    3. SSH config (hosts, ProxyJump, settings)
    4. WireGuard configuration (server + clients)
    5. Final audit report (comprehensive check)
    6. README content (plot, technical, characters)
    7. Script execution
    8. Security checks (permissions, no leaked secrets)
    9. Documentation quality
    10. Season 2 integration (references to Episodes 05-07)

- [x] **Season 2 Episode 07** (100%) — Firewalls & iptables (Москва, дни 13-14)
  - Интегрированный README.md (2,738+ строк):
    - Сюжет: DDoS атака в реальном времени (03:47, экстренный звонок от Alex)
    - 8 последовательных заданий с progressive hints (check → enable UFW → allow ports → block IPs → rate limiting → logging → monitoring → audit)
    - Полная теория: UFW vs iptables, chains, targets, rate limiting, SYN flood, fail2ban, nftables
    - LILITH Emergency Mode — активный помощник под давлением
    - Twist: Сообщение от Krylov в TCP payload логах
  - starter.sh (350+ строк) — шаблон с TODO для всех 8 задач
  - solution/firewall_setup.sh (500+ строк) — референсное решение:
    - Complete firewall setup (UFW + iptables)
    - IP blocking (botnet list processing)
    - Rate limiting (connlimit, recent, hashlimit)
    - Attack logging (rsyslog integration)
    - Real-time monitoring
    - Comprehensive audit report
  - artifacts/:
    - botnet_ips.txt (50 test IPs, real attack had 847)
    - README.md (forensics notes from Anna)
  - tests/test.sh (400+ строк) — 11 test categories
- [x] **Season 2 Episode 06** (100%) — DNS & Name Resolution (Стокгольм, дни 10-12)
- [x] **Season 2 Episode 05** (100%) — TCP/IP Fundamentals (Москва, день 9)
- [x] **Season 2 README** (100%) — обзор сезона Networking
- [x] **Season 1** (100%) — Shell & Foundations (4 episodes, days 2-8)

---

## 📚 Статус по сезонам

| Season | Название | Episodes | Прогресс | Статус |
|--------|----------|----------|----------|--------|
| **1** | Shell & Foundations | 01-04 | 100% | ✅ Complete! (Days 2-8) |
| **2** | Networking | 05-08 | 100% | ✅ Complete! (Days 9-16) 🎉 |
| **3** | System Administration | 09-12 | 50% | 🚧 In Progress (Days 17-24) 🇷🇺⚙️ |
| **4** | DevOps & Automation | 13-16 | 0% | 🚧 Not started |
| **5** | Security & Pentesting | 17-20 | 0% | 🚧 Not started |
| **6** | Embedded Linux | 21-24 | 0% | 🚧 Not started |
| **7** | Advanced Topics | 25-28 | 0% | 🚧 Not started |
| **8** | Final Operation | 29-32 | 0% | 🚧 Not started |

---

## ✅ Что готово (v0.1.4)

### Базовая документация:
- ✅ **README.md** (14 KB) — описание курса, LILITH, структура (обновлено)
- ✅ **GETTING_STARTED.md** (26 KB) — пошаговая инструкция для новичков (NEW! ✨)
- ✅ **SCENARIO.md** (27 KB) — сценарий, персонажи, сюжет, AI (обновлено)
- ✅ **CURRICULUM.md** (43 KB) — детальный план 32 эпизодов
- ✅ **LILITH.md** (13 KB) — AI-помощник, стиль, диалоги
- ✅ **RESOURCES.md** (25 KB) — кураторский список ресурсов
- ✅ **STATUS.md** — этот файл
- ✅ **LICENSE** (GPL v3) — копилефт лицензия


### Episode 01: Terminal Awakening (COMPLETE ✅):
- ✅ **README.md** (1,263 строки) — интегрированный сюжет + теория + практика (NEW! ✨)
  - Сюжет сжат до 30 строк
  - 8 последовательных заданий
  - Теория "just-in-time" (в спойлерах)
  - LILITH как проводник
- ✅ **starter.sh** — шаблон с TODO для студента
- ✅ **solution/find_files.sh** — референсное решение
- ✅ **artifacts/** — тестовая среда с 3 файлами:
  - `documents/briefing.txt`
  - `.secret_location`
  - `.next_server`
- ✅ **tests/test.sh** — автоматические тесты
- ✅ **Season 1 README.md** — обзор сезона

### Статистика Episode 01:
- **Строк кода:** ~250 (starter + solution + tests)
- **Строк документации:** ~1,263 (интегрированный README)
- **Размер:** 39 KB (был 108 KB — оптимизация!)
- **Время прохождения:** 3-4 часа
- **Сложность:** ⭐☆☆☆☆
- **Структура:** Learn by Doing (практика → теория)

### Episode 02: Shell Scripting Basics (COMPLETE ✅):
- ✅ **README.md** (1,370+ строк) — интегрированный сюжет + теория + практика
  - 7 последовательных заданий (переменные → функции → финальный проект)
  - Теория Bash: shebang, переменные, условия, циклы, функции, exit codes
  - Практика: создание production-ready мониторинга серверов
  - LILITH как наставник по автоматизации
- ✅ **starter.sh** — шаблон с TODO (130+ строк)
- ✅ **solution/server_monitor.sh** — полное решение (170+ строк)
- ✅ **artifacts/** — тестовое окружение:
  - `servers.txt` — список серверов для мониторинга
  - `README.md` — инструкции по использованию
- ✅ **tests/test.sh** — автоматические тесты (260+ строк)
  - Структурные тесты (files, shebang, functions)
  - Функциональные тесты (логи, алерты, exit codes)
  - Проверка пользовательского решения

### Статистика Episode 02:
- **Строк кода:** ~560 (starter + solution + tests)
- **Строк документации:** ~1,370 (интегрированный README)
- **Размер:** ~45 KB
- **Время прохождения:** 3-4 часа
- **Сложность:** ⭐⭐☆☆☆
- **Структура:** Incremental Learning (от простого к сложному)
- **Финальный проект:** Server monitoring script с логированием и алертами

### Episode 03: Text Processing Masters (COMPLETE ✅):
- ✅ **README.md** (1,500+ строк) — интегрированный сюжет + теория + практика
  - 9 последовательных заданий (grep → awk → sed → pipes → финальный проект)
  - Теория: grep/regex, awk колонки, sed замена, pipes/redirects
  - Практика: анализ логов атаки (4,400+ строк), извлечение IP, TOP-10 attackers
  - LILITH как проводник в анализе данных
  - Сюжет: Первая DDoS атака от Krylov (03:47), знакомство с Anna Kovaleva
- ✅ **starter.sh** — шаблон с TODO (180+ строк)
- ✅ **solution/log_analyzer.sh** — полное решение (280+ строк)
- ✅ **artifacts/** — реалистичное тестовое окружение:
  - `access.log` — симулированный веб-сервер лог (4,400+ строк)
  - `suspicious_ips.txt` — база известных угроз (10 IP)
  - `report_template.txt` — шаблон отчёта
  - `generate_log.sh` — генератор реалистичных логов
  - `README.md` — инструкции
- ✅ **tests/test.sh** — комплексные автотесты (350+ строк)
  - Структурные тесты (shebang, functions, text processing commands)
  - Функциональные тесты (TOP-10 extraction, threat detection, report generation)
  - Проверка использования grep/awk/pipes
  - Exit codes validation

### Статистика Episode 03:
- **Строк кода:** ~810 (starter + solution + tests)
- **Строк документации:** ~1,500 (интегрированный README)
- **Размер:** ~52 KB (+ 280 KB access.log)
- **Время прохождения:** 3-4 часа
- **Сложность:** ⭐⭐☆☆☆
- **Структура:** Learn by Doing with Theory (практика + справочник)
- **Финальный проект:** Log analyzer для forensics анализа
- **Особенность:** Первая атака в сюжете, Anna Kovaleva, Tor exit node

### Episode 07: Firewalls & iptables (COMPLETE ✅):
- ✅ **README.md** (2,738+ строк) — интегрированный сюжет + теория + практика
  - Сюжет: DDoS атака в реальном времени (03:47 Moscow time, 847 IPs, SYN flood)
  - 8 последовательных заданий с progressive hints (3-level system)
  - Теория: UFW vs iptables, chains (INPUT/OUTPUT/FORWARD), targets (ACCEPT/DROP/REJECT/LOG)
  - Rate limiting: connlimit, recent, hashlimit, limit modules
  - SYN flood protection и kernel tuning
  - Практика: Emergency incident response под давлением (5 минут до crash)
  - LILITH Emergency Mode — real-time помощник
  - Twist: Сообщение от Krylov в TCP payload: "Соколов. Передай брату: я найду вас. Обоих. - К."
- ✅ **starter.sh** — шаблон с TODO (350+ строк)
- ✅ **solution/firewall_setup.sh** — референсное решение (500+ строк)
  - Complete UFW setup (default deny + allow SSH/HTTP/HTTPS)
  - Botnet IP blocking (847 IPs via iptables)
  - Multi-layer rate limiting (per-IP, per-service, global)
  - Attack logging (rsyslog integration, separate log files)
  - Real-time monitoring (load, SYN_RECV, blocked packets)
  - Comprehensive audit report (8 sections, forensics analysis)
- ✅ **artifacts/** — incident response data:
  - `botnet_ips.txt` — 50 test IPs (simulating 847 real IPs from Krylov's botnet)
  - `README.md` — forensics notes from Anna (attack attribution, timing, recommendations)
- ✅ **tests/test.sh** — comprehensive test suite (400+ строк)
  - File structure tests (scripts, artifacts, executability)
  - Syntax validation (bash -n)
  - Security features validation (UFW policies, rate limiting, logging)
  - Error handling checks (set -e, file checks, IP validation)
  - 11 test categories, detailed reporting

### Статистика Episode 07:
- **Строк кода:** ~1,250 (starter + solution + tests)
- **Строк документации:** ~2,738 (интегрированный README)
- **Размер:** ~110 KB
- **Время прохождения:** 4-5 часов
- **Сложность:** ⭐⭐⭐☆☆ (incident response под давлением!)
- **Структура:** Emergency Incident Response (time pressure, real-world scenario)
- **Финальный проект:** Complete firewall setup с DDoS mitigation + audit report
- **Особенность:**
  - Первый REAL incident (не симуляция)
  - 5-минутный deadline (Load Average 47 → 2)
  - Удалённое администрирование (SSH из самолёта, 1200ms latency)
  - Progressive escalation (Krylov угрожает лично Alex и Max)
  - Multi-tool integration (UFW + iptables + rsyslog + netstat + ss)

---

## 🎯 Критерии готовности эпизода

Episodes 01-02 соответствуют ВСЕМ критериям:

### Episode 01 ⭐⭐⭐⭐⭐
1. ✅ **README.md** — интегрированный сюжет + теория + практика (1,263 строки)
2. ✅ **starter.sh** — шаблон с TODO (60 строк)
3. ✅ **solution/** — референсное решение (120 строк)
4. ✅ **artifacts/** — тестовые файлы (3 файла)
5. ✅ **tests/** — автотесты (170 строк)
6. ✅ **LILITH интеграция** — активный проводник
7. ✅ **Season README** — обзор сезона

### Episode 02 ⭐⭐⭐⭐⭐
1. ✅ **README.md** — интегрированный сюжет + теория + практика (1,370+ строк)
2. ✅ **starter.sh** — шаблон с TODO (130+ строк)
3. ✅ **solution/** — полное решение (170+ строк)
4. ✅ **artifacts/** — тестовая среда (servers.txt, README)
5. ✅ **tests/** — комплексные автотесты (260+ строк)
6. ✅ **LILITH интеграция** — наставник по автоматизации
7. ✅ **Production-ready script** — реальный мониторинг серверов

**Episodes 01-02 = Production Ready ⭐⭐⭐⭐⭐**

---

## 📅 Roadmap

### ✅ v0.1.0 — Pilot Episode (DONE — 4 октября 2025)
- [x] Базовая документация (README, SCENARIO, CURRICULUM, LILITH)
- [x] Episode 01 полностью (mission, theory, practice, tests)
- [x] Season 1 README
- [x] LICENSE (GPL v3)

### ✅ v0.1.4 — Episode 02 Ready (DONE — 4 октября 2025)
- [x] Episode 02: Shell Scripting Basics (COMPLETE)
- [x] Интегрированная структура обучения
- [x] Production-ready server monitoring script
- [x] Комплексные автотесты

### ✅ v0.1.5 — Episode 03 Ready (DONE — 4 октября 2025)
- [x] Episode 03: Text Processing Masters (COMPLETE)
- [x] grep, awk, sed, pipes — полная теория + практика
- [x] Реалистичный анализ логов (4,400+ строк)
- [x] Forensics investigation сюжет (Anna Kovaleva, DDoS атака)
- [x] Production-ready log analyzer

### ✅ v0.1.6 — Episode 04 Ready (DONE — 4 октября 2025)
- [x] Episode 04: Package Management (COMPLETE)
- [x] APT, DPKG, Snap — полная теория + практика
- [x] Репозитории, dependency resolution
- [x] Автоматизация установки (install_toolkit.sh)
- [x] Docker installation (custom repository)
- [x] Non-interactive automation для production
- [x] **Season 1 Complete!** 🎉

### 📋 v0.3.0 — Season 2 Complete (цель: декабрь 2025)
- [ ] Episodes 05-08 (Networking: TCP/IP, DNS, Firewalls, VPN)
- [ ] Локации: Москва 🇷🇺 → Стокгольм 🇸🇪
- [ ] Новые персонажи: Alex (лично), Anna (лично), Erik Johansson, Katarina Lindström
- [ ] Навыки интегрируются естественно без отдельных проектов

### 📋 v0.5.0 — Seasons 1-4 Complete (цель: март 2026)
- [ ] Seasons 3-4
- [ ] LILITH CLI прототип

### 📋 v1.0.0 — Full Release (цель: сентябрь 2026)
- [ ] Все 8 сезонов (32 эпизода)
- [ ] LILITH AI интеграция
- [ ] Community testing
- [ ] Переводы

---

## 🎬 Тестирование v0.1.3

### Как протестировать Episode 01:

```bash
cd /home/fazzz/kernel-shadows/season-1-shell-foundations/episode-01-terminal-awakening/

# 1. Открыть интегрированное руководство
less README.md
# (или открыть в редакторе для навигации по спойлерам)

# 2. Запустить симуляцию
chmod +x starter.sh
./starter.sh

# 3. "Подключиться к серверу"
cd artifacts/test_environment

# 4. Следовать заданиям из README.md:
#    - Задание 1: pwd (ориентация)
#    - Задание 2: ls -l (что вокруг?)
#    - Задание 3: ls -la (скрытые файлы)
#    - Задание 4-7: навигация и чтение
#    - Задание 8: создать скрипт find_files.sh

# 5. Запустить тесты
cd ../../tests/
./test.sh
```

### Ожидаемые результаты:
- ✅ Найдены все 3 файла через последовательные задания
- ✅ Прочитано содержимое
- ✅ Создан автоматический скрипт find_files.sh
- ✅ Все тесты пройдены (100%)
- ✅ Понимание концепций (не просто копипаст)

---

## 📊 Метрики проекта

### Текущие (v0.2.1):
- **Эпизодов готово:** 6/32 (18.75%)
- **Season 1:** Complete! 🎉 (4 episodes)
- **Season 2:** Episodes 05-06 Ready! 🇸🇪 (2/4 episodes, 50%)
- **Документация:** Episodes 05-06 README (5,550+ строк)
- **Progressive hints:** 100% в Season 1 + Episodes 05-06 (3-уровневая система)
- **Строк документации:** ~34,500+ (README files)
- **Строк кода:** ~5,200 (starter + solution + tests)
- **Размер:** ~1,800 KB

### Целевые (v1.0.0):
- **Эпизодов:** 32
- **Строк кода:** ~50,000
- **Строк документации:** ~80,000
- **Артефактов:** 100+ файлов
- **Время прохождения:** 120-160 часов

---

## 🔗 Связь с MOONLIGHT

**MOONLIGHT Course:**
- Версия: v0.3.5
- Прогресс: 50%
- Статус: Season 1-4 Ready

**KERNEL SHADOWS:**
- Версия: v0.1.7
- Прогресс: 25%
- Статус: Season 1 Complete (4 episodes + глобальная концепция)

**Связь:** Спин-офф, параллельные сюжеты, общие персонажи.

---

## 📝 Аудит курса (4 октября 2025)

**Проведён полный аудит курса по 4 критериям:**
- ✅ Полнота теории: 4.5/5
- ✅ Увлекательность сюжета: 4.7/5
- ⚠️ Удобство пользования: 3.8/5
- ⚠️ Отсутствие несостыковок: 3.9/5

**Общая оценка:** 4.2/5 (A-)
**Потенциал:** 4.8/5 (A+) после устранения недостатков

**Критические проблемы (PHASE 1) — ИСПРАВЛЕНЫ ✅:**
1. ✅ Создан GETTING_STARTED.md (26 KB, пошаговая инструкция)
2. ✅ Episode 01 дополнен разделом о локальной симуляции
3. ✅ Исправлены несостыковки в SCENARIO.md (родство Alex, AI-помощники, timeline)
4. ✅ Обновлён README.md с ссылками на GETTING_STARTED.md

**Статус:** Phase 1 (Critical Issues) — COMPLETED 🎉

**Следующий этап:** Phase 2 (LILITH CLI, .vscode, progress tracker)

---

## 💡 Источники

- **Концепция:** [Eurecable.com/ideas/973](https://eurecable.com/ideas/973) (3 октября 2025)
- **Методология:** MOONLIGHT Course v3.0+ (LUNA Edition)
- **Лицензия:** GPL v3 (копилефт)

---

## 📝 История изменений

### v0.1.0 (4 октября 2025) — Pilot Episode
- ✅ Создана базовая документация
- ✅ Episode 01 полностью реализован
- ✅ LILITH билингвальный стиль
- ✅ Production-ready тесты и artifacts
- ✅ Season 1 README

### v0.1.1 (4 октября 2025) — Phase 1 Fixes
- ✅ Создан GETTING_STARTED.md (26 KB)
- ✅ Обновлён mission.md с разделом о симуляции
- ✅ Исправлены несостыковки в SCENARIO.md
- ✅ Обновлён README.md с новой структурой
- ✅ Добавлен раздел AI-помощники (LUNA & LILITH)

### v0.1.2 (4 октября 2025) — Developer Tools
- ✅ Создан `.cursorrules` для Cursor AI (LILITH-стиль)
- ✅ Создан `.vscode/` конфиги (extensions, settings, tasks)
- ✅ Создан `tools/lilith.sh` — CLI помощник (300+ строк)
- ✅ Создан `tools/progress.sh` — progress tracker (350+ строк)
- ✅ Создан `tools/README.md` — документация инструментов
- ✅ Обновлён README.md с разделом "Инструменты разработчика"
- ✅ Обновлён .gitignore (добавлен .progress)

### v0.1.3 (4 октября 2025) — Integrated Learning Structure ⭐
- ✅ Интегрированный Episode 01 README.md (1,263 строки)
  - Объединены mission.md + README.md → единый опыт
  - Сюжет сжат до 30 строк (был ~200)
  - 8 последовательных заданий с прогрессией
  - Теория "just-in-time" в спойлерах
  - LILITH как активный проводник
- ✅ Структура "Learn by Doing" (практика → теория)
- ✅ Оптимизация: 39 KB вместо 108 KB
- ✅ Обновлена документация (STATUS, CONTRIBUTING)

### v0.1.4 (4 октября 2025) — Shell Scripting Mastery ⭐
- ✅ Episode 02: Shell Scripting Basics (COMPLETE)
  - Интегрированный README.md (1,370+ строк)
  - 7 последовательных заданий (переменные → функции)
  - Полная теория Bash: shebang, переменные, условия, циклы, функции, exit codes
  - Production-ready финальный проект: server monitoring script
  - Логирование с timestamp, алерты, цветной вывод
  - LILITH как наставник по автоматизации
- ✅ starter.sh (130+ строк) — шаблон с TODO
- ✅ solution/server_monitor.sh (170+ строк) — полное решение
- ✅ artifacts/ — servers.txt, README для тестирования
- ✅ tests/test.sh (260+ строк) — структурные + функциональные тесты
- ✅ Обновлены README.md и STATUS.md
- ✅ Season 1 прогресс: 50% (2/4 episodes готовы)

**Production Ready! 🚀**

### v0.1.5 (4 октября 2025) — Text Processing Masters ⭐
- ✅ Episode 03: Text Processing Masters (COMPLETE)
  - Интегрированный README.md (1,500+ строк)
  - 9 последовательных заданий (grep → awk → sed → pipes → final project)
  - Полная теория: grep/regex, awk колонки, sed stream editing, pipes/redirects
  - Практика: forensics анализ логов атаки (4,400+ строк)
  - Сюжет: Первая DDoS атака от Krylov, Anna Kovaleva, Tor exit node
  - Production-ready финальный проект: log_analyzer.sh
  - Справочники по командам (grep, awk, sed, pipes, утилиты)
  - LILITH как проводник в анализе данных
- ✅ starter.sh (180+ строк) — шаблон с TODO и структурой
- ✅ solution/log_analyzer.sh (280+ строк) — полное решение
- ✅ artifacts/ — реалистичное окружение:
  - access.log (4,400+ строк) с симуляцией атаки
  - suspicious_ips.txt — база угроз
  - report_template.txt — шаблон отчёта
  - generate_log.sh — генератор логов
- ✅ tests/test.sh (350+ строк) — комплексные тесты:
  - Структурные (shebang, functions, commands usage)
  - Функциональные (TOP-10 extraction, threat detection, reporting)
  - Проверка text processing (grep/awk/pipes)
- ✅ Обновлены Season 1 README.md и STATUS.md
- ✅ Season 1 прогресс: 75% (3/4 episodes готовы)

**Production Ready! 🚀🔥**

### v0.1.6 (4 октября 2025) — Package Management Complete ⭐
- ✅ Episode 04: Package Management (COMPLETE)
  - Интегрированный README.md (1,900+ строк)
  - 9 последовательных заданий (APT → DPKG → Snap → Docker → automation)
  - Полная теория: APT commands, репозитории, dependency hell, non-interactive
  - Практика: автоматизация установки инструментов для операции
  - Сюжет: Viktor даёт список из 15+ инструментов, нужно автоматизировать установку на 50 серверов
  - Production-ready финальный проект: install_toolkit.sh
  - Справочники по APT/DPKG, Docker installation guide
  - LILITH как проводник в package management
- ✅ starter.sh (170+ строк) — шаблон с TODO и структурой
- ✅ solution/install_toolkit.sh (340+ строк) — полное решение с:
  - Root checking, backup, logging, reporting
  - Массивы для tracking (INSTALLED, FAILED, SKIPPED)
  - Цветной вывод, verification, error handling
  - Non-interactive installation (DEBIAN_FRONTEND)
- ✅ artifacts/ — реалистичное окружение:
  - required_tools.txt (15+ пакетов с комментариями)
  - README.md — инструкции по использованию
- ✅ tests/test.sh (350+ строк) — комплексные тесты:
  - Структурные (shebang, functions, variables)
  - Парсинг tools list
  - Safety checks (root, backup, error handling)
  - Logging и reporting
  - Integration test (если root)
- ✅ Обновлены Season 1 README.md и STATUS.md
- ✅ **Season 1 прогресс: 100% (4/4 episodes готовы!)**

**Season 1 Complete! 🚀🔥🎉**

### v0.1.6 (4 октября 2025) — Season 1 Integration Project ⭐
- ✅ Season Project готов (позже удалён в v0.1.7)
- ✅ Season 1 Complete! 🚀🔥🎉

### v0.1.6+ (8 октября 2025) — Global Concept Integration ⭐⭐⭐
- ✅ **SCENARIO.md полностью переписан:**
  - Глобальная распределённая операция (8 стран, 60 дней)
  - География: Новосибирск → Москва → Стокгольм → СПб → Таллин → Амстердам → Берлин → Цюрих → Женева → Шэньчжэнь → Рейкьявик → Global
  - 27 персонажей: Core Team + Local Experts (по 2-3 на сезон) + Antagonists
- ✅ **CHARACTERS.md создан:**
  - Детальные биографии всех 27 персонажей
  - Мотивации, специализации, связи с Max
- ✅ **LOCATIONS.md создан:**
  - Описания всех 8+ локаций
  - Атмосфера, культура, технологические подходы, key landmarks
- ✅ **CURRICULUM.md обновлён:**
  - География курса (маршрут Max)
  - Локации и персонажи интегрированы в каждый сезон и эпизод
  - Season Projects удалены — навыки интегрируются естественно
- ✅ **Season 1 полностью обновлён:**
  - Season 1 README.md: Новосибирск, Дни 2-8, персонажи (Sergey Ivanov, Olga Petrova)
  - Episode 01: День 2, квартира Max в Академгородке, home lab
  - Episode 02: Дни 3-4, + Sergey Ivanov (кафе "Под Интегралом")
  - Episode 03: Дни 5-6, + Olga Petrova (НГУ campus)
  - Episode 04: Дни 7-8, EPIC cliffhanger (звонок от Alex, переход к Season 2)

**Global Distributed Operation — READY! 🌍🚀**

### v0.1.7 (8 октября 2025) — Season Projects Removal ⭐
- ✅ **Season projects удалены из всего курса:**
  - season-1-shell-foundations/season-project/ удалён
  - Все упоминания убраны из README.md, CURRICULUM.md, STATUS.md
  - Навыки из каждого эпизода естественно используются в следующих сезонах
  - Season 8 финал — ultimate integration всех навыков
- ✅ **Преимущества:**
  - Курс компактнее (120-160ч вместо 150-200ч)
  - Меньше maintenance overhead
  - Естественная прогрессивная интеграция
  - Season 8 = финальный проект всего курса
- ✅ Обновлены: Season 1 README (v0.1.7), CURRICULUM.md, STATUS.md (этот файл)

**Курс теперь: 8 сезонов × 4 эпизода = 32 эпизода (без отдельных проектов)**

---

### v0.2.1 (8 октября 2025) — Season 2: DNS & Name Resolution 🇸🇪
- ✅ **Episode 06: DNS & Name Resolution (COMPLETE)**
  - Интегрированный README.md (2,550+ строк):
    - Сюжет: Max в Стокгольме, Bahnhof Pionen (ядерный бункер 30м под землёй)
    - 8 последовательных заданий (DNS lookup → spoofing detection → DNSSEC → отчёт)
    - Progressive hints — 3-уровневая система подсказок (как в Season 1)
    - Полная теория DNS: records, DNSSEC, cache poisoning, DoT/DoH
    - Персонажи: Erik Johansson, Katarina Lindström
  - starter.sh (280+ строк) — шаблон с TODO
  - solution/dns_audit.sh (80+ строк) — референсное решение:
    - Check shadow servers (information leaks)
    - DNS spoofing detection (cache poisoning)
    - DNSSEC validation
    - Security audit report generation
  - artifacts/:
    - dns_zones.txt — 15 internal доменов операции
    - suspicious_domains.txt — список для spoofing detection
    - README.md — инструкции по использованию
  - tests/test.sh (6 тестов):
    - File structure tests
    - Execution tests
    - Report generation validation
- ✅ **Season 2 прогресс: 50%** (2/4 episodes готовы)

**Production Ready! 🇸🇪**

---

### v0.2.0 (8 октября 2025) — Season 2 Starts: TCP/IP Fundamentals ⭐🚀
- ✅ **Episode 05: TCP/IP Fundamentals (COMPLETE)**
  - Интегрированный README.md (3,000+ строк):
    - Сюжет: Max прилетает в Москву, встреча с командой
    - 8 последовательных заданий (IP адреса → ports → routing → отчёт)
    - **Progressive hints** — 3-уровневая система подсказок (как в Season 1):
      - "Попробуйте сами" (пауза для размышления)
      - 💡 Подсказка 1 (> 5 минут) — направление
      - 💡 Подсказка 2 (> 10 минут) — конкретные команды
      - ✅ Решение (если совсем застряли) — готовый код с объяснением
    - Полная теория TCP/IP: модель, IP, ports, TCP vs UDP, ICMP, routing
    - LILITH v2.0 — Networking Module
  - starter.sh (200+ строк) — шаблон с TODO
  - solution/network_audit.sh (350+ строк) — референсное решение:
    - Определение IP адресов (workstation + Viktor server)
    - Ping, traceroute (симуляция)
    - Открытые порты (ss/netstat)
    - Сканирование портов (nmap)
    - Routing table
    - Генерация детального отчёта
  - artifacts/:
    - network_map.txt — карта сети операции (50+ серверов)
    - README.md — инструкции по использованию
  - tests/test.sh (28 тестов):
    - Структурные тесты (shebang, functions, commands)
    - Execution тесты (syntax check, реальный запуск)
    - Output тесты (отчёт, содержимое, формат)
    - Best practices (кавычки, комментарии, error handling)
- ✅ **Season 2 README.md:**
  - Обзор сезона Networking (15-18 часов)
  - География: Москва 🇷🇺 → Стокгольм 🇸🇪
  - Персонажи: Core Team + Local Experts (Erik, Katarina)
  - Antagonist: Полковник Krylov (ex-FSB)
  - План 4 эпизодов (05-08)
- ✅ **Season 2 прогресс: 25%** (1/4 episodes готовы)

**Production Ready! 🚀**

---

<div align="center">

**KERNEL SHADOWS v0.2.1** — Stockholm Complete! 🇸🇪

*"DNS — телефонная книга интернета. Если книга поддельная — весь трафик идёт не туда."* — Erik Johansson

**Season 1: Shell & Foundations — 100% COMPLETE! 🎉**
**Season 2: Networking — 50% (Episodes 05-06 Ready!) 🇸🇪**

**Текущая локация:** Стокгольм, Швеция 🇸🇪 → Москва 🇷🇺
**День операции:** 10-12 из 60
**Персонажи:** Erik Johansson, Katarina Lindström
**Достижение:** DNS spoofing обнаружен, DNSSEC проверен ✓
**Следующая остановка:** Москва (возврат) — Firewalls & iptables (Episode 07) 🇷🇺

</div>
