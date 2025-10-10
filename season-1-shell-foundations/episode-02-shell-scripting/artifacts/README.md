# Episode 02: Artifacts

Эти файлы предоставлены Дмитрием Орловым для выполнения задания.

## Файлы

### `servers.txt`
Список серверов для мониторинга.

**Формат:**
```
SERVER_NAME IP_ADDRESS
```

**Пример:**
```
shadow-server-01 185.192.45.118
shadow-server-02 185.192.45.119
```

## Как использовать

### Вариант 1: Копирование в рабочую директорию

```bash
cd ~/kernel-shadows/season-1-shell-foundations/episode-02-shell-scripting
cp artifacts/servers.txt .
```

### Вариант 2: Работа прямо в artifacts/

```bash
cd ~/kernel-shadows/season-1-shell-foundations/episode-02-shell-scripting/artifacts
# Создай здесь свой server_monitor.sh
```

### Вариант 3: Создание отдельной рабочей директории

```bash
mkdir ~/server_monitoring
cp ~/kernel-shadows/season-1-shell-foundations/episode-02-shell-scripting/artifacts/servers.txt ~/server_monitoring/
cd ~/server_monitoring
```

## Тестовые серверы

Для тестирования скрипта используются:
- **8.8.8.8** — Google DNS (должен быть доступен)
- **1.1.1.1** — Cloudflare DNS (должен быть доступен)
- **127.0.0.1** — localhost (должен быть доступен)
- **192.168.255.255** — несуществующий IP (недоступен)

Остальные IP — симуляция серверов операции KERNEL SHADOWS.

## Ожидаемые результаты

После запуска `server_monitor.sh` должны создаться:
- `monitor.log` — логи всех проверок
- `alerts.txt` — алерты о недоступных серверах

---

**LILITH:** *"Всё что нужно для работы — здесь. Дмитрий подготовил тестовое окружение. Покажи на что способен."*

