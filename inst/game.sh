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
# 🖥️ gamne script paths
SCRIPT_PATH0="/usr/local/bin/package.sh"
SCRIPT_PATH1="/usr/local/bin/gamelist.sh"
SCRIPT_PATH2="/usr/local/bin/guess.sh"
SCRIPT_PATH3="/usr/local/bin/rps.sh"
SCRIPT_PATH4="/usr/local/bin/spaceship.py"
SCRIPT_PATH5="/usr/local/bin/snake.py"
SCRIPT_PATH6="/usr/local/bin/game6.sh"
SCRIPT_PATH7="/usr/local/bin/game7.sh"
SCRIPT_PATH8="/usr/local/bin/game8.sh"
SCRIPT_PATH9="/usr/local/bin/game9.sh"
SCRIPT_PATH10="/usr/local/bin/game10.sh"
SCRIPT_PATH11="/usr/local/bin/game11.sh"
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
#+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
# 🔥 Create Script0 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -- - - - - - - - - -+🔥 Create Script0 🔥
if check_file_exists "$SCRIPT_PATH0"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH0"
  cat <<EOF  | sudo tee "$SCRIPT_PATH0" > /dev/null
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
#!/usr/bin/env bash

# Farben
RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; BLUE="\e[34m"; MAGENTA="\e[35m"; RESET="\e[0m"

# zufällige Zielzahl 1–100
target=$(( RANDOM % 100 + 1 ))
attempts=0

# Banner
echo -e "${MAGENTA}╔═══════════════════════════════════╗${RESET}"
echo -e "${MAGENTA}║      🎯 Guess the Number 🎯      ║${RESET}"
echo -e "${MAGENTA}╚═══════════════════════════════════╝${RESET}"
echo -e "Ich habe eine Zahl zwischen ${YELLOW}1${RESET} und ${YELLOW}100${RESET} gewählt. Viel Glück!"

while true; do
  echo -en "\n${BLUE}🔢 Your guess:${RESET} "
  read guess
  (( attempts++ ))

  # Eingabe validieren
  if ! [[ $guess =~ ^[0-9]+$ ]]; then
    echo -e "${RED}⚠️ Bitte eine ganze Zahl eingeben!${RESET}"
    continue
  fi

  # Vergleich
  if (( guess < target )); then
    echo -e "${YELLOW}↗️ Too low!${RESET}"
  elif (( guess > target )); then
    echo -e "${YELLOW}↘️ Too high!${RESET}"
  else
    echo -e "\n${GREEN}✅ Correct! You guessed it in ${attempts} attempts.${RESET}"
    break
  fi
done
EOF
  process_script_creation "$SCRIPT_PATH2"
  # 📝 Skript2 wurde erfolgreich verarbeitet
fi

# 🔥 Create SCRIPT_PATH3 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH3 🔥
if check_file_exists "$SCRIPT_PATH3"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH3"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH3" > /dev/null
#!/usr/bin/env bash

# Farben
RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; BLUE="\e[34m"; RESET="\e[0m"

icons=("🪨" "📄" "✂️")
options=("Rock" "Paper" "Scissors")

# Banner
echo -e "${BLUE}╔════════════════════════════╗${RESET}"
echo -e "${BLUE}║   Rock, Paper, Scissors 🕹️   ║${RESET}"
echo -e "${BLUE}╚════════════════════════════╝${RESET}"
echo -e "Wähle: 0=${icons[0]} ${options[0]}, 1=${icons[1]} ${options[1]}, 2=${icons[2]} ${options[2]} oder 'q' zum Beenden."

while true; do
  read -p $'\n> ' choice
  [[ $choice == "q" ]] && { echo -e "${YELLOW}Game over. 👋${RESET}"; break; }

  if ! [[ $choice =~ ^[0-2]$ ]]; then
    echo -e "${RED}Ungültige Eingabe! ⚠️ Nutze 0,1,2 oder q.${RESET}"
    continue
  fi

  comp=$(( RANDOM % 3 ))
  echo -e "\nDu: ${icons[$choice]} ${options[$choice]}  –  CPU: ${icons[$comp]} ${options[$comp]}"

  result=$(( (choice - comp + 3) % 3 ))
  case $result in
    0) echo -e "${YELLOW}Draw. 🤝${RESET}" ;;
    1) echo -e "${GREEN}You win! 🎉${RESET}" ;;
    2) echo -e "${RED}CPU wins. 💻🏆${RESET}" ;;
  esac
done
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
# -*- coding: utf-8 -*-
"""
Mini-Spaceshooter in einer Datei – modular aufgebaut
"""
import curses
import random
import time

# ── Konfiguration ────────────────────────────────────────────────────────────
FPS                 = 60
TARGET_DT           = 1.0 / FPS
SPACESHIP_SYMBOL    = "===>"
SHIELD_PICKUP_SYM   = "=[)(]="
SHIELD_SPAWN_CHANCE = 0.004      # pro Frame
SHIELD_COOLDOWN     = 5.0       # Sekunden

ASTEROID_SMALL      = ["#", "##", "###", "####", "#####"]
ASTEROID_BIG_X      = ["####", "##", "#", "###", "#####"]
ASTEROID_BIG_Y      = ["####", "##", "#", "###", "#####"]

NEUTRON_STAR_SPRITE = [
    "  OOOO  ",
    " OOOOOO ",
    "OOOOOOOO",
    "OOOOOOOO",
    "OOOOOOOO",
    "OOOOOOOO",
    " OOOOOO ",
    "  OOOO  "
]

# ── Basis-Entity ─────────────────────────────────────────────────────────────
class Entity:
    def __init__(self, x: int, y: int, symbol: str):
        self.x, self.y = x, y
        self.symbol    = symbol  # kann auch multi-line sein

    def move(self, dx=0, dy=0):
        self.x += dx
        self.y += dy

    def draw(self, scr: curses.window):
        h, w = scr.getmaxyx()
        if isinstance(self.symbol, list):        # mehrzeilig (Neutron-Star)
            for i, row in enumerate(self.symbol):
                ry = self.y + i
                if 0 <= ry < h and 0 <= self.x < w:
                    try:
                        scr.addstr(ry, self.x, row)
                    except curses.error:
                        pass
        else:                                    # einzeilig
            if 0 <= self.y < h and 0 <= self.x < w:
                try:
                    scr.addstr(self.y, self.x, self.symbol)
                except curses.error:
                    pass

# ── Spezielle Entities ───────────────────────────────────────────────────────
class Spaceship(Entity):
    def __init__(self, x, y):
        super().__init__(x, y, SPACESHIP_SYMBOL)
        self.shield   = 0
        self.god_mode = False
        self.key_buf  = []

    def toggle_god(self):
        self.god_mode = not self.god_mode
        if self.god_mode:
            self.shield = 3

class Asteroid(Entity):
    """h = 1 kleiner, h = 2 großer (2-zeiliger) Asteroid"""
    def __init__(self, x, y, h=1):
        if h == 1:
            sym = random.choice(ASTEROID_SMALL)
            super().__init__(x, y, sym)
        else:
            sx = random.choice(ASTEROID_BIG_X)
            sy = random.choice(ASTEROID_BIG_Y)
            super().__init__(x, y, [sx, sy])
        self.h = h

class ShieldPickup(Entity):
    def __init__(self, x, y):
        super().__init__(x, y, SHIELD_PICKUP_SYM)

class Stream(Entity):
    def __init__(self, x, y):
        super().__init__(x, y, "///")

class NeutronStar(Entity):
    def __init__(self, x, y):
        super().__init__(x, y, NEUTRON_STAR_SPRITE)

# ── Haupt-Game-Klasse ────────────────────────────────────────────────────────
class Game:
    def __init__(self, scr: curses.window):
        self.scr = scr
        curses.curs_set(0)
        self.scr.nodelay(True)
        self.h, self.w = self.scr.getmaxyx()

        # Spielobjekte
        self.ship      = Spaceship(self.w // 2, self.h // 2)
        self.asteroids = []
        self.pickups   = []
        self.streams   = []
        self.star      = None

        # Timing / Status
        self.start_time        = time.perf_counter()
        self.last_shield_spawn = self.start_time - SHIELD_COOLDOWN
        self.star_used         = False
        self.second_star_used  = False

    # ── Spawner ────────────────────────────────────────────────────────────
    def spawn_shield(self, now):
        if (now - self.last_shield_spawn >= SHIELD_COOLDOWN and
                random.random() < SHIELD_SPAWN_CHANCE):
            y = random.randint(1, self.h - 2)
            self.pickups.append(ShieldPickup(self.w - len(SHIELD_PICKUP_SYM) - 1, y))
            self.last_shield_spawn = now

    def spawn_asteroid(self, elapsed: float):
        # 0–25 s: 20 % Dust-Phase (nur '#')
        if 3 <= elapsed < 25:
            if random.random() < 0.2:                      # hier 0.5 = 50 %; änderbar auf 0.1–1.0
                y = random.randint(1, self.h - 2)
                a = Asteroid(self.w - 2, y, h=1)
                a.symbol = "#"                            # zwingt '#'
                self.asteroids.append(a)
            return
        # 25–60 s: 50 % Mini
        if 25 <= elapsed < 60:
            if random.random() < 0.3:
                y = random.randint(1, self.h-2)
                self.asteroids.append(Asteroid(self.w-2, y, h=1))
            return
        # 60–80 s: 20 % Große
        if 60 <= elapsed < 80:
            if random.random() < 0.2:
                y = random.randint(1, self.h-3)
                self.asteroids.append(Asteroid(self.w-6, y, h=2))
            return
        # 80–100 s: 80 % Mini
        if 80 <= elapsed < 98:
            if random.random() < 0.5:
                y = random.randint(1, self.h-2)
                self.asteroids.append(Asteroid(self.w-2, y, h=1))
            return
        # 100–125 s: 100 % Dust-Phase (nur '#')
        if 100 <= elapsed < 130:
            if random.random() < 0.4:                      # hier 1.0 = 100 %; änderbar auf 0.1–1.0
                y = random.randint(1, self.h - 2)
                a = Asteroid(self.w - 2, y, h=1)
                a.symbol = "#"                            # zwingt '#'
                self.asteroids.append(a)
            return
        # 125–150 s: 100 % Mini-Asteroiden
        if 140 <= elapsed < 150:
            if random.random() < 0.6:               # <- hier auf 0.8 ändern für 80 %
                y = random.randint(1, self.h-2)
                self.asteroids.append(Asteroid(self.w-2, y, h=1))
            return
        # 150–155 s: 100 % Große Asteroiden
        if 150 <= elapsed < 155:
            if random.random() < 0.5:               # <- hier 0.5 für 50 %, etc.
                y = random.randint(1, self.h-3)
                self.asteroids.append(Asteroid(self.w-6, y, h=2))
            return
        # 100–125 s: 100 % Dust-Phase (nur '#')
        if 160 <= elapsed < 182:
            if random.random() < 0.4:                      # hier 1.0 = 100 %; änderbar auf 0.1–1.0
                y = random.randint(1, self.h - 2)
                a = Asteroid(self.w - 2, y, h=1)
                a.symbol = "#"                            # zwingt '#'
                self.asteroids.append(a)
            return
        # 190–200 s: 100 % Große Asteroiden
        if 185 <= elapsed < 200:
            if random.random() < 0.4:               # <- ebenfalls anpassbar
                y = random.randint(1, self.h-3)
                self.asteroids.append(Asteroid(self.w-6, y, h=2))
            return
        # 100–125 s: 100 % Dust-Phase (nur '#')
        if 202 <= elapsed < 250:
            if random.random() < 0.4:                      # hier 1.0 = 100 %; änderbar auf 0.1–1.0
                y = random.randint(1, self.h - 2)
                a = Asteroid(self.w - 2, y, h=1)
                a.symbol = "#"                            # zwingt '#'
                self.asteroids.append(a)
            return
        # 125–150 s: 100 % Mini-Asteroiden
        if 210 <= elapsed < 300:
            if random.random() < 0.4:               # <- hier auf 0.8 ändern für 80 %
                y = random.randint(1, self.h-2)
                self.asteroids.append(Asteroid(self.w-2, y, h=1))
            return
        # 100–125 s: 100 % Dust-Phase (nur '#')
        if 300 <= elapsed < 1200:
            if random.random() < 1.4:                      # hier 1.0 = 100 %; änderbar auf 0.1–1.0
                y = random.randint(1, self.h - 2)
                a = Asteroid(self.w - 2, y, h=1)
                a.symbol = "#"                            # zwingt '#'
                self.asteroids.append(a)
            return
    def spawn_neutron_star(self, elapsed):
        # erster Spawn ab 135 s
        if not self.star_used and elapsed >= 135:
            self.star = NeutronStar(self.w, 1)
            self.star_used = True
            self.streams.clear()
        # zweiter Spawn ab 180 s
        if not self.second_star_used and elapsed >= 180:
            self.star = NeutronStar(self.w, 1)
            self.second_star_used = True
            self.streams.clear()
        # Dritter Spawn ab 220 s
        if not self.second_star_used and elapsed >= 220:
            self.star = NeutronStar(self.w, 1)
            self.second_star_used = True
            self.streams.clear()
        # Spawn ab 310 s
        if not self.second_star_used and elapsed >= 310:
            self.star = NeutronStar(self.w, 1)
            self.second_star_used = True
            self.streams.clear()
        # Spawn ab 312 s
        if not self.second_star_used and elapsed >= 312:
            self.star = NeutronStar(self.w, 1)
            self.second_star_used = True
            self.streams.clear()

    # ── Eingabe ─────────────────────────────────────────────────────────────
    def handle_input(self):
        key = self.scr.getch()
        if key == curses.KEY_UP and self.ship.y > 1:
            self.ship.move(dy=-1)
        elif key == curses.KEY_DOWN and self.ship.y < self.h - 2:
            self.ship.move(dy=1)
        elif key == ord('q'):
            return False
        elif key != -1:
            self.ship.key_buf.append(key)
            if len(self.ship.key_buf) > 3:
                self.ship.key_buf.pop(0)
            if self.ship.key_buf == [ord('g'), ord('o'), ord('d')]:
                self.ship.toggle_god()
                self.ship.key_buf.clear()
        return True

    # ── Bewegung / Bereinigung ──────────────────────────────────────────────
    def update_objects(self):
        for a in self.asteroids:
            a.move(dx=-1)
        for p in self.pickups:
            p.move(dx=-1)
        for s in self.streams:
            s.move(dy=1)

        # Neutron-Star Bewegung + Stream-Spawn
        if self.star:
            self.star.move(dx=-1)
            if self.star.x + len(self.star.symbol[0]) < 0:
                self.star = None
                self.streams.clear()
            else:
                for col in range(len(self.star.symbol[0])):
                    if random.random() < 0.3:
                        self.streams.append(Stream(self.star.x + col,
                                                   self.star.y + len(self.star.symbol)))

        # Off-Screen entfernen
        self.asteroids = [a for a in self.asteroids
                          if a.x + (len(a.symbol[0]) if a.h == 2 else len(a.symbol)) - 1 >= 0]
        self.pickups   = [p for p in self.pickups if p.x + len(p.symbol) - 1 >= 0]
        self.streams   = [s for s in self.streams if s.y < self.h]

    # ── Kollisionslogik ─────────────────────────────────────────────────────
    def check_collisions(self):
        # Shield-Pickup
        for p in self.pickups[:]:
            if (p.y == self.ship.y and
                    not (p.x + len(p.symbol) - 1 < self.ship.x or
                         p.x > self.ship.x + len(self.ship.symbol) - 1)):
                self.ship.shield = min(3, self.ship.shield + 1)
                self.pickups.remove(p)

        # Streams (vom Neutron-Star)
        for s in self.streams[:]:
            if s.y == self.ship.y and self.ship.x <= s.x < self.ship.x + len(self.ship.symbol):
                if self.ship.shield < 3 and not self.ship.god_mode:
                    return True
                else:
                    self.ship.shield = 0
                    self.streams.clear()
                    break

        # Asteroiden
        for a in self.asteroids[:]:
            rows = ([ (a.y, a.symbol) ] if a.h == 1
                    else [ (a.y, a.symbol[0]), (a.y + 1, a.symbol[1]) ])
            for ry, sym in rows:
                if ry != self.ship.y:
                    continue
                if not (a.x + len(sym) - 1 < self.ship.x or
                        a.x > self.ship.x + len(self.ship.symbol) - 1):
                    if self.ship.god_mode:
                        self.ship.shield = 3
                        self.asteroids.remove(a)
                    elif self.ship.shield > 0:
                        self.ship.shield -= 1
                        self.asteroids.remove(a)
                    else:
                        return True
                    break
        return False

    # ── Rendering ───────────────────────────────────────────────────────────
    def draw_hud(self, elapsed):
        timer = time.strftime("%M:%S", time.gmtime(elapsed))
        self.scr.addstr(0, self.w - len(timer) - 1, timer)
        if self.ship.god_mode:
            txt = "GODMODE AKTIV"
            self.scr.addstr(1, self.w - len(txt) - 1, txt)

    def draw(self, elapsed):
        self.scr.clear()
        self.draw_hud(elapsed)

        # Entities
        if self.star:
            self.star.draw(self.scr)
        for obj in self.asteroids + self.pickups + self.streams + [self.ship]:
            obj.draw(self.scr)

        # Schild-Balken
        if self.ship.shield > 0:
            bar = ")" * self.ship.shield
            sx  = self.ship.x + len(self.ship.symbol) + 1
            if sx + len(bar) < self.w:
                self.scr.addstr(self.ship.y, sx, bar)

        self.scr.refresh()

    # ── Haupt-Loop ──────────────────────────────────────────────────────────
    def run(self):
        prev_time = time.perf_counter()
        while True:
            now     = time.perf_counter()
            dt      = now - prev_time
            prev_time = now
            elapsed = now - self.start_time

            if not self.handle_input():
                break
            self.spawn_shield(now)
            self.spawn_asteroid(elapsed)
            self.spawn_neutron_star(elapsed)

            self.update_objects()
            if self.check_collisions():
                self.scr.addstr(self.h//2, self.w//2 - 4, "BOOM!")
                self.scr.refresh()
                time.sleep(1)
                break

            self.draw(elapsed)

            # Framerate begrenzen
            sleep = TARGET_DT - (time.perf_counter() - now)
            if sleep > 0:
                time.sleep(sleep)

# ── Einstieg ────────────────────────────────────────────────────────────────
def main(stdscr):
    Game(stdscr).run()

if __name__ == "__main__":
    curses.wrapper(main)
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
import curses
import random
import time

# Spielvariablen
FPS = 15
HEAD_CHAR    = 'O'
BODY_CHAR    = 'o'
FOOD_CHAR    = 'x'
POISON_CHAR  = 'x'
POISON_FLASH = 'X'
FLASH_MIN    = 1    # früheste Sekunde bis zum nächsten Flash
FLASH_MAX    = 3   # späteste Sekunde bis zum nächsten Flash
FLASH_DUR    = 0.4  # Dauer in Sekunden
INITIAL_LIVES  = 3      # Anzahl der Leben am Spielanfang

DIRS = {
    curses.KEY_UP:    (-1,  0),
    curses.KEY_DOWN:  ( 1,  0),
    curses.KEY_LEFT:  ( 0, -1),
    curses.KEY_RIGHT: ( 0,  1),
}

def get_count(score):
    return 2 + (score//2)*2

def place_items(exclude, max_y, max_x, n):
    items = []
    while len(items) < n:
        y = random.randint(1, max_y-2)
        x = random.randint(1, max_x-2)
        if (y, x) not in exclude and (y, x) not in items:
            items.append((y, x))
    return items

def play(stdscr):
    max_y, max_x = stdscr.getmaxyx()
    lives = INITIAL_LIVES
    score = 0

    def reset_snake():
        return [(max_y//2, max_x//2 + i) for i in range(2, -1, -1)]

    snake     = reset_snake()
    direction = DIRS[curses.KEY_RIGHT]

    # Initial spawn
    count     = get_count(score)
    food      = place_items(snake, max_y, max_x, count)
    poison    = place_items(snake + food, max_y, max_x, count)

    # Flash-Logik
    poison_flash     = False
    next_flash_start = time.time() + random.uniform(FLASH_MIN, FLASH_MAX)
    flash_end        = 0

    stdscr.nodelay(True)
    stdscr.clear()

    while True:
        t0 = time.time()
        # Input
        key = stdscr.getch()
        if key in DIRS:
            dy, dx = DIRS[key]
            if (dy,dx) != (-direction[0], -direction[1]):
                direction = (dy, dx)

        # Flash-Logik
        now = time.time()
        if not poison_flash and now >= next_flash_start:
            poison_flash = True
            flash_end    = now + FLASH_DUR
        if poison_flash and now >= flash_end:
            poison_flash     = False
            next_flash_start = now + random.uniform(FLASH_MIN, FLASH_MAX)

        # Bewegung
        head     = snake[0]
        new_head = (head[0] + direction[0], head[1] + direction[1])

        # Kollision?
        died = (
            new_head[0] in (0, max_y-1) or
            new_head[1] in (0, max_x-1) or
            new_head in snake or
            new_head in poison
        )
        if died:
            lives -= 1
            if lives <= 0:
                return score  # Ende, wenn keine Leben mehr
            # Leben verloren: kurz anzeigen und zurücksetzen
            stdscr.nodelay(False)
            stdscr.clear()
            msg = f' Leben verloren! Verbleibende Leben: {lives} '
            stdscr.addstr(max_y//2, (max_x-len(msg))//2, msg)
            stdscr.refresh()
            time.sleep(1.5)
            # Snake & Richtung zurücksetzen
            snake     = reset_snake()
            direction = DIRS[curses.KEY_RIGHT]
            stdscr.nodelay(True)
            continue

        snake.insert(0, new_head)

        # Futter essen
        if new_head in food:
            score += 1
            food.remove(new_head)
            if not food:
                count  = get_count(score)
                food   = place_items(snake, max_y, max_x, count)
                poison = place_items(snake + food, max_y, max_x, count)
                poison_flash     = False
                next_flash_start = time.time() + random.uniform(FLASH_MIN, FLASH_MAX)
        else:
            snake.pop()

        # Zeichnen
        stdscr.clear()
        stdscr.border()
        # Statuszeile Lives + Score
        status = f' Lives: {lives}   Score: {score} '
        stdscr.addstr(0, 2, status)
        # Futter
        for y,x in food:
            stdscr.addch(y, x, FOOD_CHAR)
        # Giftköder
        ch = POISON_FLASH if poison_flash else POISON_CHAR
        for y,x in poison:
            stdscr.addch(y, x, ch)
        # Schlange
        stdscr.addch(new_head[0], new_head[1], HEAD_CHAR)
        for y,x in snake[1:]:
            stdscr.addch(y, x, BODY_CHAR)

        stdscr.refresh()

        # Frame-Limit
        dt = time.time() - t0
        if dt < 1/FPS:
            time.sleep(1/FPS - dt)

def main(stdscr):
    curses.curs_set(0)
    while True:
        score = play(stdscr)
        # Game Over
        stdscr.nodelay(False)
        stdscr.clear()
        max_y, max_x = stdscr.getmaxyx()
        msg  = f' GAME OVER! Endstand: {score} '
        opts = '[n] Neues Spiel    [q] Beenden'
        stdscr.addstr(max_y//2    , (max_x - len(msg))//2, msg)
        stdscr.addstr(max_y//2 + 2, (max_x - len(opts))//2, opts)
        stdscr.refresh()
        # Auswahl
        while True:
            k = stdscr.getch()
            if k in (ord('n'), ord('N')):
                break
            if k in (ord('q'), ord('Q')):
                return

if __name__ == '__main__':
    curses.wrapper(main)
EOF
  process_script_creation "$SCRIPT_PATH5"
  # 📝 SCRIPT_PATH5 processed successfully
fi

# 🔥 Create SCRIPT_PATH6 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH6 🔥
if check_file_exists "$SCRIPT_PATH6"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH6"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH6" > /dev/null
# 🎉 Placeholder
sleep 1
echo "🎉 Installation completed successfully."
EOF
  process_script_creation "$SCRIPT_PATH6"
  # 📝 SCRIPT_PATH6 processed successfully
fi
# 🔥 Create SCRIPT_PATH7 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH7 🔥
if check_file_exists "$SCRIPT_PATH7"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH7"
cat <<EOF | sudo tee "$SCRIPT_PATH7" > /dev/null
# 🎉 Placeholder
sleep 1
echo "🎉 Installation completed successfully."
EOF
  process_script_creation "$SCRIPT_PATH7"
  # 📝 SCRIPT_PATH7 processed successfully
fi

# 🔥 Create SCRIPT_PATH8 🔥+- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+🔥 Create SCRIPT_PATH8 🔥
if check_file_exists "$SCRIPT_PATH8"; then
  sleep 0.1
  log_message "📄 Creating file: $SCRIPT_PATH8"
  cat << 'EOF' | sudo tee "$SCRIPT_PATH8" > /dev/null
# 🎉 Placeholder
sleep 1
echo "🎉 Installation completed successfully."
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
# ⚙️ Run upgrade
sleep 0.5
log_message "🛠️ Starting system upgrade"
if [ -f "$SCRIPT_PATH0" ]; then
    sleep 0.5
    log_message "✅ $(basename "$SCRIPT_PATH0") found. Running script."
    if sudo bash "$SCRIPT_PATH3" | tee -a /var/log/installation_script.log; then
        log_message "🎉 $(basename "$SCRIPT_PATH0") ran successfully."
    else
        log_message "❌ Error running $(basename "$SCRIPT_PATH0")."
        exit 1
    fi
else
    log_message "❌ $(basename "$SCRIPT_PATH0") not found."
fi
#+----------------------------------------------------------------------------------------------------------------------------------+
# ⚙️ Set execute permissions and run systemv.sh | SCRIPT_PATH0
sleep 0.5
if [ -f "$SCRIPT_PATH1" ]; then
    sudo chmod +x "$SCRIPT_PATH1"
    log_message "🔧 Execute permission set for $(basename "$SCRIPT_PATH1")."
    sleep 1
    log_message "🖥️ Displaying system information"
    if sudo bash "$SCRIPT_PATH1" | tee -a /var/log/installation_script.log; then
        log_message "🎉 $(basename "$SCRIPT_PATH1") ran successfully."
    else
        log_message "❌ Error running $(basename "$SCRIPT_PATH1")."
        exit 1
    fi
else
    log_message "❌ $(basename "$SCRIPT_PATH1") not found."
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
