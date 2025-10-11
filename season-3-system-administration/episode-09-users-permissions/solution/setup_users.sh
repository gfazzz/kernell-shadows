#!/bin/bash

################################################################################
# EPISODE 09: USERS & PERMISSIONS — Минимальный скрипт создания пользователей
# Season 3: System Administration
#
# Локация: Санкт-Петербург, Россия (ЛЭТИ)
# Ментор: Андрей Волков
# Миссия: Создать пользователей и группы для операции KERNEL SHADOWS
#
# ⚠️ ЭТОТ СКРИПТ ДЕЛАЕТ ТОЛЬКО:
#   ✅ Создание пользователей (useradd)
#   ✅ Создание групп (groupadd)
#   ✅ Добавление в группы (usermod -aG)
#
# ❌ ЭТОТ СКРИПТ НЕ ДЕЛАЕТ:
#   ❌ Конфигурацию sudo (это делается через /etc/sudoers.d/)
#   ❌ Настройку ACL (это делается вручную через setfacl)
#   ❌ Настройку PAM (это /etc/pam.d/)
#   ❌ Настройку limits (это /etc/security/limits.conf)
#
# Философия: "useradd exists — use it, don't rewrite it"
# Bash только для АВТОМАТИЗАЦИИ, не для ЗАМЕНЫ системных инструментов.
################################################################################

set -euo pipefail  # Строгий режим: остановка при ошибках

# Цвета для вывода
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m' # No Color

# Конфигурация
readonly USERS=("viktor" "alex" "anna" "dmitry")
readonly TEMP_PASSWORD="TempPass123!"

# Определение групп и их участников
declare -A GROUPS
GROUPS["operations"]="viktor dmitry"
GROUPS["security"]="alex anna"
GROUPS["forensics"]="anna"
GROUPS["devops"]="dmitry"
GROUPS["netadmin"]="alex"

################################################################################
# Функция: Создание пользователя
################################################################################
create_user() {
    local username="$1"

    # Проверка существования
    if id "$username" &>/dev/null; then
        echo -e "${YELLOW}⚠️  Пользователь $username уже существует, пропускаем${NC}"
        return 0
    fi

    echo "Создаю пользователя: $username"

    # Создать пользователя с home директорией и bash shell
    sudo useradd -m -s /bin/bash -c "KERNEL SHADOWS Team Member" "$username"

    # Установить временный пароль (нужно сменить при первом входе)
    echo "$username:$TEMP_PASSWORD" | sudo chpasswd

    # Принудительная смена пароля при первом входе
    sudo chage -d 0 "$username"

    # Установить политику паролей (90 дней)
    sudo chage -M 90 "$username"

    echo -e "${GREEN}✓ Пользователь $username создан${NC}"
}

################################################################################
# Функция: Создание группы и добавление участников
################################################################################
create_group_with_members() {
    local group_name="$1"
    local members="$2"

    # Создать группу если не существует
    if ! getent group "$group_name" &>/dev/null; then
        sudo groupadd "$group_name"
        echo -e "${GREEN}✓ Группа $group_name создана${NC}"
    else
        echo -e "${YELLOW}⚠️  Группа $group_name уже существует${NC}"
    fi

    # Добавить участников
    for member in $members; do
        if id "$member" &>/dev/null; then
            sudo usermod -aG "$group_name" "$member"
            echo "  ✓ Добавлен $member в группу $group_name"
        else
            echo -e "${YELLOW}  ⚠️  Пользователь $member не существует, пропускаем${NC}"
        fi
    done
}

################################################################################
# Главная функция
################################################################################
main() {
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║  EPISODE 09: Создание пользователей и групп           ║"
    echo "║  Операция KERNEL SHADOWS                               ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo

    # Создать пользователей
    echo "=== Шаг 1: Создание пользователей ==="
    for user in "${USERS[@]}"; do
        create_user "$user"
    done
    echo

    # Создать группы и добавить участников
    echo "=== Шаг 2: Создание групп и добавление участников ==="
    for group_name in "${!GROUPS[@]}"; do
        create_group_with_members "$group_name" "${GROUPS[$group_name]}"
    done
    echo

    # Проверка членства в группах
    echo "=== Проверка членства в группах ==="
    for user in "${USERS[@]}"; do
        if id "$user" &>/dev/null; then
            echo "$user: $(groups "$user" | cut -d: -f2)"
        fi
    done
    echo

    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  Пользователи и группы созданы!                       ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo
    echo "📝 Следующие шаги:"
    echo "   1. Настрой sudo: скопируй sudoers.d/* в /etc/sudoers.d/"
    echo "   2. Настрой ACL для Anna: setfacl -m u:anna:r /var/log/*"
    echo "   3. Создай shared directory: /var/operations/shared"
    echo "   4. Проверь security/limits.conf и pam.d/common-session"
}

# Запуск
main "$@"

