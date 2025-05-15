#!/usr/bin/env python3
import curses
import random
import time

SHIELD_PICKUP       = "=[)(]="   # Symbol für Shield-Pickup
SHIELD_SPAWN_CHANCE = 0.002      # Chance pro Frame
SHIELD_MIN_COOLDOWN = 10.0        # Mindestabstand in Sekunden
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
    star_used         = False    # Stern wurde schon einmal gespawnt
    second_star_used  = False    # zweiter Spawn-Flag

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

        # ─── Asteroiden spawnen ───
        elif elapsed >= 60:
            # ab 1:00 große Asteroiden mit 20 % Chance,
            # ab 2:30 (150 s) 100 % (dauerhaft)
            spawn_chance = 1.0 if elapsed >= 150 else 0.2
            if random.random() < spawn_chance:
                sx = random.choice(ASTEROID_SYMBOLSX)
                sy = random.choice(ASTEROID_SYMBOLSY)
                y0 = random.randint(1, height - 2 - (1 if elapsed >= 60 else 0))
                asteroids.append({
                    'x': width - len(sx) - 1,
                    'y': y0,
                    'symbol_x': sx,
                    'symbol_y': sy,
                    'h': 2
                })

        else:
            # kleiner Asteroiden-Spawn wie gehabt
            if random.random() < 0.2:
                s  = random.choice(ASTEROID_SYMBOLSX)
                y0 = random.randint(1, height - 2)
                asteroids.append({
                    'x': width - len(s) - 1,
                    'y': y0,
                    'symbol': s,
                    'h': 1
                })

        # ─── Neutronenstern spawnen ───
        if not star_used and elapsed >= 135:
            neutron_spawned  = True
            star_used        = True
            star_pos.update({'x': width, 'y': 1})
            streams.clear()
        # zweiter Spawn bei 3:00 (180 s)
        if not second_star_used and elapsed >= 180:
            neutron_spawned    = True
            second_star_used   = True
            star_pos.update({'x': width, 'y': 1})
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
