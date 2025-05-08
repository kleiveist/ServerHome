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
echo "║                        ⚠️  WICHTIGE HINWEIS  ⚠️                 ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │  7 - ⚠️  auto-ssl.sh      ⚠️  Warnung  ⚠️                     │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                        💾 LOG-HINWEISE                         ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 💾 cat /var/log/installation_script.log                    │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                        📜 VERFÜGBARE SCRIPTS                   ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ Folgende Skripte stehen zur Verfügung:                         ║"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 1 - 📜 update_hosts.py                                     │ ║"
echo "║ │ 2 - 📜 ping_test.py                                        │ ║"
echo "║ │ 5 - 📜 rabbitmq_connect.sh                                 │ ║"
echo "║ │ 6 - 📜 jsoncheck.py                                        │ ║"
echo "║ │ 8 - 📜 cat_hosts.sh                                        │ ║"
echo "║ │ 9 - 📜 check_status.sh                                     │ ║"
echo "║ │10 - 📜 check_urls.sh                                       │ ║"
echo "║ └────────────────────────────────────────────────────────────┘ ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║                        📚 HILFE-SKRIPTE                        ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ ┌────────────────────────────────────────────────────────────┐ ║"
echo "║ │ 3 - 📚 show_help.sh                                        │ ║"
echo "║ │ 4 - 📚 show_help_skripts.sh                                │ ║"
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