# KERNEL SHADOWS
## Интерактивный курс по Linux системному администрированию

<div align="center">

**"In the shadows of the kernel, we control everything."**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Version](https://img.shields.io/badge/version-0.1.0-orange.svg)](https://github.com/yourusername/kernel-shadows)
[![Status](https://img.shields.io/badge/status-early_development-yellow.svg)]()

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

<img src="assets/lilith-avatar.png" width="150" align="right" alt="LILITH">

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
- (Опционально) Прохождение [OPERATION MOONLIGHT](https://github.com/gfazzz/moonlight-course) для полного погружения в сюжет

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

### 1. Установка Ubuntu

```bash
# Если у вас уже есть Ubuntu, проверьте версию:
lsb_release -a

# Рекомендуется: Ubuntu 22.04 LTS или 24.04 LTS
```

### 2. Клонирование курса

```bash
git clone https://github.com/yourusername/kernel-shadows.git
cd kernel-shadows
```

### 3. Первый эпизод

```bash
cd season-1-shell-foundations/episode-01-terminal-awakening
cat mission.md  # Прочитайте брифинг
cat README.md   # Изучите теорию

# LILITH сейчас встроена в README.md (комментарии и подсказки)
# В будущих версиях: интерактивный CLI tool
```

Подробная инструкция: [GETTING_STARTED.md](GETTING_STARTED.md)

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

**Версия:** 0.1.0 (Early Development)  
**Статус:** Создание базовой структуры  
**Прогресс:** 2% (концепция и документация)

### Roadmap:
- [x] Концепция и сюжет
- [x] Структура 8 сезонов
- [ ] Season 1 Episode 01 (proof of concept)
- [ ] LILITH AI интеграция
- [ ] Первые 4 эпизода (Season 1)
- [ ] Season 2-8 (базовая структура)
- [ ] Artifacts, tests, визуализации
- [ ] Community testing & feedback

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

- **GitHub Issues:** [Report a bug](https://github.com/yourusername/kernel-shadows/issues)
- **Discussions:** [Community forum](https://github.com/yourusername/kernel-shadows/discussions)


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

