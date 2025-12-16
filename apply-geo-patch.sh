#!/bin/bash

# Скрипт для автоматического добавления функционала Geo файлов в RemnaSetup
# Использование: sudo bash apply-geo-patch.sh

if [ "$(id -u)" != "0" ]; then
    echo "❌ Этот скрипт должен быть запущен с правами root"
    echo "❌ This script must be run as root"
    exit 1
fi

REMNASETUP_DIR="/opt/remnasetup"
BACKUP_DIR="/opt/remnasetup-backup-$(date +%Y%m%d-%H%M%S)"

echo "🔍 Проверка установки RemnaSetup..."

if [ ! -d "$REMNASETUP_DIR" ]; then
    echo "❌ RemnaSetup не установлен в $REMNASETUP_DIR"
    echo "❌ RemnaSetup is not installed in $REMNASETUP_DIR"
    exit 1
fi

echo "✅ RemnaSetup найден"

# Создаем бэкап
echo "💾 Создание резервной копии..."
cp -r "$REMNASETUP_DIR" "$BACKUP_DIR"
echo "✅ Резервная копия создана: $BACKUP_DIR"

# Определяем директорию со скриптами
SCRIPT_SOURCE_DIR="$(dirname "$(readlink -f "$0")")"

echo "📥 Установка новых файлов..."

# Копируем скрипт управления geo файлами
if [ -f "$SCRIPT_SOURCE_DIR/scripts/remnanode/install-geo.sh" ]; then
    cp "$SCRIPT_SOURCE_DIR/scripts/remnanode/install-geo.sh" \
       "$REMNASETUP_DIR/scripts/remnanode/install-geo.sh"
    chmod +x "$REMNASETUP_DIR/scripts/remnanode/install-geo.sh"
    echo "✅ Скрипт install-geo.sh установлен"
else
    echo "❌ Файл install-geo.sh не найден"
    exit 1
fi

# Добавляем переводы
if [ -f "$SCRIPT_SOURCE_DIR/scripts/common/languages-geo-addon.sh" ]; then
    echo "" >> "$REMNASETUP_DIR/scripts/common/languages.sh"
    echo "# === GEO FILES ADDON ===" >> "$REMNASETUP_DIR/scripts/common/languages.sh"
    cat "$SCRIPT_SOURCE_DIR/scripts/common/languages-geo-addon.sh" >> "$REMNASETUP_DIR/scripts/common/languages.sh"
    echo "✅ Переводы добавлены"
else
    echo "❌ Файл languages-geo-addon.sh не найден"
    exit 1
fi

# Обновляем главный скрипт
if [ -f "$SCRIPT_SOURCE_DIR/remnasetup.sh" ]; then
    cp "$SCRIPT_SOURCE_DIR/remnasetup.sh" "$REMNASETUP_DIR/remnasetup.sh"
    chmod +x "$REMNASETUP_DIR/remnasetup.sh"
    echo "✅ Главный скрипт обновлен"
else
    echo "❌ Файл remnasetup.sh не найден"
    exit 1
fi

# Установка прав
if [ -n "$SUDO_USER" ]; then
    REAL_USER="$SUDO_USER"
elif [ -n "$USER" ] && [ "$USER" != "root" ]; then
    REAL_USER="$USER"
else
    REAL_USER=$(getent passwd 2>/dev/null | awk -F: '$3 >= 1000 && $3 < 65534 && $1 != "nobody" {print $1; exit}')
    if [ -z "$REAL_USER" ]; then
        REAL_USER="root"
    fi
fi

chown -R "$REAL_USER:$REAL_USER" "$REMNASETUP_DIR"
chmod -R 755 "$REMNASETUP_DIR"
chmod +x "$REMNASETUP_DIR"/*.sh
chmod +x "$REMNASETUP_DIR"/scripts/*/*.sh

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "✅ Установка завершена успешно!"
echo "✅ Installation completed successfully!"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "📋 Что изменилось / What's new:"
echo "   • Добавлен пункт 'Управление Geo файлами' в меню Remnanode"
echo "   • Added 'Geo Files Management' menu item in Remnanode menu"
echo ""
echo "🚀 Запуск / Launch:"
echo "   cd /opt/remnasetup && sudo bash remnasetup.sh"
echo ""
echo "💾 Резервная копия / Backup:"
echo "   $BACKUP_DIR"
echo ""
echo "🔄 Откат изменений / Rollback:"
echo "   sudo rm -rf $REMNASETUP_DIR"
echo "   sudo mv $BACKUP_DIR $REMNASETUP_DIR"
echo ""
echo "═══════════════════════════════════════════════════════════"
