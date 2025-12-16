#!/bin/bash

. /opt/remnasetup/scripts/common/colors.sh
. /opt/remnasetup/scripts/common/functions.sh
. /opt/remnasetup/scripts/common/languages.sh

LOG_FILE="/var/log/remnanode-geo-update.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BOLD_CYAN}[INFO]${RESET} $1"
}

success() {
    echo -e "${BOLD_GREEN}[SUCCESS]${RESET} $1"
}

error() {
    echo -e "${BOLD_RED}[ERROR]${RESET} $1"
}

warn() {
    echo -e "${BOLD_YELLOW}[WARN]${RESET} $1"
}

# Функция проверки и добавления volumes в docker-compose.yml
patch_docker_compose() {
    local compose_file="$1"
    local node_name="$2"
    
    if [ ! -f "$compose_file" ]; then
        warn "docker-compose.yml не найден для $node_name"
        return 1
    fi
    
    # Проверяем, есть ли уже volumes для geo файлов
    if grep -q "geoip.dat:/usr/local/share/xray/geoip.dat" "$compose_file" && \
       grep -q "geosite.dat:/usr/local/share/xray/geosite.dat" "$compose_file"; then
        info "Volumes для geo файлов уже настроены в $node_name"
        return 0
    fi
    
    info "Добавление volumes для geo файлов в $node_name..."
    
    # Создаем резервную копию
    cp "$compose_file" "${compose_file}.backup-$(date +%Y%m%d-%H%M%S)"
    
    # Проверяем структуру файла и добавляем volumes
    if grep -q "volumes:" "$compose_file"; then
        # Секция volumes уже есть, добавляем наши строки
        if ! grep -q "geoip.dat" "$compose_file"; then
            sed -i '/volumes:/a\      - ./geoip.dat:/usr/local/share/xray/geoip.dat\n      - ./geosite.dat:/usr/local/share/xray/geosite.dat' "$compose_file"
        fi
    else
        # Нет секции volumes, добавляем после environment
        sed -i '/environment:/a\    volumes:\n      - /var/log/'$node_name':/var/log/'$node_name'\n      - ./geoip.dat:/usr/local/share/xray/geoip.dat\n      - ./geosite.dat:/usr/local/share/xray/geosite.dat' "$compose_file"
    fi
    
    success "Volumes добавлены в docker-compose.yml для $node_name"
    return 0
}

# Создание скрипта обновления
create_update_script() {
    info "$(get_string "install_geo_creating_script")"
    
    cat > /usr/local/bin/update-remnanode-geo.sh << 'SCRIPT_EOF'
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
    
    # Проверяем, есть ли уже volumes для geo файлов
    if grep -q "geoip.dat:/usr/local/share/xray/geoip.dat" "$compose_file" && \
       grep -q "geosite.dat:/usr/local/share/xray/geosite.dat" "$compose_file"; then
        log "✅ Volumes для geo файлов уже настроены в $node_name"
        return 0
    fi
    
    log "🔧 Добавление volumes для geo файлов в $node_name..."
    
    # Создаем резервную копию
    cp "$compose_file" "${compose_file}.backup-$(date +%Y%m%d-%H%M%S)"
    
    # Проверяем структуру файла и добавляем volumes
    if grep -q "volumes:" "$compose_file"; then
        # Секция volumes уже есть, добавляем наши строки если их нет
        if ! grep -q "geoip.dat" "$compose_file"; then
            # Находим строку volumes: и добавляем после нее
            awk '/volumes:/ && !found {print; print "      - ./geoip.dat:/usr/local/share/xray/geoip.dat"; print "      - ./geosite.dat:/usr/local/share/xray/geosite.dat"; found=1; next} 1' "$compose_file" > "${compose_file}.tmp"
            mv "${compose_file}.tmp" "$compose_file"
        fi
    else
        # Нет секции volumes, добавляем после environment
        awk '/environment:/ && !found {
            print; 
            print "    volumes:";
            print "      - /var/log/'$node_name':/var/log/'$node_name'";
            print "      - ./geoip.dat:/usr/local/share/xray/geoip.dat";
            print "      - ./geosite.dat:/usr/local/share/xray/geosite.dat";
            found=1; 
            next
        } 1' "$compose_file" > "${compose_file}.tmp"
        mv "${compose_file}.tmp" "$compose_file"
    fi
    
    log "✅ Volumes добавлены в docker-compose.yml для $node_name"
    return 0
}

log "=== Начало обновления geo файлов ==="

# Скачиваем новые файлы во временную директорию
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit 1

log "Скачивание geoip.dat из runetfreedom..."
if wget -q https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geoip.dat; then
    log "✅ geoip.dat скачан"
else
    log "❌ Ошибка скачивания geoip.dat"
    rm -rf "$TEMP_DIR"
    exit 1
fi

log "Скачивание geosite.dat из runetfreedom..."
if wget -q https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geosite.dat; then
    log "✅ geosite.dat скачан"
else
    log "❌ Ошибка скачивания geosite.dat"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Обновляем для всех существующих контейнеров
for node_dir in /opt/remnanode /opt/remnanode2 /opt/remnanode3; do
    if [ -d "$node_dir" ]; then
        node_name=$(basename "$node_dir")
        log "Обновление $node_name..."
        
        # Проверяем и патчим docker-compose.yml
        compose_file="$node_dir/docker-compose.yml"
        patch_docker_compose "$compose_file" "$node_name"
        
        # Копируем файлы
        cp geoip.dat "$node_dir/"
        cp geosite.dat "$node_dir/"
        
        # Пересоздаем контейнер если он запущен (для применения новых volumes)
        container_name="${node_name}"
        if docker ps -a --format '{{.Names}}' | grep -q "^${container_name}$"; then
            log "Пересоздание контейнера $container_name с новыми volumes..."
            cd "$node_dir"
            docker compose down >> "$LOG_FILE" 2>&1
            docker compose up -d >> "$LOG_FILE" 2>&1
            log "✅ $container_name перезапущен с обновленной конфигурацией"
            cd - > /dev/null
        fi
    fi
done

# Очистка
rm -rf "$TEMP_DIR"
log "=== Обновление завершено ==="
log ""
SCRIPT_EOF

    chmod +x /usr/local/bin/update-remnanode-geo.sh
    success "$(get_string "install_geo_script_created")"
}

# Настройка cron
setup_cron() {
    info "$(get_string "install_geo_setup_cron")"
    
    # Удаляем старые записи
    crontab -l 2>/dev/null | grep -v "geoip\|geosite\|remnanode.*geo" > /tmp/crontab.tmp || true
    
    # Добавляем новую запись (обновление каждую неделю в воскресенье в 3:00)
    echo "0 3 * * 0 /usr/local/bin/update-remnanode-geo.sh" >> /tmp/crontab.tmp
    
    crontab /tmp/crontab.tmp
    rm /tmp/crontab.tmp
    
    success "$(get_string "install_geo_cron_configured")"
}

# Первичное обновление
initial_update() {
    info "$(get_string "install_geo_initial_update")"
    
    # Сначала патчим все docker-compose.yml файлы
    info "Проверка docker-compose.yml файлов..."
    for node_dir in /opt/remnanode /opt/remnanode2 /opt/remnanode3; do
        if [ -d "$node_dir" ]; then
            node_name=$(basename "$node_dir")
            compose_file="$node_dir/docker-compose.yml"
            patch_docker_compose "$compose_file" "$node_name"
        fi
    done
    
    # Теперь запускаем обновление geo файлов
    /usr/local/bin/update-remnanode-geo.sh
    
    success "$(get_string "install_geo_initial_complete")"
}

# Показать лог
show_log() {
    echo
    info "$(get_string "install_geo_last_log")"
    echo -e "${CYAN}────────────────────────────────────────────────────────────${RESET}"
    tail -30 /var/log/remnanode-geo-update.log 2>/dev/null || echo "$(get_string "install_geo_no_log")"
    echo -e "${CYAN}────────────────────────────────────────────────────────────${RESET}"
}

# Показать текущий crontab
show_crontab() {
    echo
    info "$(get_string "install_geo_current_crontab")"
    echo -e "${CYAN}────────────────────────────────────────────────────────────${RESET}"
    crontab -l 2>/dev/null | grep -E "geo|remnanode" || echo "$(get_string "install_geo_no_crontab")"
    echo -e "${CYAN}────────────────────────────────────────────────────────────${RESET}"
}

# Меню действий
show_menu() {
    clear
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
    echo -e "${BOLD_CYAN}$(get_string "install_geo_menu_title")${RESET}"
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
    
    if [ "$LANGUAGE" = "en" ]; then
        echo -e "${BLUE}1. Install/Update geo files${RESET}"
        echo -e "${BLUE}2. Configure automatic updates${RESET}"
        echo -e "${BLUE}3. Run manual update${RESET}"
        echo -e "${BLUE}4. Show update log${RESET}"
        echo -e "${BLUE}5. Show cron schedule${RESET}"
        echo -e "${BLUE}6. Remove automatic updates${RESET}"
        echo -e "${RED}0. Back${RESET}"
    else
        echo -e "${BLUE}1. Установить/Обновить geo файлы${RESET}"
        echo -e "${BLUE}2. Настроить автоматическое обновление${RESET}"
        echo -e "${BLUE}3. Запустить ручное обновление${RESET}"
        echo -e "${BLUE}4. Показать лог обновления${RESET}"
        echo -e "${BLUE}5. Показать расписание cron${RESET}"
        echo -e "${BLUE}6. Удалить автоматическое обновление${RESET}"
        echo -e "${RED}0. Назад${RESET}"
    fi
    
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
    echo
    read -p "$(echo -e "${BOLD_CYAN}$(get_string "select_option"):${RESET}") " GEO_OPTION
    echo
}

# Удаление автоматического обновления
remove_cron() {
    info "$(get_string "install_geo_removing_cron")"
    
    crontab -l 2>/dev/null | grep -v "geoip\|geosite\|remnanode.*geo" > /tmp/crontab.tmp || true
    crontab /tmp/crontab.tmp
    rm /tmp/crontab.tmp
    
    success "$(get_string "install_geo_cron_removed")"
    
    read -n 1 -s -r -p "$(get_string "press_any_key")"
}

main() {
    while true; do
        show_menu
        
        case $GEO_OPTION in
            1)
                create_update_script
                initial_update
                show_log
                read -n 1 -s -r -p "$(get_string "press_any_key")"
                ;;
            2)
                create_update_script
                setup_cron
                show_crontab
                read -n 1 -s -r -p "$(get_string "press_any_key")"
                ;;
            3)
                if [ ! -f /usr/local/bin/update-remnanode-geo.sh ]; then
                    create_update_script
                fi
                /usr/local/bin/update-remnanode-geo.sh
                show_log
                read -n 1 -s -r -p "$(get_string "press_any_key")"
                ;;
            4)
                show_log
                read -n 1 -s -r -p "$(get_string "press_any_key")"
                ;;
            5)
                show_crontab
                read -n 1 -s -r -p "$(get_string "press_any_key")"
                ;;
            6)
                remove_cron
                ;;
            0)
                break
                ;;
            *)
                warn "$(get_string "invalid_choice")"
                sleep 1
                ;;
        esac
    done
}

main
