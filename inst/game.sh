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
SCRIPT_PATH5="/usr/local/bin/game5.sh"
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

# Generate a random number between 1 and 100
target=$(( RANDOM % 100 + 1 ))
attempts=0

echo "Welcome to Guess the Number!"
echo "I have chosen a number between 1 and 100."

while true; do
  read -p "Your guess: " guess
  (( attempts++ ))

  # validate input
  if ! [[ $guess =~ ^[0-9]+$ ]]; then
    echo "Please enter a whole number."
    continue
  fi

  # compare
  if (( guess < target )); then
    echo "Too low."
  elif (( guess > target )); then
    echo "Too high."
  else
    echo "Correct! You guessed it in $attempts attempts."
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

options=("Rock" "Paper" "Scissors")

echo "=== Rock, Paper, Scissors ==="
echo "Enter 0=Rock, 1=Paper, 2=Scissors. 'q' to quit."

while true; do
  read -p "> " choice
  [[ $choice == "q" ]] && { echo "Game over."; break; }

  if ! [[ $choice =~ ^[0-2]$ ]]; then
    echo "Invalid input. Use 0, 1, 2 or q."
    continue
  fi

  comp=$(( RANDOM % 3 ))
  echo "You: ${options[$choice]} – CPU: ${options[$comp]}"

  result=$(( (choice - comp + 3) % 3 ))
  case $result in
    0) echo "Draw." ;;
    1) echo "You win!" ;;
    2) echo "CPU wins." ;;
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
import curses
import random
import time

SHIELD_PICKUP       = "=[)(]="   # Symbol für Shield-Pickup
SHIELD_SPAWN_CHANCE = 0.004      # Chance pro Frame
SHIELD_MIN_COOLDOWN = 5.0        # Mindestabstand in Sekunden
ASTEROID_SYMBOLSX   = ["####", "##", "#", "###", "#####"]
ASTEROID_SYMBOLSY   = ["####", "##", "#", "###", "#####"]
SPACESHIP           = "===>"
NEUTRON_STAR        = [
    "  OOOO  ",
    " OOOOOO ",
    "OOOOOOOO",
    "OOOOOOOO",
    "OOOOOOOO",
    "OOOOOOOO",
    " OOOOOO ",
    "  OOOO  "
]

def main(stdscr):
    curses.curs_set(0)
    stdscr.nodelay(True)
    height, width = stdscr.getmaxyx()

    # Startzustände
    spaceship_y       = height // 2
    spaceship_x       = width // 2 - len(SPACESHIP) // 2
    asteroids         = []
    shield_items      = []
    shield_level      = 0
    last_shield_spawn = time.perf_counter() - SHIELD_MIN_COOLDOWN
    streams           = []
    neutron_spawned   = False    # Stern aktuell aktiv
    star_used         = False    # Stern wurde schon einmal gespawnt
    star_pos          = {'x': 0, 'y': 1}
    god_mode          = False
    key_buffer        = []

    TARGET_FPS = 60
    TARGET_DT  = 1.0 / TARGET_FPS
    prev_time  = time.perf_counter()
    game_start = prev_time

    while True:
        now     = time.perf_counter()
        dt      = now - prev_time
        prev_time = now
        elapsed = now - game_start

        stdscr.clear()
        # Spieltimer oben rechts
        mins = int(elapsed // 60)
        secs = int(elapsed % 60)
        timer_str = f"{mins:02d}:{secs:02d}"
        stdscr.addstr(0, width - len(timer_str) - 1, timer_str)
        # God-Mode Hinweis
        if god_mode:
            stdscr.addstr(1, width - len("you are jesus") - 1, "you are jesus")

        # Eingabe
        key = stdscr.getch()
        if key != -1:
            if   key == curses.KEY_UP   and spaceship_y > 1:
                spaceship_y -= 1
            elif key == curses.KEY_DOWN and spaceship_y < height - 2:
                spaceship_y += 1
            elif key == ord('q'):
                break
            # 'god' toggeln
            key_buffer.append(key)
            if len(key_buffer) > 3:
                key_buffer.pop(0)
            if key_buffer == [ord('g'), ord('o'), ord('d')]:
                god_mode = not god_mode
                if god_mode:
                    shield_level = 3
                key_buffer.clear()

        # Schild-Pickup spawnen
        if now - last_shield_spawn >= SHIELD_MIN_COOLDOWN and random.random() < SHIELD_SPAWN_CHANCE:
            y0 = random.randint(1, height - 2)
            shield_items.append({
                'x': width - len(SHIELD_PICKUP) - 1,
                'y': y0,
                'symbol': SHIELD_PICKUP
            })
            last_shield_spawn = now

        # Dust-Modus 100–125 s: nur Mini-Asteroiden "#"
        if 100 <= elapsed < 125:
            if random.random() < 0.2:
                y0 = random.randint(1, height - 2)
                asteroids.append({
                    'x': width - 2,
                    'y': y0,
                    'symbol': "#",
                    'h': 1
                })
        else:
            # Normale Asteroiden (außer 120–150 s)
            if not (120 <= elapsed < 150) and random.random() < 0.2:
                hard = 60 <= elapsed < 90
                if hard:
                    sx = random.choice(ASTEROID_SYMBOLSX)
                    sy = random.choice(ASTEROID_SYMBOLSY)
                    y0 = random.randint(1, height - 3)
                    asteroids.append({
                        'x': width - len(sx) - 1,
                        'y': y0,
                        'symbol_x': sx,
                        'symbol_y': sy,
                        'h': 2
                    })
                else:
                    s  = random.choice(ASTEROID_SYMBOLSX)
                    y0 = random.randint(1, height - 2)
                    asteroids.append({
                        'x': width - len(s) - 1,
                        'y': y0,
                        'symbol': s,
                        'h': 1
                    })

        # ─── Neutronenstern: nur einmal spawnen ───
        if not star_used and elapsed >= 135:
            neutron_spawned = True
            star_used       = True
            star_pos['x']   = width
            star_pos['y']   = 1
            streams.clear()
        # Bewegung des Sterns
        if neutron_spawned:
            star_pos['x'] -= 1
            if star_pos['x'] + len(NEUTRON_STAR[0]) < 0:
                neutron_spawned = False
                streams.clear()

        # Bewegung aller Objekte
        for a in asteroids:    a['x'] -= 1
        for s in shield_items: s['x'] -= 1
        for p in streams:      p['y'] += 1

        # Bereinigen
        asteroids = [
            a for a in asteroids
            if (a['h'] == 1 and a['x'] + len(a['symbol']) - 1 >= 0)
            or (a['h'] == 2 and a['x'] + max(len(a['symbol_x']), len(a['symbol_y'])) - 1 >= 0)
        ]
        shield_items = [
            s for s in shield_items
            if s['x'] + len(s['symbol']) - 1 >= 0
        ]
        streams = [p for p in streams if p['y'] < height]

        # Zeichnen: Asteroiden & Pickups
        for a in asteroids:
            if 0 <= a['x'] < width and 0 <= a['y'] < height:
                if a['h'] == 1:
                    stdscr.addstr(a['y'], a['x'], a['symbol'])
                else:
                    if a['y'] + 1 < height:
                        stdscr.addstr(a['y'], a['x'],     a['symbol_x'])
                        stdscr.addstr(a['y']+1, a['x'], a['symbol_y'])
        for s in shield_items:
            if 0 <= s['x'] < width and 0 <= s['y'] < height:
                stdscr.addstr(s['y'], s['x'], s['symbol'])

        # ─── Neutronenstern zeichnen + Partikel erzeugen ───
        if neutron_spawned:
            for i, row in enumerate(NEUTRON_STAR):
                y = star_pos['y'] + i
                x = star_pos['x']
                if 0 <= y < height and x < width:
                    try:
                        stdscr.addstr(y, x, row)
                    except curses.error:
                        pass
            # Partikel
            for col in range(len(NEUTRON_STAR[0])):
                if random.random() < 0.3:
                    streams.append({
                        'x': star_pos['x'] + col,
                        'y': star_pos['y'] + len(NEUTRON_STAR)
                    })

        # Zeichnen Partikel & Kollisions-Check
        hit = False
        for p in streams:
            text = "///"
            if (0 <= p['y'] < height and 0 <= p['x'] and p['x'] + len(text) <= width):
                try:
                    stdscr.addstr(p['y'], p['x'], text)
                except curses.error:
                    pass
            # Partikel-Kollision mit Raumschiff
            if p['y'] == spaceship_y and spaceship_x <= p['x'] < spaceship_x + len(SPACESHIP):
                if shield_level < 3 and not god_mode:
                    hit = True
                else:
                    shield_level = 0
                    streams.clear()
                break

        if hit:
            stdscr.addstr(height//2, width//2 - 5, "BOOM!")
            stdscr.refresh()
            time.sleep(1)
            return

        # Raumschiff + Schild
        stdscr.addstr(spaceship_y, spaceship_x, SPACESHIP)
        if shield_level > 0:
            bar  = ")" * shield_level
            offx = spaceship_x + len(SPACESHIP) + 1
            if offx + len(bar) <= width:
                stdscr.addstr(spaceship_y, offx, bar)

        # Pickup-Kollision
        for s in shield_items[:]:
            if (s['y'] == spaceship_y and
               not (s['x'] + len(s['symbol']) - 1 < spaceship_x
                    or s['x'] > spaceship_x + len(SPACESHIP) - 1)):
                shield_level = min(3, shield_level + 1)
                shield_items.remove(s)

        # Asteroiden-Kollision
        hit = False
        for a in asteroids:
            rows = ([(a['y'], a['symbol'])] if a['h'] == 1
                    else [(a['y'], a['symbol_x']), (a['y']+1, a['symbol_y'])])
            for ry, sym in rows:
                if ry != spaceship_y: continue
                if not (a['x'] + len(sym) - 1 < spaceship_x
                        or a['x'] > spaceship_x + len(SPACESHIP) - 1):
                    if god_mode:
                        shield_level = 3
                        asteroids.remove(a)
                    elif shield_level > 0:
                        shield_level -= 1
                        asteroids.remove(a)
                    else:
                        hit = True
                    break
            if hit: break

        if hit:
            stdscr.addstr(height//2, width//2 - 5, "BOOM!")
            stdscr.refresh()
            time.sleep(1)
            return

        stdscr.refresh()
        sleep = TARGET_DT - (time.perf_counter() - now)
        if sleep > 0:
            time.sleep(sleep)

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
# 🎉 Placeholder
sleep 1
echo "🎉 Installation completed successfully."
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
