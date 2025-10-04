# Episode 04: Artifacts

## 📦 Содержимое

### `required_tools.txt`
Список необходимых инструментов для операции KERNEL SHADOWS.

**Категории:**
- Network reconnaissance (nmap, netcat, tcpdump)
- Security tools (fail2ban, ufw, openssl)
- Monitoring (htop, iotop, net-tools)
- Development (git, python3-pip, ansible)
- Containers (Docker — требует специальной установки)

## 🎯 Как использовать

### Вариант 1: Ручная установка (для обучения)
```bash
# Прочитать список
cat required_tools.txt

# Установить каждый пакет вручную
sudo apt update
sudo apt install -y nmap
sudo apt install -y netcat
# ... и так далее
```

### Вариант 2: Автоматизация (ваша задача)
Создать скрипт `install_toolkit.sh`, который:
1. Читает `required_tools.txt`
2. Фильтрует комментарии и пустые строки
3. Устанавливает все пакеты автоматически
4. Проверяет успешность установки
5. Создаёт отчёт

## ⚠️ Важные замечания

### Docker требует особого подхода:
```bash
# Добавить официальный репозиторий Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

### Backup перед изменениями:
```bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
```

### Проверка установки:
```bash
# Проверить версию пакета
dpkg -l | grep nmap

# Проверить путь к бинарнику
which nmap

# Проверить работоспособность
nmap --version
```

## 🔧 Troubleshooting

### Если пакет не найден:
```bash
sudo apt update
apt search <package-name>
```

### Если конфликт зависимостей:
```bash
# Показать зависимости
apt-cache depends <package-name>

# Попробовать исправить
sudo apt --fix-broken install
```

### Если нужно удалить пакет:
```bash
sudo apt remove <package-name>
sudo apt purge <package-name>  # + удаление конфигов
sudo apt autoremove            # очистка неиспользуемых зависимостей
```

## 📚 Дополнительные ресурсы

- `man apt` — руководство по APT
- `man dpkg` — руководство по DPKG
- Ubuntu Packages Search: https://packages.ubuntu.com/
- Docker Installation Docs: https://docs.docker.com/engine/install/ubuntu/

---

*"Инструменты — это расширение твоих рук. Выбирай их мудро."* — LILITH

