# Season 1: Shell & Foundations

```
ОПЕРАЦИЯ: KERNEL SHADOWS
СЕЗОН: 1 — Shell & Foundations
СТАТУС: Episodes 01-04 Ready (v0.1.6)
```

---

## 📖 О сезоне

**Season 1** — это введение в Ubuntu Linux и работу с терминалом. Вы научитесь базовым командам, навигации, работе с файлами и созданию bash скриптов.

**Главный герой:** Максим "Max" Sokolov — системный администратор из Новосибирска, нанятый Viktor Petrov для критической операции.

**AI-помощник:** LILITH — ваш проводник в тенях kernel.

---

## 📚 Структура сезона

| Episode | Название | Сложность | Время | Статус |
|---------|----------|-----------|-------|--------|
| **01** | Terminal Awakening | ⭐☆☆☆☆ | 3-4ч | ✅ Ready |
| **02** | Shell Scripting Basics | ⭐⭐☆☆☆ | 3-4ч | ✅ Ready |
| **03** | Text Processing Masters | ⭐⭐☆☆☆ | 3-4ч | ✅ Ready |
| **04** | Package Management | ⭐☆☆☆☆ | 2-3ч | ✅ Ready |

**Общее время:** 12-15 часов

---

## 🎯 Чему вы научитесь

### Episode 01: Terminal Awakening
- ✅ Подключение к серверу через SSH
- ✅ Навигация по файловой системе (`cd`, `pwd`, `ls`)
- ✅ Работа с файлами (`cat`, `less`, `head`, `tail`)
- ✅ Поиск файлов (`find`)
- ✅ Создание простых bash скриптов
- ✅ Понимание структуры Linux filesystem

### Episode 02: Shell Scripting Basics
- ✅ Структура bash скриптов (shebang, комментарии)
- ✅ Переменные в bash (`VAR="value"`, `$VAR`, `${VAR}`)
- ✅ Условия (`if`, `[[ ]]`, операторы сравнения)
- ✅ Циклы (`for`, `while`, `while read`)
- ✅ Функции (`function_name() {}`, `local`, `return`)
- ✅ Exit codes (`$?`, `exit 0/1`)
- ✅ Автоматизация мониторинга серверов

### Episode 03: Text Processing Masters
- ✅ Pipes и redirects (`|`, `>`, `>>`, `<`, `2>`)
- ✅ `grep` для поиска текста (regex, filters)
- ✅ `awk` для обработки колонок (fields, conditions)
- ✅ `sed` для замены текста (stream editing)
- ✅ `cut`, `sort`, `uniq`, `wc` для обработки данных
- ✅ Анализ логов (Apache Combined Log Format)
- ✅ Извлечение IP адресов и User-Agents
- ✅ TOP-N анализ (TOP-10 attackers)

### Episode 04: Package Management
- ✅ APT (Advanced Package Tool): `apt install`, `apt update`, `apt upgrade`
- ✅ DPKG (Debian Package Manager): low-level управление
- ✅ Snap packages: современная альтернатива
- ✅ Репозитории: `/etc/apt/sources.list`, добавление PPA
- ✅ Dependency resolution и troubleshooting
- ✅ Автоматизация установки через скрипт
- ✅ Non-interactive installation (DEBIAN_FRONTEND)
- ✅ Логирование и отчёты
- ✅ Docker installation (custom repository)

---

## 🎬 Сюжет Season 1

### Завязка (Episode 01):
2 октября 2025, Красная площадь, Москва. Max Sokolov встречается с Viktor Petrov, который предлагает ему $50,000 за месяц работы — построить защищённую инфраструктуру для секретной операции.

Первое задание: найти скрытые файлы на тестовом сервере. Активируется LILITH — AI-помощник от Viktor.

### Развитие (Episodes 02-03):
Max обучается автоматизации и обработке данных. LILITH тестирует его навыки. Viktor постепенно раскрывает детали операции.

### Кульминация (Episode 04):
Max готов к настройке реальных серверов. Получает доступ к инфраструктуре операции. Встречается с остальной командой: Alex Sokolov (его брат, ex-FSB), Anna Kovaleva (forensics expert), Dmitry Orlov (DevOps).

**Cliffhanger Season 2:** Первая DDoS атака от Krylov...

---

## 🚀 Как начать

### Episode 01 — Terminal Awakening:

```bash
cd season-1-shell-foundations/episode-01-terminal-awakening/

# 1. Прочитайте README.md — интегрированное руководство (сюжет + теория + практика)
less README.md

# 2. Следуйте 8 последовательным заданиям
less README.md

# 3. Скопируйте тестовую среду
cp -r artifacts/test_environment ~/
cd ~/test_environment/

# 4. Начните поиск файлов!
ls -la
find . -name "briefing.txt"
# ... и так далее

# 5. Создайте свой скрипт
cp ~/kernel-shadows/season-1-shell-foundations/episode-01-terminal-awakening/starter.sh ./find_files.sh
chmod +x find_files.sh
nano find_files.sh

# 6. Запустите тесты
cd ~/kernel-shadows/season-1-shell-foundations/episode-01-terminal-awakening/tests/
./test.sh
```

### Episode 02 — Shell Scripting Basics:

```bash
cd season-1-shell-foundations/episode-02-shell-scripting/

# 1. Прочитайте README.md — интегрированное руководство
less README.md

# 2. Скопируйте артефакты
cp artifacts/servers.txt .

# 3. Начните с шаблона или создайте свой скрипт
cp starter.sh server_monitor.sh
chmod +x server_monitor.sh
nano server_monitor.sh

# 4. Тестируйте по ходу разработки
./server_monitor.sh

# 5. Проверьте логи
cat monitor.log
cat alerts.txt

# 6. Запустите автотесты
./tests/test.sh
```

### Episode 03 — Text Processing Masters:

```bash
cd season-1-shell-foundations/episode-03-text-processing/

# 1. Прочитайте README.md — интегрированное руководство
less README.md

# 2. Скопируйте артефакты
mkdir -p ~/log_analysis
cp artifacts/access.log ~/log_analysis/
cp artifacts/suspicious_ips.txt ~/log_analysis/
cp artifacts/report_template.txt ~/log_analysis/
cd ~/log_analysis/

# 3. Начните анализ по заданиям из README
# Задание 1-6: Изучение grep, awk, sed, pipes
grep "03:47" access.log | head
awk '{print $1}' access.log | head

# 4. Создайте свой log_analyzer.sh
cp ~/kernel-shadows/season-1-shell-foundations/episode-03-text-processing/starter.sh ./log_analyzer.sh
chmod +x log_analyzer.sh
nano log_analyzer.sh

# 5. Запустите анализ
./log_analyzer.sh access.log suspicious_ips.txt final_report.txt

# 6. Проверьте результаты
cat final_report.txt
cat top_attackers.txt

# 7. Запустите автотесты
cd ~/kernel-shadows/season-1-shell-foundations/episode-03-text-processing/tests
./test.sh
```

### Episode 04 — Package Management:

```bash
cd season-1-shell-foundations/episode-04-package-management/

# 1. Прочитайте README.md — интегрированное руководство
less README.md

# 2. Изучите список инструментов
cat artifacts/required_tools.txt

# 3. Попрактикуйтесь с APT (НЕ запускайте sudo без понимания!)
apt search nmap
apt show nmap

# 4. Начните с шаблона
cp starter.sh install_toolkit.sh
chmod +x install_toolkit.sh
nano install_toolkit.sh

# 5. Заполните TODO комментарии
# Начните с простых функций: log_message(), check_root()

# 6. Тестирование БЕЗ sudo (должна выдать ошибку о root)
./install_toolkit.sh artifacts/required_tools.txt

# 7. Создайте минимальный тестовый файл
echo "htop" > test_tools.txt
echo "curl" >> test_tools.txt

# 8. Тестирование с sudo (ОСТОРОЖНО! Реальная установка)
sudo ./install_toolkit.sh test_tools.txt

# 9. Проверьте результаты
cat install_report.txt
cat install.log

# 10. Запустите автотесты
cd tests/
./test.sh

# 11. Полная установка (когда готовы)
cd ..
sudo ./install_toolkit.sh artifacts/required_tools.txt
```

**⚠️ ВАЖНО для Episode 04:**
- Episode 04 **ТРЕБУЕТ sudo** (root права)
- Некоторые команды устанавливают реальные пакеты
- Тестируйте на виртуальной машине или докер-контейнере
- Или используйте минимальный test_tools.txt
- Читайте artifacts/README.md для деталей Docker installation

---

## 📊 Прогресс сезона

**Версия:** v0.1.6
**Статус:** Season 1 Complete! 🎉

- [x] **Episode 01** — Complete (README, artifacts, tests, solution)
- [x] **Episode 02** — Complete (README, artifacts, tests, solution)
- [x] **Episode 03** — Complete (README, artifacts, tests, solution)
- [x] **Episode 04** — Complete (README, artifacts, tests, solution)
- [ ] Season Project — Planned (integration of all 4 episodes)

---

## 🤖 LILITH в Season 1

LILITH активируется в Episode 01 и сопровождает вас через весь сезон:

**Episode 01:**
> *"Я LILITH. Твой проводник в тенях. Покажи, на что ты способен, Max."*

**Стиль:** Циничная, прямолинейная, помогает через вопросы (не даёт прямых ответов).

**Фразы:**
- *"Логи не врут. Люди — врут."*
- *"Ты видишь shell. Я вижу тени."*
- *"`ls -la` — твоя первая команда на любом сервере."*

---

## 📁 Структура файлов

```
season-1-shell-foundations/
├── README.md                          # Этот файл
│
└── episode-01-terminal-awakening/
    ├── README.md                      # Интегрированное руководство (v0.1.3+)
    ├── starter.sh                     # Шаблон скрипта
    │
    ├── solution/
    │   └── find_files.sh              # Референсное решение
    │
    ├── artifacts/
    │   ├── README.md                  # Как использовать
    │   └── test_environment/          # Тестовые файлы
    │       ├── documents/
    │       │   ├── briefing.txt
    │       │   └── .secret_location
    │       └── .next_server
    │
    └── tests/
        └── test.sh                    # Автоматические тесты
```

---

## 💡 Советы для успеха

### 1. Читайте man pages
```bash
man ls
man find
man bash
```

### 2. Экспериментируйте
Создайте тестовую папку и пробуйте команды:
```bash
mkdir ~/test_practice
cd ~/test_practice
# Экспериментируйте здесь!
```

### 3. Используйте `--help`
```bash
ls --help
find --help
```

### 4. История команд
```bash
history          # Показать последние команды
!123             # Повторить команду #123
!!               # Повторить последнюю команду
```

### 5. Tab completion
Нажимайте `Tab` для автодополнения имён файлов и команд.

---

## 🎓 Дополнительные ресурсы

- **explainshell.com** — объяснение bash команд
- **shellcheck.net** — проверка bash скриптов
- `man bash` — полная документация Bash
- `/usr/share/doc/` — документация установленных программ

---

## 🔄 Следующие шаги

### После завершения Episode 01:
1. ✅ Убедитесь, что нашли все 3 файла
2. ✅ Создали рабочий скрипт `find_files.sh`
3. ✅ Прошли все тесты (`./tests/test.sh`)
4. ➡️ Переходите к Episode 02

### После завершения Episode 02:
1. ✅ Создали функциональный `server_monitor.sh`
2. ✅ Скрипт проверяет серверы и создаёт логи
3. ✅ Прошли все тесты (`./tests/test.sh`)
4. ➡️ Переходите к Episode 03

### После завершения Episode 03:
1. ✅ Освоили grep, awk, sed, pipes
2. ✅ Проанализировали логи атаки (4400+ строк)
3. ✅ Создали `log_analyzer.sh` для автоматического анализа
4. ✅ Нашли TOP-10 атакующих IP (включая Tor exit node)
5. ✅ Прошли все тесты (`./tests/test.sh`)
6. ➡️ Переходите к Episode 04

### После завершения Episode 04:
1. ✅ Освоили package management (APT, DPKG, Snap)
2. ✅ Научились добавлять репозитории безопасно
3. ✅ Создали `install_toolkit.sh` для автоматизации
4. ✅ Установили security & networking tools
5. ✅ Настроили логирование и отчёты
6. ✅ Прошли все тесты (`./tests/test.sh`)
7. 🎉 **Season 1 завершён!** Переходите к Season 2 (в разработке)

---

## 🐛 Нашли баг?

Создайте issue в репозитории или напишите в discussions.

---

<div align="center">

**OPERATION KERNEL SHADOWS**
*Season 1 — Shell & Foundations*

*"Ты видишь shell. Я вижу тени."* — LILITH

[⬆ К началу](#season-1-shell--foundations)

</div>

