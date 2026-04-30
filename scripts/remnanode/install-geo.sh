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
            awk '/volumes:/ && !found {
                print
                print "      - ./geoip.dat:/usr/local/share/xray/geoip.dat"
                print "      - ./geosite.dat:/usr/local/share/xray/geosite.dat"
                found=1
                next
            } 1' "$compose_file" > "${compose_file}.tmp" && mv "${compose_file}.tmp" "$compose_file"
        fi
    else
        # Нет секции volumes, добавляем после environment
        awk '/environment:/ && !found {
            print
            print "    volumes:"
            print "      - /var/log/'"$node_name"':/var/log/'"$node_name"'"
            print "      - ./geoip.dat:/usr/local/share/xray/geoip.dat"
            print "      - ./geosite.dat:/usr/local/share/xray/geosite.dat"
            found=1
            next
        } 1' "$compose_file" > "${compose_file}.tmp" && mv "${compose_file}.tmp" "$compose_file"
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

# Определяем первичную ноду (первая найденная директория)
PRIMARY_NODE=""
for _dir in /opt/remnanode /opt/remnanode1 /opt/remnanode2 /opt/remnanode3; do
    if [ -d "$_dir" ]; then
        PRIMARY_NODE="$_dir"
        break
    fi
done

if [ -z "$PRIMARY_NODE" ]; then
    log "❌ Ни одной директории ноды не найдено"
    exit 1
fi

log "Первичная нода: $PRIMARY_NODE"

# Скачиваем файлы один раз во временную директорию
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

# Копируем файлы только в первичную ноду
cp geoip.dat "$PRIMARY_NODE/"
cp geosite.dat "$PRIMARY_NODE/"
log "✅ Geo файлы скопированы в $PRIMARY_NODE"

# Обновляем для всех существующих контейнеров
for node_dir in /opt/remnanode /opt/remnanode1 /opt/remnanode2 /opt/remnanode3; do
    if [ -d "$node_dir" ]; then
        node_name=$(basename "$node_dir")
        log "Обновление $node_name..."

        # Проверяем и патчим docker-compose.yml
        compose_file="$node_dir/docker-compose.yml"
        patch_docker_compose "$compose_file" "$node_name"

        # Для вторичных нод — симлинки на файлы первичной
        if [ "$node_dir" != "$PRIMARY_NODE" ]; then
            for geo_file in geoip.dat geosite.dat; do
                target="$PRIMARY_NODE/$geo_file"
                link="$node_dir/$geo_file"
                if [ ! -L "$link" ] || [ "$(readlink "$link")" != "$target" ]; then
                    ln -sf "$target" "$link"
                    log "🔗 Симлинк: $link -> $target"
                fi
            done
        fi

        # Пересоздаем контейнер если он запущен (для применения новых volumes)
        container_name="${node_name}"
        if docker ps -a --format '{{.Names}}' | grep -q "^${container_name}$"; then
            log "Пересоздание контейнера $container_name с новыми volumes..."
            if (cd "$node_dir" && docker compose down >> "$LOG_FILE" 2>&1 && docker compose up -d >> "$LOG_FILE" 2>&1); then
                log "✅ $container_name перезапущен с обновленной конфигурацией"
            else
                log "❌ Ошибка перезапуска $container_name"
            fi
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
    echo ""

    # Выбор типа расписания
    echo -e "${BLUE}1. $(get_string "install_geo_cron_type_daily")${RESET}"
    echo -e "${BLUE}2. $(get_string "install_geo_cron_type_weekly")${RESET}"
    echo -e "${BLUE}3. $(get_string "install_geo_cron_type_monthly")${RESET}"
    echo ""

    while true; do
        question "$(get_string "install_geo_cron_select_type")"
        CRON_TYPE="$REPLY"
        if [[ "$CRON_TYPE" =~ ^[123]$ ]]; then
            break
        fi
        warn "$(get_string "install_geo_cron_invalid_type")"
    done

    # День недели (для еженедельного)
    CRON_DOW="*"
    if [[ "$CRON_TYPE" == "2" ]]; then
        echo ""
        echo -e "${BLUE}1. $(get_string "install_geo_cron_weekday_1")${RESET}"
        echo -e "${BLUE}2. $(get_string "install_geo_cron_weekday_2")${RESET}"
        echo -e "${BLUE}3. $(get_string "install_geo_cron_weekday_3")${RESET}"
        echo -e "${BLUE}4. $(get_string "install_geo_cron_weekday_4")${RESET}"
        echo -e "${BLUE}5. $(get_string "install_geo_cron_weekday_5")${RESET}"
        echo -e "${BLUE}6. $(get_string "install_geo_cron_weekday_6")${RESET}"
        echo -e "${BLUE}7. $(get_string "install_geo_cron_weekday_7")${RESET}"
        echo ""
        while true; do
            question "$(get_string "install_geo_cron_enter_weekday")"
            DOW_INPUT="$REPLY"
            if [[ "$DOW_INPUT" =~ ^[1-7]$ ]]; then
                # 1-6 = Пн-Сб → cron 1-6; 7 = Вс → cron 0
                [[ "$DOW_INPUT" == "7" ]] && CRON_DOW="0" || CRON_DOW="$DOW_INPUT"
                break
            fi
            warn "$(get_string "install_geo_cron_invalid_weekday")"
        done
    fi

    # День месяца (для ежемесячного)
    CRON_DOM="*"
    if [[ "$CRON_TYPE" == "3" ]]; then
        while true; do
            question "$(get_string "install_geo_cron_enter_monthday")"
            DOM_INPUT="${REPLY:-1}"
            if [[ "$DOM_INPUT" =~ ^[0-9]+$ ]] && (( DOM_INPUT >= 1 && DOM_INPUT <= 31 )); then
                CRON_DOM="$DOM_INPUT"
                break
            fi
            warn "$(get_string "install_geo_cron_invalid_monthday")"
        done
    fi

    # Час
    while true; do
        question "$(get_string "install_geo_cron_enter_hour")"
        HOUR_INPUT="${REPLY:-3}"
        if [[ "$HOUR_INPUT" =~ ^[0-9]+$ ]] && (( HOUR_INPUT >= 0 && HOUR_INPUT <= 23 )); then
            CRON_HOUR="$HOUR_INPUT"
            break
        fi
        warn "$(get_string "install_geo_cron_invalid_hour")"
    done

    # Минуты
    while true; do
        question "$(get_string "install_geo_cron_enter_minute")"
        MIN_INPUT="${REPLY:-0}"
        if [[ "$MIN_INPUT" =~ ^[0-9]+$ ]] && (( MIN_INPUT >= 0 && MIN_INPUT <= 59 )); then
            CRON_MIN="$MIN_INPUT"
            break
        fi
        warn "$(get_string "install_geo_cron_invalid_minute")"
    done

    # Строим cron-выражение: минуты часы день-месяца месяц день-недели
    CRON_EXPR="$CRON_MIN $CRON_HOUR $CRON_DOM * $CRON_DOW"

    # Удаляем старые записи и добавляем новую
    crontab -l 2>/dev/null | grep -v "update-remnanode-geo" > /tmp/crontab.tmp || true
    echo "$CRON_EXPR /usr/local/bin/update-remnanode-geo.sh" >> /tmp/crontab.tmp
    crontab /tmp/crontab.tmp
    rm -f /tmp/crontab.tmp

    success "$(get_string "install_geo_cron_configured"): ${CRON_EXPR}"
}

# Первичное обновление
initial_update() {
    info "$(get_string "install_geo_initial_update")"
    
    # Сначала патчим все docker-compose.yml файлы
    info "Проверка docker-compose.yml файлов..."
    for node_dir in /opt/remnanode /opt/remnanode1 /opt/remnanode2 /opt/remnanode3; do
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
    
    echo -e "${BLUE}1. $(get_string "install_geo_opt_install")${RESET}"
    echo -e "${BLUE}2. $(get_string "install_geo_opt_auto_update")${RESET}"
    echo -e "${BLUE}3. $(get_string "install_geo_opt_manual_update")${RESET}"
    echo -e "${BLUE}4. $(get_string "install_geo_opt_show_log")${RESET}"
    echo -e "${BLUE}5. $(get_string "install_geo_opt_show_cron")${RESET}"
    echo -e "${BLUE}6. $(get_string "install_geo_opt_remove_cron")${RESET}"
    echo -e "${RED}0. $(get_string "install_geo_opt_back")${RESET}"
    
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
    echo
    read -p "$(echo -e "${BOLD_CYAN}$(get_string "select_option"):${RESET}") " GEO_OPTION
    echo
}

# Удаление автоматического обновления
remove_cron() {
    info "$(get_string "install_geo_removing_cron")"
    
    crontab -l 2>/dev/null | grep -v "update-remnanode-geo" > /tmp/crontab.tmp || true
    crontab /tmp/crontab.tmp
    rm -f /tmp/crontab.tmp

    success "$(get_string "install_geo_cron_removed")"
    
    pause_press_key "$(get_string "press_any_key")"
}

main() {
    while true; do
        show_menu
        
        case $GEO_OPTION in
            1)
                create_update_script
                initial_update
                show_log
                pause_press_key "$(get_string "press_any_key")"
                ;;
            2)
                create_update_script
                setup_cron
                show_crontab
                pause_press_key "$(get_string "press_any_key")"
                ;;
            3)
                if [ ! -f /usr/local/bin/update-remnanode-geo.sh ]; then
                    create_update_script
                fi
                /usr/local/bin/update-remnanode-geo.sh
                show_log
                pause_press_key "$(get_string "press_any_key")"
                ;;
            4)
                show_log
                pause_press_key "$(get_string "press_any_key")"
                ;;
            5)
                show_crontab
                pause_press_key "$(get_string "press_any_key")"
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
