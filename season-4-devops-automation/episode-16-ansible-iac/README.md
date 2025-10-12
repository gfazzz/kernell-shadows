# EPISODE 16: ANSIBLE & INFRASTRUCTURE AS CODE 🤖🇳🇱🇩🇪

> **"Configuration management is not about managing servers. It's about managing chaos."**
> — Klaus Schmidt, Ansible Architect

---

## 📍 Контекст операции

**День:** 31-32 из 60 (**SEASON 4 FINALE!**)
**Локация:** 🇳🇱 Amsterdam (Tempelhof datacenter) → 🇩🇪 Berlin (final review)
**Время:** 5-6 часов
**Сложность:** ⭐⭐⭐⭐☆

**Предыдущий эпизод:** [Episode 15: CI/CD Pipelines](../episode-15-cicd-pipelines/README.md) (Berlin)
**Следующий эпизод:** Episode 17: Security Auditing (Season 5 premiere — Zürich, Switzerland 🇨🇭)

---

## 🎬 Сюжет

### Переход Episode 15 → Episode 16

**Hans (прощание в Берлине, день 30):**
> *"Макс, Дмитрий — CI/CD pipeline готов. Automatic deployments работают. Rollback проверен. Теперь последний шаг Season 4: configuration management. Klaus Schmidt в Amsterdam ждёт. 50 серверов, одна команда, одна минута. Ansible. Go."*

**День 31: Amsterdam, Tempelhof Datacenter**

**09:00 — Amsterdam Airport Schiphol**

Макс и Дмитрий прилетают в Амстердам. Снова знакомая атмосфера: каналы, велосипеды, Dutch pragmatism. Но на этот раз — не Science Park, а промзона Tempelhof.

**10:00 — Tempelhof Datacenter**

Klaus Schmidt встречает у входа datacenter. Высокий, 50+, седая борода, суровый взгляд системного архитектора, который видел всё.

**Klaus:**
> *"Макс, Дмитрий. Добро пожаловать в Tempelhof. 4000 серверов. 200 компаний. Здесь живёт инфраструктура. Идём."*

(Klaus проводит через security, мимо рядов серверных стоек. Шум вентиляторов, холод кондиционеров, мигание LED индикаторов)

**Klaus (у терминала):**
> *"Ваши 50 серверов. Настроены вручную? Сколько времени?"*

**Дмитрий:**
> *"Один сервер — 30 минут. 50 серверов — 25 часов. Плюс ошибки, несоответствия..."*

**Klaus:**
> *"Именно. Ручная настройка не масштабируется. Процент ошибок: 1 из 10. Одна ошибка в команде → production down. Вот почему у нас Ansible. Смотри."*

(Klaus открывает terminal, показывает один файл: `playbook.yml`)

**Klaus:**
> *"Этот файл: 100 строк YAML. Описывает всю конфигурацию сервера. Пользователи, пакеты, сервисы, файрволлы, всё. Одна команда:"*

```bash
ansible-playbook -i inventory.ini playbook.yml
```

(Нажимает Enter. На экране — прогресс:)

```
PLAY [Configure operation-shadow servers] **********************

TASK [Update packages] *****************************************
ok: [server-01]
ok: [server-02]
...
ok: [server-50]

TASK [Install Docker] ******************************************
changed: [server-01]
changed: [server-02]
...

PLAY RECAP *****************************************************
server-01    : ok=15  changed=8   unreachable=0   failed=0
server-02    : ok=15  changed=8   unreachable=0   failed=0
...
server-50    : ok=15  changed=8   unreachable=0   failed=0
```

**Klaus:**
> *"Готово. 50 серверов настроены. 3 минуты. Идентичная конфигурация. Ноль человеческих ошибок. Это Infrastructure as Code. Это Ansible."*

**Max (impressed):**
> *"Три минуты вместо 25 часов?!"*

**Klaus:**
> *"Ja. А если нужно изменить конфигурацию? Редактируешь YAML, запускаешь снова. Ansible идемпотентен — можешь запустить 100 раз, результат тот же. Никаких дубликатов, никакой коррупции. Это финал DevOps."*

### 11:00 — Ansible Deep Dive

**Klaus's workshop:** Whiteboard, projector, terminal. Ansible architecture diagram нарисован мелом.

**Klaus:**
> *"Философия Ansible:
> 1. **Agentless** — никакой установки на серверах, только SSH
> 2. **Идемпотентность** — запусти 100 раз = тот же результат
> 3. **Декларативность** — описываешь ЧТО, а не КАК
> 4. **Простота** — YAML, читаемый человеком
> 5. **Мощь** — 3000+ модулей
>
> Компоненты:
> - **Inventory** — список серверов (группы, переменные)
> - **Playbook** — YAML файл с задачами
> - **Модули** — apt, copy, service, user, и т.д.
> - **Роли** — переиспользуемые пакеты конфигураций
> - **Шаблоны** — Jinja2 для динамических конфигов
> - **Handlers** — действия при изменениях (перезапуск сервиса)
> - **Vault** — зашифрованные секреты
>
> Сегодня вы изучите всё это. К концу дня вы настроите 50 серверов сами. Одной командой."*

(Klaus открывает документацию, показывает примеры)

### 14:00 — Practice Session

Max и Dmitry работают над Ansible playbooks. Klaus наблюдает, подсказывает. Постепенно создают:
- Inventory файл (50 servers в группах: web, database, cache)
- Базовый playbook (users, packages, firewall)
- Роли (webserver, database, monitoring)
- Templates для конфигов (nginx, PostgreSQL)
- Handlers для рестартов сервисов

Всё работает. Тесты проходят. 50 серверов конфигурируются за 3-4 минуты.

**Klaus:**
> *"Хорошо. Configuration management освоен. Теперь вы можете масштабировать до 500 серверов. Или 5000. Тот же playbook."*

### TWIST (происходит около 16:30, день 31)

**16:00 — Normal operations**

Max запускает финальный playbook. Всё идёт успешно. Tasks выполняются, servers конфигурируются.

**16:30 — НЕОЖИДАННОЕ ОТКРЫТИЕ**

**Ansible вывод (server-27):**

```
TASK [Copy SSL certificates] ***********************************
changed: [server-27]

TASK [Verify certificate validity] *****************************
FAILED: [server-27]
  Certificate expired: 2024-11-15
  Certificate CN: operation-shadow.net
  Issued by: Let's Encrypt
```

**Макс:**
> *"Klaus, server-27 — SSL certificate просрочен?"*

**Klaus (подходит к экрану):**
> *"Просрочен 3 недели назад. Но сервер всё ещё работает. Значит... кто-то вручную обновил. Но не обновил Ansible playbook. Ручной дрифт."*

(Klaus открывает server-27 в браузере)

**Klaus:**
> *"Сертификат валиден до 2026. Обновлён вручную. Кто это сделал?"*

(Проверяет логи server-27)

```bash
ansible server-27 -m shell -a "last | grep root"
```

**Output:**
```
root   pts/0   185.220.101.52   Nov 20 03:42 - 03:55  (00:13)
```

**Klaus (напрягается):**
> *"185.220.101.52... Этот IP знакомый?"*

**Max (внезапно):**
> *"Это Tor exit node! Anna находила этот IP в Episode 14 — backdoor от Krylov!"*

**Klaus:**
> *"Scheisse. Krylov имел root access на server-27 три недели назад. Поменял сертификат. Мы не знаем что ещё он изменил. Вот почему Infrastructure as Code критичен — любое ручное изменение это красный флаг."*

**Дмитрий:**
> *"Что он мог сделать за 13 минут root access?"*

**Klaus:**
> *"Backdoor. Keylogger. Утечку данных. Что угодно. Нужен полный audit. СЕЙЧАС."*

#### Emergency Audit (16:30 - 17:30)

**Tasks (under time pressure):**

**1. Full system audit с Ansible:**

```yaml
# audit.yml
- name: Security Audit - Server 27
  hosts: server-27
  tasks:
    - name: Check for unauthorized users
      shell: awk -F: '$3 >= 1000 {print $1}' /etc/passwd
      register: users

    - name: Check for suspicious cron jobs
      shell: crontab -l
      register: crontab

    - name: Check for unauthorized SSH keys
      shell: cat ~/.ssh/authorized_keys
      register: ssh_keys

    - name: Check for suspicious processes
      shell: ps aux | grep -v grep | grep -E "nc|ncat|socat|reverse"
      register: processes
      ignore_errors: yes

    - name: Check for modified system files
      shell: debsums -c
      register: file_integrity
      ignore_errors: yes

    - name: Generate audit report
      debug:
        msg: |
          Users: {{ users.stdout }}
          Crontab: {{ crontab.stdout }}
          SSH Keys: {{ ssh_keys.stdout }}
          Suspicious Processes: {{ processes.stdout }}
          Modified Files: {{ file_integrity.stdout }}
```

**2. Run audit:**

```bash
ansible-playbook -i inventory.ini audit.yml
```

**3. Результаты (17:00):**

```
TASK [Check for suspicious processes]
ok: [server-27]
  stdout: ""  ← No active backdoor processes

TASK [Check for modified system files]
changed: [server-27]
  stdout: "/usr/bin/openssl: checksum mismatch"  ← MODIFIED!
```

**Klaus:**
> *"OpenSSL binary изменён! Это территория руткитов. Нужно пересобрать этот сервер с нуля. Ansible делает это легко — одна команда."*

**4. Server rebuild (17:00 - 17:30):**

```bash
# 1. Isolate server
ansible server-27 -m shell -a "iptables -A INPUT -j DROP"

# 2. Backup data
ansible server-27 -m shell -a "tar -czf /backup/server-27-$(date +%Y%m%d).tar.gz /var/www"

# 3. Reinstall OS (manual — datacenter KVM)
# Klaus connects to datacenter KVM, reinstalls Ubuntu

# 4. Reconfigure with Ansible
ansible-playbook -i inventory.ini playbook.yml --limit server-27

# 5. Restore data
ansible server-27 -m unarchive -a "src=/backup/server-27-20251031.tar.gz dest=/var/www"

# 6. Verify
ansible server-27 -m shell -a "debsums -c"  # All OK
```

**17:30 — Resolution**

Server-27 восстановлен с нуля за 30 минут (вместо 8+ часов ручного конфигурирования). Ansible playbook гарантирует идентичность конфигурации.

**Klaus:**
> *"Это мощь Infrastructure as Code. Сервер скомпрометирован? Пересборка за 30 минут. Ручная настройка? 8 часов + ошибки. IaC = страховка от хаоса."*

**Макс:**
> *"Но Крылов имел root 3 недели. Что ещё он мог сделать?"*

**Klaus:**
> *"Проверяем все 50 серверов сейчас. Ansible делает это быстро."*

(Klaus запускает full audit на всех серверах — 5 минут вместо 10 часов)

**Results (17:40):**
- **server-27:** Compromised, rebuilt ✓
- **servers 01-26, 28-50:** Clean ✓
- **Total audit time:** 5 minutes (Ansible) vs 10+ hours (manual)

**Klaus:**
> *"Всё чисто кроме server-27. Krylov изолирован на одном сервере. Благодаря Ansible мы нашли и исправили быстро. Ручной audit? Вы бы всё ещё проверяли server 5."*

### Финал Episode 16 + Season 4

**18:00 — Amsterdam Tempelhof, Debriefing**

**Klaus:**
> *"Сегодня вы изучили последний кусочек DevOps пазла:
>
> - **Episode 13 (Git):** Version control — отслеживание каждого изменения
> - **Episode 14 (Docker):** Контейнеризация — портативные окружения
> - **Episode 15 (CI/CD):** Автоматизация — быстрые деплойменты
> - **Episode 16 (Ansible):** Configuration management — единообразные серверы
>
> Вместе = Infrastructure as Code. Всё версионировано, автоматизировано, воспроизводимо. Никакой ручной работы. Никаких человеческих ошибок. Масштабируйтесь от 1 до 1000 серверов. Это современный DevOps."*

**Макс:**
> *"Четыре эпизода назад я настраивал серверы вручную, 30 минут каждый. Сейчас — 50 серверов за 3 минуты."*

**Klaus:**
> *"Именно. Это 50× эффективность. Но запомните сегодня: автоматизация не защищает от атакующих. Krylov обошёл всё с root access. Фокус Season 5: Безопасность. Вы едете в Швейцарию — Цюрих, Cyber Defense Center. Изучать тестирование на проникновение, security auditing, hardening. Потому что быстрая инфраструктура бессмысленна, если не защищена."*

**19:00 — Train to Berlin**

Max и Dmitry возвращаются в Берлин на поезде. Обсуждают Season 4.

**Дмитрий:**
> *"За 8 дней мы прошли путь от Git до Ansible. От ручного администрирования к Infrastructure as Code. Это был интенсивный сезон."*

**Макс:**
> *"И два инцидента: я сломал production в Episode 15, Крылов взломал server-27 в Episode 16. Каждый раз мы учились на ошибках."*

**Дмитрий:**
> *"Это DevOps культура. Fail fast, learn fast, automate recovery. Теперь Season 5 — безопасность. Виктор уже заказал билеты в Цюрих."*

**20:00 — Berlin, Chaos Computer Club**

Встреча с Hans для финального review Season 4.

**Hans:**
> *"Max, Dmitry. Season 4 завершён. Четыре эпизода, четыре навыка:
> 1. Git — мастерство version control
> 2. Docker — эксперт контейнеризации
> 3. CI/CD — автоматизация deployment
> 4. Ansible — configuration management
>
> Вы теперь DevOps-инженеры. Не junior. Не mid. Senior level. Infrastructure as Code течёт в ваших венах. Поздравляю."*

**Макс:**
> *"Спасибо, Hans. И Sophie, и Klaus. За эти 8 дней."*

**Hans:**
> *"Но будьте осторожны. Автоматизация мощная. Но автоматизация без безопасности = катастрофа, которая ждёт своего часа. Krylov показал это. В Season 5 вы изучите безопасность. Потом возвращайтесь. Нам нужна защищённая инфраструктура, а не просто быстрая. Понятно?"*

**Max & Dmitry:**
> *"Understood."*

**Cliffhanger (Season 5 preview):**

**Виктор (видеозвонок, 21:00):**
> *"Макс, Дмитрий. Season 4 завершён. Отличная работа. Инфраструктура автоматизирована. Теперь защищаем её. Завтра вы летите в Цюрих. Встретитесь с Eva Zimmerman — ex-NSA, эксперт по тестированию на проникновение. Она научит вас взламывать вашу собственную инфраструктуру до того, как это сделает Крылов. Это Season 5: Security & Pentesting. 4 недели. Готовьтесь. — Виктор."*

(Экран гаснет. Титры Season 4.)

**TO BE CONTINUED IN SEASON 5...**

---


---

## 🎯 Миссия Episode 16 (SEASON 4 FINALE!)

**Основная задача:** Настроить 50 серверов используя Ansible (Infrastructure as Code). Одна команда, массовая автоматизация, идентичная конфигурация.

**Конкретные задания:**

1. ✅ **Install Ansible** (control node setup)
2. ✅ **Create inventory file** (50 servers, groups: web/db/cache)
3. ✅ **Write basic playbook** (users, packages, firewall)
4. ✅ **Use modules** (apt, copy, service, user, template)
5. ✅ **Create roles** (webserver, database, monitoring — reusable)
6. ✅ **Use templates** (Jinja2 for nginx.conf, postgresql.conf)
7. ✅ **Implement handlers** (restart services on config change)
8. ✅ **Ansible Vault** (encrypt secrets: passwords, API keys)
9. ✅ **TWIST: Certificate audit** — Ansible finds expired cert, security review

**Финальный артефакт:**
- Ansible playbooks для 50 servers
- Roles (reusable configurations)
- Templates (dynamic configs)
- Encrypted secrets (Vault)
- **Season 4 завершён!** 🎉

---

## 🎓 Учебная программа: 7 циклов

**Продолжительность:** 5-6 часов
**Формат:** Interleaving (Сюжет → Теория → Практика → Проверка)

1. **Цикл 1:** Ansible Basics — Оркестр-дирижёр 🎼 (10-15 мин)
2. **Цикл 2:** Inventory & Groups — Адресная книга 📇 (10-15 мин)
3. **Цикл 3:** Playbooks & Modules — Рецепт повара 👨‍🍳 (10-15 мин)
4. **Цикл 4:** Roles — Lego Blueprints 🧱 (10-15 мин)
5. **Цикл 5:** TWIST — Certificate Expired (Security Audit) 🔍 (15-20 мин)
6. **Цикл 6:** Templates & Variables — Mad Libs ✍️ (15-20 мин)
7. **Цикл 7:** Vault & Secrets — Сейф 🔐 (10-15 мин)

---

## ЦИКЛ 1: Ansible Basics — Оркестр-дирижёр 🎼
### (10-15 минут)

### 🎬 Сюжет: Klaus демонстрирует магию

**11:15 — Klaus's workshop**

Klaus открывает терминал. Один файл: `playbook.yml`. Одна команда:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

50 серверов начинают конфигурироваться одновременно. Прогресс-бар летит:

```
TASK [Install nginx] *******************
ok: [server-01]
ok: [server-02]
... (48 more)
ok: [server-50]

PLAY RECAP *****************************
server-50    : ok=12  changed=6   failed=0
Total time: 3m 14s
```

**Klaus:**
> *"3 минуты. 50 серверов. Одна команда. Ansible — это дирижёр оркестра. Дирижёр машет палочкой, 50 музыкантов играют синхронно."*

**LILITH:**
> *"Ansible — это дирижёр для servers. Один дирижёр, 50 музыкантов. Без дирижёра — хаос. С дирижёром — симфония. Configuration management at scale."*

---

### 📚 Теория: Зачем нужен Ansible?

**Проблемы ручной настройки:**

❌ **Time consuming:** 1 server = 30 min. 50 servers = 25 hours
❌ **Error-prone:** Human mistakes (typos, забыл команду)
❌ **Inconsistent:** Server 1 ≠ Server 2 (разные configs)
❌ **Not scalable:** 50 servers сегодня, 500 tomorrow?
❌ **No version control:** Изменения не tracked

**С Ansible:**

✅ **Fast:** 50 servers за 3-5 minutes
✅ **Reliable:** Computers don't typo
✅ **Consistent:** Все servers идентичны
✅ **Scalable:** 50 или 5000 — та же команда
✅ **Version controlled:** YAML в Git

**LILITH:**
> *"Manual configuration — это как печатать книги вручную. Медленно, ошибки. Ansible — это printing press. Fast, accurate, scalable."*

---

### 💡 Метафора: Ansible = Orchestra Conductor

```
🎼 Orchestra

Conductor (Ansible Control Node)
    │
    ├─→ 🎻 Violin section (web servers)
    │       Play: nginx + SSL
    │
    ├─→ 🎺 Brass section (database servers)
    │       Play: PostgreSQL + backups
    │
    ├─→ 🥁 Percussion (cache servers)
    │       Play: Redis + monitoring
    │
    └─→ 🎹 Piano (load balancers)
            Play: HAProxy + health checks

Conductor waves baton → All play together
Ansible runs playbook → All configure together
```

**Without conductor:**
- Each musician plays alone → cacophony
- Each admin configures manually → chaos

**With conductor:**
- Synchronized performance → symphony
- Automated configuration → harmony

**Klaus:**
> *"Conductor doesn't play instrument. Ansible doesn't run commands. Conductor coordinates. Ansible orchestrates."*

---

### 📖 Ansible Architecture

```
┌──────────────────────────────────────────────────┐
│         Control Node (your laptop)               │
│  ┌────────────────────────────────────────────┐  │
│  │  Ansible installed                         │  │
│  │  Playbooks (YAML files)                    │  │
│  │  Inventory (list of servers)               │  │
│  └────────────────────────────────────────────┘  │
└───────────────────┬──────────────────────────────┘
                    │ SSH (agentless!)
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
┌──────────┐  ┌──────────┐  ┌──────────┐
│ Server 1 │  │ Server 2 │  │ Server N │
│ (no agent)│  │ (no agent)│  │ (no agent)│
└──────────┘  └──────────┘  └──────────┘
```

**Key concept: AGENTLESS**

- ❌ Puppet/Chef: Need agent installed on every server
- ✅ Ansible: Only SSH required (servers already have it!)

**Why agentless?**
- ✅ No installation/maintenance on servers
- ✅ No agent updates
- ✅ No "agent died" errors
- ✅ Works on any Linux (SSH standard)

**LILITH:**
> *"Agentless — это красиво. Puppet требует agent на каждом сервере. Ansible использует SSH. SSH уже везде. Don't reinvent the wheel."*

---

### 💻 Практика 1: Install Ansible

```bash
# Control node (your laptop/jumpbox)
# Ubuntu/Debian:
sudo apt update
sudo apt install ansible -y

# Verify
ansible --version

# Create project directory
mkdir ~/ansible-operation-shadow
cd ~/ansible-operation-shadow

# Test connectivity to servers
ansible all -i "server1.example.com," -m ping
# Output: server1.example.com | SUCCESS => { "ping": "pong" }
```

**Klaus:**
> *"Installation done. Now you are conductor. Servers are your orchestra."*

---

### 🤔 Проверка понимания: Цикл 1

**Вопрос 1:** Почему Ansible быстрее чем manual configuration?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Parallel execution.**

Manual (sequential):
```
Server 1 → 30 min
Server 2 → 30 min
...
Server 50 → 30 min
Total: 50 × 30 = 1500 min (25 hours!)
```

Ansible (parallel):
```
All 50 servers AT ONCE → 3-5 min
(limited by slowest server)
```

**Parallelism = speed.**

**Klaus:** *"Diri

жёр не играет с каждым музыкантом по очереди. Все играют одновременно. Ansible то же самое."*

</details>

**Вопрос 2:** Что значит "agentless"?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **No software installation on managed servers.**

**With agent (Puppet/Chef):**
```bash
# On EVERY server:
curl -L install-puppet.sh | bash
puppet agent --enable
systemctl enable puppet-agent
# Repeat 50 times! 😱
```

**Ansible (agentless):**
```bash
# Servers: Nothing! SSH already there ✅
# Control node: ansible-playbook playbook.yml
```

**Requirements:**
- Servers: SSH enabled (default on Linux)
- Control node: Ansible installed

**LILITH:** *"Agent = extra complexity. Agentless = simplicity. KISS principle (Keep It Simple, Stupid)."*

</details>

---

## ЦИКЛ 2: Inventory & Groups — Адресная книга 📇
### (10-15 минут)

### 🎬 Сюжет: Klaus показывает inventory

**11:45 — Organizing servers**

**Klaus:**
> *"50 servers. Как Ansible знает куда подключаться? Inventory file. Это адресная книга."*

(Klaus открывает `inventory.ini`)

```ini
[web]
web-01.example.com
web-02.example.com
web-03.example.com

[database]
db-01.example.com
db-02.example.com

[cache]
cache-01.example.com

[production:children]
web
database
cache
```

**Klaus:**
> *"Groups. Web servers в одной группе. Databases в другой. Можешь настраивать группу целиком. Один playbook, разные роли."*

**LILITH:**
> *"Inventory — это контакты в телефоне. Группы = 'Работа', 'Семья', 'Друзья'. Хочешь позвонить всем коллегам? Выбираешь группу 'Работа'. Ansible то же самое."*

---

### 📚 Теория: Inventory Structure

**Inventory file** = list of servers + groups

**Basic format (INI):**

```ini
# Individual servers
server1.example.com
server2.example.com

# Groups
[webservers]
web1.example.com
web2.example.com

[databases]
db1.example.com
db2.example.com

# Group of groups (meta-group)
[production:children]
webservers
databases

# Variables for group
[webservers:vars]
nginx_port=80
ssl_enabled=true
```

**YAML format (alternative):**

```yaml
all:
  children:
    webservers:
      hosts:
        web1.example.com:
        web2.example.com:
      vars:
        nginx_port: 80
    databases:
      hosts:
        db1.example.com:
```

---

### 💡 Метафора: Inventory = Phone Contacts

```
📇 Phone Contacts (Inventory)

👥 Work (webservers group)
   ├─ Alice (web1.example.com)
   ├─ Bob (web2.example.com)
   └─ Carol (web3.example.com)

👨‍👩‍👧 Family (database servers)
   ├─ Mom (db-primary.com)
   └─ Dad (db-replica.com)

🎮 Friends (cache servers)
   └─ Dave (cache1.example.com)

Want to call all Work contacts?
→ Select "Work" group
→ Group call! 📞

Want to configure all webservers?
→ Select [webservers] group
→ ansible-playbook -i inventory.ini webservers.yml
```

---

### 💻 Практика 2: Create Inventory

```bash
cd ~/ansible-operation-shadow

# Create inventory file
cat > inventory.ini << 'EOF'
[web]
web-01 ansible_host=10.0.1.10
web-02 ansible_host=10.0.1.11
web-03 ansible_host=10.0.1.12

[database]
db-01 ansible_host=10.0.2.10
db-02 ansible_host=10.0.2.11

[cache]
cache-01 ansible_host=10.0.3.10

[production:children]
web
database
cache

[production:vars]
ansible_user=admin
ansible_ssh_private_key_file=~/.ssh/operation-shadow.pem
EOF

# Test inventory
ansible all -i inventory.ini --list-hosts
# Output: Lists all servers

# Ping specific group
ansible web -i inventory.ini -m ping
```

---

### 🤔 Проверка понимания: Цикл 2

**Вопрос 1:** Зачем groups в inventory?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Target specific server types.**

Without groups:
```bash
ansible server1,server2,server3 ...  # Manual list, tedious!
```

With groups:
```bash
ansible webservers ...  # All web servers automatically!
```

**Use cases:**
- Deploy nginx только на web servers
- Backup только databases
- Restart только cache servers

**Different configs for different roles.**

**Klaus:** *"Groups — это classification. Web servers нужен nginx. Database servers нужен PostgreSQL. Groups позволяют разделить."*

</details>

**Вопрос 2:** Что такое `:children`?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Group of groups (meta-group).**

```ini
[web]
web1
web2

[database]
db1

[production:children]  # Meta-group
web
database

# Now "production" includes: web1, web2, db1
```

**Use case:**
```bash
# Configure ALL production servers
ansible production -m setup

# vs individual groups
ansible web -m setup
ansible database -m setup
```

**LILITH:** *"`:children` — это папка содержащая другие папки. 'Production' папка содержит 'Web' и 'Database' подпапки."*

</details>

---

## ЦИКЛ 3: Playbooks & Modules — Рецепт повара 👨‍🍳
### (10-15 минут)

### 🎬 Сюжет: Klaus's First Playbook

**12:15 — Writing automation**

**Klaus:**
> *"Inventory — это ГДЕ. Playbook — это ЧТО делать. Playbook как рецепт повара."*

(Klaus создаёт простой playbook)

```yaml
---
- name: Configure web servers
  hosts: web
  become: yes
  
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
    
    - name: Start nginx
      service:
        name: nginx
        state: started
        enabled: yes
```

```bash
ansible-playbook -i inventory.ini webserver.yml
```

**3 web servers** конфигурируются одновременно. Nginx установлен, запущен, enabled.

**Klaus:**
> *"Playbook = recipe. 'Install nginx, start nginx'. Modules = ingredients. `apt` module = package manager. `service` module = systemctl wrapper. 3000+ modules available."*

**LILITH:**
> *"Playbook — это рецепт. Modules — ингредиенты. Chef (ты) пишешь рецепт. Ansible (кухонный робот) готовит. Servers (обеды) получаются идентичными."*

---

### 📚 Теория: Playbook Syntax

**Playbook structure:**

```yaml
---  # YAML start
- name: Playbook description
  hosts: target_group  # From inventory
  become: yes  # Run as root (sudo)
  
  vars:  # Variables
    nginx_port: 80
  
  tasks:  # List of tasks
    - name: Task description
      module_name:  # Ansible module
        parameter1: value1
        parameter2: value2
    
    - name: Another task
      another_module:
        param: value
```

**Key components:**

1. **hosts:** Which servers (from inventory)
2. **become:** Run as superuser (sudo)
3. **vars:** Variables
4. **tasks:** List of actions
5. **modules:** Built-in Ansible functions

---

### 💡 Метафора: Playbook = Recipe

```
👨‍🍳 Cooking Recipe (Playbook)

Recipe: Chocolate Cake
Serves: 50 people (50 servers)

Ingredients (Modules):
├─ Flour (apt module)
├─ Eggs (copy module)
├─ Sugar (service module)
└─ Chocolate (template module)

Instructions (Tasks):
1. Mix flour and eggs (install packages)
2. Add sugar (configure files)
3. Bake at 350°F (start services)
4. Cool down (enable on boot)

Result: 50 identical cakes (50 configured servers)
```

**Chef (you):** Writes recipe
**Kitchen robot (Ansible):** Executes recipe
**Diners (users):** Enjoy consistent meals

---

### 📖 Popular Modules

**Package management:**
```yaml
- name: Install package
  apt:  # Debian/Ubuntu
    name: nginx
    state: present

- name: Remove package
  yum:  # RedHat/CentOS
    name: httpd
    state: absent
```

**File operations:**
```yaml
- name: Copy file
  copy:
    src: /local/file.txt
    dest: /remote/file.txt
    mode: '0644'

- name: Create directory
  file:
    path: /opt/app
    state: directory
    owner: www-data
```

**Service management:**
```yaml
- name: Start service
  service:
    name: nginx
    state: started
    enabled: yes  # Start on boot
```

**Command execution:**
```yaml
- name: Run command
  command: /usr/bin/custom-script.sh
  
- name: Run shell command
  shell: echo "Hello" > /tmp/file.txt
```

---

### 💻 Практика 3: First Playbook

```yaml
# webserver.yml
---
- name: Configure web servers
  hosts: web
  become: yes
  
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
    
    - name: Install nginx
      apt:
        name: nginx
        state: present
    
    - name: Copy index.html
      copy:
        content: |
          <html>
            <body>
              <h1>Operation Shadow - Web Server</h1>
              <p>Configured by Ansible</p>
            </body>
          </html>
        dest: /var/www/html/index.html
    
    - name: Start nginx
      service:
        name: nginx
        state: started
        enabled: yes
```

```bash
# Run playbook
ansible-playbook -i inventory.ini webserver.yml

# Check result
curl http://web-01
```

---

### 🤔 Проверка понимания: Цикл 3

**Вопрос 1:** В чём разница между playbook и module?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:**

**Playbook** = Recipe (full instructions)
**Module** = Ingredient/Tool (one specific action)

```yaml
# Playbook (recipe)
- name: Bake cake
  tasks:
    - name: Mix ingredients  ← Module (apt)
    - name: Bake             ← Module (service)
    - name: Decorate         ← Module (template)
```

**Playbook** = YAML file with many tasks
**Module** = One task (apt, copy, service, etc.)

**Klaus:** *"Playbook orchestrates. Modules execute."*

</details>

**Вопрос 2:** Зачем `become: yes`?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Run as superuser (sudo).**

```yaml
# Without become
- name: Install nginx
  apt:
    name: nginx
  # ❌ FAIL: Permission denied (normal user can't install packages)

# With become
- name: Install nginx
  become: yes  # Run as root
  apt:
    name: nginx
  # ✅ SUCCESS: root can install packages
```

**become** = `sudo` prefix

**LILITH:** *"`become: yes` — это Ansible говорит 'I need admin права'. Как `sudo` перед командой."*

</details>

---

## ЦИКЛ 4: Roles — Lego Blueprints 🧱
### (10-15 минут)

### 🎬 Сюжет: Klaus показывает переиспользование

**13:00 — Reusable configurations**

**Klaus:**
> *"50 web servers. Все одинаковые. Зачем писать playbook 50 раз? Roles. Lego blueprints. Создал роль 'webserver' — используешь везде."*

(Klaus показывает структуру ролей)

```
roles/
├── webserver/
│   ├── tasks/main.yml      # What to do
│   ├── handlers/main.yml   # Restart services
│   ├── templates/nginx.j2  # Config templates
│   └── defaults/main.yml   # Default variables
└── database/
    ├── tasks/main.yml
    └── templates/postgresql.conf.j2
```

**Klaus:**
> *"Role = reusable package. Web servers нужна роль 'webserver'. Database servers — роль 'database'. DRY principle."*

**LILITH:**
> *"Roles — это Lego blueprints. Создал blueprint для башни — можешь построить 100 башен. Не переписывай каждый раз. Ansible roles = code reusability."*

---

### 📚 Теория: Ansible Roles

**Role structure:**

```
roles/webserver/
├── tasks/
│   └── main.yml        # Tasks (install, configure, start)
├── handlers/
│   └── main.yml        # Handlers (restart on change)
├── templates/
│   └── nginx.conf.j2   # Jinja2 templates
├── files/
│   └── index.html      # Static files
├── vars/
│   └── main.yml        # Variables
├── defaults/
│   └── main.yml        # Default variables
└── meta/
    └── main.yml        # Role metadata
```

**Using roles in playbook:**

```yaml
---
- name: Configure all servers
  hosts: all
  roles:
    - common          # Everyone gets this
    
- name: Configure web servers
  hosts: web
  roles:
    - webserver       # Only web servers

- name: Configure databases
  hosts: database
  roles:
    - database        # Only db servers
```

---

### 💡 "Aha!" момент: Idempotence

**Idempotence** = running multiple times = same result

```bash
# Run playbook first time
ansible-playbook playbook.yml
# Output: changed=10 (10 tasks modified something)

# Run again immediately
ansible-playbook playbook.yml
# Output: changed=0 (nothing to change, already correct!)
```

**Why?**

Modules check current state:
```yaml
- name: Install nginx
  apt:
    name: nginx
    state: present

# First run: nginx not installed → INSTALL (changed)
# Second run: nginx already installed → SKIP (ok)
```

**LILITH:**
> *"Idempotence — это как выключатель света. Нажал 'включить' 10 раз — свет включён (не 10 раз ярче!). Ansible проверяет состояние. Уже правильно? Ничего не делает."*

---

### 💻 Практика 4: Create Role

```bash
# Create role structure
ansible-galaxy init roles/webserver

# Edit roles/webserver/tasks/main.yml
cat > roles/webserver/tasks/main.yml << 'EOF'
---
- name: Install nginx
  apt:
    name: nginx
    state: present

- name: Copy config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: restart nginx  # Trigger handler

- name: Start nginx
  service:
    name: nginx
    state: started
    enabled: yes
EOF

# Create handler
cat > roles/webserver/handlers/main.yml << 'EOF'
---
- name: restart nginx
  service:
    name: nginx
    state: restarted
EOF

# Use role in playbook
cat > site.yml << 'EOF'
---
- name: Configure infrastructure
  hosts: web
  roles:
    - webserver
EOF

# Run
ansible-playbook -i inventory.ini site.yml
```

---

### 🤔 Проверка понимания: Цикл 4

**Вопрос 1:** Что произойдёт если запустить playbook 2 раза?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Second run: changed=0 (idempotence)**

```bash
# First run
ansible-playbook playbook.yml
PLAY RECAP:
server-01  ok=10  changed=10  failed=0  # 10 changes made

# Second run (immediately)
ansible-playbook playbook.yml
PLAY RECAP:
server-01  ok=10  changed=0  failed=0  # 0 changes (already correct!)
```

**Ansible checks state:**
- nginx already installed? → skip install
- config already correct? → skip copy
- service already running? → skip start

**Safe to run repeatedly!**

**Klaus:** *"Idempotence = safety. Can run 100 times. Won't break anything."*

</details>

**Вопрос 2:** Зачем использовать roles вместо playbooks?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Reusability + Organization.**

**Without roles (playbook):**
```yaml
# webserver1.yml
- tasks:
    - install nginx
    - configure nginx
    - start nginx

# webserver2.yml
- tasks:
    - install nginx  # DUPLICATE CODE!
    - configure nginx
    - start nginx
```

**With roles:**
```yaml
# roles/webserver/tasks/main.yml (once)
- install nginx
- configure nginx
- start nginx

# Use everywhere
- hosts: web1
  roles: [webserver]
- hosts: web2
  roles: [webserver]
```

**DRY: Don't Repeat Yourself!**

**LILITH:** *"Roles — это functions в programming. Написал функцию — вызываешь многократно. Don't copy-paste код."*

</details>

---

## ЦИКЛ 5: TWIST — Certificate Expired (Security Audit) 🔍
### (15-20 минут)

### 🎬 Сюжет: Unexpected Discovery

**16:30 — During playbook execution**

Max запускает финальный playbook. Всё идёт гладко. Tasks зелёные.

**Suddenly:**

```
TASK [Copy SSL certificates] ***********************************
changed: [server-27]

TASK [Verify certificate validity] *****************************
FAILED: [server-27]
  Certificate expired: 2024-11-15
  Certificate CN: operation-shadow.net
  Issued by: Let's Encrypt
  Days expired: 362 days
```

**Max (confused):**
> *"Certificate expired?! Год назад?!"*

**Klaus (проверяет):**
> *"Server-27... это production load balancer. Expired certificate год назад. Как это никто не заметил?!"*

**Dmitry (проверяет остальные):**
> *"Проверяю другие серверы... Server-31 тоже expired. Server-42 expires через 3 дня!"*

**Klaus (серьёзно):**
> *"Audit time. Ansible нашёл то, что monitoring пропустил. Проверим всё."*

---

### 📚 Теория: Ansible as Audit Tool

**Ansible не только для configuration. Также для AUDIT:**

```yaml
# Certificate audit playbook
- name: Audit SSL certificates
  hosts: all
  tasks:
    - name: Find all certificates
      find:
        paths: /etc/ssl/certs
        patterns: "*.crt"
      register: certs
    
    - name: Check expiration
      command: >
        openssl x509 -in {{ item.path }}
        -noout -enddate
      loop: "{{ certs.files }}"
      register: cert_expiry
    
    - name: Report expired
      debug:
        msg: "{{ item.item.path }} expires {{ item.stdout }}"
      loop: "{{ cert_expiry.results }}"
      when: "'EXPIRED' in item.stdout or days_until_expiry < 30"
```

**Klaus runs audit:**

```bash
ansible-playbook -i inventory.ini cert-audit.yml

# Output:
# server-27: ❌ Expired 362 days ago
# server-31: ❌ Expired 180 days ago
# server-42: ⚠️  Expires in 3 days
# server-15: ⚠️  Expires in 15 days
# (46 servers: ✅ Valid)
```

---

### 💡 Security Discovery

**Emergency response:**

1. **Identify scope** (4 servers affected)
2. **Generate new certificates** (Let's Encrypt)
3. **Deploy via Ansible** (automated!)
4. **Update monitoring** (add cert expiry checks)

**16:45 - 17:15 — Emergency Fix**

```yaml
# emergency-cert-renewal.yml
- name: Emergency certificate renewal
  hosts: expired_certs
  become: yes
  tasks:
    - name: Install certbot
      apt:
        name: certbot
        state: present
    
    - name: Renew certificates
      command: >
        certbot renew --force-renewal
        --non-interactive
        --agree-tos
        --email admin@operation-shadow.net
    
    - name: Restart nginx
      service:
        name: nginx
        state: restarted
```

```bash
ansible-playbook emergency-cert-renewal.yml
# 4 servers renewed, 30 seconds
```

**17:15 — Resolution**

**Klaus:**
> *"4 servers fixed. Certificates renewed. Valid for 90 days. Это урок: Ansible не только автоматизация. Также discovery. Нашёл проблемы, которые monitoring пропустил."*

**Anna (видеозвонок, forensics):**
> *"Certificate expired год назад, но HTTPS всё ещё работал? Проверьте load balancer. Возможно, кэшированный cert или fallback. Investigating..."*

**(Анна проверяет, обнаруживает: load balancer использовал старый cached cert + ошибка в monitoring config — cert expiry checks были disabled после migration)**

**Anna:**
> *"Found it. Monitoring cert checks disabled during migration 18 months ago. Never re-enabled. Added to post-incident checklist."*

---

### 🤔 Проверка понимания: Цикл 5

**Вопрос 1:** Как Ansible нашёл expired certificates?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Automated audit playbook.**

```yaml
# Audit task checks ALL servers
- name: Verify certificate validity
  command: openssl x509 -in /etc/ssl/cert.pem -noout -checkend 0
  register: cert_check
  failed_when: cert_check.rc != 0
```

**Manual audit:**
- SSH to 50 servers individually
- Run `openssl x509` command
- Check dates manually
- 2-3 hours work

**Ansible audit:**
- One playbook
- All servers checked in parallel
- 2 minutes

**LILITH:** *"Ansible = automated inspector. Checks все серверы, finds inconsistencies. Humans make mistakes. Automation doesn't."*

</details>

**Вопрос 2:** Почему monitoring пропустил expired cert?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **Cert expiry checks were disabled.**

**Root cause:**
- Migration 18 months ago
- Cert monitoring temporarily disabled
- Never re-enabled
- Fell through cracks

**Prevention:**
1. **Checklist:** Post-migration verification
2. **Automation:** Ansible checks certs on every run
3. **Redundancy:** Multiple monitoring layers

**LILITH:** *"Single point of failure. Monitoring disabled = blind spot. Always have backup checks. Defense in depth."*

</details>

---

## ЦИКЛ 6: Templates & Variables — Mad Libs ✍️
### (15-20 минут)

### 🎬 Сюжет: Dynamic Configurations

**17:45 — After cert fix**

**Klaus:**
> *"Certificates fixed. Теперь dynamic configs. 50 servers, разные настройки. Templates. Jinja2. Как Mad Libs."*

(Klaus показывает шаблон nginx config)

```jinja2
# templates/nginx.conf.j2
server {
    listen {{ nginx_port }};
    server_name {{ server_name }};
    
    ssl_certificate {{ ssl_cert_path }};
    ssl_certificate_key {{ ssl_key_path }};
    
    {% if enable_ssl %}
    listen 443 ssl;
    {% endif %}
    
    location / {
        proxy_pass http://{{ backend_host }}:{{ backend_port }};
    }
}
```

**Klaus:**
> *"Шаблон. Variables в двойных скобках. Ansible заполняет. Каждый сервер получает свою версию."*

**LILITH:**
> *"Templates — это Mad Libs. 'My name is ___'. Fill in blank. Jinja2 template: 'server_name is {{ server_name }}'. Ansible fills in."*

---

### 📚 Теория: Jinja2 Templates

**Template syntax:**

```jinja2
{# Comment #}

{{ variable }}  # Variable substitution

{% if condition %}
  # Conditional block
{% endif %}

{% for item in list %}
  # Loop
{% endfor %}
```

**Example:**

```jinja2
# app.conf.j2
[app]
name = {{ app_name }}
port = {{ app_port }}
debug = {{ debug_mode | default('false') }}

{% if enable_ssl %}
ssl_cert = /etc/ssl/{{ app_name }}.crt
{% endif %}

{% for host in backend_servers %}
backend = {{ host }}
{% endfor %}
```

**Variables from:**
- Inventory (`ansible_host`, group_vars)
- Playbook (`vars:` section)
- Role defaults (`defaults/main.yml`)
- Command line (`-e "var=value"`)

---

### 💻 Практика 6: Use Templates

```yaml
# playbook with template
- name: Configure nginx
  hosts: web
  vars:
    nginx_port: 80
    server_name: "{{ inventory_hostname }}"
    backend_host: "app.internal"
    backend_port: 8080
  
  tasks:
    - name: Deploy nginx config
      template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/sites-available/default
      notify: reload nginx
  
  handlers:
    - name: reload nginx
      service:
        name: nginx
        state: reloaded
```

```bash
ansible-playbook -i inventory.ini nginx-config.yml
```

**Result:** Each server gets customized config!

---

### 🤔 Проверка понимания: Цикл 6

**Вопрос 1:** В чём разница между `copy` и `template` module?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:**

**copy:** Static file (exact copy)
```yaml
- copy:
    src: file.txt
    dest: /remote/file.txt
# Same file on all servers
```

**template:** Dynamic file (variables replaced)
```yaml
- template:
    src: app.conf.j2
    dest: /etc/app.conf
# Different file per server (variables filled in)
```

**Klaus:** *"`copy` = photocopy (exact). `template` = Mad Libs (fill blanks)."*

</details>

---

## ЦИКЛ 7: Vault & Secrets — Сейф 🔐
### (10-15 минут)

### 🎬 Сюжет: Encrypting Secrets

**18:15 — Security best practice**

**Klaus:**
> *"Playbooks в Git. Но passwords тоже в Git? НЕТ! Ansible Vault. Шифрование."*

(Klaus создаёт зашифрованный файл)

```bash
ansible-vault create secrets.yml
# Enter password: ********

# Edit encrypted file
cat > secrets.yml << EOF
database_password: SuperSecret123
api_key: abc123xyz789
ssl_private_key: |
  -----BEGIN PRIVATE KEY-----
  ...
  -----END PRIVATE KEY-----
EOF
```

**Klaus:**
> *"Теперь зашифрован. Можешь коммитить в Git. Decrypt только с паролем."*

**LILITH:**
> *"Vault — это сейф. Secrets внутри сейфа. Код в Git (public). Сейф в Git (encrypted). Только ты знаешь комбинацию (vault password)."*

---

### 📚 Теория: Ansible Vault

**Operations:**

```bash
# Create encrypted file
ansible-vault create secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Encrypt existing file
ansible-vault encrypt passwords.txt

# Decrypt file
ansible-vault decrypt secrets.yml

# View encrypted file
ansible-vault view secrets.yml

# Change vault password
ansible-vault rekey secrets.yml
```

**Using vault in playbook:**

```bash
# Prompt for password
ansible-playbook --ask-vault-pass playbook.yml

# Password from file
ansible-playbook --vault-password-file ~/.vault_pass playbook.yml
```

---

### 💻 Практика 7: Encrypt Secrets

```bash
# Create vault
ansible-vault create group_vars/all/vault.yml

# Add secrets
database_password: secret123
api_token: xyz789

# Use in playbook
- name: Configure database
  hosts: database
  vars_files:
    - group_vars/all/vault.yml
  tasks:
    - name: Create database user
      postgresql_user:
        name: app_user
        password: "{{ database_password }}"  # From vault!
```

---

### 🤔 Проверка понимания: Цикл 7

**Вопрос 1:** Можно ли коммитить vault файл в Git?

<details>
<summary>Думай перед проверкой</summary>

**Ответ:** **ДА! Он зашифрован.**

```bash
# Encrypted vault file (safe to commit)
$ANSIBLE_VAULT;1.1;AES256
61363966386662356537653...
# Gibberish without password

# Git
git add secrets.yml  # ✅ Safe! Encrypted
git commit -m "Add encrypted secrets"
git push  # ✅ Safe! Cannot be read without password
```

**Password НЕ в Git!** Store separately (password manager, environment variable).

**LILITH:** *"Зашифрованный сейф можешь положить где угодно. Без ключа — бесполезен."*

</details>

---

## 📁 Структура файлов

```
episode-16-ansible-iac/
├── README.md                  # Теория + micro-cycles
├── artifacts/
│   └── README.md
│
├── starter/                   # 🎯 НАЧНИ ЗДЕСЬ!
│   ├── inventory.ini          # 50 servers inventory
│   ├── playbooks/
│   │   ├── site.yml           # Main playbook
│   │   └── cert-audit.yml     # Certificate audit
│   ├── roles/
│   │   ├── common/
│   │   ├── webserver/
│   │   ├── database/
│   │   └── monitoring/
│   ├── group_vars/
│   │   └── all/
│   │       └── vars.yml
│   ├── templates/
│   └── README.md
│
├── solution/                  # Референсное решение
└── tests/
    └── test.sh
```

---

## 💬 Цитаты Episode 16

**Klaus Schmidt:**
> "Configuration management is not about managing servers. It's about managing chaos."

> "Ansible — это дирижёр оркестра. Один дирижёр, 50 музыкантов. Без дирижёра — хаос."

> "Idempotence = safety. Can run 100 times. Won't break anything."

**LILITH:**
> "Ansible — это дирижёр для servers. Один дирижёр, 50 музыкантов. Без дирижёра — хаос. С дирижёром — симфония."

> "Agentless — это красиво. Puppet требует agent. Ansible использует SSH. SSH уже везде."

> "Playbook — это рецепт. Modules — ингредиенты. Ansible — кухонный робот. Servers — готовые обеды."

---

## 🎓 Что вы узнали

После Episode 16 вы умеете:

✅ Устанавливать Ansible (control node)
✅ Создавать inventory (groups, variables)
✅ Писать playbooks (tasks, modules)
✅ Использовать roles (reusable configs)
✅ Templates (Jinja2 for dynamic configs)
✅ Handlers (restart services on change)
✅ Ansible Vault (encrypt secrets)
✅ Audit infrastructure (certificate checks, compliance)
✅ **SEASON 4 COMPLETE!** 🎉

**Key concepts:**
- **Agentless:** SSH only, no agent installation
- **Idempotent:** Safe to run multiple times
- **Declarative:** Describe WHAT, not HOW
- **Roles:** Reusable configurations
- **Vault:** Encrypted secrets

---

## 🏆 SEASON 4 FINALE — Итоги

**Episodes completed:**
- Episode 13: Git & Version Control ✅
- Episode 14: Docker Basics ✅
- Episode 15: CI/CD Pipelines ✅
- Episode 16: Ansible & IaC ✅

**Skills mastered:**
- Version control (Git)
- Containerization (Docker)
- Continuous Deployment (GitHub Actions)
- Configuration Management (Ansible)

**DevOps journey:** Complete! 🚀

**Viktor (final video call, day 32):**
> *"Max, Dmitry. Season 4 complete. Git, Docker, CI/CD, Ansible — вся automation готова. 50 servers управляются одной командой. Infrastructure as Code работает. Следующий этап: Security. Season 5. Zürich, Switzerland. Penetration testing, security audits, hardening. See you there."*

---

## 🚀 Следующий шаг

**SEASON 5 PREMIERE — Episode 17: Security Auditing**
**Location:** 🇨🇭 Zürich, Switzerland
**Focus:** Penetration testing, security hardening, compliance

**Eva Zimmerman (new character, security expert):**
> *"You built the infrastructure. Now we break it. Pentesting. Vulnerability scanning. Hardening. See you in Zürich. — Eva"*

---

<div align="center">

**🎬 SEASON 4: DEVOPS AUTOMATION — COMPLETE! 🎉**

*"Configuration management is not about managing servers. It's about managing chaos."*

🇩🇪 Berlin → 🇳🇱 Amsterdam • 4 Episodes • Klaus Schmidt • Ansible Architecture

**SEASON 4 FINALE!**

[⬅️ Episode 15: CI/CD](../episode-15-cicd-pipelines/README.md) | [⬆️ Season 4 Overview](../README.md) | [➡️ Season 5 Premiere](../../season-5-security/)

</div>

