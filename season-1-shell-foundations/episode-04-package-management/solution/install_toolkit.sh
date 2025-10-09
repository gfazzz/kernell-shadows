#!/bin/bash

################################################################################
# OPERATION KERNEL SHADOWS
# Episode 04: Package Management
# Script: install_toolkit.sh
#
# Mission: Установить необходимые инструменты для операции
# Author: Max Sokolov
# Date: 5 октября 2025
#
# Description:
#   Автоматизированная установка security & networking инструментов
#   из списка required_tools.txt
################################################################################

# Строгий режим: остановка при ошибках
set -e          # Exit on error
set -u          # Exit on undefined variable
set -o pipefail # Exit on pipe failure


# === CONFIGURATION ===

TOOLS_FILE="${1:-required_tools.txt}"
LOG_FILE="install.log"
BACKUP_DIR="./backups"
REPORT_FILE="install_report.txt"

# Массивы для отслеживания результатов
declare -a INSTALLED_PACKAGES=()
declare -a FAILED_PACKAGES=()
declare -a SKIPPED_PACKAGES=()


# === COLORS (for terminal output) ===

COLOR_RESET="\033[0m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_RED="\033[0;31m"
COLOR_BLUE="\033[0;34m"
COLOR_CYAN="\033[0;36m"


# === FUNCTIONS ===

# Логирование с timestamp
log_message() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}

# Цветной вывод в терминал
print_colored() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${COLOR_RESET}"
}

# Проверка прав root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_colored "$COLOR_RED" "ERROR: This script must be run as root (use sudo)"
        log_message "ERROR: Script requires root privileges"
        exit 1
    fi
    log_message "Root privileges confirmed"
}

# Backup sources.list
backup_sources_list() {
    local backup_file="$BACKUP_DIR/sources.list.backup.$(date +%Y%m%d_%H%M%S)"

    if [[ -f /etc/apt/sources.list ]]; then
        mkdir -p "$BACKUP_DIR"
        cp /etc/apt/sources.list "$backup_file"
        print_colored "$COLOR_GREEN" "✓ Backup created: $backup_file"
        log_message "Backup created: $backup_file"
    else
        log_message "WARNING: /etc/apt/sources.list not found (might be OK on some systems)"
    fi
}

# Обновление списков пакетов
update_package_lists() {
    print_colored "$COLOR_CYAN" "Updating package lists..."
    log_message "Running apt update..."

    if apt update >> "$LOG_FILE" 2>&1; then
        print_colored "$COLOR_GREEN" "✓ Package lists updated"
        log_message "apt update successful"
    else
        print_colored "$COLOR_RED" "✗ Failed to update package lists"
        log_message "ERROR: apt update failed"
        exit 1
    fi
}

# Парсинг списка инструментов
parse_tools_list() {
    if [[ ! -f "$TOOLS_FILE" ]]; then
        print_colored "$COLOR_RED" "ERROR: $TOOLS_FILE not found"
        log_message "ERROR: $TOOLS_FILE not found"
        exit 1
    fi

    # Фильтрация:
    # - Строки, начинающиеся с # (комментарии)
    # - Пустые строки
    # - Берём первое слово (имя пакета)
    grep -v '^#' "$TOOLS_FILE" | \
    grep -v '^$' | \
    awk '{print $1}' | \
    grep -v '^$'
}

# Проверка, установлен ли пакет
check_package_installed() {
    local package="$1"
    dpkg -l | grep -q "^ii  $package " 2>/dev/null
}

# Получение версии установленного пакета
get_package_version() {
    local package="$1"
    dpkg -l | grep "^ii  $package " | awk '{print $3}'
}

# Установка пакета
install_package() {
    local package="$1"

    print_colored "$COLOR_BLUE" "Installing: $package"
    log_message "Installing package: $package"

    # Попытка установки
    if DEBIAN_FRONTEND=noninteractive apt install -y "$package" >> "$LOG_FILE" 2>&1; then
        local version
        version=$(get_package_version "$package")
        print_colored "$COLOR_GREEN" "  ✓ Installed: $package ($version)"
        log_message "SUCCESS: $package installed ($version)"
        INSTALLED_PACKAGES+=("$package:$version")
        return 0
    else
        print_colored "$COLOR_RED" "  ✗ Failed: $package"
        log_message "FAILED: $package installation failed"
        FAILED_PACKAGES+=("$package")
        return 1
    fi
}

# Генерация отчёта
generate_report() {
    {
        echo "========================================"
        echo "KERNEL SHADOWS - Installation Report"
        echo "========================================"
        echo ""
        echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Host: $(hostname)"
        echo "User: $(whoami)"
        echo "System: $(lsb_release -d | cut -f2-)"
        echo ""

        echo "--- INSTALLED PACKAGES ---"
        if [[ ${#INSTALLED_PACKAGES[@]} -gt 0 ]]; then
            for pkg in "${INSTALLED_PACKAGES[@]}"; do
                echo "  ✓ ${pkg//:/ (version: })"
            done
        else
            echo "  (none)"
        fi
        echo ""

        echo "--- SKIPPED PACKAGES (already installed) ---"
        if [[ ${#SKIPPED_PACKAGES[@]} -gt 0 ]]; then
            for pkg in "${SKIPPED_PACKAGES[@]}"; do
                echo "  ~ ${pkg//:/ (version: })"
            done
        else
            echo "  (none)"
        fi
        echo ""

        echo "--- FAILED PACKAGES ---"
        if [[ ${#FAILED_PACKAGES[@]} -gt 0 ]]; then
            for pkg in "${FAILED_PACKAGES[@]}"; do
                echo "  ✗ $pkg"
            done
        else
            echo "  (none)"
        fi
        echo ""

        echo "--- SUMMARY ---"
        echo "  Total packages processed: $(( ${#INSTALLED_PACKAGES[@]} + ${#SKIPPED_PACKAGES[@]} + ${#FAILED_PACKAGES[@]} ))"
        echo "  Newly installed: ${#INSTALLED_PACKAGES[@]}"
        echo "  Already installed: ${#SKIPPED_PACKAGES[@]}"
        echo "  Failed: ${#FAILED_PACKAGES[@]}"
        echo ""

        if [[ ${#FAILED_PACKAGES[@]} -eq 0 ]]; then
            echo "Status: SUCCESS ✓"
        else
            echo "Status: PARTIAL (some packages failed)"
        fi
        echo ""
        echo "========================================"

    } > "$REPORT_FILE"

    print_colored "$COLOR_GREEN" "Report generated: $REPORT_FILE"
    log_message "Report generated: $REPORT_FILE"
}

# Проверка работоспособности установленных пакетов
verify_installations() {
    print_colored "$COLOR_CYAN" "Verifying installations..."
    log_message "Verifying installed packages..."

    local verified=0
    local failed_verify=0

    for pkg_info in "${INSTALLED_PACKAGES[@]}"; do
        local package="${pkg_info%%:*}"

        # Пробуем запустить с --version или --help
        if command -v "$package" &> /dev/null; then
            if "$package" --version &> /dev/null || "$package" --help &> /dev/null; then
                ((verified++))
                log_message "VERIFY OK: $package"
            else
                ((failed_verify++))
                log_message "VERIFY FAILED: $package (command exists but cannot execute)"
            fi
        else
            # Некоторые пакеты не имеют команды с тем же именем (например, python3-pip)
            log_message "VERIFY SKIPPED: $package (no binary found)"
        fi
    done

    print_colored "$COLOR_GREEN" "  ✓ Verified: $verified packages"
    if [[ $failed_verify -gt 0 ]]; then
        print_colored "$COLOR_YELLOW" "  ⚠ Failed verification: $failed_verify packages"
    fi

    log_message "Verification complete: $verified OK, $failed_verify FAILED"
}

# Вывод статистики в терминал
print_summary() {
    echo ""
    print_colored "$COLOR_CYAN" "========================================"
    print_colored "$COLOR_CYAN" "INSTALLATION SUMMARY"
    print_colored "$COLOR_CYAN" "========================================"

    echo -e "${COLOR_GREEN}Newly installed:${COLOR_RESET} ${#INSTALLED_PACKAGES[@]}"
    echo -e "${COLOR_YELLOW}Already installed:${COLOR_RESET} ${#SKIPPED_PACKAGES[@]}"
    echo -e "${COLOR_RED}Failed:${COLOR_RESET} ${#FAILED_PACKAGES[@]}"

    echo ""
    echo "Detailed report: $REPORT_FILE"
    echo "Installation log: $LOG_FILE"
    echo ""

    if [[ ${#FAILED_PACKAGES[@]} -eq 0 ]]; then
        print_colored "$COLOR_GREEN" "All packages installed successfully! ✓"
    else
        print_colored "$COLOR_YELLOW" "Some packages failed. Check $LOG_FILE for details."
    fi
}


# === MAIN LOGIC ===

main() {
    # Заголовок
    print_colored "$COLOR_CYAN" "========================================"
    print_colored "$COLOR_CYAN" "KERNEL SHADOWS - Toolkit Installation"
    print_colored "$COLOR_CYAN" "========================================"
    echo ""

    # Инициализация лога
    > "$LOG_FILE"
    log_message "=== Installation started ==="
    log_message "Tools file: $TOOLS_FILE"

    # Проверки
    check_root

    # Backup
    backup_sources_list

    # Обновление
    update_package_lists

    # Парсинг списка
    local tools
    tools=$(parse_tools_list)
    local total
    total=$(echo "$tools" | wc -l)

    print_colored "$COLOR_CYAN" "Found $total packages to process"
    log_message "Found $total packages to process"
    echo ""

    # Установка
    local count=0
    while IFS= read -r package; do
        ((count++))
        echo -e "${COLOR_CYAN}[$count/$total]${COLOR_RESET}"

        if check_package_installed "$package"; then
            local version
            version=$(get_package_version "$package")
            print_colored "$COLOR_YELLOW" "  ~ Already installed: $package ($version)"
            log_message "SKIPPED: $package (already installed)"
            SKIPPED_PACKAGES+=("$package:$version")
        else
            install_package "$package" || true  # Continue on failure
        fi

        echo ""
    done <<< "$tools"

    # Отчёт
    generate_report

    # Проверка
    if [[ ${#INSTALLED_PACKAGES[@]} -gt 0 ]]; then
        verify_installations
    fi

    # Итоги
    print_summary

    log_message "=== Installation completed ==="

    # Exit code
    if [[ ${#FAILED_PACKAGES[@]} -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}


# === ENTRY POINT ===

main "$@"


