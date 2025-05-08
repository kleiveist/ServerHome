#!/bin/bash

LOG_FILE="/var/log/installation_script.log"
log_message() {
  local message=$1
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}
echo "💾 /var/log/installation_script.log erstellt"
# ────────────────────────────────────────────────────────────────────────
# 🛠️ Dynamische Bestimmung von Server-IP und Systeminformationen
# ────────────────────────────────────────────────────────────────────────
SERVER_IP="$(hostname -I | awk '{print $1}')"
OS_DESCRIPTION="$(lsb_release -d | awk -F'\t' '{print $2}')"
HOSTNAME_VAR="$(hostname)"
USER_VAR="$(whoami)"
CURRENT_TIME="$(date '+%Y-%m-%d %H:%M:%S')"

log_message "🔧 Installationsserver IP ermittelt: $SERVER_IP"
#+-------------------------------------------------------------------------------------------------------------------------------+
# 🛠️ Funktion zur Überprüfung, ob die Datei bereits existiert
check_file_exists() {
  sleep 0.3
  local file_path=$1
  if [ -f "$file_path" ]; then
    log_message "ℹ️  Datei $file_path existiert bereits. Erstellung wird übersprungen."
    return 1
  else
    return 0
  fi
}
# 🛠️ Funktion zur Verarbeitung der Skripterstellung
process_script_creation() {
  local script_path=$1
  if [ ! -f "$script_path" ]; then
    log_message "❌ Fehler: Skript $script_path wurde nicht gefunden."
    return 1
  fi
  if [ $? -ne 0 ]; then
    log_message "❌ Fehler: Skript $script_path wurde nicht erstellt."
  else
    sleep 2
    sudo chmod +x "$script_path"
    log_message "🎉 Skript erfolgreich erstellt | : $script_path"
  fi
}
#+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
# 🖥️ System Skriptpfade
SCRIPT_PATH0="/usr/local/bin/systemv.sh"
# 🗂️ Definition der Skriptpfade
SCRIPT_PATH1="/usr/local/bin/skripts.sh"
SCRIPT_PATH2="/usr/local/bin/help.sh"
# 📜 Help - Skriptpfade📝 💾 📂 🛠️
SCRIPT_PATH3="/usr/local/bin/upgrade.sh"
SCRIPT_PATH4="/usr/local/bin/update_hosts.py"
SCRIPT_PATH5="/usr/local/bin/ping_test.py"
SCRIPT_PATH6="/usr/local/bin/cat_hosts.sh"
SCRIPT_PATH7="/usr/local/bin/check_urls.sh"
SCRIPT_PATH8="/usr/local/bin/08.sh"
SCRIPT_PATH9="/usr/local/bin/09.sh"
SCRIPT_PATH10="/usr/local/bin/10.sh"
SCRIPT_PATH11="/usr/local/bin/11.sh"
#+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
# 🔄 Dynamische Umwandlung in ein Array, ungültige Pfade ignorieren
SCRIPT_PATHS=()
for VAR in SCRIPT_PATH{1..11}; do
    VALUE="${!VAR}" # Hole den Wert der Variablen
    if [[ -n "$VALUE" && "$VALUE" != */ ]]; then
        SCRIPT_PATHS+=("$VALUE")
    fi
done
# ────────────────────────────────────────────────────────────────────────
# ❓ Möchten Sie alle alten Skripte vor der Neuerstellung löschen? [y/N]
# ────────────────────────────────────────────────────────────────────────
read -rp "Alte Skripte löschen (y/n)? " answer
case "${answer,,}" in
  y|yes )
    log_message "🗑️  Lösche alte Skripte..."
    for VAR in SCRIPT_PATH{0..11}; do
      FILE="${!VAR}"
      if [ -n "$FILE" ] && [ -f "$FILE" ]; then
        sudo rm -f "$FILE"
        log_message "🗑️  Alte Datei gelöscht: $FILE"
      fi
    done
    ;;
  * )
    log_message "ℹ️  Löschen alter Skripte übersprungen."
    ;;
esac
#+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
# 🔥 Skript0 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -- - - - - - - - - -+🔥 Skript0 erstellen 🔥
if check_file_exists "$SCRIPT_PATH0"; then
  sleep 1
  log_message "📄 Erstelle die Datei: $SCRIPT_PATH0"
  {
  cat << 'EOF' | sudo tee "$SCRIPT_PATH0" > /dev/null
#!/bin/bash
# ────────────────────────────────────────────────────────────────────────
# system_vars.sh – zentrale Definition und Ausgabe Deiner System-Variablen
# ────────────────────────────────────────────────────────────────────────

# Variablen
SERVER_IP="$(hostname -I | awk '{print $1}')"
OS_DESCRIPTION="$(lsb_release -d | awk -F'\t' '{print $2}')"
HOSTNAME_VAR="$(hostname)"
USER_VAR="$(whoami)"
CURRENT_TIME="$(date '+%Y-%m-%d %H:%M:%S')"

# Einfaches Log-Helper
log_message() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Funktion zur strukturierten Ausgabe
show_system_info() {
  echo "╔════════════════════════════════════════════════════════════════╗"
  echo "║                        📜 SYSTEMINFORMATIONEN                 ║"
  echo "╠════════════════════════════════════════════════════════════════╣"
  printf "║ Betriebssystem: %-49s ║\n" "$OS_DESCRIPTION"
  printf "║ Hostname:       %-49s ║\n" "$HOSTNAME_VAR"
  printf "║ Benutzer:       %-49s ║\n" "$USER_VAR"
  printf "║ Aktuelle Zeit:  %-49s ║\n" "$CURRENT_TIME"
  echo "╚════════════════════════════════════════════════════════════════╝"
}

# Nur bei direkter Ausführung: Log und Anzeige
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  log_message "🔧 Installationsserver IP ermittelt: $SERVER_IP"
  show_system_info
fi

EOF
  } | sudo tee "$SCRIPT_PATH0" > /dev/null

  process_script_creation "$SCRIPT_PATH0"
fi

# 🔥 Skript1 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Skript1 erstellen 🔥
if check_file_exists "$SCRIPT_PATH1"; then
  sleep 1
  log_message "📄 Erstelle die Datei: $SCRIPT_PATH1"
  {
cat << 'STATIC_CONTENT'
#!/bin/bash
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                        📜 VERFÜGBARE SCRIPTS                   ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
STATIC_CONTENT

    # Einzige Methode: alle .sh/.py in /usr/local/bin
    for f in /usr/local/bin/*.{sh,py}; do
      [ -f "$f" ] || continue
      FN=$(basename "$f")
      # Füllt rechts mit Leerzeichen auf, damit die Breite passt
      PADDING=$((55 - ${#FN}))
      printf 'echo "║ │  📜 %s%*s │ ║"\n' "$FN" "$PADDING" ""
    done

  cat << 'STATIC_CONTENT_END'
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
STATIC_CONTENT_END
  } | sudo tee "$SCRIPT_PATH1" > /dev/null

  process_script_creation "$SCRIPT_PATH1"
fi

# 🔥 Skript2 erstellen 🔥+- - - - - - - - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Skript2 erstellen 🔥
if check_file_exists "$SCRIPT_PATH2"; then
  sleep 1
  log_message "📄 Erstelle die Datei: $SCRIPT_PATH2"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH2" > /dev/null
#!/bin/bash

# Funktion zur Navigation der Seiten
function navigate_pages() {
    current_page=1
    total_pages=11

    while true; do
        clear

        # Anzeige der Anweisung oben
        display_navigation_instructions

        if [ "$current_page" -eq 1 ]; then
            display_page_1
        elif [ "$current_page" -eq 2 ]; then
            display_page_2
        elif [ "$current_page" -eq 3 ]; then
            display_page_3
        elif [ "$current_page" -eq 4 ]; then
            display_page_4
        elif [ "$current_page" -eq 5 ]; then
            display_page_5
        elif [ "$current_page" -eq 6 ]; then
            display_page_6
        elif [ "$current_page" -eq 7 ]; then
            display_page_7
        elif [ "$current_page" -eq 8 ]; then
            display_page_8
        elif [ "$current_page" -eq 9 ]; then
            display_page_9
       elif [ "$current_page" -eq 10 ]; then
           display_page_10
       elif [ "$current_page" -eq 11 ]; then
           display_page_11
       #elif [ "$current_page" -eq 12 ]; then
       #    display_page_12
       #elif [ "$current_page" -eq 13 ]; then
       #    display_page_13
       #elif [ "$current_page" -eq 14 ]; then
       #    display_page_14
        fi

        # Anzeige der Anweisung unten
        display_navigation_instructions

        read -rsn1 input
        case "$input" in
            "A") ;; # Pfeil nach oben - keine Aktion
            "B")
                echo "🚪 Das Skript wird beendet... Vielen Dank fürs Verwenden!"
                break
                ;;
            "C") # Rechts
                if [ "$current_page" -lt "$total_pages" ]; then
                    current_page=$((current_page + 1))
                fi
                ;;
            "D") # Links
                if [ "$current_page" -gt 1 ]; then
                    current_page=$((current_page - 1))
                fi
                ;;
            $'\x18') # Strg + X (ASCII 0x18)
                echo "🚪 Das Skript wird beendet... Vielen Dank fürs Verwenden!"
                break
                ;;
            *)
                echo "⚠️  Pfeiltasten Links (←), Rechts (→) oder Runter (↓) verwenden."
                ;;
        esac
    done
}

# 🛠️ Funktion zur Anzeige der Anweisungen
function display_navigation_instructions() {
    echo ""
    echo "🔄 Blättern mit Links (←) / Rechts (→), Beenden mit Pfeil nach unten (↓) || Strg + X"
    echo "📄 Dies ist Seite $current_page"
    echo ""
}
#------------------------------------------------------------------------------------------------------------------------------
# Funktion, um die zero Seite anzuzeigen
#function display_page_0() {
#}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_1() {
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                       📚 INHALTSVERZEICHNIS                     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📘 SEITENÜBERSICHT                                             ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📄 Seite 1: Verzeichnis-Übersicht                             ║"
echo "║    ➡️ Systemverzeichnisse, UFW-Verzeichnisse, NGINX-Verzeichnisse ║"
echo "║    ➡️ Log-Dateien, Benutzerverzeichnisse                        ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📄 Seite 2: Verfügbare Skripte & Wichtige Warnungen            ║"
echo "║    ➡️ Übersicht der verfügbaren Skripte                       ║"
echo "║    ➡️ Wichtige Logs und Warnung zu auto-ssl.sh                 ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📄 Seite 3: System-Befehle & Service-Status                   ║"
echo "║    ➡️ Neustart, Systembefehle, Service-Status                  ║"
echo "║    ➡️ Neustart-Befehle, Log-Befehle                            ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📄 Seite 4: NGINX-Befehle & Konfigurationshilfe               ║"
echo "║    ➡️ Wichtige NGINX-Befehle, Verzeichnisse, Logs               ║"
echo "║    ➡️ Dienst-Befehle, Troubleshooting                          ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📄 Seite 5: NGINX Konfigurationshilfe                         ║"
echo "║    ➡️ Erklärungen zur nginx.conf                              ║"
echo "║    ➡️ Blöcke, Direktiven, Server-Blöcke                       ║"
echo "║    ➡️ Location-Matching, Praktische Beispiele                 ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📄 Seite 6: UFW-Firewall-Kommandos                            ║"
echo "║    ➡️ Installation, Status, Regeln, Logging                    ║"
echo "║    ➡️ NGINX-Firewall-Befehle, Protokolle                      ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📢 NAVIGATIONS-HINWEISE                                        ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 🔄 Navigation mit den Pfeiltasten:                            ║"
echo "║    ➡️ Links (←) – Zurückblättern                               ║"
echo "║    ➡️ Rechts (→) – Weiterblättern                             ║"
echo "║    🔽 Pfeil nach unten (↓) – Beendet das Skript               ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📜 SYSTEMINFORMATIONEN                                         ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ Betriebssystem: $(lsb_release -d | awk -F'\t' '{print $2}')     ║"
echo "║ Hostname: $(hostname)                                          ║"
echo "║ Benutzer: $(whoami)                                            ║"
echo "║ Aktuelle Zeit: $(date '+%Y-%m-%d %H:%M:%S')                    ║"
echo "╚════════════════════════════════════════════════════════════════╝"
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_2() {
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                        💾 LOG-HINWEISE                         ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 💾 cat /var/log/installation_script.log                    │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                        📜 VERFÜGBARE SCRIPTS                   ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
  for f in /usr/local/bin/*.{sh,py}; do
    [ -f "$f" ] || continue
    FN=$(basename "$f")
    printf '║ │  📜 %-55s │ ║\n' "$FN"
  done
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                        📚 HILFE-SKRIPTE                        ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 3 - 📚 help.sh                                             │ ║"
echo "║ │ 4 - 📚 kripts.sh                                           │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
}
#------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------
function display_page_3() {
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                          🔄 SYSTEM-BEFEHLE                     ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📌 Neustart des Systems                                        ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 💻 sudo reboot                                             │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                        🖥️ SYSTEM & MONITORING                  ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📊 Systembelastung, Prozesse und Logs prüfen                   ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 📈 top                                                     │ ║"
echo "║ │ 📉 htop (ggf. installieren: sudo apt-get install htop)     │ ║"
echo "║ │ 📜 journalctl -xe                                          │ ║"
echo "║ │ 💽 df -h (Dateisystem-Auslastung)                          │ ║"
echo "║ │ 🏗️ free -h (RAM-Auslastung)                                │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                         📋 SERVICE-STATUS                       ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 🛠️ Status der folgenden Dienste prüfen                         ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 📡 sudo systemctl status nginx                             │ ║"
echo "║ │ 🗂️ sudo systemctl status supervisor                        │ ║"
echo "║ │ 🗄️ sudo systemctl status postgresql                         │ ║"
echo "║ │ 🔴 sudo systemctl status redis                             │ ║"
echo "║ │ 🐇 sudo systemctl status rabbitmq-server                   │ ║"
echo "║ │ 📄 sudo systemctl status onlyoffice-documentserver         │ ║"
echo "║ │ 🌐 sudo systemctl status apache2                           │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    🔁 SERVICE-NEUSTART BEFEHLE                  ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 🔄 Neustart der folgenden Dienste                              ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 🐇 sudo systemctl restart rabbitmq-server                  │ ║"
echo "║ │ 📄 sudo systemctl restart onlyoffice-documentserver        │ ║"
echo "║ │ 🌐 sudo systemctl restart apache2                          │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                         🌐 APACHE-BEFEHLE                       ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📜 Apache Konfiguration und Logs prüfen                       ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 🌐 sudo apache2ctl -S                                      │ ║"
echo "║ │ 📜 sudo tail -n 10 /var/log/apache2/error.log              │ ║"
echo "║ │ 📜 sudo tail -n 10 /var/log/apache2/access.log             │ ║"
echo "║ │ ✍️ sudo nano /etc/apache2/sites-available/onlyoffice.local.conf │ ║"
echo "║ │ ✍️ sudo nano /etc/apache2/sites-available/onlyoffice-ssl.conf  │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                         📜 LOG-ANALYSE                          ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📑 Logs der ONLYOFFICE-Dienste anzeigen                        ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 📜 sudo tail -n 10 /var/log/onlyoffice/documentserver/docservice/out.log  │ ║"
echo "║ │ 📜 sudo tail -n 10 /var/log/onlyoffice/documentserver/converter/out.log   │ ║"
echo "║ │ 📜 sudo tail -n 10 /var/log/onlyoffice/documentserver/metrics/out.log     │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                     ✍️ EDITOR-BEFEHLE (NANO)                     ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ✍️ Dateien zum Bearbeiten                                      ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 📘 nano /etc/hosts                                         │ ║"
echo "║ │ 📘 sudo nano /usr/local/bin/cat_hosts.sh                   │ ║"
echo "║ │ 📘 sudo nano /usr/local/bin/ping_test.py                   │ ║"
echo "║ │ 📘 sudo nano /usr/local/bin/restart-onlyoffice.py          │ ║"
echo "║ │ 📘 sudo nano /usr/local/bin/check_rabbitmq_connection.s    │ ║"
echo "║ │ 📘 nano ~/.bashrc                                          │ ║"
echo "║ │ 📘 sudo crontab -e                                         │ ║"
echo "║ │ 📘 sudo nano /usr/local/bin/show_help_commands.sh          │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_4() {
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                     📚 NGINX HILFE & KOMMANDOS                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                         📁 WICHTIGE VERZEICHNISSE               ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 🔍 Hauptverz.: /etc/nginx/                                      ║"
echo "║ 🔍 Konfig-Datei: /etc/nginx/nginx.conf                          ║"
echo "║ 🔍 Virt. Hosts: /etc/nginx/sites-available/                     ║"
echo "║ 🔍 Aktivierte Hosts: /etc/nginx/sites-enabled/                  ║"
echo "║ 🔍 Module: /etc/nginx/conf.d/                                   ║"
echo "║ 🔍 Logs: /var/log/nginx/access.log & /var/log/nginx/error.log   ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                         📄 NÜTZLICHE BEFEHLE                    ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 🛠️ NGINX Dienst-Optionen                                       ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 📜 start: sudo systemctl start nginx                       │ ║"
echo "║ │ 📜 stop: sudo systemctl stop nginx                         │ ║"
echo "║ │ 🔄 restart: sudo systemctl restart nginx                   │ ║"
echo "║ │ 🔄 reload: sudo systemctl reload nginx                     │ ║"
echo "║ │ 🔄 status: sudo systemctl status nginx                     │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📋 Konfiguration & Logs                                         ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ ✅ Test: nginx -t                                            │ ║"
echo "║ │ 📜 Konfig anzeigen: nginx -T                                 │ ║"
echo "║ │ 🔍 Version: nginx -V                                         │ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                      🔍 FEHLERSUCHE & LOGS                      ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📜 Logs anzeigen:                                              ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 📜 Fehlerlogs: cat /var/log/nginx/error.log                  │ ║"
echo "║ │ 📜 Letzte Fehler: tail -n 20 /var/log/nginx/error.log        │ ║"
echo "║ │ 📜 Live-Fehler: tail -f /var/log/nginx/error.log             │ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                         📂 DATEISUCHE                          ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📂 Wichtige Dateien finden:                                    ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 📜 Alle .conf-Dateien: find /etc/nginx -name '*.conf'       │ ║"
echo "║ │ 🔍 Server-Namen: grep -r 'server_name' /etc/nginx/           │ ║"
echo "║ │ 🔍 Ports finden: grep -r 'listen' /etc/nginx/                │ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                         ⚙️ SYSTEMSTATUS                        ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📊 NGINX Systemstatus:                                        ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 📜 Dienststatus: sudo systemctl status nginx                │ ║"
echo "║ │ 📜 Prozesse: ps aux | grep nginx                            │ ║"
echo "║ │ 🔍 Port 80: netstat -tuln | grep 80                         │ ║"
echo "║ │ 🔍 Port 443: netstat -tuln | grep 443                       │ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                     📢 NÜTZLICHE HINWEISE                      ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 🔥 Konfigurationsänderungen erfordern 'reload'                 ║"
echo "║ 📢 Befehl: sudo systemctl reload nginx                         ║"
echo "║ 🔥 Konfiguration testen: nginx -t                             ║"
echo "║ 🔥 Logs überprüfen: tail -f /var/log/nginx/error.log           ║"
echo "╚════════════════════════════════════════════════════════════════╝"
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_5() {
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                        🔥 UFW FIREWALL COMMANDS 🔥               ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📜 INSTALLATION & STATUS                                       ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ apt install ufw -y                    # Installiert UFW         ║"
echo "║ ufw status                            # Zeigt UFW-Status        ║"
echo "║ ufw status verbose                    # Zeigt UFW-Status (Details) ║"
echo "║ ufw enable                            # Aktiviert UFW           ║"
echo "║ ufw disable                           # Deaktiviert UFW         ║"
echo "║ ufw reload                            # Lädt UFW-Konfiguration neu ║"
echo "║ ufw reset                             # Setzt UFW auf Standard  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📜 STANDARD-RICHTLINIEN                                        ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ufw default deny incoming            # Blockiert eingehend     ║"
echo "║ ufw default allow outgoing           # Erlaubt ausgehend       ║"
echo "║ ufw default allow incoming           # Erlaubt eingehend (nicht empfohlen) ║"
echo "║ ufw default deny outgoing            # Blockiert ausgehend     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📜 PORTS & DIENSTE VERWALTEN                                   ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ufw allow 22                          # Erlaubt SSH-Zugriff    ║"
echo "║ ufw allow 80                          # Erlaubt HTTP-Zugriff   ║"
echo "║ ufw allow 443                         # Erlaubt HTTPS-Zugriff  ║"
echo "║ ufw allow 8080/tcp                    # Erlaubt TCP Port 8080  ║"
echo "║ ufw allow 5000:6000/tcp               # Erlaubt TCP Bereich 5000-6000 ║"
echo "║ ufw allow from 192.168.1.0/24         # Erlaubt Zugriff von 192.168.1.0/24 ║"
echo "║ ufw deny 3306                         # Blockiert MySQL-Port 3306  ║"
echo "║ ufw deny from 203.0.113.4             # Blockiert IP 203.0.113.4   ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📜 UFW NGINX-BEFEHLE                                          ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ufw allow 'Nginx Full'              # Erlaubt HTTP und HTTPS   ║"
echo "║ ufw allow 'Nginx HTTP'              # Erlaubt nur HTTP (Port 80) ║"
echo "║ ufw allow 'Nginx HTTPS'             # Erlaubt nur HTTPS (Port 443) ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📜 UFW REGELN VERWALTEN                                       ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ufw delete allow 22                   # Entfernt SSH-Erlaubnis ║"
echo "║ ufw delete deny 3306                  # Entfernt MySQL-Block   ║"
echo "║ ufw delete allow 8080/tcp             # Entfernt Erlaubnis Port 8080 ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📜 REGELN FÜR SPEZIFISCHE IPs UND SCHNITTSTELLEN                ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ufw allow in on eth0                    # Erlaubt auf eth0     ║"
echo "║ ufw allow from 203.0.113.5              # Erlaubt Zugriff von IP ║"
echo "║ ufw allow from 192.168.1.0/24 to any port 22 # Erlaubt SSH aus Subnetz ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📜 LOGGING & PROTOKOLLE                                       ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ufw logging on                       # Aktiviert Protokoll     ║"
echo "║ ufw logging low                      # Setzt Protokoll auf niedrig ║"
echo "║ ufw logging medium                   # Setzt Protokoll auf mittel ║"
echo "║ ufw logging high                     # Setzt Protokoll auf hoch ║"
echo "║ tail -f /var/log/ufw.log             # Zeigt UFW-Logs in Echtzeit ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📜 KONFIGURATION SICHERN UND LADEN                             ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ufw export > ufw_backup.rules       # Exportiert Konfiguration ║"
echo "║ ufw reset && ufw import ufw_backup.rules # Lädt gespeicherte Konfig ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📜 ANWENDUNGEN MIT UFW VERWALTEN                              ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ufw app list                          # Zeigt installierte Apps ║"
echo "║ ufw app info Apache                   # Infos zu Apache-Profil ║"
echo "║ ufw allow Apache                      # Erlaubt Apache-Profile ║"
echo "║ ufw delete allow Apache               # Entfernt Apache-Regel  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📜 REGELN FÜR SPEZIFISCHE PROTOKOLLE                          ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ufw allow proto tcp from 192.168.1.0/24 to any port 80        ║"
echo "║ ufw allow proto udp from 203.0.113.0/24 to any port 53        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_6() {
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                       📁 VERZEICHNISÜBERSICHT                   ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📁 SYSTEMVERZEICHNISSE                                        ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📂 /etc/                           # Hauptkonfigurationsverzeichnis  ║"
echo "║ 📂 /usr/local/bin/                 # Benutzerdefinierte Skripte      ║"
echo "║ 📂 /var/log/                       # Systemprotokolle                 ║"
echo "║ 📂 /home/                          # Benutzerverzeichnisse            ║"
echo "║ 📂 /tmp/                           # Temporäre Dateien                ║"
echo "║ 📂 /opt/                           # Software-Pakete von Drittanbietern ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📁 UFW-FIREWALL VERZEICHNISSE                                 ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📂 /etc/ufw/                      # Konfigurationsverzeichnis der UFW ║"
echo "║ 📂 /var/log/ufw.log                # Protokolle der UFW-Firewall      ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📁 NGINX VERZEICHNISSE                                        ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📂 /etc/nginx/                    # NGINX-Konfigurationsverzeichnis  ║"
echo "║ 📂 /etc/nginx/sites-available/    # Verfügbare virtuelle Hosts       ║"
echo "║ 📂 /etc/nginx/sites-enabled/      # Aktivierte virtuelle Hosts       ║"
echo "║ 📂 /var/log/nginx/                 # NGINX-Protokolldateien           ║"
echo "║ 📂 /usr/share/nginx/html/         # Standardverzeichnis für Webinhalte ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📁 LOG-DATEIEN VERZEICHNISSE                                 ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📜 /var/log/syslog                 # Systemprotokoll              ║"
echo "║ 📜 /var/log/auth.log               # Authentifizierungsprotokoll  ║"
echo "║ 📜 /var/log/kern.log               # Kernel-Protokoll             ║"
echo "║ 📜 /var/log/dpkg.log               # Protokoll der Paketverwaltung║"
echo "║ 📜 /var/log/boot.log               # Boot-Protokoll               ║"
echo "║ 📜 /var/log/ufw.log                # UFW-Firewall-Logs            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📁 BENUTZERDEFINIERTE VERZEICHNISSE                          ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ 📂 /usr/local/bin/                # Benutzerdefinierte Skripte  ║"
echo "║ 📂 ~/.config/                     # Benutzerkonfigurationsdateien║"
echo "║ 📂 ~/.local/share/                # Lokale Benutzerdateien       ║"
echo "╚════════════════════════════════════════════════════════════════╝"
}
#------------------------------------------------------------------------------------------------------------------------------
function display_page_7() {
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                      🐳 DOCKER-BEFEHLE-HILFE                   ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 🛠️  GRUNDLAGEN                                                  ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ docker --version                # Docker-Version anzeigen       ║"
echo "║ systemctl status docker         # Status des Docker-Dienstes    ║"
echo "║ systemctl start docker          # Docker-Dienst starten         ║"
echo "║ systemctl stop docker           # Docker-Dienst stoppen         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 🐳 CONTAINER-VERWALTUNG                                         ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ docker ps                      # Laufende Container anzeigen    ║"
echo "║ docker ps -a                   # Alle Container anzeigen        ║"
echo "║ docker run <image>             # Container starten              ║"
echo "║ docker stop <container_id>     # Container stoppen              ║"
echo "║ docker start <container_id>    # Container erneut starten       ║"
echo "║ docker rm <container_id>       # Container löschen              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 🔄 IMAGES-VERWALTUNG                                           ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ docker images                  # Verfügbare Images anzeigen     ║"
echo "║ docker pull <image>            # Image herunterladen            ║"
echo "║ docker rmi <image_id>          # Image löschen                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 🔍 LOGS UND DETAILS                                            ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ docker logs <container_id>      # Logs eines Containers         ║"
echo "║ docker inspect <container_id>   # Details eines Containers      ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📦 VOLUMES UND NETZWERKE                                       ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ docker volume create <name>     # Volume erstellen              ║"
echo "║ docker volume ls                # Volumes anzeigen              ║"
echo "║ docker network create <name>    # Netzwerk erstellen            ║"
echo "║ docker network ls               # Netzwerke anzeigen            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 📁 DATEIEN KOPIEREN                                            ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ docker cp <pfad> <container_id>:<ziel>   # Host → Container    ║"
echo "║ docker cp <container_id>:<pfad> <ziel>   # Container → Host    ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ 🐙 DOCKER-COMPOSE                                              ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ docker-compose --version         # Version anzeigen            ║"
echo "║ docker-compose up -d             # Container starten (Hintergr.)║"
echo "║ docker-compose down              # Container stoppen/herunterfahren ║"
echo "║ docker-compose logs <service>    # Logs anzeigen               ║"
echo "║ docker-compose ps                # Status anzeigen             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
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

# 🔥 SCRIPT_PATH3 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 SCRIPT_PATH3 erstellen 🔥
if check_file_exists "$SCRIPT_PATH3"; then
  sleep 1
  log_message "📄 Erstelle die Datei: $SCRIPT_PATH3"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH3" > /dev/null
#!/bin/bash

# 🛠️ Funktion zur Überprüfung, ob die Pakete bereits installiert sind
check_packages() {
  local packages=("curl" "wget" "net-tools" "at")
  local missing_packages=()

  # 🔍 Überprüfe jedes Paket
  for pkg in "${packages[@]}"; do
    if ! dpkg -l | grep -q "^ii  $pkg "; then
      missing_packages+=("$pkg")
    fi
  done

  # 🔄 Installation fehlender Pakete
  sleep 2
  if [ ${#missing_packages[@]} -eq 0 ]; then
    echo "📦 Alle Pakete sind bereits installiert."
  else
    sleep 2
    echo "📦 Fehlende Pakete werden installiert: ${missing_packages[*]}"
    sleep 2
    sudo apt update && sudo apt upgrade -y || {
      echo "❌ Fehler beim System-Update."
      exit 1
    }
    sudo apt install -y "${missing_packages[@]}" || {
      echo "❌ Fehler beim Installieren der Pakete: ${missing_packages[*]}."
      exit 1
    }
  fi

  # 📋 Dynamische Ausgabe der Paketübersicht als ASCII-Tabelle
  echo -e "\n+----------------------------------------------+"
  echo -e "| | ✅ | ❌ | Paketname       | Status            |"
  echo -e "+------------------------------------------------+"
  for pkg in "${packages[@]}"; do
    local status=$(dpkg -l | grep -q "^ii  $pkg " && echo "| ✅ Installiert" || echo "| ❌ Fehlt")
    printf "| %-25s | %-18s |\n" "$pkg" "$status"
  done
  echo -e "+----------------------------------------------+\n"
}

# 🛠️ Rufe die Funktion zur Überprüfung und Installation auf
check_packages

# 🕒 Wartezeit für den Benutzer
sleep 5
EOF
  process_script_creation "$SCRIPT_PATH3"
  # 📝 SCRIPT_PATH3 wurde erfolgreich verarbeitet
fi
# 🔥 SCRIPT_PATH4 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 SCRIPT_PATH4 erstellen 🔥
if check_file_exists "$SCRIPT_PATH4"; then
  sleep 1
  log_message "📄 Erstelle die Datei: $SCRIPT_PATH4"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH4" > /dev/null
#!/usr/bin/env python3
import os

HOSTS_FILE = "/etc/hosts"
IP1 = "192.168.178.115"
#IP2 = "192.168.178.111"
#IP3 = "192.168.178.xxx"
DOMAINS_IP1 = ["books.local", "bookstack.local"]
#DOMAINS_IP2 = ["cloud.local", "nextcloud.local"]
#DOMAINS_IP3 = ["xxx.local", "xyz.local"]

def update_hosts():
    # Lese vorhandene Einträge aus der Hosts-Datei
    with open(HOSTS_FILE, "r") as file:
        lines = file.readlines()

    # Neue Einträge für IP1 und zugehörige Domains hinzufügen, wenn sie nicht existieren
    with open(HOSTS_FILE, "a") as file:
        if not any("# 💻 ====== IP from Server ====== 💻" in line for line in lines):
            file.write("# 💻 ====== IP from Server ====== 💻\n")
        for domain in DOMAINS_IP1:
            if not any(domain in line.split() for line in lines):
                entry = f"{IP1} {domain}\n"
                file.write(entry)
                print(f"Eintrag hinzugefügt: {entry.strip()}")
        """
        if not any("# 🌐 ====== IP Network Server 1 ====== 🌐" in line for line in lines):
            file.write("# 🌐 ====== IP Network Server 1 ====== 🌐\n")
        # Neue Einträge für IP2 und zugehörige Domains hinzufügen, wenn sie nicht existieren
        for domain in DOMAINS_IP2:
            if not any(domain in line.split() for line in lines):
                entry = f"{IP2} {domain}\n"
                file.write(entry)
                print(f"Eintrag hinzugefügt: {entry.strip()}")
        """
        """
        if not any("# 📼 ====== IP Network Server 2 ====== 📼" in line for line in lines):
            file.write("# 📼 ====== IP Network Server 2 ====== 📼\n")
        # Neue Einträge für IP3 und zugehörige Domains hinzufügen, wenn sie nicht existieren
        for domain in DOMAINS_IP3:
            if not any(domain in line.split() for line in lines):
                entry = f"{IP3} {domain}\n"
                file.write(entry)
                print(f"Eintrag hinzugefügt: {entry.strip()}")
        """
if __name__ == "__main__":
    if os.geteuid() != 0:
        print("Dieses Skript muss als root ausgeführt werden!")
        exit(1)
    update_hosts()
EOF
  process_script_creation "$SCRIPT_PATH4"
  # 📝 SCRIPT_PATH4 wurde erfolgreich verarbeitet
fi

# 🔥 SCRIPT_PATH5 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 SCRIPT_PATH5 erstellen 🔥
if check_file_exists "$SCRIPT_PATH5"; then
  sleep 1
  log_message "📄 Erstelle die Datei: $SCRIPT_PATH5"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH5" > /dev/null
#!/usr/bin/env python3

import os
import subprocess
from datetime import datetime

# Serverliste mit für 192.168.178.112
HOSTS = {
    "1.1.1.1": "Cloudflare DNS",
    "8.8.8.8": "Google DNS",
    "192.168.178.1": "RouterHome",
    "192.168.178.4": "Pi-hole DNS",
    "192.168.178.5": "VPN Server",
    "192.168.178.115": "book server",
    "books.local": "book-domain1",
    "bookstack.local": "book-domain2",
}

def ping_host(host):
    """
    Pingt einen Host und gibt True zurück, wenn er erreichbar ist, andernfalls False.
    """
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
    print("==== Ping-Test starten ====")
    print(f"Datum: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")

    failed_hosts = []

    for host, description in HOSTS.items():
        print(f"Pinge {host} ({description})...")
        if ping_host(host):
            print(f"{host} ({description}) ist erreichbar ✅")
        else:
            print(f"{host} ({description}) ist nicht erreichbar ❌")
            failed_hosts.append(f"{host} ({description})")
        print()

    print("==== Ping-Test abgeschlossen ====")
    if failed_hosts:
        print("==== Fehlgeschlagene Hosts ====")
        for failed in failed_hosts:
            print(failed)
    else:
        print("Alle Hosts sind erreichbar ✅")

    # Skript beendet sich mit [Enter]
#    input("==== [Enter], um das Skript zu beenden ====\n")

if __name__ == "__main__":
    main()
EOF
  process_script_creation "$SCRIPT_PATH5"
  # 📝 SCRIPT_PATH5 wurde erfolgreich verarbeitet
fi

# 🔥 SCRIPT_PATH6 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 SCRIPT_PATH6 erstellen 🔥
if check_file_exists "$SCRIPT_PATH6"; then
  log_message "📄 Erstelle die Datei: $SCRIPT_PATH6"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH6" > /dev/null
#!/bin/bash

# Definition der log_message-Funktion
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Anzeige des Inhalts der Datei /etc/hosts
echo "📁 Inhalt der Datei /etc/hosts:"
echo "-----------------------------"
cat /etc/hosts
echo "+----------------------------------------------------+"
EOF
  process_script_creation "$SCRIPT_PATH6"
  # 📝 SCRIPT_PATH6 wurde erfolgreich verarbeitet
fi
# 🔥 SCRIPT_PATH7 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 SCRIPT_PATH7 erstellen 🔥
if check_file_exists "$SCRIPT_PATH7"; then
  log_message "📄 Erstelle die Datei: $SCRIPT_PATH7"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH7" > /dev/null
#!/bin/bash

# Liste der zu prüfenden URLs
URLS=(
    "http://192.168.178.115"
    "https://192.168.178.115"
    "https://book.local"
    "https://bookstack.local"
)
# Funktion zum Prüfen der URL
check_url() {
    local url=$1
    if curl -k -I --silent --output /dev/null --fail "$url"; then
        echo "✅ $url"
    else
        echo "❌ $url"
    fi
}
# Hauptlogik: Iteriere über alle URLs und prüfe sie
echo "🔍 Überprüfe URLs..."
for url in "${URLS[@]}"; do
    check_url "$url"
done
EOF
  process_script_creation "$SCRIPT_PATH7"
  # 📝 SCRIPT_PATH7 wurde erfolgreich verarbeitet
fi
# 🔥 SCRIPT_PATH8 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 SCRIPT_PATH8 erstellen 🔥
if check_file_exists "$SCRIPT_PATH8"; then
  sleep 1
  log_message "📄 Erstelle die Datei: $SCRIPT_PATH8"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH8" > /dev/null
# 🎉 Platzhalter
sleep 1
echo "🎉 Installation erfolgreich abgeschlossen."
EOF
  process_script_creation "$SCRIPT_PATH8"
  # 📝 SCRIPT_PATH8 wurde erfolgreich verarbeitet
fi
# 🔥 SCRIPT_PATH9 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 SCRIPT_PATH9 erstellen 🔥
if check_file_exists "$SCRIPT_PATH9"; then
  sleep 1
  log_message "📄 Erstelle die Datei: $SCRIPT_PATH9"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH9" > /dev/null
# 🎉 Platzhalter
sleep 1
echo "🎉 Installation erfolgreich abgeschlossen."
EOF
  process_script_creation "$SCRIPT_PATH9"
  # 📝 SCRIPT_PATH9 wurde erfolgreich verarbeitet
fi
# 🔥 SCRIPT_PATH10 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 SCRIPT_PATH10 erstellen 🔥
if check_file_exists "$SCRIPT_PATH10"; then
  sleep 1
  log_message "📄 Erstelle die Datei: $SCRIPT_PATH10"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH10" > /dev/null
# 🎉 Platzhalter
sleep 1
echo "🎉 Installation erfolgreich abgeschlossen."
EOF
  process_script_creation "$SCRIPT_PATH10"
  # 📝 SCRIPT_PATH10 wurde erfolgreich verarbeitet
fi
# 🔥 SCRIPT_PATH11 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 SCRIPT_PATH11 erstellen 🔥
if check_file_exists "$SCRIPT_PATH11"; then
  sleep 1
  log_message "📄 Erstelle die Datei: $SCRIPT_PATH11"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH11" > /dev/null
# 🎉 Platzhalter
sleep 1
echo "🎉 Installation erfolgreich abgeschlossen."
EOF
  process_script_creation "$SCRIPT_PATH11"
  # 📝 SCRIPT_PATH11 wurde erfolgreich verarbeitet
fi

# 🔥 Skript 999 erstellen 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Skript 999 erstellen 🔥
#if check_file_exists "$SCRIPT_PATH999"; then
#  sleep 1
#  log_message "📄 Erstelle die Datei: $SCRIPT_PATH999"
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
# ⚙️ Führe upgrade.sh aus | SCRIPT_PATH3="/usr/local/bin/upgrade.sh"
sudo chmod +x /usr/local/bin/system_vars.sh

#+----------------------------------------------------------------------------------------------------------------------------------+
# ⚙️ Setze Ausführungsrechte und führe systemv.sh aus | SCRIPT_PATH0
sleep 1
if [ -f "$SCRIPT_PATH0" ]; then
    sudo chmod +x "$SCRIPT_PATH0"
    log_message "🔧 Ausführungsrechte für $(basename "$SCRIPT_PATH0") gesetzt."
    sleep 1
    log_message "🖥️ Zeige Systeminformationen"
    if sudo bash "$SCRIPT_PATH0" | tee -a /var/log/installation_script.log; then
        log_message "🎉 $(basename "$SCRIPT_PATH0") erfolgreich ausgeführt."
    else
        log_message "❌ Fehler beim Ausführen von $(basename "$SCRIPT_PATH0")"
        exit 1
    fi
else
    log_message "❌ $(basename "$SCRIPT_PATH0") nicht gefunden."
    exit 1
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# ⚙️ Führe update_hosts.py aus | SCRIPT_PATH4="/usr/local/bin/update_hosts.py"
sleep 1
log_message "🛠️ Aktualisiere die hosts"
if [ -f "$SCRIPT_PATH4" ]; then
    sleep 1
    log_message "✅ update_hosts.py gefunden. Starte Skript."
    if sudo python3 "$SCRIPT_PATH4" | tee -a /var/log/installation_script.log; then
        log_message "🎉 update_hosts.py erfolgreich ausgeführt."
    else
        log_message "❌ Fehler beim Ausführen von update_hosts.py"
        exit 1
    fi
else
    log_message "❌ update_hosts.py nicht gefunden."
    exit 1
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# ⚙️ Führe ping_test.py aus | SCRIPT_PATH5="/usr/local/bin/ping_test.py"
sleep 1
log_message "🛠️ Prüfe erforderliche Verbindungen"
if [ -f "$SCRIPT_PATH5" ]; then
    sleep 1
    log_message "✅ ping_test.py gefunden. Starte Skript."
    if sudo python3 "$SCRIPT_PATH5" | tee -a /var/log/installation_script.log; then
        log_message "🎉 ping_test.py erfolgreich ausgeführt."
    else
        log_message "❌ Fehler beim Ausführen von ping_test.py"
        exit 1
    fi
else
    log_message "❌ ping_test.py nicht gefunden."
    exit 1
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# 🛠️ Eintrag in crontab vornehmen
sleep 1
log_message "🔄 Füge Eintrag in crontab hinzu, wenn noch nicht vorhanden."
if ! crontab -l | grep -q '/usr/local/bin/update_hosts.py'; then
  (crontab -l 2>/dev/null; echo "@reboot /usr/local/bin/update_hosts.py") | crontab -
  sleep 1
  log_message "🎉 Eintrag in crontab erfolgreich hinzugefügt."
else
  sleep 2
  log_message "ℹ️ Eintrag in crontab ist bereits vorhanden."
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# 📜 Eintrag in .bashrc vornehmen
sleep 0.5
log_message "🔄 Füge Eintrag in .bashrc hinzu, wenn noch nicht vorhanden."
if ! grep -q 'sudo /usr/local/bin/cat_hosts.sh' ~/.bashrc; then
  cat << 'EOF' | tee -a ~/.bashrc > /dev/null
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 🛠️ Automatische Skriptausführung bei SSH-Login
if [ -n "$SSH_CONNECTION" ]; then  # Prüft, ob eine SSH-Verbindung besteht
    sudo /usr/local/bin/cat_hosts.sh  # Führt Skript cat_hosts.sh aus
    if [ $? -eq 0 ]; then  # Überprüft, ob cat_hosts.sh erfolgreich abgeschlossen (Exit-Code 0)
        sudo /usr/local/bin/skripts.sh  # Führt show_help_skripts.sh aus
    else
        echo "❌ cat_hosts.sh fehlgeschlagen. skripts.sh wird nicht ausgeführt."
    fi
fi
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
EOF
  sleep 1
  log_message "🎉 Eintrag in .bashrc erfolgreich hinzugefügt."
else
  sleep 2
  log_message "ℹ️ Eintrag in .bashrc ist bereits vorhanden."
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# ⚙️ Führe check_urls.sh aus | SCRIPT_PATH11="/usr/local/bin/check_urls.sh"
sleep 1
log_message "🛠️ Überprüfe URLs"
if [ -f "$SCRIPT_PATH11" ]; then
    sleep 1
    log_message "✅ check_urls.sh gefunden. Starte Skript."
    if sudo bash "$SCRIPT_PATH11" | tee -a /var/log/installation_script.log; then
        log_message "🎉 check_urls.sh erfolgreich ausgeführt."
    else
        log_message "❌ Fehler beim Ausführen von check_urls.sh"
        exit 1
    fi
else
    log_message "❌ check_urls.sh nicht gefunden."
    exit 1
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# Neustart des Systems
log_message "🔄 Starte das System neu."
sleep 5
sudo reboot
