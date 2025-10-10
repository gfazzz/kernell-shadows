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
> *"Max, Dmitry — CI/CD pipeline готов. Automatic deployments работают. Rollback проверен. Теперь последний шаг Season 4: configuration management. Klaus Schmidt в Amsterdam ждёт. 50 серверов, одна команда, одна минута. Ansible. Go."*

**День 31: Amsterdam, Tempelhof Datacenter**

**09:00 — Amsterdam Airport Schiphol**

Max и Dmitry прилетают в Амстердам. Снова знакомая атмосфера: каналы, велосипеды, Dutch pragmatism. Но на этот раз — не Science Park, а промзона Tempelhof.

**10:00 — Tempelhof Datacenter**

Klaus Schmidt встречает у входа datacenter. Высокий, 50+, седая борода, суровый взгляд системного архитектора, который видел всё.

**Klaus:**
> *"Max, Dmitry. Добро пожаловать в Tempelhof. 4000 серверов. 200 компаний. Здесь живёт инфраструктура. Идём."*

(Klaus проводит через security, мимо рядов серверных стоек. Шум вентиляторов, холод кондиционеров, мигание LED индикаторов)

**Klaus (у терминала):**
> *"Ваши 50 серверов. Настроены вручную? Сколько времени?"*

**Dmitry:**
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

**Max:**
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

**Dmitry:**
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

**Max:**
> *"Но Krylov имел root 3 недели. Что ещё он мог сделать?"*

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

**Max:**
> *"Четыре эпизода назад я настраивал серверы вручную, 30 минут каждый. Сейчас — 50 серверов за 3 минуты."*

**Klaus:**
> *"Именно. Это 50× эффективность. Но запомните сегодня: автоматизация не защищает от атакующих. Krylov обошёл всё с root access. Фокус Season 5: Безопасность. Вы едете в Швейцарию — Цюрих, Cyber Defense Center. Изучать тестирование на проникновение, security auditing, hardening. Потому что быстрая инфраструктура бессмысленна, если не защищена."*

**19:00 — Train to Berlin**

Max и Dmitry возвращаются в Берлин на поезде. Обсуждают Season 4.

**Dmitry:**
> *"За 8 дней мы прошли путь от Git до Ansible. От ручного администрирования к Infrastructure as Code. Это был интенсивный сезон."*

**Max:**
> *"И два инцидента: я сломал production в Episode 15, Krylov взломал server-27 в Episode 16. Каждый раз мы учились на ошибках."*

**Dmitry:**
> *"Это DevOps культура. Fail fast, learn fast, automate recovery. Теперь Season 5 — безопасность. Viktor уже заказал билеты в Цюрих."*

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

**Max:**
> *"Спасибо, Hans. И Sophie, и Klaus. За эти 8 дней."*

**Hans:**
> *"Но будьте осторожны. Автоматизация мощная. Но автоматизация без безопасности = катастрофа, которая ждёт своего часа. Krylov показал это. В Season 5 вы изучите безопасность. Потом возвращайтесь. Нам нужна защищённая инфраструктура, а не просто быстрая. Понятно?"*

**Max & Dmitry:**
> *"Understood."*

**Cliffhanger (Season 5 preview):**

**Viktor (видеозвонок, 21:00):**
> *"Max, Dmitry. Season 4 завершён. Отличная работа. Инфраструктура автоматизирована. Теперь защищаем её. Завтра вы летите в Цюрих. Встретитесь с Eva Zimmerman — ex-NSA, эксперт по тестированию на проникновение. Она научит вас взламывать вашу собственную инфраструктуру до того, как это сделает Krylov. Это Season 5: Security & Pentesting. 4 недели. Готовьтесь. — Viktor."*

(Экран гаснет. Титры Season 4.)

**TO BE CONTINUED IN SEASON 5...**

---

## 🎯 Миссия Episode 16

**Основная задача:** Настроить Ansible для автоматизированного configuration management 50 серверов.

**Конкретные задания:**

1. ✅ **Install Ansible** (apt, verify version)
2. ✅ **Create inventory file** (50 servers в группах)
3. ✅ **Write basic playbook** (update packages, install Docker)
4. ✅ **Create roles** (webserver, database, monitoring)
5. ✅ **Use variables** (environment-specific configs)
6. ✅ **Templates with Jinja2** (nginx.conf, postgresql.conf)
7. ✅ **Handlers** (restart services on config change)
8. ✅ **Ansible Vault** (encrypted secrets)
9. ✅ **Security audit playbook** (detect compromised servers)

**Финальный артефакт:**
- Рабочая настройка Ansible
- Playbooks для 50 серверов
- Автоматизация security audit
- Документация Infrastructure as Code

---

## 📚 Теория: Ansible & Infrastructure as Code

### Зачем нужен Ansible?

**Проблемы без configuration management:**
- ❌ Ручная настройка (30 минут × 50 серверов = 25 часов)
- ❌ Configuration drift (серверы расходятся со временем)
- ❌ Человеческие ошибки (опечатки, забытые шаги)
- ❌ Нет документации (знания в головах людей)
- ❌ Медленное восстановление (8+ часов на пересборку сервера)

**С Ansible:**
- ✅ Автоматизированная настройка (3 минуты для 50 серверов)
- ✅ Согласованное состояние (все серверы идентичны)
- ✅ Никаких человеческих ошибок (playbook протестирован один раз, работает везде)
- ✅ Документация как код (playbook = документация)
- ✅ Быстрое восстановление (пересборка сервера за 30 минут)

### Ansible Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                   Control Node (your laptop)                 │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  ansible-playbook playbook.yml                         │  │
│  └────────────────────────────────────────────────────────┘  │
└────────────────┬─────────────────────────────────────────────┘
                 │ SSH (agentless!)
    ┌────────────┼────────────┬────────────┐
    │            │            │            │
    ▼            ▼            ▼            ▼
┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐
│ server1 │  │ server2 │  │ server3 │  │ server50│
│         │  │         │  │         │  │         │
└─────────┘  └─────────┘  └─────────┘  └─────────┘
```

**Key concepts:**
- **Control Node:** Where Ansible runs (ваш laptop)
- **Managed Nodes:** Servers you configure (50 servers)
- **Inventory:** List of managed nodes
- **Playbook:** YAML file with tasks
- **Modules:** Built-in functions (apt, copy, service, etc.)
- **Agentless:** No software on managed nodes, только SSH

### Inventory File

**inventory.ini:**

```ini
# Groups of servers
[web]
web-01.operation-shadow.net
web-02.operation-shadow.net
web-03.operation-shadow.net

[database]
db-01.operation-shadow.net ansible_user=postgres
db-02.operation-shadow.net ansible_user=postgres

[cache]
cache-01.operation-shadow.net
cache-02.operation-shadow.net

# Group of groups
[production:children]
web
database
cache

# Variables for group
[production:vars]
ansible_user=deploy
ansible_ssh_private_key_file=~/.ssh/deploy_key
environment=production
```

**Dynamic inventory (advanced):**
```bash
# Query cloud provider API
ansible-inventory --list
```

### Playbook Syntax

**Basic playbook:**

```yaml
---
- name: Configure web servers
  hosts: web
  become: yes  # Run as root

  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
        cache_valid_time: 3600

    - name: Install nginx
      apt:
        name: nginx
        state: present

    - name: Start nginx
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Copy website files
      copy:
        src: files/index.html
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: '0644'
```

**Run:**
```bash
ansible-playbook -i inventory.ini playbook.yml
```

### Modules

**Common modules:**

**Package management:**
```yaml
- apt:  # Ubuntu/Debian
    name: docker.io
    state: present

- yum:  # CentOS/RHEL
    name: docker
    state: latest
```

**Files:**
```yaml
- copy:  # Copy file from control node
    src: /local/file
    dest: /remote/file

- file:  # Create directory, set permissions
    path: /opt/app
    state: directory
    mode: '0755'

- template:  # Copy with Jinja2 variables
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
```

**Services:**
```yaml
- service:
    name: nginx
    state: restarted
    enabled: yes
```

**Users:**
```yaml
- user:
    name: deploy
    groups: sudo,docker
    shell: /bin/bash
    create_home: yes
```

**Commands:**
```yaml
- shell: echo "Hello" > /tmp/hello.txt
- command: /usr/bin/myapp --start
```

**3,000+ modules:** https://docs.ansible.com/ansible/latest/modules/modules_by_category.html

### Variables

**Define in playbook:**
```yaml
vars:
  nginx_port: 80
  app_version: 1.2.3

tasks:
  - name: Configure nginx
    template:
      src: nginx.conf.j2
      dest: /etc/nginx/nginx.conf
```

**Use in templates (Jinja2):**
```nginx
# nginx.conf.j2
server {
    listen {{ nginx_port }};
    server_name {{ ansible_hostname }};
}
```

**Variable precedence (highest to lowest):**
1. Extra vars (`-e "var=value"`)
2. Task vars
3. Play vars
4. Host vars (`host_vars/server01.yml`)
5. Group vars (`group_vars/web.yml`)
6. Inventory vars

### Templates (Jinja2)

**nginx.conf.j2:**
```nginx
server {
    listen {{ nginx_port | default(80) }};
    server_name {{ ansible_hostname }};

    {% if environment == "production" %}
    access_log /var/log/nginx/access.log combined;
    {% else %}
    access_log /var/log/nginx/access.log;
    {% endif %}

    location / {
        proxy_pass http://{{ backend_host }}:{{ backend_port }};
    }
}
```

**Use in playbook:**
```yaml
- template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: restart nginx  # Trigger handler
```

### Handlers

**Handlers = tasks that run only on change:**

```yaml
tasks:
  - name: Copy nginx config
    template:
      src: nginx.conf.j2
      dest: /etc/nginx/nginx.conf
    notify: restart nginx  # Run handler if config changed

handlers:
  - name: restart nginx
    service:
      name: nginx
      state: restarted
```

**Handlers run at end of play, only once** (even if multiple tasks notify).

### Roles

**Roles = reusable playbook components:**

**Structure:**
```
roles/
  webserver/
    tasks/main.yml       # Tasks
    handlers/main.yml    # Handlers
    templates/           # Jinja2 templates
    files/               # Static files
    vars/main.yml        # Variables
    defaults/main.yml    # Default variables
```

**Use in playbook:**
```yaml
- name: Configure servers
  hosts: web
  roles:
    - webserver
    - monitoring
```

### Ansible Vault (Secrets)

**Encrypt sensitive data:**

```bash
# Create encrypted file
ansible-vault create secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Encrypt existing file
ansible-vault encrypt vars.yml
```

**secrets.yml (encrypted):**
```yaml
db_password: supersecret123
api_key: abc123xyz
```

**Use in playbook:**
```yaml
- name: Configure database
  hosts: database
  vars_files:
    - secrets.yml
  tasks:
    - name: Create database user
      postgresql_user:
        name: app
        password: "{{ db_password }}"
```

**Run with vault:**
```bash
ansible-playbook playbook.yml --ask-vault-pass
# or
ansible-playbook playbook.yml --vault-password-file ~/.vault_pass
```

### Idempotence

**Idempotent = можно запускать много раз, результат одинаковый.**

**Good (idempotent):**
```yaml
- name: Install nginx
  apt:
    name: nginx
    state: present  # Install if not present, skip if already present
```

**Bad (not idempotent):**
```yaml
- name: Add user to sudoers
  shell: echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
  # Running twice adds line twice!
```

**Fix:**
```yaml
- name: Add user to sudoers
  lineinfile:
    path: /etc/sudoers
    line: "user ALL=(ALL) NOPASSWD: ALL"
    state: present  # Adds once, skips if already present
```

### Check Mode (Dry Run)

**Test without making changes:**

```bash
ansible-playbook playbook.yml --check
# Shows what WOULD change, but doesn't apply
```

**Diff mode:**
```bash
ansible-playbook playbook.yml --check --diff
# Shows exact changes to files
```

---

## 💻 Практика: 9 заданий

### Задание 1: Install Ansible

**Миссия:** Установить Ansible на control node.

**Задача:**

```bash
# Update package list
sudo apt update

# Install Ansible
sudo apt install -y ansible

# Verify installation
ansible --version
# Should show: ansible [core 2.x.x]

# Check Python
python3 --version
# Ansible requires Python 3.8+
```

**Test connection (localhost):**
```bash
ansible localhost -m ping
# Expected: localhost | SUCCESS => { "ping": "pong" }
```

<details>
<summary>💡 Hint: Installation issues</summary>

**If Ansible not in Ubuntu repos:**
```bash
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible
```

**Alternative (pip):**
```bash
pip3 install ansible
```

</details>

---

### Задание 2: Create Inventory File

**Миссия:** Создать inventory с 50 серверами в группах.

**Create inventory.ini:**

```ini
# Web servers (10 servers)
[web]
web-[01:10].operation-shadow.net

# Database servers (5 servers)
[database]
db-[01:05].operation-shadow.net

# Cache servers (5 servers)
[cache]
cache-[01:05].operation-shadow.net

# Monitoring servers (2 servers)
[monitoring]
monitor-01.operation-shadow.net
monitor-02.operation-shadow.net

# Application servers (28 servers)
[app]
app-[01:28].operation-shadow.net

# Group of groups
[production:children]
web
database
cache
app
monitoring

# Variables for all production servers
[production:vars]
ansible_user=deploy
ansible_ssh_private_key_file=~/.ssh/deploy_key
environment=production
```

**Test inventory:**
```bash
# List all hosts
ansible all -i inventory.ini --list-hosts

# List hosts in group
ansible web -i inventory.ini --list-hosts

# Ping all servers (будет fail если серверы недоступны, это OK для практики)
ansible all -i inventory.ini -m ping
```

**For local testing (без реальных серверов):**
```ini
[local]
localhost ansible_connection=local
```

---

### Задание 3: Write Basic Playbook

**Миссия:** Создать playbook для базовой конфигурации.

**playbook.yml:**

```yaml
---
- name: Configure operation-shadow servers
  hosts: production
  become: yes

  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
        cache_valid_time: 3600

    - name: Install essential packages
      apt:
        name:
          - vim
          - git
          - curl
          - htop
          - net-tools
        state: present

    - name: Create deploy user
      user:
        name: deploy
        groups: sudo
        shell: /bin/bash
        create_home: yes

    - name: Set up SSH key for deploy user
      authorized_key:
        user: deploy
        key: "{{ lookup('file', '~/.ssh/id_ed25519.pub') }}"
        state: present

    - name: Configure firewall (UFW)
      ufw:
        rule: allow
        port: "{{ item }}"
      loop:
        - 22
        - 80
        - 443

    - name: Enable UFW
      ufw:
        state: enabled

    - name: Install Docker
      apt:
        name: docker.io
        state: present

    - name: Start Docker service
      service:
        name: docker
        state: started
        enabled: yes

    - name: Add deploy user to docker group
      user:
        name: deploy
        groups: docker
        append: yes
```

**Run playbook:**
```bash
ansible-playbook -i inventory.ini playbook.yml

# Check mode (dry run)
ansible-playbook -i inventory.ini playbook.yml --check

# Verbose output
ansible-playbook -i inventory.ini playbook.yml -v
```

---

### Задание 4: Create Roles

**Миссия:** Организовать playbook в reusable roles.

**Create role structure:**

```bash
mkdir -p roles/{common,webserver,database}/tasks
mkdir -p roles/{common,webserver,database}/{handlers,templates,files,vars,defaults}
```

**roles/common/tasks/main.yml:**

```yaml
---
- name: Update apt cache
  apt:
    update_cache: yes
    cache_valid_time: 3600

- name: Install essential packages
  apt:
    name:
      - vim
      - git
      - curl
      - htop
    state: present

- name: Create deploy user
  user:
    name: deploy
    groups: sudo
    shell: /bin/bash
    create_home: yes
```

**roles/webserver/tasks/main.yml:**

```yaml
---
- name: Install nginx
  apt:
    name: nginx
    state: present

- name: Copy nginx config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: restart nginx

- name: Start nginx
  service:
    name: nginx
    state: started
    enabled: yes
```

**roles/webserver/handlers/main.yml:**

```yaml
---
- name: restart nginx
  service:
    name: nginx
    state: restarted
```

**Use roles in playbook:**

```yaml
---
- name: Configure all servers
  hosts: production
  become: yes
  roles:
    - common

- name: Configure web servers
  hosts: web
  become: yes
  roles:
    - webserver

- name: Configure database servers
  hosts: database
  become: yes
  roles:
    - database
```

---

### Задание 5: Use Variables

**Миссия:** Параметризовать конфигурацию с variables.

**group_vars/all.yml:**

```yaml
---
# Common variables for all servers
deploy_user: deploy
ntp_server: pool.ntp.org
timezone: Europe/Berlin
```

**group_vars/web.yml:**

```yaml
---
# Web server specific variables
nginx_port: 80
nginx_worker_processes: auto
nginx_worker_connections: 1024
max_upload_size: 100M
```

**group_vars/database.yml:**

```yaml
---
# Database specific variables
postgres_version: 14
postgres_max_connections: 200
postgres_shared_buffers: 256MB
```

**host_vars/web-01.yml:**

```yaml
---
# Specific overrides for web-01
nginx_worker_connections: 2048  # More connections for primary server
```

**Use in playbook:**

```yaml
- name: Configure timezone
  timezone:
    name: "{{ timezone }}"

- name: Configure nginx workers
  lineinfile:
    path: /etc/nginx/nginx.conf
    regexp: '^worker_processes'
    line: "worker_processes {{ nginx_worker_processes }};"
```

---

### Задание 6: Templates with Jinja2

**Миссия:** Использовать templates для dynamic configuration.

**roles/webserver/templates/nginx.conf.j2:**

```nginx
user www-data;
worker_processes {{ nginx_worker_processes }};
pid /run/nginx.pid;

events {
    worker_connections {{ nginx_worker_connections }};
}

http {
    sendfile on;
    tcp_nopush on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size {{ max_upload_size }};

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    {% if environment == "production" %}
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log warn;
    {% else %}
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log debug;
    {% endif %}

    gzip on;

    server {
        listen {{ nginx_port }};
        server_name {{ ansible_hostname }};

        root /var/www/html;
        index index.html;

        location / {
            try_files $uri $uri/ =404;
        }

        location /health {
            access_log off;
            return 200 "OK\n";
            add_header Content-Type text/plain;
        }
    }
}
```

**Use template in role:**

```yaml
- name: Deploy nginx configuration
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: '0644'
  notify: restart nginx
```

---

### Задание 7: Handlers

**Миссия:** Реагировать на изменения конфигурации.

**roles/webserver/tasks/main.yml:**

```yaml
- name: Copy nginx config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify:
    - validate nginx config
    - restart nginx

- name: Copy SSL certificate
  copy:
    src: "{{ item }}"
    dest: /etc/ssl/certs/
  loop:
    - operation-shadow.crt
    - operation-shadow.key
  notify: reload nginx
```

**roles/webserver/handlers/main.yml:**

```yaml
---
- name: validate nginx config
  command: nginx -t
  changed_when: false  # Don't report as "changed"

- name: restart nginx
  service:
    name: nginx
    state: restarted

- name: reload nginx
  service:
    name: nginx
    state: reloaded  # Graceful reload (no downtime)
```

**Handlers run:**
- At end of play
- Only if notified
- Only once (even if multiple tasks notify)
- In order defined in handlers file

---

### Задание 8: Ansible Vault (Secrets)

**Миссия:** Защитить чувствительные данные encryption.

**Create encrypted file:**

```bash
# Create vault file
ansible-vault create secrets.yml

# Enter vault password: operation-shadow-vault-2025
# Opens editor, add:
db_password: superSecretPass123
api_key: sk-abc123xyz456
ssh_private_key: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  ...
  -----END OPENSSH PRIVATE KEY-----
```

**secrets.yml (после создания — encrypted):**
```
$ANSIBLE_VAULT;1.1;AES256
66386439653966636230303838...
```

**Use in playbook:**

```yaml
---
- name: Configure database
  hosts: database
  become: yes
  vars_files:
    - secrets.yml  # Load encrypted variables

  tasks:
    - name: Create database user
      postgresql_user:
        name: appuser
        password: "{{ db_password }}"  # From secrets.yml
        state: present

    - name: Configure API key
      lineinfile:
        path: /opt/app/config.env
        line: "API_KEY={{ api_key }}"
        state: present
```

**Run with vault password:**

```bash
# Interactive password prompt
ansible-playbook playbook.yml --ask-vault-pass

# Password from file
echo "operation-shadow-vault-2025" > ~/.vault_pass
chmod 600 ~/.vault_pass
ansible-playbook playbook.yml --vault-password-file ~/.vault_pass
```

**Vault commands:**
```bash
# View encrypted file
ansible-vault view secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Change password
ansible-vault rekey secrets.yml

# Encrypt existing file
ansible-vault encrypt vars.yml

# Decrypt file
ansible-vault decrypt secrets.yml
```

---

### Задание 9: Security Audit Playbook

**Миссия:** Автоматизировать security audit всех серверов.

**audit.yml:**

```yaml
---
- name: Security Audit - All Servers
  hosts: production
  become: yes
  gather_facts: yes

  tasks:
    - name: Check for unauthorized users (UID 0)
      shell: awk -F: '$3 == 0 {print $1}' /etc/passwd
      register: uid_zero_users
      changed_when: false

    - name: Fail if unauthorized root users found
      fail:
        msg: "Unauthorized UID 0 users: {{ uid_zero_users.stdout_lines }}"
      when: uid_zero_users.stdout_lines | length > 1  # Only 'root' allowed

    - name: Check for users with empty passwords
      shell: awk -F: '($2 == "") {print $1}' /etc/shadow
      register: empty_passwords
      changed_when: false
      failed_when: false

    - name: Check SSH configuration
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: "{{ item.regexp }}"
        line: "{{ item.line }}"
        state: present
      check_mode: yes
      register: ssh_config
      loop:
        - { regexp: '^PermitRootLogin', line: 'PermitRootLogin no' }
        - { regexp: '^PasswordAuthentication', line: 'PasswordAuthentication no' }
        - { regexp: '^PermitEmptyPasswords', line: 'PermitEmptyPasswords no' }

    - name: Check for suspicious processes
      shell: ps aux | grep -E "nc|ncat|socat|/bin/sh|bash -i" | grep -v grep
      register: suspicious_processes
      changed_when: false
      failed_when: false

    - name: Check for modified system binaries
      shell: debsums -c 2>&1 | head -20
      register: modified_files
      changed_when: false
      failed_when: false

    - name: Check open ports
      shell: ss -tulpn | grep LISTEN
      register: open_ports
      changed_when: false

    - name: Check firewall status
      shell: ufw status
      register: firewall_status
      changed_when: false

    - name: Check for unauthorized SSH keys
      shell: find /home -name authorized_keys -exec cat {} \;
      register: ssh_keys
      changed_when: false

    - name: Check last logins
      shell: last -20
      register: last_logins
      changed_when: false

    - name: Generate audit report
      copy:
        content: |
          ═══════════════════════════════════════════════════════
          SECURITY AUDIT REPORT
          Server: {{ ansible_hostname }}
          Date: {{ ansible_date_time.iso8601 }}
          ═══════════════════════════════════════════════════════

          [1] UID 0 Users:
          {{ uid_zero_users.stdout }}

          [2] Empty Password Accounts:
          {{ empty_passwords.stdout | default("None", true) }}

          [3] Suspicious Processes:
          {{ suspicious_processes.stdout | default("None", true) }}

          [4] Modified System Files:
          {{ modified_files.stdout | default("None", true) }}

          [5] Open Ports:
          {{ open_ports.stdout }}

          [6] Firewall Status:
          {{ firewall_status.stdout }}

          [7] SSH Keys:
          {{ ssh_keys.stdout }}

          [8] Recent Logins:
          {{ last_logins.stdout }}

          ═══════════════════════════════════════════════════════
        dest: "/tmp/audit_{{ ansible_hostname }}_{{ ansible_date_time.date }}.txt"

    - name: Fetch audit reports to control node
      fetch:
        src: "/tmp/audit_{{ ansible_hostname }}_{{ ansible_date_time.date }}.txt"
        dest: "./audit_reports/"
        flat: yes

- name: Consolidate audit results
  hosts: localhost
  connection: local
  gather_facts: no

  tasks:
    - name: Create summary report
      shell: |
        cat audit_reports/*.txt > audit_reports/SUMMARY_{{ lookup('pipe', 'date +%Y%m%d') }}.txt
        echo "Audit complete. Check audit_reports/SUMMARY_*.txt"
```

**Run security audit:**

```bash
ansible-playbook -i inventory.ini audit.yml

# Results in ./audit_reports/
ls -lh audit_reports/
# SUMMARY_20251031.txt — consolidated report
```

**Klaus's security checklist:**
```yaml
# Quick security check
ansible all -i inventory.ini -m shell -a "ufw status" -b
ansible all -i inventory.ini -m shell -a "last -5" -b
ansible all -i inventory.ini -m shell -a "debsums -c | head" -b
```

---

## 📖 Ansible Best Practices

<details>
<summary><strong>🔹 Playbook Organization</strong></summary>

**Good structure:**
```
ansible/
├── inventory.ini
├── playbook.yml
├── group_vars/
│   ├── all.yml
│   ├── web.yml
│   └── database.yml
├── host_vars/
│   └── web-01.yml
├── roles/
│   ├── common/
│   ├── webserver/
│   └── database/
├── secrets.yml (encrypted)
└── README.md
```

**Naming conventions:**
- Playbooks: `verb_noun.yml` (e.g., `configure_webservers.yml`)
- Roles: noun (e.g., `webserver`, not `install_webserver`)
- Variables: `role_purpose` (e.g., `nginx_port`, not `port`)
- Tasks: Start with verb (e.g., "Install nginx", not "nginx installation")

</details>

<details>
<summary><strong>🔹 Idempotence</strong></summary>

**Always ensure playbooks are idempotent:**

❌ **Bad:**
```yaml
- shell: echo "server 1.2.3.4" >> /etc/config
```

✅ **Good:**
```yaml
- lineinfile:
    path: /etc/config
    line: "server 1.2.3.4"
    state: present
```

**Test idempotence:**
```bash
# Run twice, second run should be all "ok", no "changed"
ansible-playbook playbook.yml
ansible-playbook playbook.yml
```

</details>

<details>
<summary><strong>🔹 Error Handling</strong></summary>

**Ignore errors selectively:**
```yaml
- name: Check if file exists
  stat:
    path: /opt/app/config.json
  register: config_file
  ignore_errors: yes

- name: Create config if missing
  copy:
    src: default_config.json
    dest: /opt/app/config.json
  when: not config_file.stat.exists
```

**Fail gracefully:**
```yaml
- name: Check disk space
  shell: df -h / | awk 'NR==2 {print $5}' | sed 's/%//'
  register: disk_usage
  changed_when: false

- name: Fail if disk full
  fail:
    msg: "Disk usage {{ disk_usage.stdout }}% too high!"
  when: disk_usage.stdout | int > 90
```

</details>

<details>
<summary><strong>🔹 Performance</strong></summary>

**Parallel execution:**
```bash
# Run on 10 servers simultaneously (default: 5)
ansible-playbook playbook.yml --forks 10
```

**Limit scope:**
```bash
# Only run on specific group
ansible-playbook playbook.yml --limit web

# Only run on specific host
ansible-playbook playbook.yml --limit web-01
```

**Tags:**
```yaml
tasks:
  - name: Install packages
    apt: ...
    tags: packages

  - name: Configure firewall
    ufw: ...
    tags: firewall

# Run only specific tags
ansible-playbook playbook.yml --tags firewall
```

</details>

---

## 🧪 Тестирование

Автоматические тесты проверят:

1. ✅ Ansible installation
2. ✅ Inventory file structure
3. ✅ Playbook syntax
4. ✅ Roles organization
5. ✅ Variables configuration
6. ✅ Templates validity
7. ✅ Handlers configuration
8. ✅ Vault usage
9. ✅ Security audit playbook

**Запуск тестов:**
```bash
cd ~/kernel-shadows/season-4-devops-automation/episode-16-ansible-iac
./tests/test.sh
```

---

## 💬 Цитаты Episode 16

**Klaus Schmidt:**
> "Configuration management is not about managing servers. It's about managing chaos."

**Klaus (демонстрируя Ansible):**
> "50 servers. 3 minutes. Identical configuration. Zero human error. That's Infrastructure as Code."

**Klaus (после инцидента):**
> "Server compromised? Rebuild in 30 minutes. Manual configuration? 8 hours + mistakes. IaC = insurance against chaos."

**Klaus (финал Season 4):**
> "Episode 13: Git. Episode 14: Docker. Episode 15: CI/CD. Episode 16: Ansible. Together = Infrastructure as Code. Everything versioned, automated, reproducible."

**LILITH:**
> "Ansible не защита от attackers. Krylov bypassed всё с root access. But Ansible made recovery 16× faster. That's the difference."

**Max (evolution):**
- Start: "30 минут на сервер, 50 серверов = 25 часов"
- Mid: "Ansible делает это за 3 минуты?!"
- After incident: "Server-27 compromised, но восстановлен за 30 минут благодаря IaC"
- End: "Infrastructure as Code — это не роскошь. Это необходимость для масштаба."

---

## 🎓 Что вы узнали

После Episode 16 вы умеете:

✅ Устанавливать и настраивать Ansible
✅ Создавать inventory files (groups, variables)
✅ Писать playbooks (tasks, modules)
✅ Организовывать roles (reusable components)
✅ Использовать variables и templates (Jinja2)
✅ Создавать handlers (reactive actions)
✅ Защищать secrets (Ansible Vault)
✅ Автоматизировать security audits
✅ Масштабировать конфигурацию (1 → 1000 servers)

**Season 4 Complete!** 🎉

**Навыки Season 4:**
- Episode 13: Git & Version Control
- Episode 14: Docker & Containerization
- Episode 15: CI/CD Pipelines
- Episode 16: Ansible & Infrastructure as Code

**Результат:** Full-stack DevOps engineer, Infrastructure as Code mastery

---

## 🚀 Следующий шаг

**Season 5: Security & Pentesting** (Zürich, Switzerland 🇨🇭)

**Viktor (cliffhanger):**
> *"Season 4 complete. Infrastructure automated. Now we secure it. Tomorrow you fly to Zürich. Meet Eva Zimmerman — ex-NSA, penetration testing expert. She'll teach you hack your own infrastructure before Krylov does. Season 5: Security. 4 weeks. Get ready."*

**Episode 17: Security Auditing** (Zürich)
- Eva Zimmerman — ex-NSA penetration tester
- Security scanning (Nmap, Nessus, OpenVAS)
- Vulnerability assessment
- CVSS scoring
- Compliance checking

---

<div align="center">

**Episode 16: Ansible & IaC — COMPLETE!**
**🎉 SEASON 4: DEVOPS & AUTOMATION — COMPLETE! 🎉**

*"Configuration management is not about managing servers. It's about managing chaos."*

🇳🇱 Amsterdam → 🇩🇪 Berlin • 50 Servers, 3 Minutes • Infrastructure as Code Mastery

[⬅️ Episode 15: CI/CD](../episode-15-cicd-pipelines/README.md) | [⬆️ Season 4 Overview](../README.md) | [➡️ Season 5: Security](../../season-5-security-pentesting/README.md)

</div>


