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
echo " Docker & Docker Compose Statusprüfung "
draw_headline

if command -v docker &>/dev/null; then
  docker_ver=$(docker --version)
  echo "✅ Docker ist installiert: $docker_ver"
else
  echo "❌ Docker ist nicht installiert!"
fi

if docker compose version &>/dev/null; then
  compose_ver=$(docker compose version)
  echo "✅ Docker Compose Plugin ist installiert: $compose_ver"
else
  echo "❌ Docker Compose ist nicht installiert!"
fi

# ────────────────────────────────────────────────────────────────────────
# Docker & Compose Befehle Übersicht
# ────────────────────────────────────────────────────────────────────────

echo ""
draw_headline
echo " Wichtige Docker & Docker Compose Befehle "
draw_headline

draw_border widths
print_row widths "docker ps             → Laufende Container anzeigen"
print_row widths "docker images         → Lokale Images anzeigen"
print_row widths "docker run hello-world → Testcontainer starten"
print_row widths "docker stop <ID|NAME> → Container stoppen"
print_row widths "docker rm <ID|NAME>   → Container löschen"
print_row widths "docker-compose up -d  → Dienste im Hintergrund starten"
print_row widths "docker-compose down   → Dienste stoppen & entfernen"
print_row widths "docker-compose logs   → Logs anzeigen"
draw_border widths
echo ""
