# Season 1: Shell & Foundations

```
ОПЕРАЦИЯ: KERNEL SHADOWS
СЕЗОН: 1 — Shell & Foundations
СТАТУС: Episode 01 Ready (v0.1)
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
| **02** | Shell Scripting Basics | ⭐⭐☆☆☆ | 3-4ч | 🔄 Planned |
| **03** | Text Processing Masters | ⭐⭐☆☆☆ | 3-4ч | 🔄 Planned |
| **04** | Package Management | ⭐☆☆☆☆ | 2-3ч | 🔄 Planned |

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

### Episode 02: Shell Scripting Basics (Planned)
- Переменные в bash
- Условия (`if`, `else`, `elif`)
- Циклы (`for`, `while`)
- Функции
- Автоматизация задач

### Episode 03: Text Processing Masters (Planned)
- Pipes и redirects (`|`, `>`, `>>`)
- `grep` для поиска текста
- `awk` для обработки колонок
- `sed` для замены текста
- `cut`, `sort`, `uniq`

### Episode 04: Package Management (Planned)
- APT (`apt install`, `apt update`)
- DPKG
- Snap packages
- Установка необходимых инструментов

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

# 1. Прочитайте mission.md — сюжет и задание
cat mission.md

# 2. Изучите теорию в README.md
less README.md

# 3. Скопируйте тестовую среду
cp -r artifacts/test_environment ~/
cd ~/test_environment/

# 4. Начните поиск файлов!
ls -la
find . -name "briefing.txt"
# ... и так далее

# 5. Создайте свой скрипт
cp ~/kernell-shadows/season-1-shell-foundations/episode-01-terminal-awakening/starter.sh ./find_files.sh
chmod +x find_files.sh
nano find_files.sh

# 6. Запустите тесты
cd ~/kernell-shadows/season-1-shell-foundations/episode-01-terminal-awakening/tests/
./test.sh
```

---

## 📊 Прогресс сезона

**Версия:** v0.1  
**Статус:** Early Development

- [x] **Episode 01** — Complete (mission, README, artifacts, tests)
- [ ] Episode 02 — Not started
- [ ] Episode 03 — Not started
- [ ] Episode 04 — Not started
- [ ] Season Project — Not started

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
    ├── mission.md                     # Сюжетное задание
    ├── README.md                      # Теория + примеры
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

После завершения Episode 01:
1. ✅ Убедитесь, что нашли все 3 файла
2. ✅ Создали рабочий скрипт `find_files.sh`
3. ✅ Прошли все тесты (`./tests/test.sh`)
4. ➡️ Переходите к Episode 02 (когда будет готов)

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

