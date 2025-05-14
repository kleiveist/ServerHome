#!/usr/bin/env python3
import curses
import random
import time

SHIELD_PICKUP       = "=[)(]="   # Symbol für Shield-Pickup
SHIELD_SPAWN_CHANCE = 0.002       # Chance pro Frame
SHIELD_MIN_COOLDOWN = 10.0        # Mindestabstand in Sekunden
ASTEROID_SYMBOLSX   = ["####", "##", "#", "###", "#####"]
ASTEROID_SYMBOLSY   = ["####", "##", "#", "###", "#####"]
SPACESHIP           = "===>"

def main(stdscr):
    curses.curs_set(0)
    stdscr.nodelay(True)
    height, width = stdscr.getmaxyx()
    spaceship_y = height // 2
    spaceship_x = width // 2 - len(SPACESHIP) // 2

    asteroids         = []
    shield_items      = []
    shield_level      = 0
    last_shield_spawn = time.perf_counter() - SHIELD_MIN_COOLDOWN

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
        # Spielzeit-Timer oben rechts
        mins = int(elapsed // 60)
        secs = int(elapsed % 60)
        stdscr.addstr(0, width - 5, f"{mins:02d}:{secs:02d}")

        # Eingabe
        key = stdscr.getch()
        if   key == curses.KEY_UP   and spaceship_y > 1:
            spaceship_y -= 1
        elif key == curses.KEY_DOWN and spaceship_y < height - 2:
            spaceship_y += 1
        elif key == ord('q'):
            break

        # Schild-Pickup spawnen
        if now - last_shield_spawn >= SHIELD_MIN_COOLDOWN and random.random() < SHIELD_SPAWN_CHANCE:
            y0 = random.randint(1, height - 2)
            shield_items.append({
                'x': width - len(SHIELD_PICKUP) - 1,
                'y': y0,
                'symbol': SHIELD_PICKUP
            })
            last_shield_spawn = now

        # Neue Asteroiden
        hard = 60 <= elapsed < 90
        if random.random() < 0.2:
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

        # Bewegung
        for a in asteroids:    a['x'] -= 1
        for s in shield_items: s['x'] -= 1

        # Entfernen außerhalb
        asteroids = [
            a for a in asteroids
            if (a['h'] == 1 and a['x'] + len(a['symbol']) - 1 >= 0)
            or (a['h'] == 2 and a['x'] + max(len(a['symbol_x']), len(a['symbol_y'])) - 1 >= 0)
        ]
        shield_items = [
            s for s in shield_items
            if s['x'] + len(s['symbol']) - 1 >= 0
        ]

        # Zeichnen
        for a in asteroids:
            # X- und Y-Bereich prüfen
            if 0 <= a['x'] < width and 0 <= a['y'] < height:
                if a['h'] == 1:
                    stdscr.addstr(a['y'], a['x'], a['symbol'])
                else:
                    # Höhen-Zwei-Asteroid: zweite Zeile auch prüfen
                    if a['y'] + 1 < height:
                        stdscr.addstr(a['y'],     a['x'], a['symbol_x'])
                        stdscr.addstr(a['y'] + 1, a['x'], a['symbol_y'])

        for s in shield_items:
            # Shield-Pickup nur zeichnen, wenn in Sichtbereich
            if 0 <= s['x'] < width and 0 <= s['y'] < height:
                stdscr.addstr(s['y'], s['x'], s['symbol'])

        # Raumschiff
        if 0 <= spaceship_x < width and 0 <= spaceship_y < height:
            stdscr.addstr(spaceship_y, spaceship_x, SPACESHIP)

        # Schild-Anzeige neben der Rakete
        if shield_level > 0:
            bar  = ")" * shield_level
            offx = spaceship_x + len(SPACESHIP) + 1
            # Platz prüfen, damit bar komplett reinpasst
            if 0 <= offx < width and offx + len(bar) <= width:
                stdscr.addstr(spaceship_y, offx, bar)

        # Pickup-Kollision
        for s in shield_items[:]:
            if (s['y'] == spaceship_y
               and not (s['x'] + len(s['symbol']) - 1 < spaceship_x
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
                    if shield_level > 0:
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
