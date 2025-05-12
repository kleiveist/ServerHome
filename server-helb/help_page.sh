#!/bin/bash
# ────────────────────────────────────────────────────────────────────────
# ASCII Table Drawing Functions
# ────────────────────────────────────────────────────────────────────────

# Spaltenbreite (nur eine Spalte)
COL1=68
widths=($COL1)

# Draws a headline separator line using '='
function draw_headline() {
  # Länge = Spaltenbreite + 2 (für je ein Leerzeichen links/rechts)
  local length=$((COL1 + 2))
  # '+' , dann 'length' mal '=', dann '+'
  printf '+%*s+\n' "$length" '' | tr ' ' '='
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
  draw_headline
  draw_border widths
  print_row  widths "🖥️ System: $(lsb_release -d | cut -f2)"
  print_row  widths "Hostname: $(hostname)"
  print_row  widths "User: $(whoami)"
  print_row  widths "Time: $(date '+%Y-%m-%d %H:%M:%S')"
  draw_border widths
  draw_headline
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_1() {

  draw_headline
  print_row  widths "📚 TABLE OF CONTENTS"
  draw_headline

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
  draw_headline
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
