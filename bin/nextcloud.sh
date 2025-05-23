#!/bin/bash
set -euo pipefail

# ---------------------------------------------------
# Automatisiertes Installations-Skript für Nextcloud mit HTTPS (Caddy)
# ---------------------------------------------------

# --- Passwort-Generator (24 Zeichen: A-Z a-z 0-9) ---
passgen() {
  tr -dc 'A-Za-z0-9' </dev/urandom | head -c 24
  echo
}

# --- Zufällige Passwörter generieren ---
ADMIN_PASS="$(passgen)"
DB_ROOT_PASS="$(passgen)"
DB_PASS="$(passgen)"

# --- Konfiguration ---
COMPOSE_DIR=/srv/nextcloud
COMPOSE_FILE="$COMPOSE_DIR/docker-compose.yml"
CADDYFILE="$COMPOSE_DIR/Caddyfile"
# Pfad, der per Proxmox-mp0 im CT gemountet ist
DATA_DIR=/var/www/html/data
ADMIN_USER="admin"
DB_NAME="nextcloud"
DB_USER="ncuser"

# --- Verzeichnis anlegen ---
mkdir -p "$COMPOSE_DIR"

# --- Server-IP ermitteln ---
SERVER_IP="$(hostname -I | awk '{print $1}')"
echo "🔧 Server-IP erkannt: $SERVER_IP"

echo "🔧 Generierte Zugangsdaten:"
echo "  Admin-Passwort: $ADMIN_PASS"
echo "  DB Root-Passwort: $DB_ROOT_PASS"
echo "  DB User-Passwort: $DB_PASS"

# --- Docker-Compose-Datei schreiben ---
cat > "$COMPOSE_FILE" <<EOF
version: '3.8'

services:
  db:
    image: mariadb:10.11
    container_name: nextcloud-db
    restart: always
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASS}
      MYSQL_DATABASE: ${DB_NAME}
      MYSQL_USER: ${DB_USER}
      MYSQL_PASSWORD: ${DB_PASS}
    volumes:
      - db_data:/var/lib/mysql

  app:
    image: nextcloud:29-apache
    container_name: nextcloud-app
    restart: always
    expose:
      - 80
    environment:
      MYSQL_HOST: db
      MYSQL_DATABASE: ${DB_NAME}
      MYSQL_USER: ${DB_USER}
      MYSQL_PASSWORD: ${DB_PASS}
      NEXTCLOUD_ADMIN_USER: ${ADMIN_USER}
      NEXTCLOUD_ADMIN_PASSWORD: ${ADMIN_PASS}
    volumes:
      - ${DATA_DIR}:/var/www/html/data
      - nextcloud_config:/var/www/html/config
      - nextcloud_apps:/var/www/html/custom_apps
      - nextcloud_themes:/var/www/html/themes
    depends_on:
      - db

  caddy:
    image: caddy:2
    container_name: nextcloud-caddy
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "$CADDYFILE:/etc/caddy/Caddyfile"
      - caddy_data:/data
      - caddy_config:/config
    depends_on:
      - app

volumes:
  db_data:
  nextcloud_config:
  nextcloud_apps:
  nextcloud_themes:
  caddy_data:
  caddy_config:
EOF

# --- Caddyfile schreiben ---
cat > "$CADDYFILE" <<EOF
${SERVER_IP} {
    reverse_proxy nextcloud-app:80
    tls internal
}
EOF

# --- Auf Datenbank-Ready warten ---
echo "Warte auf Datenbank-Initialisierung..."
until docker exec nextcloud-db mysqladmin ping -h "localhost" -p"${DB_ROOT_PASS}" --silent &>/dev/null; do
  sleep 2
done

echo "Datenbank ist bereit."

# --- Trusted Domains konfigurieren ---
docker exec nextcloud-app bash -c "php occ config:system:set trusted_domains 0 --value=localhost"
docker exec nextcloud-app bash -c "php occ config:system:set trusted_domains 1 --value=\"${SERVER_IP}\""

echo "🔧 Caddy-Proxy konfiguriert für https://$SERVER_IP"

# --- Docker-Compose starten ---
cd "$COMPOSE_DIR"
docker compose pull
docker compose up -d --force-recreate

# --- Abschließende Meldung ---
echo "Nextcloud wurde erfolgreich installiert und ist nun per HTTPS erreichbar!"
echo "🔗 https://$SERVER_IP"
echo "Admin (admin): $ADMIN_PASS"
echo "DB Root: $DB_ROOT_PASS"
echo "DB User (ncuser): $DB_PASS"
