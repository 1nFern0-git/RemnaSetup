# RemnaSetup - Модификация с поддержкой Geo файлов

## 🌍 Что нового?

Добавлен новый пункт меню **"Управление Geo файлами"** в раздел Remnanode для автоматического обновления `geoip.dat` и `geosite.dat` из репозитория runetfreedom.

## 🎯 Возможности

### Новое меню "Управление Geo файлами":
1. **Установить/Обновить geo файлы** - первичная установка файлов
2. **Настроить автоматическое обновление** - настройка cron для еженедельного обновления
3. **Запустить ручное обновление** - обновление по требованию
4. **Показать лог обновления** - просмотр последних операций
5. **Показать расписание cron** - проверка настроенных задач
6. **Удалить автоматическое обновление** - очистка cron

## 📥 Установка

### Вариант 1: Модификация существующей установки

```bash
# Скачиваем новый скрипт управления geo файлами
sudo wget -O /opt/remnasetup/scripts/remnanode/install-geo.sh \
  https://raw.githubusercontent.com/ваш-репозиторий/install-geo.sh

# Делаем исполняемым
sudo chmod +x /opt/remnasetup/scripts/remnanode/install-geo.sh

# Добавляем переводы в languages.sh
sudo cat languages-geo-addon.sh >> /opt/remnasetup/scripts/common/languages.sh

# Заменяем основной скрипт
sudo cp remnasetup.sh /opt/remnasetup/remnasetup.sh
sudo chmod +x /opt/remnasetup/remnasetup.sh
```

### Вариант 2: Чистая установка

Если вы устанавливаете RemnaSetup впервые, используйте модифицированную версию:

```bash
# Клонируйте модифицированный репозиторий
git clone https://github.com/ваш-репозиторий/RemnaSetup-modified.git
cd RemnaSetup-modified

# Запустите установку
sudo bash install.sh
```

## 🔧 Ручная настройка (если нужно)

Если вы хотите настроить обновление geo файлов вручную:

```bash
# Создаем скрипт обновления
sudo nano /usr/local/bin/update-remnanode-geo.sh
# (вставьте содержимое скрипта)

# Делаем исполняемым
sudo chmod +x /usr/local/bin/update-remnanode-geo.sh

# Настраиваем автоматическое обновление (каждое воскресенье в 3:00)
sudo crontab -e
# Добавьте строку:
# 0 3 * * 0 /usr/local/bin/update-remnanode-geo.sh

# Первый запуск
sudo /usr/local/bin/update-remnanode-geo.sh
```

## 📝 Файлы проекта

```
remnasetup-modified/
├── remnasetup.sh                          # Модифицированный главный скрипт
├── scripts/
│   ├── remnanode/
│   │   └── install-geo.sh                 # Скрипт управления geo файлами
│   └── common/
│       └── languages-geo-addon.sh         # Дополнительные переводы
└── README-GEO.md                          # Эта инструкция
```

## 🌟 Особенности

### Автоматическое обновление
- Обновление происходит каждое воскресенье в 3:00 ночи
- Скачивание файлов из официального репозитория runetfreedom
- **Автоматическое добавление volumes в docker-compose.yml** (если их нет)
- Автоматический пересоздание контейнеров после обновления конфигурации
- Поддержка множественных нод (remnanode, remnanode2, remnanode3)

### Патчинг docker-compose.yml
Скрипт автоматически проверяет и при необходимости добавляет в `docker-compose.yml`:
```yaml
volumes:
  - ./geoip.dat:/usr/local/share/xray/geoip.dat
  - ./geosite.dat:/usr/local/share/xray/geosite.dat
```
- Создает резервную копию перед изменением
- Проверяет наличие volumes для geo файлов
- Добавляет только если их нет
- Пересоздает контейнер для применения изменений

### Логирование
- Все операции записываются в `/var/log/remnanode-geo-update.log`
- Удобный просмотр через меню скрипта
- Отметки времени для каждой операции
- Логирование патчинга docker-compose.yml

### Безопасность
- Скачивание во временную директорию
- Резервные копии docker-compose.yml перед изменением
- Проверка успешности загрузки перед применением
- Автоматическая очистка временных файлов

## 🔗 Источник geo файлов

Файлы загружаются из репозитория:
- **geoip.dat**: https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geoip.dat
- **geosite.dat**: https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geosite.dat

## 📊 Расположение файлов

После обновления geo файлы будут находиться в:
- `/opt/remnanode/geoip.dat`
- `/opt/remnanode/geosite.dat`
- `/opt/remnanode2/geoip.dat` (если установлена вторая нода)
- `/opt/remnanode2/geosite.dat`
- `/opt/remnanode3/geoip.dat` (если установлена третья нода)
- `/opt/remnanode3/geosite.dat`

## 🔍 Проверка работы

После установки проверьте:

```bash
# Проверка наличия скрипта
ls -la /usr/local/bin/update-remnanode-geo.sh

# Проверка cron задачи
crontab -l | grep geo

# Просмотр лога
tail -f /var/log/remnanode-geo-update.log

# Ручной запуск для теста
sudo /usr/local/bin/update-remnanode-geo.sh
```

## ❓ FAQ

**Q: Как часто обновляются geo файлы?**
A: По умолчанию раз в неделю (воскресенье, 3:00). Можно настроить другое расписание через меню.

**Q: Что произойдет с моим docker-compose.yml?**
A: Скрипт автоматически проверит наличие volumes для geo файлов. Если их нет - добавит. Перед изменением создается резервная копия с именем `docker-compose.yml.backup-YYYYMMDD-HHMMSS`.

**Q: Будут ли перезапускаться контейнеры?**
A: Да. При первом запуске контейнеры будут пересозданы (down + up) для применения новых volumes. При последующих обновлениях - только restart если volumes уже есть.

**Q: Что делать если обновление не работает?**
A: Проверьте лог `/var/log/remnanode-geo-update.log` и убедитесь, что сервер имеет доступ к GitHub.

**Q: Можно ли отключить автоматическое обновление?**
A: Да, используйте пункт меню "Удалить автоматическое обновление".

**Q: Где найти резервные копии docker-compose.yml?**
A: В директории каждой ноды: `/opt/remnanode/docker-compose.yml.backup-*`

## 📧 Контакты

- Оригинальный RemnaSetup: [@KaTTuBaRa](https://t.me/KaTTuBaRa)
- Geo файлы: [runetfreedom/russia-v2ray-rules-dat](https://github.com/runetfreedom/russia-v2ray-rules-dat)

## 📄 Лицензия

MIT (как и оригинальный RemnaSetup)

---

**Версия:** 2.6 (RemnaSetup + Geo Files Management)
