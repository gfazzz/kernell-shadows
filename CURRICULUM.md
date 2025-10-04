# KERNEL SHADOWS: Учебный план

## 📚 Структура: 8 Сезонов • 32 Эпизода • ~120-160 часов

---

## SEASON 1: SHELL & FOUNDATIONS
**Тема:** Основы Ubuntu Linux и работа с терминалом  
**Время:** 12-15 часов  
**Сложность:** ⭐☆☆☆☆

### Episode 01: Terminal Awakening
**Тема:** Первые шаги в терминале  
**Время:** 3-4ч  
**Миссия:** Viktor активирует вас. Первое задание — освоить терминал.

**Теория:**
- Что такое терминал, shell, bash
- Структура файловой системы Linux (/, /home, /etc, /var)
- Основные команды: `ls`, `cd`, `pwd`, `mkdir`, `rm`, `cp`, `mv`
- Навигация: абсолютные и относительные пути
- Man pages: `man`, `--help`

**Практика:**
- Найти скрытый файл Viktor в `/home/student/.secrets/`
- Создать структуру папок для операции
- Расшифровать сообщение через навигацию по директориям

**Артефакты:**
- `briefing.txt` от Viktor
- Скрытые файлы `.secret_message`
- Структура папок как "карта" операции

**Сюжет:**
- Viktor: "Добро пожаловать в операцию. Начнём с основ."
- LILITH активируется: "Я LILITH. Твой проводник в тенях. Покажи, на что ты способен."
- Первое задание: найти координаты сервера в скрытых файлах

---

### Episode 02: Shell Scripting Basics
**Тема:** Bash скрипты и автоматизация  
**Время:** 3-4ч  
**Миссия:** Автоматизировать рутинные задачи через скрипты.

**Теория:**
- Что такое shell script
- Shebang `#!/bin/bash`
- Переменные: `VAR="value"`, `$VAR`, `${VAR}`
- Условия: `if`, `[[ ]]`, `test`
- Циклы: `for`, `while`
- Функции
- Exit codes: `$?`, `exit 0`

**Практика:**
- Написать скрипт для проверки статуса серверов
- Автоматизировать backup файлов
- Создать `monitor.sh` для логирования событий

**Артефакты:**
- `servers.txt` — список серверов для проверки
- `backup_template.sh` — шаблон скрипта
- Логи событий

**Сюжет:**
- Dmitry Orlov: "Мы не можем проверять 50 серверов вручную. Скрипты."
- Задача: скрипт, который проверяет доступность серверов каждые 5 минут
- LILITH: "Автоматизация — это не лень. Это эффективность. Learn the difference."

---

### Episode 03: Text Processing Masters
**Тема:** Обработка текста (grep, awk, sed, pipes)  
**Время:** 3-4ч  
**Миссия:** Анализировать огромные логи для поиска следов Krylov.

**Теория:**
- Pipes и redirects: `|`, `>`, `>>`, `<`, `2>`
- `grep`: поиск паттернов, regex basics
- `awk`: обработка колонок, filtering
- `sed`: замена текста, stream editing
- `cut`, `sort`, `uniq`, `wc`
- `find` и `xargs`

**Практика:**
- Найти в логах (10K+ строк) IP адреса атак
- Извлечь TOP-10 атакующих IP
- Отфильтровать ложные срабатывания
- Создать отчёт для Anna Kovaleva

**Артефакты:**
- `access.log` (100MB+) — логи сервера
- `suspicious_ips.txt` — база известных угроз
- `report_template.txt`

**Сюжет:**
- Anna Kovaleva: "Нас атаковали вчера в 03:47. Найди IP атакующих в логах."
- Лог огромный — нужны grep/awk/sed
- Найдено: 185.220.101.47 (Tor exit node) + 10 других
- LILITH: "Логи не врут. Люди — врут."

---

### Episode 04: Package Management
**Тема:** Управление пакетами (apt, dpkg, snap)  
**Время:** 2-3ч  
**Миссия:** Установить необходимые инструменты для операции.

**Теория:**
- APT: `apt update`, `apt upgrade`, `apt install`
- DPKG: `dpkg -i`, `dpkg -l`, `dpkg -r`
- Snap packages: `snap install`, `snap list`
- Репозитории: `/etc/apt/sources.list`
- PPAs (Personal Package Archives)
- Dependencies hell и как его решить

**Практика:**
- Установить набор инструментов: `nmap`, `tcpdump`, `wireshark`, `docker`
- Создать скрипт `install_toolkit.sh`
- Решить конфликт зависимостей

**Артефакты:**
- `required_tools.txt` — список необходимого ПО
- `install_toolkit.sh` — автоматизация установки
- `sources.list.backup` — бэкап репозиториев

**Сюжет:**
- Viktor: "Тебе нужны инструменты. Вот список."
- Конфликт: `docker` требует `containerd`, но он конфликтует с установленным
- LILITH: "Dependencies как семья. Не выбираешь их, но приходится с ними жить."

**Season 1 Project:**
- `system_setup.sh` — полная автоматизация настройки системы
- Интеграция всех скриптов из Episodes 01-04

---

## SEASON 2: NETWORKING
**Тема:** Сети TCP/IP, DNS, VPN, SSH  
**Время:** 15-18 часов  
**Сложность:** ⭐⭐☆☆☆

### Episode 05: TCP/IP Fundamentals
**Тема:** Основы сетей, модель TCP/IP  
**Время:** 4-5ч  
**Миссия:** Понять, как работают сети, чтобы защитить их.

**Теория:**
- Модель OSI vs TCP/IP
- IP адреса: IPv4, IPv6, subnetting
- MAC адреса, ARP
- TCP vs UDP
- Порты и сокеты
- `ip`, `ifconfig`, `netstat`, `ss`

**Практика:**
- Определить IP адрес сервера Viktor
- Проверить открытые порты: `netstat -tuln`
- Настроить статический IP
- Ping и traceroute для диагностики

**Артефакты:**
- `network_map.txt` — карта сети операции
- Список серверов с IP
- Результаты traceroute к серверу Viktor

**Сюжет:**
- Alex Sokolov: "Krylov прослушивает трафик. Нужно понять сеть."
- Задача: определить маршрут до сервера Viktor (traceroute)
- Обнаружено: 3 промежуточных узла, последний в Москве
- LILITH: "Каждый packet рассказывает историю. Научись слушать."

---

### Episode 06: DNS & Name Resolution
**Тема:** DNS, dig, nslookup, /etc/hosts  
**Время:** 3-4ч  
**Миссия:** Настроить DNS для скрытия инфраструктуры.

**Теория:**
- Как работает DNS
- A, AAAA, CNAME, MX, TXT записи
- `dig`, `nslookup`, `host`
- `/etc/hosts` и `/etc/resolv.conf`
- DNS spoofing и защита

**Практика:**
- Настроить локальный DNS через `/etc/hosts`
- Проверить DNS записи сервера Viktor
- Обнаружить DNS spoofing атаку от Krylov

**Артефакты:**
- `dns_records.txt` — записи серверов операции
- `hosts.backup` — бэкап перед изменениями
- `spoofed_dns.log` — лог атаки

**Сюжет:**
- Anna: "DNS запросы идут не туда. Кто-то подменяет ответы."
- Анализ: DNS cache poisoning от 185.220.101.47
- Решение: настроить DoT (DNS over TLS)

---

### Episode 07: Firewalls (iptables/ufw)
**Тема:** Файрволы для защиты периметра  
**Время:** 4-5ч  
**Миссия:** Защитить серверы от DDoS атаки Krylov.

**Теория:**
- Netfilter и iptables
- Chains: INPUT, OUTPUT, FORWARD
- Правила: ACCEPT, DROP, REJECT
- UFW (Uncomplicated Firewall) — wrapper
- `nftables` — новое поколение

**Практика:**
- Настроить UFW: закрыть все порты кроме SSH (22)
- Создать правила iptables для защиты от DDoS
- Rate limiting: `iptables -m limit`
- Логирование попыток атак

**Артефакты:**
- `firewall_rules.sh` — скрипт настройки
- `attack.log` — лог DDoS атаки (100K+ пакетов)
- `blocked_ips.txt` — автоматически забаненные IP

**Сюжет:**
- INCIDENT: DDoS атака на сервер Viktor — 50K пакетов/сек
- Alex: "Файрвол. Сейчас. У нас 5 минут до падения сервера."
- Решение: rate limiting спасает сервер
- LILITH: "Firewalls как вышибалы. Хорошие знают, кого впускать."

---

### Episode 08: VPN & SSH Tunneling
**Тема:** VPN, SSH туннели, безопасные соединения  
**Время:** 4-5ч  
**Миссия:** Настроить VPN для безопасной коммуникации команды.

**Теория:**
- Что такое VPN, зачем нужен
- OpenVPN vs WireGuard
- SSH tunneling: local, remote, dynamic
- SSH config: `~/.ssh/config`
- SSH keys: `ssh-keygen`, `ssh-copy-id`

**Практика:**
- Настроить OpenVPN сервер
- Создать конфиги для команды (Viktor, Alex, Anna, Dmitry)
- SSH tunnel для доступа к закрытому серверу
- Автоматизировать подключение через скрипт

**Артефакты:**
- `vpn_server.conf` — конфиг OpenVPN
- `client_*.ovpn` — конфиги для клиентов
- `ssh_tunnel.sh` — автоматизация SSH туннеля

**Сюжет:**
- Alex: "Krylov перехватывает трафик. Все коммуникации через VPN. Сейчас."
- Viktor: "У меня есть сервер в Цюрихе. Настрой его как VPN шлюз."
- Результат: Безопасная коммуникация через швейцарский сервер
- LILITH: "Шифрование — это не паранойя. Это здравый смысл."

**Season 2 Project:**
- `secure_network.sh` — полная автоматизация защиты сети
- VPN + Firewall + DNS интеграция

---

## SEASON 3: SYSTEM ADMINISTRATION
**Тема:** Администрирование систем, процессы, логи  
**Время:** 15-18 часов  
**Сложность:** ⭐⭐⭐☆☆

### Episode 09: Users & Permissions
**Тема:** Пользователи, группы, права доступа  
**Время:** 4-5ч  
**Миссия:** Настроить безопасный доступ для команды операции.

**Теория:**
- Users: `useradd`, `usermod`, `userdel`
- Groups: `groupadd`, `usermod -aG`
- Permissions: `chmod`, `chown`, `umask`
- SUID, SGID, Sticky bit
- `sudo` и `/etc/sudoers`
- ACL (Access Control Lists): `setfacl`, `getfacl`

**Практика:**
- Создать учётные записи для команды
- Настроить sudo для Alex (только network команды)
- Ограничить доступ Anna к логам (read-only)
- Настроить ACL для shared папки

**Артефакты:**
- `team_users.sh` — скрипт создания пользователей
- `sudoers.d/alex` — ограниченный sudo
- `permissions_audit.txt` — проверка доступов

**Сюжет:**
- Viktor: "На сервере будут работать 5 человек. Каждому свой уровень доступа."
- Проблема: Alex нужен sudo для networking, но НЕ для всего
- LILITH: "Root access как заряженный пистолет. Не давай его кому попало."

---

### Episode 10: Processes & Systemd
**Тема:** Процессы, сервисы, systemd, cron  
**Время:** 4-5ч  
**Миссия:** Настроить мониторинг процессов и автоматизацию.

**Теория:**
- Процессы: `ps`, `top`, `htop`, `pgrep`, `pkill`
- Signals: `kill -SIGTERM`, `kill -9`, `killall`
- Systemd: `systemctl`, unit files
- Services: `start`, `stop`, `restart`, `enable`, `disable`
- Cron: `crontab -e`, syntax
- Journalctl: `journalctl -u service`

**Практика:**
- Создать systemd service для мониторинга (`monitor.service`)
- Настроить cron для backup каждый час
- Убить зависший процесс (симуляция атаки)
- Анализировать логи через journalctl

**Артефакты:**
- `monitor.service` — systemd unit
- `backup_cron.sh` — скрипт для cron
- `process_attack.log` — лог подозрительного процесса

**Сюжет:**
- Anna: "На сервере запущен подозрительный процесс. PID 6623. Разберись."
- Анализ: процесс `sshd_backdoor` (маскировка под sshd)
- Решение: `kill -9`, проверка systemd services
- LILITH: "Процессы не врут про свой PID. Но врут про имя."

---

### Episode 11: Disk Management & LVM
**Тема:** Управление дисками, LVM, RAID, fstab  
**Время:** 4-5ч  
**Миссия:** Расширить дисковое пространство для логов.

**Теория:**
- Диски: `df -h`, `du -sh`, `lsblk`, `fdisk`
- Partitions: создание, удаление, форматирование
- LVM: Physical Volume, Volume Group, Logical Volume
- `pvcreate`, `vgcreate`, `lvcreate`, `lvextend`
- RAID: типы (0, 1, 5, 10), `mdadm`
- `/etc/fstab`: монтирование при загрузке

**Практика:**
- Добавить новый диск к серверу
- Создать LVM: расширяемый том для `/var/log`
- Настроить автоматическое монтирование в fstab
- (Опционально) Настроить RAID1 для резервирования

**Артефакты:**
- `lvm_setup.sh` — автоматизация LVM
- `fstab.backup` — бэкап перед изменениями
- `disk_usage_report.txt`

**Сюжет:**
- Anna: "Логи заполнили диск. `/var/log` 95%. Нужно больше места. СРОЧНО."
- Viktor: "У нас есть новый диск 500GB. Добавь его через LVM."
- Решение: LVM extend без downtime
- LILITH: "Диски как жизнь. Места всегда мало."

---

### Episode 12: Backup & Recovery
**Тема:** Резервное копирование и восстановление  
**Время:** 3-4ч  
**Миссия:** Спасти данные после атаки Krylov.

**Теория:**
- Стратегии backup: full, incremental, differential
- Инструменты: `rsync`, `tar`, `dd`
- Remote backup: `rsync` через SSH
- Автоматизация: cron + rsync
- Восстановление: как не потерять данные

**Практика:**
- Настроить rsync backup на удалённый сервер
- Создать incremental backup скрипт
- Симуляция: "случайно удалили базу данных" — восстановление
- Тестирование восстановления (disaster recovery)

**Артефакты:**
- `backup.sh` — скрипт резервного копирования
- `restore.sh` — скрипт восстановления
- `backup_log.txt` — история бэкапов

**Сюжет:**
- КАТАСТРОФА: Атака Krylov — сервер скомпрометирован, база данных удалена
- Viktor: "У нас есть backup с вчерашнего дня. Восстанавливай."
- Процесс восстановления через rsync
- LILITH: "Backup'ы как страховка. Надеешься, что не понадобятся, но рад, что есть."

**Season 3 Project:**
- `sysadmin_toolkit.sh` — полная автоматизация администрирования
- Users + Services + Disks + Backup интеграция

---

## SEASON 4: DEVOPS & AUTOMATION
**Тема:** Docker, Kubernetes, CI/CD, Infrastructure as Code  
**Время:** 18-22 часа  
**Сложность:** ⭐⭐⭐⭐☆

### Episode 13: Git & Version Control
**Тема:** Git для инфраструктуры как кода  
**Время:** 4-5ч  
**Миссия:** Организовать репозиторий для конфигов операции.

**Теория:**
- Git basics: `init`, `add`, `commit`, `push`, `pull`
- Branches: `branch`, `checkout`, `merge`
- Workflows: feature branch, GitFlow
- `.gitignore` — что НЕ коммитить (пароли!)
- Git для infrastructure: конфиги, скрипты

**Практика:**
- Создать Git репозиторий для конфигов
- Branching strategy для команды
- Симуляция: конфликт merge и разрешение
- Secrets management: НЕ коммитить пароли

**Артефакты:**
- `configs/` — репозиторий конфигов
- `.gitignore` — правила игнорирования
- `workflow.md` — процесс для команды

**Сюжет:**
- Dmitry Orlov: "Мы не можем управлять конфигами через копирование файлов. Git."
- Проблема: кто-то закоммитил пароль от сервера Viktor в репозиторий
- Решение: `git filter-branch`, secrets в отдельном хранилище
- LILITH: "Version control — это не опция. Это выживание."

---

### Episode 14: Docker Basics
**Тема:** Контейнеризация с Docker  
**Время:** 5-6ч  
**Миссия:** Упаковать инструменты MOONLIGHT в Docker контейнеры.

**Теория:**
- Что такое контейнеры vs VM
- Docker: images, containers, Dockerfile
- Команды: `docker run`, `docker build`, `docker ps`
- Docker Hub: `docker pull`, `docker push`
- Volumes и networking
- Docker Compose для multi-container

**Практика:**
- Создать Dockerfile для `moonlight_decoder` (из MOONLIGHT Season 1)
- Запустить контейнер с Ubuntu + необходимые инструменты
- Docker Compose: web + database + monitoring
- Оптимизация размера образа (multi-stage build)

**Артефакты:**
- `Dockerfile` для инструментов
- `docker-compose.yml` для инфраструктуры
- `container_logs/` — логи контейнеров

**Сюжет:**
- Dmitry: "Нам нужно развернуть инструменты на 50 серверах. Docker решит это."
- Viktor: "Упакуй `crypto_toolkit` (MOONLIGHT S4) в контейнер."
- Результат: Контейнер запускается на любом сервере за 10 секунд
- LILITH: "Контейнеры как тетрис. Либо всё идеально складывается, либо ничего не работает."

---

### Episode 15: CI/CD Pipelines
**Тема:** Автоматизация развёртывания  
**Время:** 5-6ч  
**Миссия:** Настроить CI/CD для автоматических обновлений.

**Теория:**
- Что такое CI/CD
- GitHub Actions / GitLab CI
- Pipeline stages: build, test, deploy
- Автоматизация тестов
- Blue-Green deployment, Canary releases

**Практика:**
- Создать GitHub Actions workflow
- Автоматическое тестирование при commit
- Автодеплой на staging сервер
- Rollback при ошибках

**Артефакты:**
- `.github/workflows/ci.yml` — pipeline
- `deploy.sh` — скрипт развёртывания
- `test_results.xml` — результаты автотестов

**Сюжет:**
- Dmitry: "Мы обновляем код 5 раз в день. Это нужно автоматизировать."
- Проблема: кто-то задеплоил broken code на production
- Решение: CI/CD с тестами — broken code не проходит
- LILITH: "Автоматизация — не про замену людей. Это про освобождение от скучных задач."

---

### Episode 16: Ansible & IaC
**Тема:** Infrastructure as Code с Ansible  
**Время:** 5-6ч  
**Миссия:** Автоматизировать настройку 50 серверов одной командой.

**Теория:**
- Infrastructure as Code концепция
- Ansible: playbooks, roles, inventory
- YAML syntax
- Идемпотентность операций
- Ansible для конфигурации vs Terraform для provisioning

**Практика:**
- Создать Ansible playbook для настройки серверов
- Inventory: список всех серверов операции
- Роли: webserver, database, monitoring
- Запуск playbook на 50 серверах одновременно

**Артефакты:**
- `playbooks/setup_servers.yml` — главный playbook
- `inventory/hosts.ini` — список серверов
- `roles/` — переиспользуемые роли

**Сюжет:**
- Viktor: "Нам нужны ещё 50 серверов. Настроены одинаково. Завтра."
- Dmitry: "Ansible справится за 10 минут."
- Результат: 50 серверов настроены, протестированы, готовы
- LILITH: "Infrastructure as Code — это не магия. Это просто очень хорошая автоматизация."

**Season 4 Project:**
- `devops_pipeline/` — полная CI/CD + IaC инфраструктура
- Git + Docker + GitHub Actions + Ansible интеграция

---

## SEASON 5: SECURITY & PENTESTING
**Тема:** Offensive & Defensive Security  
**Время:** 18-22 часа  
**Сложность:** ⭐⭐⭐⭐⭐

### Episode 17: Security Fundamentals
**Тема:** Основы кибербезопасности, threat modeling  
**Время:** 4-5ч  
**Миссия:** Провести анализ угроз для инфраструктуры.

**Теория:**
- CIA triad: Confidentiality, Integrity, Availability
- Threat modeling: STRIDE, attack trees
- Vectors: network, web, social engineering
- Defense in depth
- Security vs Usability trade-off

**Практика:**
- Threat model для инфраструктуры операции
- Идентифицировать слабые места
- Приоритизация рисков
- План защиты

**Артефакты:**
- `threat_model.md` — модель угроз
- `risk_matrix.csv` — матрица рисков
- `security_plan.md` — план защиты

**Сюжет:**
- Anna Kovaleva: "Krylov умнее, чем мы думали. Нужен threat model."
- Анализ: 15 потенциальных векторов атаки
- Критические: SSH brute-force, SQL injection, social engineering
- LILITH: "Security — это не продукт. Это процесс."

---

### Episode 18: Kali Tools (Nmap, Metasploit)
**Тема:** Offensive security инструменты  
**Время:** 5-6ч  
**Миссия:** Научиться думать как атакующий (Alex Sokolov подход).

**Теория:**
- Установка Kali tools в Ubuntu
- Nmap: сканирование сетей, портов, ОС
- Metasploit Framework: эксплуатация уязвимостей
- Ethical hacking правила
- Bug bounty подход

**Практика:**
- Установить Nmap, Metasploit в Ubuntu
- Просканировать тестовый сервер (свой!)
- Найти открытые порты и сервисы
- Эксплуатировать уязвимость в контролируемой среде

**Артефакты:**
- `install_kali_tools.sh` — установка инструментов
- `nmap_scan_results.xml` — результаты сканирования
- `vulnerabilities.txt` — найденные уязвимости

**Сюжет:**
- Alex Sokolov: "Я знаю, как Krylov атакует. Потому что я сам так делал в ФСБ."
- Задача: просканировать сервер операции как это сделал бы Krylov
- Найдено: открытый порт 8080 (debug interface!), устаревший OpenSSH
- LILITH: "Знай врага. Стань врагом. Потом защищайся от себя."

---

### Episode 19: Web Security (OWASP Top 10)
**Тема:** Безопасность веб-приложений  
**Время:** 5-6ч  
**Миссия:** Защитить веб-интерфейс операции от атак.

**Теория:**
- OWASP Top 10: SQL injection, XSS, CSRF, etc.
- Burp Suite для тестирования
- Web Application Firewall (WAF)
- HTTPS, SSL/TLS сертификаты
- Content Security Policy (CSP)

**Практика:**
- Тестирование веб-интерфейса на SQL injection
- Настройка HTTPS с Let's Encrypt
- Внедрение CSP headers
- Настройка WAF (ModSecurity)

**Артефакты:**
- `web_vulnerabilities.txt` — отчёт тестирования
- `ssl_cert.pem` — SSL сертификат
- `waf_rules.conf` — правила WAF

**Сюжет:**
- ИНЦИДЕНТ: Попытка SQL injection на веб-интерфейс от 185.220.101.47
- Anna: "Кто-то пытается взломать нашу админку. Защити её."
- Решение: WAF блокирует атаки, HTTPS обязателен
- LILITH: "Web apps как швейцарский сыр. Полны дыр. Твоя работа — заделать их."

---

### Episode 20: Incident Response & Forensics
**Тема:** Реагирование на инциденты, форензика  
**Время:** 5-6ч  
**Миссия:** Расследовать APT атаку от "Новой Эры".

**Теория:**
- Incident response процесс: Preparation, Detection, Containment, Eradication, Recovery
- Forensics: сбор доказательств, цепочка custody
- Анализ логов: auth.log, syslog, apache logs
- Memory forensics: Volatility
- Timeline reconstruction

**Практика:**
- Анализ скомпрометированного сервера
- Поиск backdoors: `find / -mtime -7`, `lsof`
- Извлечение вредоносного кода
- Составление timeline атаки
- Отчёт для команды

**Артефакты:**
- `compromised_server.img` — образ диска
- `forensic_report.pdf` — детальный отчёт
- `timeline.csv` — timeline атаки
- `backdoor.c` — найденный бэкдор

**Сюжет:**
- КРИТИЧЕСКИЙ ИНЦИДЕНТ: Сервер Viktor скомпрометирован
- Anna: "APT атака. Они внутри уже 3 дня. Forensics. СЕЙЧАС."
- Находки: backdoor в `/lib/systemd/system/`, rootkit, keylogger
- Вывод: "Новая Эра" использует zero-day exploit
- LILITH: "Forensics как работа детектива. Каждый файл — улика. Каждый timestamp — доказательство."

**Season 5 Project:**
- `security_operations_center/` — SOC инфраструктура
- Мониторинг + Pentesting + Incident Response интеграция

---

## SEASON 6: EMBEDDED LINUX
**Тема:** Embedded системы, IoT, дроны  
**Время:** 15-18 часов  
**Сложность:** ⭐⭐⭐☆☆

### Episode 21: Raspberry Pi & GPIO
**Тема:** Основы embedded Linux  
**Время:** 4-5ч  
**Миссия:** Настроить Raspberry Pi для наблюдения.

**Теория:**
- Что такое embedded Linux
- Raspberry Pi: hardware, GPIO pins
- Cross-compilation
- Device Tree
- Bootloaders: U-Boot

**Практика:**
- Установить Ubuntu на Raspberry Pi
- Подключить камеру и сенсоры через GPIO
- Написать программу на C для чтения GPIO
- Удалённый доступ через SSH

**Артефакты:**
- `gpio_control.c` — программа управления GPIO
- `camera_stream.sh` — стриминг с камеры
- `pi_config.txt` — конфигурация

**Сюжет:**
- Dmitry Orlov: "Нам нужна камера наблюдения. Raspberry Pi + Ubuntu."
- Viktor: "Установи её у здания Krylov. Скрытно."
- Результат: Live stream с камеры, скрытая установка
- LILITH: "Embedded Linux как LEGO для взрослых. Но с проводами."

---

### Episode 22: Drones & UAV Control
**Тема:** Управление беспилотниками  
**Время:** 5-6ч  
**Миссия:** Настроить разведывательный дрон для миссии.

**Теория:**
- UAV (Unmanned Aerial Vehicle) архитектура
- MAVLink протокол
- Автопилоты: ArduPilot, PX4
- Телеметрия: GPS, IMU, барометр
- Computer vision для навигации

**Практика:**
- Установить ArduPilot на Linux board
- Настроить MAVLink коммуникацию
- Написать скрипт для автономного полёта
- Шифрование команд управления (AES из MOONLIGHT S4)

**Артефакты:**
- `drone_control.py` — скрипт управления
- `mission_waypoints.txt` — точки маршрута
- `telemetry_log.csv` — телеметрия полёта

**Сюжет:**
- Viktor: "Нам нужна разведка базы Krylov. Дрон. Завтра."
- Dmitry: "У меня есть квадрокоптер. ArduPilot + шифрование команд."
- Миссия: автономный полёт, фото базы Krylov, возврат
- ОПАСНОСТЬ: Krylov пытается перехватить управление дроном
- Решение: AES шифрование команд (используя `crypto_toolkit` из MOONLIGHT S4)
- LILITH: "Дроны — это весело. Пока кто-то не попытается их угнать."

---

### Episode 23: Industrial Protocols (UART/I2C/SPI)
**Тема:** Протоколы для embedded устройств  
**Время:** 3-4ч  
**Миссия:** Интегрировать сенсоры для мониторинга.

**Теория:**
- UART: serial communication
- I2C: multi-device bus
- SPI: high-speed communication
- Debugging: logic analyzer, oscilloscope

**Практика:**
- Подключить датчики через I2C
- Чтение данных через UART
- Написать драйвер для кастомного устройства

**Артефакты:**
- `i2c_sensor.c` — чтение с I2C датчика
- `uart_logger.c` — логирование через UART
- `device_protocol.md` — документация протокола

**Сюжет:**
- Dmitry: "Нам нужны датчики движения и температуры для безопасности."
- Интеграция: 5 датчиков через I2C bus
- LILITH: "Embedded протоколы как языки. Выучи их, или твои устройства не заговорят."

---

### Episode 24: IoT Integration (MQTT)
**Тема:** IoT экосистема, MQTT протокол  
**Время:** 3-4ч  
**Миссия:** Создать распределённую сеть датчиков.

**Теория:**
- MQTT: publish/subscribe model
- Brokers: Mosquitto
- Topics и QoS levels
- IoT security: TLS, authentication

**Практика:**
- Установить Mosquitto broker
- Подключить Raspberry Pi и датчики через MQTT
- Мониторинг в реальном времени
- Алерты при аномалиях

**Артефакты:**
- `mqtt_publisher.py` — публикация данных
- `mqtt_subscriber.py` — подписка и алерты
- `sensor_dashboard/` — веб-интерфейс

**Сюжет:**
- Anna: "Нам нужен мониторинг 20 точек. Реал-тайм. MQTT."
- Результат: Распределённая сеть датчиков, алерты на Telegram
- LILITH: "IoT — это не 'Internet of Things'. Это 'Internet of Threats'."

**Season 6 Project:**
- `iot_surveillance_system/` — полная система наблюдения
- Raspberry Pi + Drones + Sensors + MQTT интеграция

---

## SEASON 7: ADVANCED TOPICS
**Тема:** Kubernetes, Monitoring, Performance, Hardening  
**Время:** 18-22 часа  
**Сложность:** ⭐⭐⭐⭐⭐

### Episode 25: Kubernetes Basics
**Тема:** Оркестрация контейнеров  
**Время:** 5-6ч  
**Миссия:** Развернуть микросервисную архитектуру для операции.

**Теория:**
- Kubernetes архитектура: master, nodes, pods
- `kubectl` команды
- Deployments, Services, ConfigMaps
- Namespaces и RBAC

**Практика:**
- Установить Kubernetes (minikube или k3s)
- Развернуть приложение в pods
- Настроить LoadBalancer
- Scaling и rolling updates

**Артефакты:**
- `deployment.yaml` — deployment манифест
- `service.yaml` — service конфиг
- `k8s_dashboard/` — мониторинг кластера

**Сюжет:**
- Dmitry: "Нам нужна масштабируемость. 1000 запросов/сек. Kubernetes."
- Viktor: "Развёрнуть инфраструктуру на Kubernetes. У нас 24 часа."
- Результат: Кластер выдерживает нагрузку, auto-scaling работает
- LILITH: "Kubernetes как дирижирование оркестром. Только каждый музыкант — контейнер."

---

### Episode 26: Monitoring (Prometheus/Grafana)
**Тема:** Мониторинг production систем  
**Время:** 5-6ч  
**Миссия:** Настроить мониторинг для раннего обнаружения атак.

**Теория:**
- Prometheus: metrics collection
- Grafana: визуализация
- Exporters: node_exporter, blackbox_exporter
- Alerting: Alertmanager
- SLO, SLI, SLA

**Практика:**
- Установить Prometheus + Grafana
- Настроить мониторинг всех серверов
- Создать dashboard для операции
- Alerts на Telegram при аномалиях

**Артефакты:**
- `prometheus.yml` — конфиг Prometheus
- `grafana_dashboard.json` — дашборд
- `alertmanager.yml` — правила алертов

**Сюжет:**
- Anna: "Krylov атакует ночью. Нам нужны алерты 24/7."
- Результат: Grafana dashboard показывает все системы, алерты в Telegram
- ИНЦИДЕНТ: Alert "CPU spike 90%" — обнаружена атака за 30 секунд
- LILITH: "Не можешь измерить — не можешь управлять. Мониторинг обязателен."

---

### Episode 27: Performance Tuning
**Тема:** Оптимизация производительности  
**Время:** 5-6ч  
**Миссия:** Оптимизировать инфраструктуру под высокую нагрузку.

**Теория:**
- Performance profiling: `perf`, `strace`, `ltrace`
- Bottlenecks: CPU, Memory, Disk I/O, Network
- Kernel tuning: sysctl параметры
- Database optimization: indexes, query plans
- Caching: Redis, Memcached

**Практика:**
- Профилирование приложения с `perf`
- Оптимизация kernel parameters
- Настройка Redis кеша
- Load testing: Apache Bench, wrk

**Артефакты:**
- `perf_report.txt` — отчёт профилирования
- `sysctl_tuning.conf` — оптимизированные параметры
- `load_test_results.csv` — результаты нагрузочного теста

**Сюжет:**
- Viktor: "Нам нужна скорость. 10K requests/sec. Оптимизируй."
- Находки: bottleneck в database queries, медленный DNS
- Решение: Redis кеш + оптимизация запросов → 15K req/sec
- LILITH: "Performance — это не делать больше. Это делать меньше, но быстрее."

---

### Episode 28: Security Hardening
**Тема:** Укрепление безопасности систем  
**Время:** 5-6ч  
**Миссия:** Подготовить инфраструктуру к финальной атаке (Season 8).

**Теория:**
- Security hardening checklist
- SELinux и AppArmor: mandatory access control
- Fail2ban: автоматическая блокировка атак
- Auditd: аудит действий в системе
- CIS Benchmarks

**Практика:**
- Настроить SELinux (enforcing mode)
- Fail2ban для SSH brute-force защиты
- Auditd для логирования всех действий
- Сканирование: Lynis, OpenSCAP

**Артефакты:**
- `selinux_policy/` — кастомные политики SELinux
- `fail2ban_jail.conf` — правила блокировки
- `audit_rules.conf` — правила аудита
- `hardening_report.pdf` — отчёт сканирования

**Сюжет:**
- Anna: "Финальная атака близко. Нужен максимальный уровень защиты."
- Процесс: hardening всех 50 серверов через Ansible
- Тестирование: Alex пытается взломать (red team) — защита держится
- LILITH: "Hardening — это не паранойя. Это подготовка."

**Season 7 Project:**
- `production_infrastructure/` — production-ready инфраструктура
- Kubernetes + Monitoring + Performance + Hardening

---

## SEASON 8: FINAL OPERATION
**Тема:** Финальная операция — защита под атакой  
**Время:** 15-20 часов  
**Сложность:** ⭐⭐⭐⭐⭐

### Episode 29-30: The Siege Begins
**Тема:** Начало финальной атаки  
**Время:** 8-10ч  
**Миссия:** Выстоять под массированной атакой.

**Сюжет:**
- Viktor: "Они идут. 'Новая Эра' + Krylov. Одновременно. Всё сразу."
- DDoS на 100+ Gbps
- Zero-day exploits на веб-приложения
- APT backdoors активируются
- Social engineering атаки на команду

**Задачи:**
- Отражать DDoS в реальном времени
- Патчить zero-day уязвимости
- Находить и удалять backdoors
- Координация команды под стрессом

**Twist:** [Marcus Weber — предатель? Или герой?]

---

### Episode 31: Counterattack
**Тема:** Контратака  
**Время:** 4-5ч  
**Миссия:** Перейти в наступление.

**Сюжет:**
- Alex Sokolov: "Лучшая защита — нападение. Атакуем их инфраструктуру."
- Пентестинг серверов "Новой Эры"
- Отключение их C&C (Command & Control) серверов
- Leak их данных (ethical disclosure)

---

### Episode 32: Final Stand
**Тема:** Финал операции  
**Время:** 4-5ч  
**Миссия:** Последняя битва.

**Сюжет:**
- Krylov последняя попытка: физическое проникновение в ЦОД?
- Команда защищает физический доступ + цифровой
- Финальный твист: [Viktor раскрывает финальный план]
- Результат: Операция успешна, инфраструктура цела

**Эпилог:**
- Viktor: "Хорошая работа. Мы выстояли."
- Anna: "Но это не конец. Новые угрозы уже на горизонте."
- LILITH: "Я буду наблюдать. В тенях. Всегда."

**Season 8 Project:**
- `final_report.pdf` — полный отчёт операции KERNEL SHADOWS
- Все навыки Season 1-8 интегрированы

---

## 📊 Общая статистика

- **Сезонов:** 8
- **Эпизодов:** 32
- **Время:** 120-160 часов
- **Технологий:** 50+
- **Персонажей:** 10
- **Серверов:** 50+
- **Строк кода:** 10,000+

---

## 🎯 Результаты обучения

После прохождения KERNEL SHADOWS вы сможете:

✅ Администрировать Ubuntu Linux системы  
✅ Настраивать сети, VPN, firewalls  
✅ Автоматизировать через Bash, Python, Ansible  
✅ Работать с Docker, Kubernetes  
✅ Проводить пентестинг и hardening  
✅ Настраивать мониторинг production систем  
✅ Оптимизировать performance  
✅ Реагировать на инциденты безопасности  
✅ Работать с embedded Linux и IoT  
✅ Мыслить как системный администратор И как атакующий  

---

<div align="center">

**"Master the kernel. Control the shadows."**

[⬆ Наверх](#kernel-shadows-учебный-план)

</div>

