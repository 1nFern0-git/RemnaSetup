# 🔄 ОБНОВЛЕНИЕ v2.6 - Автоматический патчинг docker-compose.yml

## ⚡ КЛЮЧЕВОЕ ИЗМЕНЕНИЕ

Скрипт теперь **автоматически добавляет volumes** в docker-compose.yml каждой ноды!

### 🎯 Что это значит?

В оригинальной установке RemnaSetup файл `docker-compose.yml` выглядит так:

```yaml
services:
  remnanode:
    volumes:
      - /var/log/remnanode:/var/log/remnanode
      # ❌ НЕТ geo файлов!
```

Наш скрипт **автоматически** добавит:

```yaml
services:
  remnanode:
    volumes:
      - /var/log/remnanode:/var/log/remnanode
      - ./geoip.dat:/usr/local/share/xray/geoip.dat      # ✅ ДОБАВЛЕНО
      - ./geosite.dat:/usr/local/share/xray/geosite.dat  # ✅ ДОБАВЛЕНО
```

## 🛡️ Безопасность

**Резервное копирование:**
- Перед изменением создается `docker-compose.yml.backup-YYYYMMDD-HHMMSS`
- Можно откатить изменения в любой момент

**Умная проверка:**
- Скрипт проверяет наличие volumes для geo файлов
- Если уже есть - пропускает патчинг
- Добавляет только если отсутствуют

## 🔄 Процесс работы

1. **Первый запуск** (пункт меню 1 "Установить geo файлы"):
   ```
   ✓ Проверка docker-compose.yml
   ✓ Создание резервной копии
   ✓ Добавление volumes (если нужно)
   ✓ Скачивание geoip.dat и geosite.dat
   ✓ Копирование в /opt/remnanode/
   ✓ Пересоздание контейнера (down + up)
   ```

2. **Последующие обновления**:
   ```
   ✓ Проверка docker-compose.yml (volumes уже есть)
   ✓ Скачивание новых geoip.dat и geosite.dat
   ✓ Копирование в /opt/remnanode/
   ✓ Restart контейнера (быстрый перезапуск)
   ```

## 📂 Резервные копии

После патчинга в директории ноды появятся:

```
/opt/remnanode/
├── docker-compose.yml                    # Текущий (с volumes)
├── docker-compose.yml.backup-20250101    # Бэкап 1
├── docker-compose.yml.backup-20250102    # Бэкап 2
├── geoip.dat
└── geosite.dat
```

## 🔧 Откат изменений

Если что-то пошло не так:

```bash
# 1. Найти резервную копию
ls -la /opt/remnanode/docker-compose.yml.backup-*

# 2. Восстановить
sudo cp /opt/remnanode/docker-compose.yml.backup-20250101-120000 \
        /opt/remnanode/docker-compose.yml

# 3. Пересоздать контейнер
cd /opt/remnanode
sudo docker compose down
sudo docker compose up -d
```

## ✅ Проверка

Убедитесь, что volumes добавлены:

```bash
# Проверить docker-compose.yml
cat /opt/remnanode/docker-compose.yml | grep -A2 "volumes:"

# Должно показать:
    volumes:
      - /var/log/remnanode:/var/log/remnanode
      - ./geoip.dat:/usr/local/share/xray/geoip.dat
      - ./geosite.dat:/usr/local/share/xray/geosite.dat
```

## 🎉 Преимущества

- ✅ **Автоматизация**: не нужно вручную редактировать docker-compose.yml
- ✅ **Безопасность**: резервные копии перед каждым изменением
- ✅ **Умная логика**: патчинг только когда нужно
- ✅ **Универсальность**: работает для всех нод (remnanode, remnanode2, remnanode3)
- ✅ **Прозрачность**: все операции логируются

## 📋 Логи

Все операции патчинга записываются в лог:

```bash
tail -f /var/log/remnanode-geo-update.log
```

Пример лога:
```
[2025-01-15 03:00:01] === Начало обновления geo файлов ===
[2025-01-15 03:00:02] 🔧 Добавление volumes для geo файлов в remnanode...
[2025-01-15 03:00:02] ✅ Volumes добавлены в docker-compose.yml для remnanode
[2025-01-15 03:00:03] ✅ geoip.dat скачан
[2025-01-15 03:00:04] ✅ geosite.dat скачан
[2025-01-15 03:00:05] Обновление remnanode...
[2025-01-15 03:00:06] Пересоздание контейнера remnanode с новыми volumes...
[2025-01-15 03:00:10] ✅ remnanode перезапущен с обновленной конфигурацией
[2025-01-15 03:00:10] === Обновление завершено ===
```

---

**Вывод:** Теперь скрипт полностью автономен и не требует ручного редактирования docker-compose.yml! 🚀
