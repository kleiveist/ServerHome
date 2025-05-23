#!/bin/bash

LOG_FILE="/var/log/installation_script.log"
log_message() {
  local message=$1
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}
echo "💾 /var/log/installation_script.log created"
# ────────────────────────────────────────────────────────────────────────
# 🛠️ Dynamically determine server IP and system information
# ────────────────────────────────────────────────────────────────────────
SERVER_IP="$(hostname -I | awk '{print $1}')"
OS_DESCRIPTION="$(lsb_release -d | awk -F'\t' '{print $2}')"
HOSTNAME_VAR="$(hostname)"
USER_VAR="$(whoami)"
CURRENT_TIME="$(date '+%Y-%m-%d %H:%M:%S')"
log_message "🔧 Installation server IP determined: $SERVER_IP"
#+-------------------------------------------------------------------------------------------------------------------------------+
# 🛠️ Function to check if the file already exists
# -------------------------------------------------------------------------------------------------------------------------------+
check_file_exists() {
  sleep 0.1
  local file_path=$1
  if [ -f "$file_path" ]; then
    log_message "ℹ️  File $file_path already exists. Creation skipped."
    return 1
  else
    return 0
  fi
}
# 🛠️ Function to process script creation
process_script_creation() {
  local script_path=$1
  if [ ! -f "$script_path" ]; then
    log_message "❌ Error: Script $script_path not found."
    return 1
  fi
  if [ $? -ne 0 ]; then
    log_message "❌ Error: Script $script_path was not created."
  else
    sleep 0.1
    sudo chmod +x "$script_path"
    log_message "🎉 Script created successfully: $script_path"
  fi
}
#+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
# 🖥️ System script paths
SCRIPT_PATH0="/usr/local/bin/systemv.sh"
# 🗂️ Define script paths
SCRIPT_PATH1="/usr/local/bin/skripts.sh"
SCRIPT_PATH2="/usr/local/bin/help.sh"
# 📜 Help – script paths 📝 💾 📂 🛠️
SCRIPT_PATH3="/usr/local/bin/upgrade.sh"
SCRIPT_PATH4="/usr/local/bin/hosts.py"
SCRIPT_PATH5="/usr/local/bin/ping.py"
SCRIPT_PATH6="/usr/local/bin/cat.sh"
SCRIPT_PATH7="/usr/local/bin/urls.sh"
SCRIPT_PATH8="/usr/local/bin/docker.sh"
SCRIPT_PATH9="/usr/local/bin/9.sh"
SCRIPT_PATH10="/usr/local/bin/10.sh"
SCRIPT_PATH11="/usr/local/bin/11.sh"
#+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
# 🔄 Dynamically convert to an array, ignore invalid paths
SCRIPT_PATHS=()
for VAR in SCRIPT_PATH{0..11}; do
    VALUE="${!VAR}" # retrieve variable value
    if [[ -n "$VALUE" && "$VALUE" != */ ]]; then
        SCRIPT_PATHS+=("$VALUE")
    fi
done
# ────────────────────────────────────────────────────────────────────────
# ❓ Delete old scripts only if any exist
# ────────────────────────────────────────────────────────────────────────
# Collect existing script files
existing=()
for VAR in SCRIPT_PATH{0..11}; do
    FILE="${!VAR}"
    [[ -n "$FILE" && -f "$FILE" ]] && existing+=("$FILE")
done

# Prompt only if at least one file exists
if (( ${#existing[@]} )); then
    read -rp "Delete old scripts? [y/n] " answer
    case "${answer,,}" in
      y|yes )
        log_message "🗑️  Deleting old scripts..."
        for FILE in "${existing[@]}"; do
            sudo rm -f "$FILE" \
              && log_message "🗑️  Deleted: $FILE"
        done
        ;;
      * )
        log_message "ℹ️  Deletion skipped."
        ;;
    esac
fi
# ────────────────────────────────────────────────────────────────────────
# 🌐 Prompt for domains
# ────────────────────────────────────────────────────────────────────────
read -rp "Local domain (e.g. domain.local) [domain.local]: " LOCAL_DOMAIN
LOCAL_DOMAIN=${LOCAL_DOMAIN:-domain.local}

read -rp "Global domain (e.g. example.com) [domain.global]: " GLOBAL_DOMAIN
GLOBAL_DOMAIN=${GLOBAL_DOMAIN:-domain.global}

log_message "🌐 Using domains: $LOCAL_DOMAIN, $GLOBAL_DOMAIN"
#+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
# 🔥 Create Script0 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -- - - - - - - - - -+🔥 Create Script0 🔥
if check_file_exists "$SCRIPT_PATH0"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH0"
  cat <<EOF  | sudo tee "$SCRIPT_PATH0" > /dev/null
#!/bin/bash
# ────────────────────────────────────────────────────────────────────────
# systemv.sh – central definition and display of your system variables
# ────────────────────────────────────────────────────────────────────────
# Variables
SERVER_IP="$(hostname -I | awk '{print $1}')"
OS_DESCRIPTION="$(lsb_release -d | awk -F'\t' '{print $2}')"
HOSTNAME_VAR="$(hostname)"
USER_VAR="$(whoami)"
CURRENT_TIME="$(date '+%Y-%m-%d %H:%M:%S')"

# Simple log helper
log_message() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Function for structured output
show_system_info() {
  local width=62
  local border
  border=$(printf '%*s' "$width" '' | tr ' ' '-')

  echo "+$border+"
  printf "| %-62s |\n" "SYSTEM INFORMATION"
  echo "+$border+"
  printf "| Operating System: %-44s |\n" "$OS_DESCRIPTION"
  printf "| Hostname:         %-44s |\n" "$HOSTNAME_VAR"
  printf "| User:             %-44s |\n" "$USER_VAR"
  printf "| Current Time:     %-44s |\n" "$CURRENT_TIME"
  echo "+$border+"
}
# Only on direct execution: log and display
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  log_message "🔧 Installation server IP determined: $SERVER_IP"
  show_system_info
fi
EOF
  process_script_creation "$SCRIPT_PATH0"
fi
#+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
# 🔥 Create Script1 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create Script1 🔥
if check_file_exists "$SCRIPT_PATH1"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH1"
  {
  cat << 'EOF' | sudo tee "$SCRIPT_PATH1" > /dev/null
#!/bin/bash

# Width of the outer frame (total 66 characters)
outer_dash=$(printf '%*s' 64 '' | tr ' ' -)
# Width of the inner frame (total 62 characters)
inner_dash=$(printf '%*s' 62 '' | tr ' ' -)

echo
echo "+$outer_dash+"
echo "|                    📜 AVAILABLE SCRIPTS                    |"
echo "+$outer_dash+"
echo "| +$inner_dash+ |"

for f in /usr/local/bin/*.sh /usr/local/bin/*.py; do
  [ -f "$f" ] || continue
  FN=$(basename "$f")
  # left-aligned on 55 characters, rest is blank
  printf '| |  📜 %-55s | |\n' "$FN"
done

echo "| +$inner_dash+ |"
echo "+$outer_dash+"

EOF
  } | sudo tee "$SCRIPT_PATH1" > /dev/null

  process_script_creation "$SCRIPT_PATH1"
fi

# 🔥 Create Script2 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create Script2 🔥
if check_file_exists "$SCRIPT_PATH2"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH2"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH2" > /dev/null
#!/bin/bash
# ────────────────────────────────────────────────────────────────────────
# ASCII Table Drawing Functions
# ────────────────────────────────────────────────────────────────────────

# Spaltenbreite (nur eine Spalte)
COL1=68
widths=($COL1)

# Draws a headline separator line using '='
function draw_headline() {
  # Länge = Spaltenbreite + 2 (für die beiden Leerzeichen links/rechts)
  local length=$((COL1 + 2))
  printf '%*s\n' "$length" '' | tr ' ' '='
}

# Draws an ASCII border line based on column widths
draw_border(){
  local -n w=$1
  local line="+"
  for b in "${w[@]}"; do
    line+=$(printf '%*s' $((b+2)) '' | tr ' ' '-')+
  done
  echo "${line%+}+"
}

print_row(){
  local -n w=$1
  shift
  local cells=("$@")
  local row="|"
  for i in "${!w[@]}"; do
    row+=" $(printf "%-${w[i]}s" "${cells[i]}") "
  done
  echo "$row"
}
# ────────────────────────────────────────────────────────────────────────
# Page Navigation Functions
# ────────────────────────────────────────────────────────────────────────
# 🛠️ Function to display navigation instructions
function display_navigation_instructions() {
    echo ""
    echo "🔄 Navigate with left (←) / right (→), exit with down arrow (↓) || Ctrl + X"
    echo "📄 This is page $current_page"
    echo ""
}
# Function to navigate between pages
function navigate_pages() {
    current_page=0
    total_pages=11

    while true; do
        clear

        # display instructions at top
        display_navigation_instructions

        case "$current_page" in
            0) display_page_0 ;;
            1) display_page_1 ;;
            2) display_page_2 ;;
            3) display_page_3 ;;
            4) display_page_4 ;;
            5) display_page_5 ;;
            6) display_page_6 ;;
            7) display_page_7 ;;
            8) display_page_8 ;;
            9) display_page_9 ;;
            10) display_page_10 ;;
            11) display_page_11 ;;
        esac

        # display instructions at bottom
        display_navigation_instructions

        read -rsn1 input
        case "$input" in
            "A") ;; # up arrow - no action
            "B"|$'\x18') # down arrow or Ctrl+X
                echo "🚪 Exiting script... Thank you for using!"
                break
                ;;
            "C") # right arrow
                (( current_page < total_pages )) && (( current_page++ ))
                ;;
            "D") # left arrow
                (( current_page > 0 )) && (( current_page-- ))
                ;;
            *) echo "⚠️  Use left (←), right (→) or down (↓) arrow keys." ;;
        esac
    done
}
# ────────────────────────────────────────────────────────────────────────
# (Dann folgen deine display_page_* Funktionen…)
# ────────────────────────────────────────────────────────────────────────
function display_page_0() {
  echo
  draw_border widths
  print_row  widths "🖥️ System: $(lsb_release -d | cut -f2)"
  print_row  widths "Hostname: $(hostname)"
  print_row  widths "User: $(whoami)"
  print_row  widths "Time: $(date '+%Y-%m-%d %H:%M:%S')"
  draw_border widths
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_1() {

  draw_border widths
  print_row  widths "📚 INHALTSVERZEICHNIS" ""
  draw_border widths
  # … und so weiter …

  draw_border widths
  print_row  widths "📚 TABLE OF CONTENTS"
  draw_border widths

  print_row  widths "📘 PAGE OVERVIEW"
  draw_border widths

  print_row  widths "📄 Page 1: Directory Overview"
  print_row  widths "   ➡️ System, UFW, NGINX directories"
  print_row  widths "   ➡️ Log files, User home directories"
  draw_border widths

  print_row  widths "📄 Page 2: Available Scripts & Warnings"
  print_row  widths "   ➡️ List installed scripts"
  print_row  widths "   ➡️ Important logs / auto-ssl.sh warning"
  draw_border widths

  print_row  widths "📄 Page 3: System Commands & Service Status"
  print_row  widths "   ➡️ Reboot, logs, status checks"
  draw_border widths

  print_row  widths "📄 Page 4: NGINX Commands & Troubleshooting"
  draw_border widths

  print_row  widths "📄 Page 5: NGINX Configuration Guide"
  draw_border widths

  print_row  widths "📄 Page 6: UFW Firewall Commands"
  draw_border widths
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_2() {
  echo
  # Headline für wichtigen Hinweis
  draw_headline
  print_row  widths "⚠️ IMPORTANT NOTICE ⚠️"
  draw_headline

  # Warnungstabelle
  draw_border widths
  print_row  widths "7 - ⚠️ auto-ssl.sh warning"
  draw_border widths

  # Log-Hinweis
  draw_border widths
  print_row  widths "💾 LOG NOTICE"
  print_row  widths "cat /var/log/installation_script.log"
  draw_border widths

  # 📜 AVAILABLE SCRIPTS
  draw_border widths
  print_row widths "📜 AVAILABLE SCRIPTS"
  for f in /usr/local/bin/*.{sh,py}; do
    [ -f "$f" ] || continue
    FN=$(basename "$f")
    print_row widths "📜 $FN"
  done
  draw_border widths
  # Hilfe-Skripte
  draw_border widths
  print_row  widths "📚 HELP SCRIPTS"
  print_row  widths "3 - show_help.sh"
  print_row  widths "4 - show_help_skripts.sh"
  draw_border widths
  draw_headline
}
#------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------
function display_page_3() {
  echo
  # ────────────────────────────────────────────────────────────────────────
  # 🔄 SYSTEM COMMANDS
  # ────────────────────────────────────────────────────────────────────────
  draw_headline
  print_row  widths "🔄 SYSTEM COMMANDS"
  draw_headline
  draw_border widths
  print_row  widths "Reboot system"
  print_row  widths "sudo reboot"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 🖥️ SYSTEM & MONITORING
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row  widths "🖥️ SYSTEM & MONITORING"
  draw_border widths
  print_row  widths "Check load, processes and logs"
  print_row  widths "top"
  print_row  widths "htop (install: sudo apt-get install htop)"
  print_row  widths "journalctl -xe"
  print_row  widths "df -h"
  print_row  widths "free -h"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 📋 SERVICE STATUS
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row  widths "📋 SERVICE STATUS"
  draw_border widths
  print_row  widths "Check status of services"
  print_row  widths "sudo systemctl status nginx"
  print_row  widths "sudo systemctl status supervisor"
  print_row  widths "sudo systemctl status postgresql"
  print_row  widths "sudo systemctl status redis"
  print_row  widths "sudo systemctl status rabbitmq-server"
  print_row  widths "sudo systemctl status onlyoffice-documentserver"
  print_row  widths "sudo systemctl status apache2"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 🔁 SERVICE RESTART
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row  widths "🔁 SERVICE RESTART"
  draw_border widths
  print_row  widths "Restart selected services"
  print_row  widths "sudo systemctl restart rabbitmq-server"
  print_row  widths "sudo systemctl restart onlyoffice-documentserver"
  print_row  widths "sudo systemctl restart apache2"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 🌐 APACHE COMMANDS
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row  widths "🌐 APACHE COMMANDS"
  draw_border widths
  print_row  widths "Show virtual host settings"
  print_row  widths "sudo apache2ctl -S"
  print_row  widths "View error log"
  print_row  widths "sudo tail -n 10 /var/log/apache2/error.log"
  print_row  widths "View access log"
  print_row  widths "sudo tail -n 10 /var/log/apache2/access.log"
  print_row  widths "Edit site config"
  print_row  widths "sudo nano /etc/apache2/sites-available/onlyoffice.local.conf"
  print_row  widths "sudo nano /etc/apache2/sites-available/onlyoffice-ssl.conf"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 📜 LOG ANALYSIS
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row  widths "📜 LOG ANALYSIS"
  draw_border widths
  print_row  widths "ONLYOFFICE service logs"
  print_row  widths "sudo tail -n 10 /var/log/onlyoffice/documentserver/docservice/out.log"
  print_row  widths "sudo tail -n 10 /var/log/onlyoffice/documentserver/converter/out.log"
  print_row  widths "sudo tail -n 10 /var/log/onlyoffice/documentserver/metrics/out.log"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # ✍️ EDITOR COMMANDS (NANO)
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row  widths "✍️ EDITOR COMMANDS (NANO)"
  draw_border widths
  print_row  widths "Edit /etc/hosts"
  print_row  widths "nano /etc/hosts"
  print_row  widths "Edit custom scripts"
  print_row  widths "sudo nano /usr/local/bin/cat_hosts.sh"
  print_row  widths "sudo nano /usr/local/bin/ping_test.py"
  print_row  widths "sudo nano /usr/local/bin/restart-onlyoffice.py"
  print_row  widths "sudo nano /usr/local/bin/check_rabbitmq_connection.sh"
  print_row  widths "nano ~/.bashrc"
  print_row  widths "sudo crontab -e"
  print_row  widths "sudo nano /usr/local/bin/show_help_commands.sh"
  draw_border widths
  draw_headline
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_4() {
  echo
  # ────────────────────────────────────────────────────────────────────────
  # 🌐 NGINX HELP & COMMANDS
  # ────────────────────────────────────────────────────────────────────────
  draw_headline
  print_row   widths "🌐 NGINX HELP & COMMANDS"
  draw_headline
  # ────────────────────────────────────────────────────────────────────────
  # 📁 IMPORTANT DIRECTORIES
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "📁 IMPORTANT DIRECTORIES"
  draw_border widths
  print_row   widths "/etc/nginx/               – main config"
  print_row   widths "/etc/nginx/nginx.conf     – global settings"
  print_row   widths "/etc/nginx/sites-available – vhosts"
  print_row   widths "/etc/nginx/sites-enabled   – enabled vhosts"
  print_row   widths "/etc/nginx/conf.d/         – extra configs"
  print_row   widths "/var/log/nginx/            – access & error logs"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 🛠️ USEFUL COMMANDS
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "🛠️ USEFUL COMMANDS"
  draw_border widths
  print_row   widths "sudo systemctl start nginx     – start service"
  print_row   widths "sudo systemctl stop nginx      – stop service"
  print_row   widths "sudo systemctl restart nginx   – restart service"
  print_row   widths "sudo systemctl reload nginx    – reload config"
  print_row   widths "sudo systemctl status nginx    – check status"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 🔍 TROUBLESHOOTING & LOGS
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "🔍 TROUBLESHOOTING & LOGS"
  draw_border widths
  print_row   widths "cat /var/log/nginx/error.log      – view errors"
  print_row   widths "tail -n 20 /var/log/nginx/error.log – last 20 errors"
  print_row   widths "tail -f /var/log/nginx/error.log   – live error stream"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 📂 FILE SEARCH
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "📂 FILE SEARCH"
  draw_border widths
  print_row   widths "find /etc/nginx -name '*.conf'    – all .conf files"
  print_row   widths "grep -R 'server_name' /etc/nginx/ – find server_name"
  print_row   widths "grep -R 'listen' /etc/nginx/      – find ports"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # ⚙️ SYSTEM STATUS
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "⚙️ SYSTEM STATUS"
  draw_border widths
  print_row   widths "sudo systemctl status nginx      – service status"
  print_row   widths "ps aux | grep nginx               – running processes"
  print_row   widths "netstat -tuln | grep 80           – check port 80"
  print_row   widths "netstat -tuln | grep 443          – check port 443"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 💡 USEFUL TIPS
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "💡 USEFUL TIPS"
  draw_border widths
  print_row   widths "Always reload after changes: sudo systemctl reload nginx"
  print_row   widths "Test config before reload: nginx -t"
  print_row   widths "Watch logs in real time: tail -f /var/log/nginx/error.log"
  draw_border widths
  draw_headline
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_5() {
  echo
  # ────────────────────────────────────────────────────────────────────────
  # 🔥 UFW FIREWALL COMMANDS 🔥
  # ────────────────────────────────────────────────────────────────────────
  draw_headline
  print_row   widths "🔥 UFW FIREWALL COMMANDS 🔥"
  draw_headline

  # Installation & Status
  draw_border widths
  print_row   widths "📜 INSTALLATION & STATUS"
  draw_border widths
  print_row   widths "Install UFW: sudo apt install ufw -y"
  print_row   widths "Show status: ufw status"
  print_row   widths "Verbose status: ufw status verbose"
  print_row   widths "Enable firewall: ufw enable"
  print_row   widths "Disable firewall: ufw disable"
  print_row   widths "Reload rules: ufw reload"
  print_row   widths "Reset to defaults: ufw reset"
  draw_border widths

  # Default Policies
  draw_border widths
  print_row   widths "📜 DEFAULT POLICIES"
  draw_border widths
  print_row   widths "ufw default deny incoming"
  print_row   widths "ufw default allow outgoing"
  print_row   widths "ufw default allow incoming    (not recommended)"
  print_row   widths "ufw default deny outgoing"
  draw_border widths

  # Manage Ports & Services
  draw_border widths
  print_row   widths "📜 PORTS & SERVICES"
  draw_border widths
  print_row   widths "ufw allow 22                 – allow SSH"
  print_row   widths "ufw allow 80                 – allow HTTP"
  print_row   widths "ufw allow 443                – allow HTTPS"
  print_row   widths "ufw allow 8080/tcp           – allow TCP 8080"
  print_row   widths "ufw allow 5000:6000/tcp      – allow TCP 5000–6000"
  print_row   widths "ufw allow from 192.168.1.0/24  – allow subnet"
  print_row   widths "ufw deny 3306                – deny MySQL port"
  print_row   widths "ufw deny from 203.0.113.4    – deny single IP"
  draw_border widths

  # NGINX Application Profiles
  draw_border widths
  print_row   widths "📜 NGINX APPLICATION PROFILES"
  draw_border widths
  print_row   widths "ufw allow 'Nginx Full'       – HTTP & HTTPS"
  print_row   widths "ufw allow 'Nginx HTTP'       – HTTP only"
  print_row   widths "ufw allow 'Nginx HTTPS'      – HTTPS only"
  draw_border widths

  # Delete Rules
  draw_border widths
  print_row   widths "📜 DELETE RULES"
  draw_border widths
  print_row   widths "ufw delete allow 22"
  print_row   widths "ufw delete deny 3306"
  print_row   widths "ufw delete allow 8080/tcp"
  draw_border widths

  # Specific IPs & Interfaces
  draw_border widths
  print_row   widths "📜 SPECIFIC IPS & INTERFACES"
  draw_border widths
  print_row   widths "ufw allow in on eth0        – allow on eth0"
  print_row   widths "ufw allow from 203.0.113.5  – allow from IP"
  print_row   widths "ufw allow from 192.168.1.0/24 to any port 22  – allow SSH from subnet"
  draw_border widths

  # Logging & Levels
  draw_border widths
  print_row   widths "📜 LOGGING & LEVELS"
  draw_border widths
  print_row   widths "ufw logging on"
  print_row   widths "ufw logging low"
  print_row   widths "ufw logging medium"
  print_row   widths "ufw logging high"
  print_row   widths "tail -f /var/log/ufw.log   – live log"
  draw_border widths

  # Save & Load Configuration
  draw_border widths
  print_row   widths "📜 SAVE & LOAD CONFIG"
  draw_border widths
  print_row   widths "ufw export > ufw_backup.rules"
  print_row   widths "ufw reset && ufw import ufw_backup.rules"
  draw_border widths

  # Application Profiles Management
  draw_border widths
  print_row   widths "📜 APPLICATION PROFILE MANAGEMENT"
  draw_border widths
  print_row   widths "ufw app list               – list profiles"
  print_row   widths "ufw app info Apache        – show Apache profile"
  print_row   widths "ufw allow Apache           – allow Apache profile"
  print_row   widths "ufw delete allow Apache    – delete Apache rule"
  draw_border widths

  # Protocol-Specific Rules
  draw_border widths
  print_row   widths "📜 PROTOCOL-SPECIFIC RULES"
  draw_border widths
  print_row   widths "ufw allow proto tcp from 192.168.1.0/24 to any port 80"
  print_row   widths "ufw allow proto udp from 203.0.113.0/24 to any port 53"
  draw_border widths
  draw_headline
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_6() {
  echo
  # ────────────────────────────────────────────────────────────────────────
  # 📁 DIRECTORY OVERVIEW
  # ────────────────────────────────────────────────────────────────────────
  draw_headline
  print_row   widths "📁 DIRECTORY OVERVIEW"
  draw_headline
  # ────────────────────────────────────────────────────────────────────────
  # 📁 SYSTEM DIRECTORIES
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "📁 SYSTEM DIRECTORIES"
  draw_border widths
  print_row   widths "/etc/                  – main config folder"
  print_row   widths "/usr/local/bin/        – custom scripts"
  print_row   widths "/var/log/              – system logs"
  print_row   widths "/home/                 – user home directories"
  print_row   widths "/tmp/                  – temporary files"
  print_row   widths "/opt/                  – third-party packages"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 📁 UFW FIREWALL DIRECTORIES
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "📁 UFW FIREWALL DIRECTORIES"
  draw_border widths
  print_row   widths "/etc/ufw/              – UFW config directory"
  print_row   widths "/var/log/ufw.log       – UFW log file"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 📁 NGINX DIRECTORIES
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "📁 NGINX DIRECTORIES"
  draw_border widths
  print_row   widths "/etc/nginx/            – nginx config directory"
  print_row   widths "/etc/nginx/sites-available/ – available vhosts"
  print_row   widths "/etc/nginx/sites-enabled/   – enabled vhosts"
  print_row   widths "/var/log/nginx/         – nginx log files"
  print_row   widths "/usr/share/nginx/html/  – default web root"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 📁 LOG FILE DIRECTORIES
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "📁 LOG FILE DIRECTORIES"
  draw_border widths
  print_row   widths "/var/log/syslog         – system log"
  print_row   widths "/var/log/auth.log       – authentication log"
  print_row   widths "/var/log/kern.log       – kernel log"
  print_row   widths "/var/log/dpkg.log       – package manager log"
  print_row   widths "/var/log/boot.log       – boot log"
  print_row   widths "/var/log/ufw.log        – UFW firewall logs"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 📁 CUSTOM USER DIRECTORIES
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "📁 CUSTOM USER DIRECTORIES"
  draw_border widths
  print_row   widths "/usr/local/bin/        – custom scripts"
  print_row   widths "~/.config/             – user config files"
  print_row   widths "~/.local/share/        – local share files"
  draw_border widths
  draw_headline
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_7() {
  echo
  # ────────────────────────────────────────────────────────────────────────
  # 🐳 DOCKER COMMAND REFERENCE
  # ────────────────────────────────────────────────────────────────────────
  draw_headline
  print_row   widths "🐳 DOCKER COMMAND REFERENCE"
  draw_headline
  # ────────────────────────────────────────────────────────────────────────
  # 🔧 BASICS
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "🔧 BASICS"
  draw_border widths
  print_row   widths "docker --version            – show Docker version"
  print_row   widths "systemctl status docker     – show Docker service status"
  print_row   widths "systemctl start docker      – start Docker service"
  print_row   widths "systemctl stop docker       – stop Docker service"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 🐳 CONTAINER MANAGEMENT
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "🐳 CONTAINER MANAGEMENT"
  draw_border widths
  print_row   widths "docker ps                   – list running containers"
  print_row   widths "docker ps -a                – list all containers"
  print_row   widths "docker run <image>          – start a new container"
  print_row   widths "docker stop <container_id>  – stop a container"
  print_row   widths "docker start <container_id> – restart a container"
  print_row   widths "docker rm <container_id>    – remove a container"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 🖼️ IMAGE MANAGEMENT
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "🖼️ IMAGE MANAGEMENT"
  draw_border widths
  print_row   widths "docker images               – list images"
  print_row   widths "docker pull <image>         – download an image"
  print_row   widths "docker rmi <image_id>       – remove an image"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 🔍 LOGS & INSPECTION
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "🔍 LOGS & INSPECTION"
  draw_border widths
  print_row   widths "docker logs <container_id>   – view container logs"
  print_row   widths "docker inspect <container_id>– show container details"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 📦 VOLUMES & NETWORKS
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "📦 VOLUMES & NETWORKS"
  draw_border widths
  print_row   widths "docker volume create <name>  – create a volume"
  print_row   widths "docker volume ls             – list volumes"
  print_row   widths "docker network create <name> – create a network"
  print_row   widths "docker network ls            – list networks"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 📁 FILE COPY
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "📁 FILE COPY"
  draw_border widths
  print_row   widths "docker cp <src> <ctr>:<dst>  – copy host → container"
  print_row   widths "docker cp <ctr>:<src> <dst>  – copy container → host"
  draw_border widths
  # ────────────────────────────────────────────────────────────────────────
  # 🐙 DOCKER COMPOSE
  # ────────────────────────────────────────────────────────────────────────
  draw_border widths
  print_row   widths "🐙 DOCKER COMPOSE"
  print_row   widths "docker-compose --version     – show Compose version"
  print_row   widths "docker-compose up -d         – start services in background"
  print_row   widths "docker-compose down          – stop & remove containers"
  print_row   widths "docker-compose logs <svc>    – view service logs"
  print_row   widths "docker-compose ps            – list services status"
  draw_border widths
  draw_headline
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_8() {
echo ""
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_9() {
echo ""
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_10() {
echo ""
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_11() {
echo ""
}
#------------------------------------------------------------------------------------------------------------------------------
#function display_page_12() {
#echo ""
#}
#------------------------------------------------------------------------------------------------------------------------------
#function display_page_13() {
#echo ""
#}
#------------------------------------------------------------------------------------------------------------------------------
#function display_page_14() {
#echo ""
#}
#------------------------------------------------------------------------------------------------------------------------------
navigate_pages
#------------------------------------------------------------------------------------------------------------------------------
EOF
  process_script_creation "$SCRIPT_PATH2"
  # 📝 Skript2 wurde erfolgreich verarbeitet
fi

# 🔥 Create SCRIPT_PATH3 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH3 🔥
if check_file_exists "$SCRIPT_PATH3"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH3"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH3" > /dev/null
#!/bin/bash

# 🛠️ Function to check if packages are already installed
check_packages() {
  local packages=("curl" "wget" "net-tools" "at" "ca-certificates" "lsb-release")
  local missing_packages=()

  # 🔍 Check each package
  for pkg in "${packages[@]}"; do
    if ! dpkg -l | grep -q "^ii  $pkg "; then
      missing_packages+=("$pkg")
    fi
  done

  # 🔄 Install missing packages
  sleep 2
  if [ ${#missing_packages[@]} -eq 0 ]; then
    echo "📦 All packages are already installed."
  else
    sleep 2
    echo "📦 Installing missing packages: ${missing_packages[*]}"
    sleep 2
    sudo apt update && sudo apt upgrade -y || {
      echo "❌ Error during system update."
      exit 1
    }
    sudo apt install -y "${missing_packages[@]}" || {
      echo "❌ Error installing packages: ${missing_packages[*]}."
      exit 1
    }
  fi

  # 📋 Dynamic display of package status as ASCII table
  echo -e "\n+----------------------------------------------+"
  echo -e "| | ✅ | ❌ | Package Name    | Status            |"
  echo -e "+------------------------------------------------+"
  for pkg in "${packages[@]}"; do
    local status=$(dpkg -l | grep -q "^ii  $pkg " && echo "| ✅ Installed" || echo "| ❌ Missing")
    printf "| %-25s | %-18s |\n" "$pkg" "$status"
  done
  echo -e "+----------------------------------------------+\n"
}

# 🛠️ Invoke the package check and install function
check_packages

# 🕒 Wait time for the user
sleep 5
EOF
  process_script_creation "$SCRIPT_PATH3"
  # 📝 SCRIPT_PATH3 processed successfully
fi

# 🔥 Create SCRIPT_PATH4 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH4 🔥
if check_file_exists "$SCRIPT_PATH4"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH4"
  cat <<EOF | sudo tee "$SCRIPT_PATH4" > /dev/null
#!/usr/bin/env python3
import os
import socket
from datetime import datetime

HOSTS_FILE = "/etc/hosts"

def get_ip(env_var):
    ip = os.getenv(env_var)
    if ip:
        return ip
    if env_var == "IP1":
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
            s.connect(("8.8.8.8", 80))
            return s.getsockname()[0]
        finally:
            s.close()
    return None

IP1 = get_ip("IP1")

# Domains come from Bash wrapper via ENV: LOCAL_DOMAIN, GLOBAL_DOMAIN
DOMAINS_IP1 = "$LOCAL_DOMAIN".split()
DOMAINS_IP2 = "$GLOBAL_DOMAIN".split()

def log(msg):
    print(f"{datetime.now():%Y-%m-%d %H:%M:%S} - {msg}")

def add_entries(ip, domains, header):
    if not ip or not domains:
        return
    with open(HOSTS_FILE, "r") as f:
        lines = f.readlines()
    if not any(header in line for line in lines):
        with open(HOSTS_FILE, "a") as f:
            f.write(f"{header}\n")
    with open(HOSTS_FILE, "a") as f:
        for d in domains:
            if d and not any(d == part for line in lines for part in line.split()):
                f.write(f"{ip} {d}\\n")
                log(f"Entry added: {ip} {d}")

if __name__ == "__main__":
    if os.geteuid() != 0:
        print("Dieses Skript muss als Root laufen!")
        exit(1)
    add_entries(IP1, DOMAINS_IP1,  "#====== LOCAL_DOMAIN ======")
    add_entries(IP1, DOMAINS_IP2, "#====== GLOBAL_DOMAIN ======")
EOF
  process_script_creation "$SCRIPT_PATH4"
  # 📝 SCRIPT_PATH4 processed successfully
fi

# 🔥 Create SCRIPT_PATH5 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH5 🔥
if check_file_exists "$SCRIPT_PATH5"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH5"
  cat <<EOF  | sudo tee "$SCRIPT_PATH5" > /dev/null
#!/usr/bin/env python3
import os
import socket
import subprocess
from datetime import datetime

# 1) Try ENV variable, 2) fallback to socket query
def get_server_ip():
    if ip := os.getenv("SERVER_IP"):
        return ip
    # Fallback
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        return s.getsockname()[0]
    finally:
        s.close()

# Pass Bash variable as ENV
SERVER_IP = get_server_ip()
# Prefix from first three octets
PREFIX = ".".join(SERVER_IP.split('.')[:3])

HOSTS = {
    "1.1.1.1": "Cloudflare DNS",
    "8.8.8.8": "Google DNS",
    SERVER_IP: "Server",
    f"{PREFIX}.1": "RouterHome",
    f"{PREFIX}.4": "Pi-hole DNS",
    f"{PREFIX}.5": "VPN Server",
    "$LOCAL_DOMAIN": "domain1",
    "$GLOBAL_DOMAIN": "domain2",
}

def ping_host(host):
    try:
        subprocess.run(
            ["ping", "-c", "3", "-W", "2", host],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True,
        )
        return True
    except subprocess.CalledProcessError:
        return False

def main():
    print("==== Starting Ping Test ====")
    print(f"Date: {datetime.now():%Y-%m-%d %H:%M:%S}\\n")
    failed = []
    for host, desc in HOSTS.items():
        print(f"Pinging {host} ({desc})…")
        if ping_host(host):
            print(f"{host} ({desc}) is reachable ✅")
        else:
            failed.append(f"{host} ({desc})")
            print(f"{host} ({desc}) is unreachable ❌")
        print()
    print("==== Ping Test Completed ====")
    if failed:
        print("==== Failed Hosts ====")
        print(*failed, sep="\n")
    else:
        print("All hosts are reachable ✅")

if __name__ == "__main__":
    main()
EOF

  # Export ENV for Python
  export SERVER_IP

  process_script_creation "$SCRIPT_PATH5"
  # 📝 SCRIPT_PATH5 processed successfully
fi

# 🔥 Create SCRIPT_PATH6 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH6 🔥
if check_file_exists "$SCRIPT_PATH6"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH6"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH6" > /dev/null
#!/bin/bash

# Definition of the log_message function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Display contents of /etc/hosts file
echo "📁 Contents of /etc/hosts:"
echo "-----------------------------"
cat /etc/hosts
echo "+----------------------------------------------------+"
EOF
  process_script_creation "$SCRIPT_PATH6"
  # 📝 SCRIPT_PATH6 processed successfully
fi
# 🔥 Create SCRIPT_PATH7 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH7 🔥
if check_file_exists "$SCRIPT_PATH7"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH7"
cat <<EOF | sudo tee "$SCRIPT_PATH7" > /dev/null
#!/bin/bash
log_message() {
  echo "\$(date '+%Y-%m-%d %H:%M:%S') - \$1"
}

# Dynamic variables (must come from your wrapper):
# SERVER_IP, LOCAL_DOMAIN, GLOBAL_DOMAIN

URLS=(
  "http://${SERVER_IP}"
  "https://${SERVER_IP}"
  "http://${LOCAL_DOMAIN}"
  "https://${LOCAL_DOMAIN}"
  "http://${GLOBAL_DOMAIN}"
  "https://${GLOBAL_DOMAIN}"
)

declare -a RESULTS

check_url() {
  local url="\$1"
  if curl -k -I --silent --fail --max-time 5 "\$url" >/dev/null; then
    mark="✅"
  else
    mark="❌"
  fi
  RESULTS+=( "\$url|\$mark" )
}


# Literal loop: dollar signs are escaped, evaluated in the script
for url in "\${URLS[@]}"; do
  check_url "\$url"
done

# Output table
printf '+-%-60s-+-%-3s-+\n' "------------------------------------------------------------" "---"
printf '| %-60s | %-3s |\n' "URL" ""
printf '+-%-60s-+-%-3s-+\n' "============================================================" "==="
for entry in "\${RESULTS[@]}"; do
  IFS='|' read -r u mark <<< "\$entry"
  printf '| %-60s | %-3s |\n' "\$u" "\$mark"
done
printf '+-%-60s-+-%-3s-+\n' "------------------------------------------------------------" "---"
EOF
  process_script_creation "$SCRIPT_PATH7"
  # 📝 SCRIPT_PATH7 processed successfully
fi

# 🔥 Create SCRIPT_PATH8 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH8 🔥
if check_file_exists "$SCRIPT_PATH8"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH8"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH8" > /dev/null
#!/usr/bin/env bash

# Script: Install Docker Engine and Docker Compose on Ubuntu
# Updated: 2025-05-14

set -euo pipefail

sudo apt-get install -y gnupg

# ─────────────────────────────────────────────────────────────────────────────
# Variables
# ─────────────────────────────────────────────────────────────────────────────
DOCKER_GPG_URL="https://download.docker.com/linux/ubuntu/gpg"
KEYRING_DIR="/etc/apt/keyrings"
KEYRING_FILE="${KEYRING_DIR}/docker.gpg"
UBUNTU_CODENAME="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")"
DOCKER_REPO="deb [arch=$(dpkg --print-architecture) signed-by=${KEYRING_FILE}] \
  https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable"

COMPOSE_APT_PKG="docker-compose-plugin"
COMPOSE_BIN="/usr/local/bin/docker-compose"
COMPOSE_FALLBACK_URL="https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)"

# Simple logger
log() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] $*"
}

# ─────────────────────────────────────────────────────────────────────────────
# 1) Install Docker Engine
# ─────────────────────────────────────────────────────────────────────────────
if command -v docker &> /dev/null; then
  log "Docker already installed: $(docker --version)"
else
  log "Adding Docker GPG key..."
  sudo mkdir -p "${KEYRING_DIR}"
  curl -fsSL "${DOCKER_GPG_URL}" \
    | sudo gpg --dearmor -o "${KEYRING_FILE}"
  sudo chmod a+r "${KEYRING_FILE}"

  log "Adding Docker apt repository..."
  echo "${DOCKER_REPO}" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  log "Updating apt and installing Docker Engine..."
  sudo apt-get update
  sudo apt-get install -y \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  log "Verifying Docker installation..."
  if docker --version &> /dev/null; then
    log "Successfully installed $(docker --version)"
  else
    log "Error: Docker installation failed"
    exit 1
  fi
fi

# ─────────────────────────────────────────────────────────────────────────────
# 2) Install Docker Compose
# ─────────────────────────────────────────────────────────────────────────────
if docker compose version &> /dev/null; then
  log "Docker Compose plugin already installed: $(docker compose version)"
else
  log "Installing Docker Compose plugin via apt..."
  sudo apt-get update
  sudo apt-get install -y ${COMPOSE_APT_PKG}

  if docker compose version &> /dev/null; then
    log "Successfully installed $(docker compose version)"
  else
    log "APT install failed, falling back to manual download..."
    log "Downloading Docker Compose binary..."
    sudo curl -fsSL "${COMPOSE_FALLBACK_URL}" -o "${COMPOSE_BIN}"
    sudo chmod +x "${COMPOSE_BIN}"

    if "${COMPOSE_BIN}" --version &> /dev/null; then
      log "Successfully installed $("${COMPOSE_BIN}" --version)"
    else
      log "Error: Docker Compose installation failed"
      exit 1
    fi
  fi
fi

log "Installation complete. Enjoy using Docker and Docker Compose!"

# ────────────────────────────────────────────────────────────────────────
# ASCII Table Drawing Functions
# ────────────────────────────────────────────────────────────────────────

COL1=68
widths=($COL1)

draw_headline() {
  local length=$((COL1 + 2))
  printf '%*s\n' "$length" '' | tr ' ' '='
}

draw_border() {
  local -n w=$1
  local line="+"
  for b in "${w[@]}"; do
    line+=$(printf '%*s' $((b+2)) '' | tr ' ' '-')+
  done
  echo "${line%+}+"
}

print_row() {
  local -n w=$1
  shift
  local cells=("$@")
  local row="|"
  for i in "${!w[@]}"; do
    row+=" $(printf "%-${w[i]}s" "${cells[i]}") "
  done
  echo "$row"
}

# ────────────────────────────────────────────────────────────────────────
# Feedback zu installierten Komponenten
# ────────────────────────────────────────────────────────────────────────

echo ""
draw_headline
echo " Docker & Docker Compose Status Check "
draw_headline

if command -v docker &>/dev/null; then
  docker_ver=$(docker --version)
  echo "✅ Docker is installed: $docker_ver"
else
  echo "❌ Docker is not installed!"
fi

if docker compose version &>/dev/null; then
  compose_ver=$(docker compose version)
  echo "✅ Docker Compose plugin is installed: $compose_ver"
else
  echo "❌ Docker Compose is not installed!"
fi

# ────────────────────────────────────────────────────────────────────────
# Docker & Compose Befehle Übersicht (DE/EN)
# ────────────────────────────────────────────────────────────────────────

echo ""
draw_headline
echo " Common Docker & Docker Compose Commands "
draw_headline

draw_border widths
print_row widths "docker ps              → Show running containers"
print_row widths "docker images          → List local images"
print_row widths "docker run hello-world → Run test container"
print_row widths "docker stop <ID|NAME>  → Stop a container"
print_row widths "docker rm <ID|NAME>    → Remove a container"
print_row widths "docker-compose up -d   → Start services in background"
print_row widths "docker-compose down    → Stop and remove services"
print_row widths "docker-compose logs    → Show logs"
draw_border widths
echo ""
EOF
  process_script_creation "$SCRIPT_PATH8"
  # 📝 SCRIPT_PATH8 processed successfully
fi

# 🔥 Create SCRIPT_PATH9 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH9 🔥
if check_file_exists "$SCRIPT_PATH9"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH9"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH9" > /dev/null
# 🎉 Placeholder
sleep 1
echo "🎉 Installation completed successfully."
EOF
  process_script_creation "$SCRIPT_PATH9"
  # 📝 SCRIPT_PATH9 processed successfully
fi

# 🔥 Create SCRIPT_PATH10 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH10 🔥
if check_file_exists "$SCRIPT_PATH10"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH10"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH10" > /dev/null
# 🎉 Placeholder
sleep 1
echo "🎉 Installation completed successfully."
EOF
  process_script_creation "$SCRIPT_PATH10"
  # 📝 SCRIPT_PATH10 processed successfully
fi

# 🔥 Create SCRIPT_PATH11 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH11 🔥
if check_file_exists "$SCRIPT_PATH11"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH11"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH11" > /dev/null
# 🎉 Placeholder
sleep 1
echo "🎉 Installation completed successfully."
EOF
  process_script_creation "$SCRIPT_PATH11"
  # 📝 SCRIPT_PATH11 processed successfully
fi

# 🔥 Skript 999 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Skript 999 erstellen 🔥
#if check_file_exists "$SCRIPT_PATH999"; then
#  sleep 0.5
#  log_message "📄 Creating file: $SCRIPT_PATH999"
#  cat << 'EOF' | sudo tee "$SCRIPT_PATH999" > /dev/null
#[📝 Skript 999 einfügen 📝]
#EOF
#  process_script_creation "$SCRIPT_PATH999"
  # 📝 Skript 7 wurde erfolgreich verarbeitet
#fi
#+----------------------------------------------------------------------------------------------------------------------------------+
#+----------------------------------------------------------------------------------------------------------------------------------+
#+----------------------------------------------------------------------------------------------------------------------------------+
#+----------------------------------------------------------------------------------------------------------------------------------+
#+----------------------------------------------------------------------------------------------------------------------------------+
# ⚙️ Set execute permissions and run systemv.sh | SCRIPT_PATH0
sleep 0.5
if [ -f "$SCRIPT_PATH0" ]; then
    sudo chmod +x "$SCRIPT_PATH0"
    log_message "🔧 Execute permission set for $(basename "$SCRIPT_PATH0")."
    sleep 1
    log_message "🖥️ Displaying system information"
    if sudo bash "$SCRIPT_PATH0" | tee -a /var/log/installation_script.log; then
        log_message "🎉 $(basename "$SCRIPT_PATH0") ran successfully."
    else
        log_message "❌ Error running $(basename "$SCRIPT_PATH0")."
        exit 1
    fi
else
    log_message "❌ $(basename "$SCRIPT_PATH0") not found."
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# ⚙️ Run upgrade.sh | SCRIPT_PATH3="/usr/local/bin/upgrade.sh"
sleep 0.5
log_message "🛠️ Starting system upgrade"
if [ -f "$SCRIPT_PATH3" ]; then
    sleep 0.5
    log_message "✅ $(basename "$SCRIPT_PATH3") found. Running script."
    if sudo bash "$SCRIPT_PATH3" | tee -a /var/log/installation_script.log; then
        log_message "🎉 $(basename "$SCRIPT_PATH3") ran successfully."
    else
        log_message "❌ Error running $(basename "$SCRIPT_PATH3")."
        exit 1
    fi
else
    log_message "❌ $(basename "$SCRIPT_PATH3") not found."
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# ⚙️ Run hosts.py | SCRIPT_PATH4="/usr/local/bin/hosts.py"
sleep 0.5
log_message "🛠️ Updating hosts file"
if [ -f "$SCRIPT_PATH4" ]; then
    sleep 0.5
    log_message "✅ $(basename "$SCRIPT_PATH4") found. Running script."
    if sudo python3 "$SCRIPT_PATH4" | tee -a /var/log/installation_script.log; then
        log_message "🎉 $(basename "$SCRIPT_PATH4") ran successfully."
    else
        log_message "❌ Error running $(basename "$SCRIPT_PATH4")."
        exit 1
    fi
else
    log_message "❌ $(basename "$SCRIPT_PATH4") not found."
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# ⚙️ Run ping.py | SCRIPT_PATH5="/usr/local/bin/ping.py"
sleep 0.5
log_message "🛠️ Checking required connections"
if [ -f "$SCRIPT_PATH5" ]; then
    sleep 0.5
    log_message "✅ $(basename "$SCRIPT_PATH5") found. Running script."
    # Unbuffered Python output, real-time to terminal and log
    sudo PYTHONUNBUFFERED=1 python3 "$SCRIPT_PATH5" 2>&1 | tee -a /var/log/installation_script.log
    RET=${PIPESTATUS[0]}
    if [ "$RET" -eq 0 ]; then
        log_message "🎉 $(basename "$SCRIPT_PATH5") ran successfully."
    else
        log_message "❌ Error running $(basename "$SCRIPT_PATH5")."
        exit 1
    fi
else
    log_message "❌ $(basename "$SCRIPT_PATH5") not found."
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# 🛠️ Add entry to crontab
sleep 0.5
log_message "🔄 Adding entry to crontab if missing."
if ! crontab -l | grep -q '/usr/local/bin/hosts.py'; then
  (crontab -l 2>/dev/null; echo "@reboot /usr/local/bin/hosts.py") | crontab -
  sleep 0.5
  log_message "🎉 Crontab entry added successfully."
else
  sleep 0.5
  log_message "ℹ️ Crontab entry already exists."
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# 📜 Add entry to .bashrc
sleep 0.5
log_message "🔄 Adding entry to ~/.bashrc if missing."
if ! grep -q 'sudo /usr/local/bin/cat.sh' ~/.bashrc; then
  cat << 'EOF' | tee -a ~/.bashrc > /dev/null
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 🛠️ Auto-run scripts on SSH login
if [ -n "$SSH_CONNECTION" ]; then  # Check if SSH connection exists
    sudo /usr/local/bin/cat.sh  # Run cat.sh
    if [ $? -eq 0 ]; then  # If cat.sh succeeded (exit code 0)
        sudo /usr/local/bin/skripts.sh  # Run skripts.sh
    else
        echo "❌ cat.sh failed. skripts.sh will not run."
    fi
fi
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
EOF
  sleep 0.5
  log_message "🎉 Entry added to ~/.bashrc successfully."
else
  sleep 0.5
  log_message "ℹ️ ~/.bashrc entry already exists."
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# 🔄 Download und Installation des Nextcloud-Skripts
#+----------------------------------------------------------------------------------------------------------------------------------+
sleep 0.5
log_message "🌐 Downloading Nextcloud installation script from GitHub"
if sudo curl -fsSL \
     https://raw.githubusercontent.com/kleiveist/ServerHome/main/bin/nextcloud.sh \
     -o /usr/local/bin/nextcloud.sh; then
  sudo chmod +x /usr/local/bin/nextcloud.sh
  log_message "✅ nextcloud.sh downloaded and made executable successfully"
else
  log_message "❌ Failed to download nextcloud.sh"
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
sleep 0.5
log_message "🛠️ Verifying URLs"
if [ -f "$SCRIPT_PATH7" ]; then
    sleep 0.5
    log_message "✅ $(basename "$SCRIPT_PATH7") found. Running script."
    if sudo bash "$SCRIPT_PATH7" | tee -a /var/log/installation_script.log; then
        log_message "🎉 $(basename "$SCRIPT_PATH7") ran successfully."
    else
        log_message "❌ Error running $(basename "$SCRIPT_PATH7")."
        exit 1
    fi
else
    log_message "❌ $(basename "$SCRIPT_PATH7") not found."
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
sudo cat.sh
# Reboot the system
log_message "🔄 Rebooting the system."
sleep 5
#sudo reboot
