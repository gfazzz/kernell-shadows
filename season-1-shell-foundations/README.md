# Season 1: Shell & Foundations

```
ОПЕРАЦИЯ: KERNEL SHADOWS
СЕЗОН: 1 — Shell & Foundations
ЛОКАЦИЯ: 🇷🇺 Новосибирск, Россия (Академгородок)
ДНИ ОПЕРАЦИИ: 2-8 (из 60)
СТАТУС: Episodes 01-04 Ready (v0.1.7)
```

---

## 📖 О сезоне

**Season 1** — это введение в Ubuntu Linux и работу с терминалом. Вы научитесь базовым командам, навигации, работе с файлами и созданию bash скриптов.

**Главный герой:** Максим "Max" Sokolov — 28 лет, системный администратор из Новосибирска, нанятый Viktor Petrov для критической операции.

**Локация:** 🇷🇺 Новосибирск, Академгородок — научный городок в Сибири. Октябрь 2025. Зима, -20°C, снег, тишина.

**Контекст:** Max работает удалённо из дома (квартира в Академгородке). Домашний home lab: Dell PowerEdge server, несколько Raspberry Pi. Первые задания от Viktor. Встречи с локальными сисадминами в кафе "Под Интегралом".

**Персонажи:**
- **Max Sokolov** — вы, главный герой
- **Viktor Petrov** — заказчик (видеозвонки)
- **LILITH** — AI-помощник, активируется в Episode 01
- **Sergey Ivanov** (Episode 02) — локальный ментор по скриптингу, работал в институте ядерной физики, знал отца Max
- **Olga Petrova** (Episode 03) — data scientist из Yandex, эксперт по обработке логов
- **Dmitry Orlov** (Episode 02+) — DevOps engineer, знакомый по Linux User Group (видеозвонки)

**Атмосфера:** Тишина сибирской зимы. Гудение домашнего сервера. Кофе и терминал. Окно на снежный лес. Студенческое кафе с плакатами формул. НГУ campus. Unix традиции советской науки.

---

## 📚 Структура сезона

| Episode | Название | Сложность | Время | Статус |
|---------|----------|-----------|-------|--------|
| **01** | Terminal Awakening | ⭐☆☆☆☆ | 3-4ч | ✅ Ready |
| **02** | Shell Scripting Basics | ⭐⭐☆☆☆ | 3-4ч | ✅ Ready |
| **03** | Text Processing Masters | ⭐⭐☆☆☆ | 3-4ч | ✅ Ready |
| **04** | Package Management | ⭐☆☆☆☆ | 2-3ч | ✅ Ready |

**Общее время:** 12-15 часов

**Интеграция:** Навыки из каждого эпизода используются в следующих сезонах. Season 8 финал объединяет все навыки курса.

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

### День 0 (1 октября): Звонок от Alex
Alex Sokolov (двоюродный брат Max) звонит из Москвы:
> *"Макс, мне нужна твоя помощь. Серьёзное дело. Хорошие деньги. Приезжай в Москву."*

Max отказывается (работа, дела). Alex настаивает. Viktor готов платить $50,000 за 2 месяца работы.

### День 1 (2 октября): Встреча в Москве
Красная площадь, 14:00. Max встречается с Viktor Petrov:
> *"Твой брат сказал, ты лучший сисадмин. Нам нужна инфраструктура. 50 серверов. Защищённые сети. Безопасность на уровне военных стандартов."*

Max соглашается. $10K авансом. Viktor: *"Начнём с основ. Работай удалённо из Новосибирска. У тебя 24 часа."*

### Episode 01 (день 2): Первое задание
**Локация:** Квартира Max в Академгородке (home lab)

Max возвращается в Новосибирск. Получает доступ к тестовому серверу Viktor. Задание: найти скрытые файлы с координатами.

LILITH активируется:
> *"Приветствую, Max. Я LILITH. Твой проводник в тенях. Посмотрим, так ли ты хорош, как говорит Alex."*

**Атмосфера:** Тишина сибирской зимы. Снег за окном. Гудение домашнего сервера. Кофе и терминал. Первые шаги в операции.

### Episode 02 (дни 3-4): Автоматизация
**Локация:** Квартира + кафе "Под Интегралом"

Viktor: *"50 серверов нужно мониторить. Скрипты."*

Max встречается с **Sergey Ivanov** (52 года, работал в институте ядерной физики, знал отца Max):
> *"Знал твоего отца. Он тоже любил автоматизацию. Покажу тебе старую школу скриптинга."*

Dmitry Orlov (видеозвонок): *"Мы не можем проверять 50 серверов вручную. Автоматизация — наша сила."*

Max создаёт `server_monitor.sh`. Sergey помогает с bash best practices.

**Атмосфера:** Кафе "Под Интегралом", плакаты с формулами, студенты, Wi-Fi. Снег за окном. Разговоры о Unix традициях советской науки.

### Episode 03 (дни 5-6): Анализ атаки
**Локация:** Квартира + НГУ campus

Anna Kovaleva (видеозвонок из Москвы):
> *"Нас атаковали вчера в 03:47. Найди IP атакующих в логах. Лог огромный (100MB+)."*

Max в растерянности. Встреча с **Olga Petrova** (29 лет, data scientist из Yandex, эксперт по логам):
> *"10 миллионов строк? Это не много. awk справится за секунду. Смотри."*

Olga обучает Max grep/awk/sed. Анализ логов на НГУ campus (лаборатория с Linux серверами).

Найдено: 185.220.101.47 (Tor exit node) + 10 других IP. Первые следы противника.

LILITH: *"Логи не врут. Люди — врут."*

**Атмосфера:** НГУ, научная традиция Unix, белые доски с формулами, старые Sun Microsystems серверы, запах кофе и паяльников.

### Episode 04 (дни 7-8): Инструменты
**Локация:** Квартира Max

Viktor: *"Тебе нужны инструменты. Вот список."* (nmap, tcpdump, wireshark, docker, etc.)

Max учится package management. Конфликты dependencies. Решение проблем.

**Результат:** Viktor доволен работой Max. Приглашает в Москву для основной операции:
> *"Хорошо. Ты справился. Приезжай в Москву. Встретишься с командой. Настоящая операция начинается."*

Max: *"Я справился. Может быть, я готов к чему-то большему..."*

### Season 1 завершается
Max собирает вещи. Прощается с Новосибирском (пока). Билет на самолёт в Москву.

**Cliffhanger → Season 2:**
Звонок от Alex:
> *"Макс, у нас проблема. Krylov знает о нас. Приезжай быстрее."*

Экран гаснет. Первая реальная угроза. Операция переходит на новый уровень.

---

## 🌍 Season 1 как часть глобальной операции

**Season 1** — это только начало. Max доказывает свою компетентность удалённо из Новосибирска.

**Далее (Seasons 2-8):**
- Season 2: Москва → Стокгольм (networking, первая международная поездка)
- Season 3: СПб → Таллин (system administration)
- Season 4: Амстердам → Берлин (DevOps)
- Season 5: Цюрих + Женева (security & pentesting)
- Season 6: Шэньчжэнь, Китай (embedded Linux)
- Season 7: Рейкьявик, Исландия (production infrastructure)
- Season 8: Глобальная (финальная битва во всех локациях)

**Путешествие:** 8+ стран, 35,000+ км, 60 дней, от Новосибирска до Рейкьявика.

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

**Версия:** v0.1.7
**Статус:** Season 1 Complete! 🎉
**Обновление:** Интегрирована глобальная концепция (локации + персонажи). Season projects удалены — навыки естественно интегрируются между сезонами.

- [x] **Episode 01** — Complete (README, artifacts, tests, solution)
- [x] **Episode 02** — Complete (README, artifacts, tests, solution)
- [x] **Episode 03** — Complete (README, artifacts, tests, solution)
- [x] **Episode 04** — Complete (README, artifacts, tests, solution)
- [x] **Season README** — Updated with locations & characters

**См. также:**
- [SCENARIO.md](../SCENARIO.md) — полный сценарий операции KERNEL SHADOWS
- [CHARACTERS.md](../CHARACTERS.md) — биографии всех персонажей (27+)
- [LOCATIONS.md](../LOCATIONS.md) — детальные описания всех локаций
- [CURRICULUM.md](../CURRICULUM.md) — полный учебный план (8 сезонов)

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
7. 🎉 **Season 1 ЗАВЕРШЁН!**

### Переход к Season 2:
Max садится в самолёт Новосибирск → Москва. Впереди — встреча с командой Viktor, новые локации (Москва → Стокгольм), первая реальная угроза (полковник Krylov).

**Следующий сезон:**
- **Season 2:** Networking (TCP/IP, DNS, Firewalls, VPN, SSH)
- **Локации:** Москва 🇷🇺 → Стокгольм 🇸🇪
- **Новые персонажи:** Alex (лично), Anna (лично), Erik Johansson, Katarina Lindström
- **Дни операции:** 9-16 (из 60)

**→ Continue: [Season 2 README](../../season-2-networking/README.md)** (в разработке)

---

## 🐛 Нашли баг?

Создайте issue в репозитории или напишите в discussions.

---

<div align="center">

**OPERATION KERNEL SHADOWS**
*Season 1 — Shell & Foundations*

*🇷🇺 Новосибирск, Россия (Академгородок)*
*Дни 2-8 из 60 • Первый шаг из 35,000 км*

---

*"Ты видишь shell. Я вижу тени."* — LILITH

*"В мои времена не было StackOverflow. Был man и мозг."* — Sergey Ivanov

---

**Следующая остановка:** Season 2 → Москва → Стокгольм 🇸🇪
**Новые персонажи:** Alex Sokolov, Anna Kovaleva, Erik Johansson
**Новая угроза:** Полковник Krylov

*Путешествие только начинается...*

[⬆ К началу](#season-1-shell--foundations)

</div>

