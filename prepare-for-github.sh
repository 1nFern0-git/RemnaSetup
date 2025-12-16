#!/bin/bash

# Скрипт для автоматической подготовки файлов к публикации в GitHub

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  RemnaSetup GeoMod - GitHub Publication Preparation Script    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Функция для вывода сообщений
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
    exit 1
}

# Проверка что мы в правильной директории
if [ ! -f "remnasetup.sh" ]; then
    error "Запустите скрипт из корневой директории проекта (где находится remnasetup.sh)"
fi

# Проверка наличия git
if ! command -v git &> /dev/null; then
    error "Git не установлен. Установите: sudo apt install git"
fi

echo ""
info "Начало подготовки к публикации..."
echo ""

# 1. Проверка структуры файлов
info "Шаг 1/7: Проверка структуры файлов..."
required_files=(
    "remnasetup.sh"
    "apply-geo-patch.sh"
    "scripts/remnanode/install-geo.sh"
    "scripts/common/languages-geo-addon.sh"
    "README-GEO.md"
    "QUICKSTART.md"
    "COMMIT_MESSAGE.md"
    "RELEASE_NOTES.md"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        success "Найден: $file"
    else
        error "Отсутствует: $file"
    fi
done

# 2. Создание .gitignore
info "Шаг 2/7: Создание .gitignore..."
cat > .gitignore << 'EOF'
# Backups
*.backup
*.backup-*

# Logs
*.log
/var/log/

# Temporary files
*.tmp
*.temp
/tmp/

# OS files
.DS_Store
Thumbs.db

# Editor files
*.swp
*.swo
*~
.vscode/
.idea/

# Build artifacts
*.tar.gz
*.zip
dist/
build/

# Local configuration
.env
.env.local
EOF
success "Создан .gitignore"

# 3. Проверка прав на исполнение
info "Шаг 3/7: Проверка прав на исполнение скриптов..."
chmod +x remnasetup.sh
chmod +x apply-geo-patch.sh
chmod +x scripts/remnanode/install-geo.sh
chmod +x scripts/common/*.sh
chmod +x scripts/remnawave/*.sh
chmod +x scripts/backups/*.sh
success "Права на исполнение установлены"

# 4. Создание архива релиза
info "Шаг 4/7: Создание архива для релиза..."
RELEASE_NAME="remnasetup-geomod-v2.6"
tar -czf "${RELEASE_NAME}.tar.gz" \
    --exclude='.git' \
    --exclude='*.backup*' \
    --exclude='*.log' \
    --exclude="${RELEASE_NAME}.tar.gz" \
    .
success "Создан архив: ${RELEASE_NAME}.tar.gz"

# 5. Создание checksums
info "Шаг 5/7: Создание контрольных сумм..."
sha256sum "${RELEASE_NAME}.tar.gz" > "${RELEASE_NAME}.tar.gz.sha256"
md5sum "${RELEASE_NAME}.tar.gz" > "${RELEASE_NAME}.tar.gz.md5"
success "Созданы контрольные суммы"

# 6. Генерация информации о версии
info "Шаг 6/7: Генерация информации о версии..."
cat > VERSION.txt << EOF
RemnaSetup GeoMod Version Information
=====================================

Version: 2.6
Release Date: $(date +%Y-%m-%d)
Build Date: $(date +%Y-%m-%d\ %H:%M:%S)

Components:
- RemnaSetup Core: 2.5 (base)
- Geo Files Management: 2.6 (new)
- Docker Compose Patching: 2.6 (new)

Features:
- Automatic docker-compose.yml patching
- Geo files auto-update system
- Multi-node support
- Weekly cron scheduling
- Comprehensive logging
- Bilingual interface (RU/EN)

Sources:
- Original RemnaSetup: https://github.com/Capybara-z/RemnaSetup
- Geo Files: https://github.com/runetfreedom/russia-v2ray-rules-dat

Checksums:
SHA256: $(cat ${RELEASE_NAME}.tar.gz.sha256)
MD5: $(cat ${RELEASE_NAME}.tar.gz.md5)
EOF
success "Создан VERSION.txt"

# 7. Подготовка сообщения для коммита
info "Шаг 7/7: Подготовка файлов для Git..."

# Создание упрощенной версии commit message для использования в команде
cat > .git-commit-msg.txt << 'EOF'
feat: Add automatic geo files management with docker-compose.yml patching

Added comprehensive geo files management system for Remnanode with automatic
docker-compose.yml patching capability.

Features:
- Automatic docker-compose.yml volumes patching
- Geo files auto-update from runetfreedom repository
- Multi-node support (remnanode, remnanode2, remnanode3)
- Weekly automatic updates via cron
- Comprehensive logging system
- Backup creation before changes
- Full RU/EN localization

New Components:
- scripts/remnanode/install-geo.sh
- scripts/common/languages-geo-addon.sh
- Modified remnasetup.sh (new menu item)

Documentation:
- README-GEO.md
- QUICKSTART.md
- CHANGELOG-VOLUMES.md
- VISUAL-GUIDE.txt

Breaking Changes: None
Backward Compatible: Yes

Version: 2.6
EOF
success "Подготовлено сообщение для коммита"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                 Подготовка завершена успешно!                  ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}Следующие шаги:${NC}"
echo ""
echo "1. Инициализировать Git репозиторий (если еще не сделано):"
echo -e "   ${BLUE}git init${NC}"
echo ""
echo "2. Добавить удаленный репозиторий:"
echo -e "   ${BLUE}git remote add origin https://github.com/ваш-username/RemnaSetup-GeoMod.git${NC}"
echo ""
echo "3. Добавить все файлы:"
echo -e "   ${BLUE}git add .${NC}"
echo ""
echo "4. Создать коммит:"
echo -e "   ${BLUE}git commit -F .git-commit-msg.txt${NC}"
echo ""
echo "5. Отправить в GitHub:"
echo -e "   ${BLUE}git branch -M main${NC}"
echo -e "   ${BLUE}git push -u origin main${NC}"
echo ""
echo "6. Создать тег для релиза:"
echo -e "   ${BLUE}git tag -a v2.6 -m \"RemnaSetup v2.6 - Geo Files Management\"${NC}"
echo -e "   ${BLUE}git push origin v2.6${NC}"
echo ""
echo "7. Создать Release на GitHub:"
echo "   - Перейдите в Releases → Draft a new release"
echo "   - Tag: v2.6"
echo "   - Title: v2.6 - Geo Files Management 🌍"
echo "   - Description: скопируйте из RELEASE_NOTES.md"
echo "   - Прикрепите файл: ${RELEASE_NAME}.tar.gz"
echo ""
echo -e "${YELLOW}Созданные файлы:${NC}"
echo "  📦 ${RELEASE_NAME}.tar.gz (архив релиза)"
echo "  🔒 ${RELEASE_NAME}.tar.gz.sha256 (контрольная сумма SHA256)"
echo "  🔒 ${RELEASE_NAME}.tar.gz.md5 (контрольная сумма MD5)"
echo "  📄 VERSION.txt (информация о версии)"
echo "  📝 .git-commit-msg.txt (сообщение для коммита)"
echo "  🚫 .gitignore (исключения для Git)"
echo ""
echo -e "${GREEN}Готово! Удачной публикации! 🚀${NC}"
