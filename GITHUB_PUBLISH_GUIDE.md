# 📝 Инструкция по публикации в GitHub

## Шаг 1: Подготовка репозитория

### Вариант A: Новый репозиторий (рекомендуется)

```bash
# Создайте новый репозиторий на GitHub:
# Имя: RemnaSetup-GeoMod
# Описание: RemnaSetup with automatic geo files management and docker-compose.yml patching

# Клонируйте и добавьте файлы
git clone https://github.com/ваш-username/RemnaSetup-GeoMod.git
cd RemnaSetup-GeoMod

# Распакуйте модификацию
tar -xzf remnasetup-geo-mod.tar.gz
cp -r remnasetup-modified/* .
rm -rf remnasetup-modified

# Создайте .gitignore
cat > .gitignore << 'EOF'
*.backup
*.log
*.tmp
.DS_Store
*.swp
*~
EOF
```

### Вариант B: Fork оригинального репозитория

```bash
# Сделайте fork на GitHub:
# https://github.com/Capybara-z/RemnaSetup → Fork

# Клонируйте свой fork
git clone https://github.com/ваш-username/RemnaSetup.git
cd RemnaSetup

# Создайте новую ветку
git checkout -b feature/geo-files-management

# Добавьте файлы модификации
tar -xzf remnasetup-geo-mod.tar.gz
cp -r remnasetup-modified/scripts/remnanode/install-geo.sh scripts/remnanode/
cp remnasetup-modified/scripts/common/languages-geo-addon.sh scripts/common/
cp remnasetup-modified/remnasetup.sh .
cp remnasetup-modified/apply-geo-patch.sh .
cp remnasetup-modified/*.md .
```

---

## Шаг 2: Создание коммита

```bash
# Добавьте все файлы
git add .

# Создайте коммит (используя подготовленное сообщение)
git commit -F COMMIT_MESSAGE.md

# Или кратко:
git commit -m "feat: Add automatic geo files management with docker-compose.yml patching

Added comprehensive geo files management system for Remnanode with automatic
docker-compose.yml patching capability.

See RELEASE_NOTES.md for details."
```

---

## Шаг 3: Push в GitHub

```bash
# Отправьте изменения
git push origin main

# Или если создали ветку:
git push origin feature/geo-files-management
```

---

## Шаг 4: Создание Pull Request (если это fork)

1. Перейдите на GitHub в свой fork
2. Нажмите "Compare & pull request"
3. Заполните описание:

**Title:**
```
feat: Add automatic geo files management with docker-compose patching
```

**Description:**
```markdown
## 🌍 New Feature: Geo Files Management Module

This PR adds comprehensive geo files management system for Remnanode with automatic docker-compose.yml patching.

### What's Added
- Automatic docker-compose.yml volumes patching
- Geo files auto-update from runetfreedom
- Multi-node support (remnanode, remnanode2, remnanode3)
- Weekly automatic updates via cron
- Comprehensive logging system
- Full Russian and English localization

### Technical Details
- New script: `scripts/remnanode/install-geo.sh`
- New menu item: Remnanode → Geo Files Management
- Automatic backup before config changes
- Smart volume detection

### Documentation
- README-GEO.md - Full documentation
- QUICKSTART.md - Installation guide
- CHANGELOG-VOLUMES.md - Technical details
- VISUAL-GUIDE.txt - Workflow diagrams

### Testing
Tested on Ubuntu 20.04/22.04/24.04 and Debian 11/12

### Breaking Changes
None. Fully backward compatible.

Closes #XXX (if there's an issue)
```

---

## Шаг 5: Создание Release на GitHub

### 5.1 Создание тега

```bash
# Создайте тег для релиза
git tag -a v2.6 -m "RemnaSetup v2.6 - Geo Files Management"

# Отправьте тег
git push origin v2.6
```

### 5.2 Создание Release на GitHub

1. Перейдите в свой репозиторий на GitHub
2. Нажмите "Releases" → "Draft a new release"
3. Заполните форму:

**Tag:** `v2.6`

**Release title:** `v2.6 - Geo Files Management 🌍`

**Description:** (скопируйте из RELEASE_NOTES.md)

**Files to attach:**
- ✅ `remnasetup-geo-mod.tar.gz` - Main package

4. Отметьте:
   - ☐ This is a pre-release (не отмечайте, это стабильная версия)
   - ☑ Set as the latest release

5. Нажмите "Publish release"

---

## Шаг 6: Обновление README.md

Добавьте в основной README.md информацию о новом функционале:

```markdown
## 🌍 Geo Files Management (NEW in v2.6!)

RemnaSetup now includes automatic geo files management for Remnanode with smart docker-compose.yml patching.

**Features:**
- ✅ Automatic docker-compose.yml volumes configuration
- ✅ Weekly geo files updates from runetfreedom
- ✅ Multi-node support
- ✅ One-click installation

**Quick Start:**
```bash
# Access through menu
RemnaSetup → 2. Remnanode → 8. 🌍 Geo Files Management
```

**Documentation:**
- [Full Documentation](README-GEO.md)
- [Quick Start Guide](QUICKSTART.md)
- [Visual Guide](VISUAL-GUIDE.txt)
```

---

## Шаг 7: Объявление о релизе

### GitHub Discussions
Создайте обсуждение в разделе Announcements:

**Title:** `🎉 v2.6 Released - Automatic Geo Files Management`

**Content:**
```markdown
We're excited to announce **RemnaSetup v2.6** with automatic geo files management!

🌍 **What's New:**
- Automatic docker-compose.yml patching
- Weekly geo files updates
- Multi-node support
- Comprehensive logging

📦 **Download:** [v2.6 Release](https://github.com/your-repo/releases/tag/v2.6)
📚 **Docs:** [README-GEO.md](README-GEO.md)

Feedback welcome! 🚀
```

### Telegram (если есть канал)
```
🎉 RemnaSetup v2.6 Released!

Добавлена автоматическая система управления geo файлами:
• Автопатчинг docker-compose.yml
• Еженедельное обновление
• Поддержка множественных нод

Скачать: [ссылка на GitHub Release]
Документация: [ссылка на README-GEO.md]

#RemnaSetup #Update #GeoFiles
```

---

## Шаг 8: Проверка

После публикации проверьте:

- ✅ Релиз виден на странице Releases
- ✅ Архив можно скачать
- ✅ README обновлен с новой информацией
- ✅ Все ссылки работают
- ✅ Документация доступна

---

## Структура итогового репозитория

```
RemnaSetup-GeoMod/
├── README.md (обновленный)
├── README-GEO.md (новый)
├── QUICKSTART.md (новый)
├── CHANGELOG-VOLUMES.md (новый)
├── VISUAL-GUIDE.txt (новый)
├── INDEX.md (новый)
├── MENU-STRUCTURE.txt (новый)
├── install.sh
├── remnasetup.sh (модифицированный)
├── apply-geo-patch.sh (новый)
└── scripts/
    ├── common/
    │   ├── colors.sh
    │   ├── functions.sh
    │   ├── languages.sh (модифицированный)
    │   └── languages-geo-addon.sh (новый)
    ├── remnawave/
    │   └── ...
    ├── remnanode/
    │   ├── install-node.sh
    │   ├── install-caddy.sh
    │   ├── install-geo.sh (новый) ⭐
    │   └── ...
    └── backups/
        └── ...
```

---

## Команды для копирования

### Полный процесс для нового репозитория:

```bash
# 1. Создайте репозиторий на GitHub
# 2. Клонируйте
git clone https://github.com/ваш-username/RemnaSetup-GeoMod.git
cd RemnaSetup-GeoMod

# 3. Распакуйте файлы
tar -xzf /path/to/remnasetup-geo-mod.tar.gz
cp -r remnasetup-modified/* .
rm -rf remnasetup-modified

# 4. Создайте .gitignore
echo -e "*.backup\n*.log\n*.tmp\n.DS_Store" > .gitignore

# 5. Коммит
git add .
git commit -m "feat: Initial release with geo files management

RemnaSetup v2.6 with automatic geo files management and docker-compose.yml patching"

# 6. Push
git push origin main

# 7. Создайте тег
git tag -a v2.6 -m "RemnaSetup v2.6 - Geo Files Management"
git push origin v2.6

# 8. Создайте Release на GitHub с файлом remnasetup-geo-mod.tar.gz
```

---

## 📞 Поддержка

Если возникли вопросы при публикации:
- Telegram: [@KaTTuBaRa](https://t.me/KaTTuBaRa)
- GitHub Issues: в вашем репозитории
- Оригинальный проект: https://github.com/Capybara-z/RemnaSetup

---

**Удачной публикации! 🚀**
