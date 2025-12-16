# 📦 RemnaSetup v2.6 - Модификация с поддержкой Geo файлов

## 📋 Список файлов проекта

```
remnasetup-modified/                     [47.5 KB total]
│
├── 📄 remnasetup.sh                     (12.0 KB)  - Модифицированный главный скрипт
├── 📄 apply-geo-patch.sh                (4.2 KB)   - Скрипт автоматической установки патча
│
├── 📚 Документация:
│   ├── README-GEO.md                    (6.9 KB)   - Полная документация по geo файлам
│   ├── QUICKSTART.md                    (5.2 KB)   - Быстрый старт
│   ├── MENU-STRUCTURE.txt               (8.1 KB)   - Визуализация структуры меню
│   └── INDEX.md                         (этот файл) - Сводка проекта
│
└── 📁 scripts/
    ├── 📁 remnanode/
    │   └── install-geo.sh               (8.3 KB)   - Скрипт управления geo файлами
    └── 📁 common/
        └── languages-geo-addon.sh       (2.8 KB)   - Переводы для нового функционала
```

## ✨ Что нового в версии 2.6?

### 🌍 Управление Geo файлами (НОВОЕ!)

Добавлен полноценный модуль для автоматического обновления географических баз данных:

**Возможности:**
- ✅ Автоматическая загрузка `geoip.dat` и `geosite.dat` из runetfreedom
- ✅ **Автоматический патчинг docker-compose.yml** (добавление volumes)
- ✅ Поддержка множественных нод (remnanode, remnanode2, remnanode3)
- ✅ Настройка автоматического обновления через cron
- ✅ Ручное обновление по требованию
- ✅ Просмотр логов обновления
- ✅ Резервное копирование docker-compose.yml перед изменением
- ✅ Автоматический пересоздание Docker контейнеров
- ✅ Полностью на русском и английском языках

**Важно:** Скрипт автоматически проверяет `docker-compose.yml` каждой ноды и при необходимости добавляет:
```yaml
volumes:
  - ./geoip.dat:/usr/local/share/xray/geoip.dat
  - ./geosite.dat:/usr/local/share/xray/geosite.dat
```

### 📍 Расположение в меню

```
Главное меню
  └─► 2. Установка/Обновление Remnanode
       └─► 8. 🌍 Управление Geo файлами ← ЗДЕСЬ
```

## 🚀 Быстрая установка

### Вариант 1: Новая установка RemnaSetup v2.6 (рекомендуется)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh)
```

### Вариант 2: Патч для существующей установки

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/apply-geo-patch.sh)
```

### Вариант 3: Клонирование репозитория

```bash
git clone -b dev https://github.com/1nFern0-git/RemnaSetup.git
cd RemnaSetup
sudo bash install.sh
```

## 📖 Документация

### 🎯 Быстрый старт
Файл: `QUICKSTART.md` (5.2 KB)
- Автоматическая установка одной командой
- Поэтапная установка
- Ручная настройка без меню
- Проверка установки
- Откат к оригинальной версии

### 📚 Полная документация
Файл: `README-GEO.md` (6.9 KB)
- Подробное описание всех возможностей
- Особенности работы с geo файлами
- Настройка автоматического обновления
- Логирование и отладка
- FAQ

### 🗺️ Структура меню
Файл: `MENU-STRUCTURE.txt` (8.1 KB)
- Визуальное представление всего меню
- ASCII-art структура проекта
- Описание нового функционала

## 🔧 Технические детали

### Создаваемые файлы

После установки модуль создаст:

```
/usr/local/bin/update-remnanode-geo.sh        - Скрипт обновления
/var/log/remnanode-geo-update.log             - Лог операций
/opt/remnanode/docker-compose.yml.backup-*    - Резервные копии конфигураций
```

### Изменяемые файлы

Модификация обновляет:

```
/opt/remnasetup/remnasetup.sh                      - Главный скрипт (новое меню)
/opt/remnasetup/scripts/common/languages.sh        - Добавлены переводы
/opt/remnasetup/scripts/remnanode/install-geo.sh   - Новый скрипт (создается)
/opt/remnanode/docker-compose.yml                  - Добавлены volumes (патчится)
/opt/remnanode2/docker-compose.yml                 - Добавлены volumes (патчится)
/opt/remnanode3/docker-compose.yml                 - Добавлены volumes (патчится)
```

### Cron задача

По умолчанию создается:

```cron
0 3 * * 0 /usr/local/bin/update-remnanode-geo.sh
```

Расшифровка: каждое воскресенье в 3:00 утра

## 🔒 Безопасность

### Резервное копирование

Скрипт `apply-geo-patch.sh` автоматически создает бэкап:

```
/opt/remnasetup-backup-YYYYMMDD-HHMMSS/
```

### Откат изменений

```bash
# Найти бэкапы
ls -la /opt/ | grep remnasetup-backup

# Восстановить из бэкапа
sudo rm -rf /opt/remnasetup
sudo mv /opt/remnasetup-backup-20250101-120000 /opt/remnasetup
```

## 📊 Статистика проекта

- **Всего файлов:** 7
- **Общий размер:** ~47.5 KB
- **Строк кода:** ~1200+
- **Языков:** 2 (русский, английский)
- **Совместимость:** Ubuntu 20.04+, Debian 10+

## 🔗 Источники

- **Оригинальный RemnaSetup:** https://github.com/Capybara-z/RemnaSetup
- **Geo базы runetfreedom:** https://github.com/runetfreedom/russia-v2ray-rules-dat
- **Контакты автора RemnaSetup:** [@KaTTuBaRa](https://t.me/KaTTuBaRa)

## 🎁 Бонус: Полезные команды

### Проверка работы

```bash
# Проверить установку
ls -la /opt/remnasetup/scripts/remnanode/install-geo.sh

# Проверить скрипт обновления
ls -la /usr/local/bin/update-remnanode-geo.sh

# Проверить cron
crontab -l | grep geo

# Посмотреть логи
tail -f /var/log/remnanode-geo-update.log

# Ручной запуск обновления
sudo /usr/local/bin/update-remnanode-geo.sh
```

### Управление

```bash
# Запуск RemnaSetup
cd /opt/remnasetup && sudo bash remnasetup.sh

# Быстрый доступ к geo меню
# Главное меню → 2 → 8

# Удаление автообновления
crontab -l | grep -v "geo" | crontab -

# Удаление скрипта
sudo rm /usr/local/bin/update-remnanode-geo.sh
```

## 💡 Примеры использования

### Сценарий 1: Первичная установка

```bash
1. Запустите RemnaSetup
2. Выберите: 2 (Remnanode) → 8 (Geo файлы) → 1 (Установить)
3. Дождитесь завершения
4. Выберите: 2 (Настроить автообновление)
```

### Сценарий 2: Ручное обновление

```bash
1. Запустите RemnaSetup
2. Выберите: 2 (Remnanode) → 8 (Geo файлы) → 3 (Ручное обновление)
3. Или из командной строки: sudo /usr/local/bin/update-remnanode-geo.sh
```

### Сценарий 3: Проверка логов

```bash
1. Запустите RemnaSetup
2. Выберите: 2 (Remnanode) → 8 (Geo файлы) → 4 (Показать лог)
3. Или из командной строки: tail -30 /var/log/remnanode-geo-update.log
```

## 🐛 Решение проблем

### Geo файлы не обновляются

```bash
# Проверьте доступ к GitHub
curl -I https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geoip.dat

# Проверьте права на скрипт
ls -la /usr/local/bin/update-remnanode-geo.sh

# Запустите вручную с выводом ошибок
sudo bash -x /usr/local/bin/update-remnanode-geo.sh
```

### Docker-compose.yml был изменен, как откатить?

```bash
# Найти резервную копию
ls -la /opt/remnanode/docker-compose.yml.backup-*

# Восстановить из бэкапа
sudo cp /opt/remnanode/docker-compose.yml.backup-20250101-120000 /opt/remnanode/docker-compose.yml

# Пересоздать контейнер
cd /opt/remnanode
sudo docker compose down
sudo docker compose up -d
```

### Cron не работает

```bash
# Проверьте службу cron
sudo systemctl status cron

# Перезапустите cron
sudo systemctl restart cron

# Проверьте задачу
crontab -l | grep geo
```

### Контейнеры не перезапускаются

```bash
# Проверьте Docker
sudo docker ps -a

# Проверьте имена контейнеров
sudo docker ps --format '{{.Names}}'

# Перезапустите вручную
cd /opt/remnanode
sudo docker compose down
sudo docker compose up -d
```

## 📜 Лицензия

MIT (как и оригинальный RemnaSetup)

## 🤝 Вклад

Этот проект является модификацией оригинального RemnaSetup.
Большая благодарность:
- **[@KaTTuBaRa](https://t.me/KaTTuBaRa)** - автор RemnaSetup
- **[runetfreedom](https://github.com/runetfreedom)** - поддержка geo баз

---

**Версия:** 2.6  
**Дата:** Декабрь 2024  
**Статус:** Стабильная

🌟 Если модификация была полезна - поставьте звезду оригинальному проекту!
