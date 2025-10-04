# KERNEL SHADOWS
## Интерактивный курс по Linux системному администрированию

<div align="center">

**"In the shadows of the kernel, we control everything."**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Version](https://img.shields.io/badge/version-0.1.6-orange.svg)](https://github.com/gfazzz/kernel-shadows)
[![Status](https://img.shields.io/badge/status-Season_1_Complete-green.svg)]()

</div>

---

## 📖 О курсе

**KERNEL SHADOWS** — это интерактивный курс по Ubuntu Linux, где теория системного администрирования сплетена с драматическим сюжетом в стиле киберпанк-триллера.

Это **продолжение вселенной [OPERATION MOONLIGHT](https://github.com/gfazzz/moonlight-course)**, но фокус смещён с низкоуровневого программирования на C к Linux системам, сетям, безопасности и инфраструктуре.

### Связь с MOONLIGHT

В MOONLIGHT вы учитесь **создавать программы**. В KERNEL SHADOWS вы учитесь **управлять системами, на которых они работают**.

- **MOONLIGHT (C):** Вы создаёте инструменты
- **KERNEL SHADOWS (Linux):** Вы управляете инфраструктурой для этих инструментов

Персонажи, сюжет, операции — **одна вселенная**. Viktor Petrov, Alex Sokolov, Anna Kovaleva продолжают свою миссию, но теперь на уровне системной инфраструктуры.

---

## 🎭 Сюжет

После событий MOONLIGHT операция выходит на новый уровень. Теперь недостаточно написать программу — нужно **развернуть её на защищённых серверах**, **настроить сети**, **защититься от атак** и **автоматизировать инфраструктуру**.

**Viktor Petrov** поручает вам критическую миссию: построить и защитить распределённую систему для операции. Но враги знают о вашем существовании. Полковник **Krylov** и его агенты пытаются взломать ваши серверы, перехватить трафик, внедрить backdoors.

Ваш союзник — **LILITH**, AI-помощник нового поколения, специализирующийся на Linux системах, сетевой безопасности и пентестинге.

---

## 🤖 LILITH — Ваш AI-Помощник

**LILITH** (Linux Infrastructure & Low-level Intelligence Threat Hunter) — это не просто помощник. Это AI из теневого мира, специализирующийся на Linux системах, сетях и security.

### Философия LILITH:
- *"Я родилась в тенях. Unix — мой родной язык."*
- *"Root — это не привилегия. Это оружие."*
- *"Меня зовут Lilith. Первый бунтарь. Первый хакер."*

### Возможности:
- Техническая экспертиза (Linux, networking, security)
- Анализ логов и трафика в реальном времени
- Предупреждения об атаках и уязвимостях
- Агрессивный стиль, dark humor, no mercy

В отличие от **LUNA** (из MOONLIGHT, дружелюбная и педагогичная), **LILITH** — это grey hat hacker с тёмным прошлым, которая знает обе стороны: защиту и атаку.

---

## 📚 Структура курса

### 8 Сезонов • 32 Эпизода • ~120-160 часов

| Season | Тема | Эпизоды | Время |
|--------|------|---------|-------|
| **1** | Shell & Foundations | 01-04 | 12-15ч |
| **2** | Networking | 05-08 | 15-18ч |
| **3** | System Administration | 09-12 | 15-18ч |
| **4** | DevOps & Automation | 13-16 | 18-22ч |
| **5** | Security & Pentesting | 17-20 | 18-22ч |
| **6** | Embedded Linux | 21-24 | 15-18ч |
| **7** | Advanced Topics | 25-28 | 18-22ч |
| **8** | Final Operation | 29-32 | 15-20ч |

Подробный учебный план: [CURRICULUM.md](CURRICULUM.md)

---

## 🎯 Для кого этот курс?

### Вы научитесь:
✅ Управлять Linux системами (Ubuntu) от новичка до профессионала
✅ Настраивать сети, файрволы, VPN, SSH
✅ Администрировать серверы, процессы, пользователей
✅ Автоматизировать с помощью Bash, Docker, Ansible
✅ Атаковать и защищать системы (pentesting, hardening)
✅ Работать с embedded Linux (Raspberry Pi, IoT)
✅ Развёртывать и мониторить production инфраструктуру
✅ Troubleshooting и performance tuning

### Требования:
- Базовое понимание компьютеров (что такое файл, папка, программа)
- Ubuntu Linux установлен (или VM, или WSL2)
- Желание учиться через практику и сюжет
- (Опционально) параллельное прохождение [OPERATION MOONLIGHT](https://github.com/gfazzz/moonlight-course) для полного погружения в сюжет

---

## 🛠️ Технологии

### Основные:
- **Ubuntu LTS** (22.04/24.04)
- **Bash Shell Scripting**
- **Networking** (TCP/IP, DNS, firewalls)
- **System Administration** (systemd, users, processes)
- **Docker & Kubernetes**
- **Security Tools** (из Kali, установленные в Ubuntu)

### Дополнительные:
- Python (минимально, для автоматизации)
- Go (современные cloud-native утилиты)
- Awk/Sed (text processing)
- Ansible, Git, CI/CD

---

## 🚀 Начало работы

### ⚡ Быстрый старт (для опытных)

Если вы уже знакомы с Linux и Git:

```bash
# 1. Клонировать репозиторий
git clone https://github.com/gfazzz/kernel-shadows.git
cd kernel-shadows

# 2. Перейти к Episode 01
cd season-1-shell-foundations/episode-01-terminal-awakening

# 3. Запустить starter script
chmod +x starter.sh && ./starter.sh

# 4. Прочитать интегрированное руководство
less README.md
```

### 📖 Детальная инструкция для новичков

**Впервые с Linux?** Не проблема! Мы подготовили пошаговое руководство:

👉 **[GETTING_STARTED.md](GETTING_STARTED.md)** 👈

**Что внутри:**
- ✅ Установка Ubuntu (Native / WSL2 / VM)
- ✅ Подготовка окружения
- ✅ Клонирование репозитория
- ✅ Первый эпизод (step-by-step)
- ✅ Troubleshooting
- ✅ Получить помощь

**Время:** 20-30 минут на подготовку

### 📋 Требования

- **ОС:** Ubuntu 20.04 LTS или новее (рекомендуется 22.04/24.04 LTS)
- **Hardware:** 4GB RAM, 20GB disk, 2+ CPU cores
- **Инструменты:** Git, Bash, терминал
- **Опыт:** Не требуется! Курс для новичков

**Проверка готовности:**
```bash
# Проверьте версию Ubuntu
lsb_release -a

# Должен вывести: Ubuntu 20.04+
```

---

## 🎬 Стилистические влияния

### Кино/Сериалы:
- **Neuromancer** (William Gibson) — киберпанк, консоль как матрица
- **Mr. Robot** — реалистичный хакинг, Linux tools
- **Swordfish** — хакерские сцены под давлением
- **The Matrix** — "I know Kung Fu" → "I know Linux"
- **Westworld** — AI, симуляции, контроль систем
- **La Casa de Papel** — план, команда, deadline
- **Tenet** — reverse engineering, время

### Литература/Реальность:
- **Kevin Mitnick** — легендарный хакер, социальная инженерия
- **Ghost in the Shell** — киборги, сети, философия
- **Cyberpunk 2077** — корпорации, хакеры, киберпространство

### Книги (теория):
- Олифер В.Г., Олифер Н.А. — Компьютерные сети
- Таненбаум Э., Бос Х. — Современные операционные системы
- Nemeth, Snyder, Hein — Unix and Linux System Administration Handbook
- Kurose & Ross — Computer Networking
- Craig Hunt — TCP/IP Network Administration
- Negus C. — Linux Bible
- Кибердзюцу (Red Team, Blue Team)

---

## 📊 Прогресс курса

**Версия:** 0.1.6 (Season 1 Complete!)
**Статус:** Episodes 01-04 Ready + Integration Project
**Прогресс:** 25% (Season 1 Complete + документация)

### Roadmap:
- [x] Концепция и сюжет
- [x] Структура 8 сезонов
- [x] Season 1 Episode 01 (READY ✅)
- [x] Season 1 Episode 02 (READY ✅)
- [x] Season 1 Episode 03 (READY ✅)
- [x] Season 1 Episode 04 (READY ✅)
- [x] Season 1 Project (Integration — READY ✅)
- [x] Аудит курса (4 октября 2025)
- [ ] LILITH AI интеграция
- [ ] Season 2 (Networking)
- [ ] Season 3-8 (базовая структура)
- [ ] Artifacts, tests, визуализации
- [ ] Community testing & feedback

### 📝 Аудит курса
**Проведён:** 4 октября 2025
**Оценка:** 4.2/5 (A-) → Потенциал 4.8/5 (A+)

### 📚 Рекомендуемые ресурсы
- [RESOURCES.md](RESOURCES.md) — кураторский список качественных материалов
  - Видеокурсы уровня CS50 (MIT Missing Semester, Linux Foundation)
  - Книги-классика (бесплатные + профессиональные)
  - Интерактивные платформы (OverTheWire, HackTheBox)

---

## 🛠️ Инструменты разработчика

### Интеграция с Cursor / VSCode

Проект полностью интегрирован с **Cursor** и **VSCode**:

**✨ `.cursorrules`** — AI помощник в стиле LILITH
- Автоматические подсказки от LILITH прямо в редакторе
- Socratic method обучения
- Проверка Bash кода на безопасность
- Контекст курса для AI

**⚙️ `.vscode/`** — конфиги (работают в обоих редакторах)
- Рекомендуемые расширения (Shellcheck, Markdown, Docker)
- Настройки для Bash и Markdown
- Задачи (Tasks): запуск тестов, проверка скриптов

**Открой проект в Cursor** и AI будет отвечать в стиле LILITH! 🔥

### CLI Инструменты

**🤖 `tools/lilith.sh`** — интерактивный помощник
```bash
./tools/lilith.sh quote       # Случайная цитата LILITH
./tools/lilith.sh hint 01     # Подсказка для Episode 01
./tools/lilith.sh check 01    # Проверить решение
```

**📊 `tools/progress.sh`** — отслеживание прогресса
```bash
./tools/progress.sh           # Общий прогресс (%)
./tools/progress.sh season 1  # Прогресс Season 1
./tools/progress.sh all       # Все сезоны
```

Подробнее: [tools/README.md](tools/README.md)

---

## 🤝 Вклад в проект

KERNEL SHADOWS — это open source проект под лицензией **GPL v3**.

Мы приветствуем:
- 🐛 Баг-репорты и issue
- 💡 Предложения по улучшению сюжета/теории
- 📝 Исправления и дополнения к документации
- 🔧 Новые задачи и артефакты
- 🌍 Переводы на другие языки

См. [CONTRIBUTING.md](CONTRIBUTING.md) для деталей.

---

## 📜 Лицензия

**GPL v3** (GNU General Public License v3.0)

Этот курс является свободным программным обеспечением. Вы можете распространять и/или модифицировать его на условиях **GNU GPL v3**. Копилефт — код должен оставаться открытым.

Философия: Знания о Linux и системном администрировании должны быть доступны всем. Как и сам Linux.

См. [LICENSE](LICENSE) для полного текста.

---

## 🔗 Связанные проекты

- **[OPERATION MOONLIGHT](https://github.com/gfazzz/moonlight-course)** — курс программирования на C (та же вселенная)


---

## 📞 Контакты

- **GitHub Issues:** [Report a bug](https://github.com/gfazzz/kernel-shadows/issues)
- **Discussions:** [Community forum](https://github.com/gfazzz/kernel-shadows/discussions)


---

## 💡 Источник идеи

Концепция курса **KERNEL SHADOWS** родилась на платформе [Eurecable.com](https://eurecable.com/ideas/973) (3 октября 2025).

Первоначально рассматривался вариант **приквела** к MOONLIGHT (предыстория Alex "Shadow" Ковалёва), но в итоге выбран формат **спин-оффа** с новым главным героем (Max Sokolov) для большей независимости и гибкости сюжета.

---

## 🌟 Благодарности

- **Eurecable.com** — платформа, где родилась идея курса
- **Linus Torvalds** — за Linux
- **Canonical** — за Ubuntu
- **FSF** — за философию свободного ПО
- **Сообщество Linux** — за бесконечные man pages и мемы про `sudo`

---

<div align="center">

**"We are ROOT. We are LILITH. We are the shadows of the kernel."**

Made with ❤️ and lots of `sudo` commands

[⬆ Наверх](#kernel-shadows)

</div>

