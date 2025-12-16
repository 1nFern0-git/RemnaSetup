# 🚀 Быстрая установка модификации RemnaSetup с Geo файлами

## ⚡ Автоматическая установка (рекомендуется)

### Для существующей установки RemnaSetup:

```bash
# Скачайте и примените патч одной командой:
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/apply-geo-patch.sh)
```

### Для новой установки RemnaSetup с Geo модулем:

```bash
# Установите RemnaSetup v2.6 Enhanced Edition одной командой:
bash <(curl -fsSL https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh)
```

ИЛИ поэтапно:

```bash
# 1. Скачайте репозиторий
git clone -b dev https://github.com/1nFern0-git/RemnaSetup.git
cd RemnaSetup

# 2. Запустите установку
sudo bash install.sh

# 3. Выберите: 2 (Remnanode) → 8 (Geo Files Management)
```

**Альтернативный метод (wget):**

```bash
# Скачать и запустить
wget -O install.sh https://raw.githubusercontent.com/1nFern0-git/RemnaSetup/dev/install.sh
chmod +x install.sh
sudo bash install.sh
```

## 📦 Что будет установлено?

1. **Новый скрипт**: `/opt/remnasetup/scripts/remnanode/install-geo.sh`
2. **Обновленные переводы**: добавлены в `/opt/remnasetup/scripts/common/languages.sh`
3. **Обновленное меню**: новый пункт в меню Remnanode
4. **Автоматический патчинг**: добавление volumes в docker-compose.yml (если их нет)

## 🎯 Как использовать?

После установки:

1. Запустите RemnaSetup: `sudo bash /opt/remnasetup/remnasetup.sh`
2. Выберите пункт `2` (Remnanode)
3. Выберите пункт `8` (🌍 Управление Geo файлами)
4. Выберите желаемое действие:
   - `1` - Первичная установка geo файлов (+ автопатч docker-compose.yml)
   - `2` - Настройка автоматического обновления (раз в неделю)
   - `3` - Ручное обновление
   - `4` - Просмотр логов
   - `5` - Проверка расписания cron
   - `6` - Отключение автообновления

## 🔧 Ручная установка (если нужно больше контроля)

<details>
<summary>Развернуть инструкцию</summary>

```bash
# 1. Сначала патчим docker-compose.yml (добавляем volumes для geo файлов)
for node_dir in /opt/remnanode /opt/remnanode2 /opt/remnanode3; do
    if [ -d "$node_dir" ]; then
        compose_file="$node_dir/docker-compose.yml"
        
        # Создаем резервную копию
        sudo cp "$compose_file" "${compose_file}.backup-$(date +%Y%m%d-%H%M%S)"
        
        # Проверяем, есть ли уже volumes для geo
        if ! grep -q "geoip.dat" "$compose_file"; then
            echo "Патчим $compose_file..."
            
            # Добавляем volumes если есть секция volumes
            if grep -q "volumes:" "$compose_file"; then
                sudo sed -i '/volumes:/a\      - ./geoip.dat:/usr/local/share/xray/geoip.dat\n      - ./geosite.dat:/usr/local/share/xray/geosite.dat' "$compose_file"
            else
                # Добавляем секцию volumes после environment
                node_name=$(basename "$node_dir")
                sudo sed -i '/environment:/a\    volumes:\n      - /var/log/'$node_name':/var/log/'$node_name'\n      - ./geoip.dat:/usr/local/share/xray/geoip.dat\n      - ./geosite.dat:/usr/local/share/xray/geosite.dat' "$compose_file"
            fi
        fi
    fi
done

# 2. Создаем скрипт обновления (с автоматическим патчингом)
sudo tee /usr/local/bin/update-remnanode-geo.sh > /dev/null << 'EOF'
#!/bin/bash
LOG_FILE="/var/log/remnanode-geo-update.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Функция патчинга docker-compose.yml
patch_docker_compose() {
    local compose_file="$1"
    local node_name="$2"
    
    if [ ! -f "$compose_file" ]; then
        log "⚠️  docker-compose.yml не найден для $node_name"
        return 1
    fi
    
    if grep -q "geoip.dat:/usr/local/share/xray/geoip.dat" "$compose_file"; then
        log "✅ Volumes уже настроены в $node_name"
        return 0
    fi
    
    log "🔧 Добавление volumes в $node_name..."
    cp "$compose_file" "${compose_file}.backup-$(date +%Y%m%d-%H%M%S)"
    
    if grep -q "volumes:" "$compose_file"; then
        awk '/volumes:/ && !found {print; print "      - ./geoip.dat:/usr/local/share/xray/geoip.dat"; print "      - ./geosite.dat:/usr/local/share/xray/geosite.dat"; found=1; next} 1' "$compose_file" > "${compose_file}.tmp"
        mv "${compose_file}.tmp" "$compose_file"
    fi
    
    log "✅ Volumes добавлены в $node_name"
}

log "=== Начало обновления geo файлов ==="

TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit 1

log "Скачивание geoip.dat..."
if wget -q https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geoip.dat; then
    log "✅ geoip.dat скачан"
else
    log "❌ Ошибка скачивания geoip.dat"
    rm -rf "$TEMP_DIR"
    exit 1
fi

log "Скачивание geosite.dat..."
if wget -q https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geosite.dat; then
    log "✅ geosite.dat скачан"
else
    log "❌ Ошибка скачивания geosite.dat"
    rm -rf "$TEMP_DIR"
    exit 1
fi

for node_dir in /opt/remnanode /opt/remnanode2 /opt/remnanode3; do
    if [ -d "$node_dir" ]; then
        node_name=$(basename "$node_dir")
        log "Обновление $node_name..."
        
        # Патчим docker-compose.yml
        compose_file="$node_dir/docker-compose.yml"
        patch_docker_compose "$compose_file" "$node_name"
        
        # Копируем файлы
        cp geoip.dat "$node_dir/"
        cp geosite.dat "$node_dir/"
        
        # Пересоздаем контейнер
        container_name="${node_name}"
        if docker ps -a --format '{{.Names}}' | grep -q "^${container_name}$"; then
            log "Пересоздание контейнера $container_name..."
            cd "$node_dir"
            docker compose down >> "$LOG_FILE" 2>&1
            docker compose up -d >> "$LOG_FILE" 2>&1
            log "✅ $container_name обновлен"
            cd - > /dev/null
        fi
    fi
done

rm -rf "$TEMP_DIR"
log "=== Обновление завершено ==="
log ""
EOF

# 3. Делаем исполняемым
sudo chmod +x /usr/local/bin/update-remnanode-geo.sh

# 3. Настраиваем автообновление (каждое воскресенье в 3:00)
(crontab -l 2>/dev/null | grep -v "remnanode.*geo"; echo "0 3 * * 0 /usr/local/bin/update-remnanode-geo.sh") | crontab -

# 4. Первый запуск
sudo /usr/local/bin/update-remnanode-geo.sh

# 5. Проверяем результат
echo "=== Установленные задачи cron ==="
crontab -l | grep geo

echo -e "\n=== Лог последнего обновления ==="
tail -20 /var/log/remnanode-geo-update.log
```

</details>

## ✅ Проверка установки

```bash
# Проверка скрипта
ls -la /opt/remnasetup/scripts/remnanode/install-geo.sh

# Проверка обновления скрипта
ls -la /usr/local/bin/update-remnanode-geo.sh

# Проверка cron
crontab -l | grep geo

# Проверка логов
tail -f /var/log/remnanode-geo-update.log
```

## 🔄 Откат к оригинальной версии

Если что-то пошло не так:

```bash
# Восстановить из автоматически созданного бэкапа
sudo rm -rf /opt/remnasetup
sudo mv /opt/remnasetup-backup-* /opt/remnasetup
```

## 📞 Поддержка

- Оригинальный RemnaSetup: [@KaTTuBaRa](https://t.me/KaTTuBaRa)
- GitHub: [Capybara-z/RemnaSetup](https://github.com/Capybara-z/RemnaSetup)
- Geo файлы: [runetfreedom/russia-v2ray-rules-dat](https://github.com/runetfreedom/russia-v2ray-rules-dat)

---

**Версия модификации:** 2.6
**Дата:** 2025
