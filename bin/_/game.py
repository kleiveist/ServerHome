#!/usr/bin/env python3
import curses
import random
import time

ASTEROID_SYMBOLSX = ["####", "##", "#", "###", "#####"]
ASTEROID_SYMBOLSY = ["####", "##", "#", "###", "#####"]
SPACESHIP = "===>"

def main(stdscr):
    curses.curs_set(0)
    stdscr.nodelay(True)
    height, width = stdscr.getmaxyx()
    spaceship_y = height // 2
    spaceship_x = width // 2 - len(SPACESHIP) // 2

    asteroids = []
    TARGET_FPS = 60
    TARGET_DT = 1.0 / TARGET_FPS
    prev_time = time.perf_counter()
    game_start = prev_time

    while True:
        now = time.perf_counter()
        dt = now - prev_time
        prev_time = now
        elapsed = now - game_start

        stdscr.clear()
        # Spielzeit-Timer oben rechts
        mins = int(elapsed // 60)
        secs = int(elapsed % 60)
        timer = f"{mins:02d}:{secs:02d}"
        stdscr.addstr(0, width - len(timer) - 1, timer)

        # Eingabe
        key = stdscr.getch()
        if key == curses.KEY_UP and spaceship_y > 0:
            spaceship_y -= 1
        elif key == curses.KEY_DOWN and spaceship_y < height - 1:
            spaceship_y += 1
        elif key == ord('q'):
            break

        # Schwierigkeitsstufe
        hard = 60 <= elapsed < 90

        # Neue Asteroiden
        if random.random() < 0.2:
            if hard:
                sx = random.choice(ASTEROID_SYMBOLSX)
                sy = random.choice(ASTEROID_SYMBOLSY)
                y0 = random.randint(1, height - 2)
                asteroids.append({
                    'x': width - len(sx) - 1,
                    'y': y0,
                    'symbol_x': sx,
                    'symbol_y': sy,
                    'h': 2
                })
            else:
                s = random.choice(ASTEROID_SYMBOLSX)
                y0 = random.randint(1, height - 1)
                asteroids.append({
                    'x': width - len(s) - 1,
                    'y': y0,
                    'symbol': s,
                    'h': 1
                })

        # Bewegung
        for a in asteroids:
            a['x'] -= 1

        # Entfernen, wenn aus dem Bild
        def alive(a):
            if a['h'] == 1:
                return a['x'] + len(a['symbol']) - 1 >= 0
            return a['x'] + max(len(a['symbol_x']), len(a['symbol_y'])) - 1 >= 0
        asteroids = [a for a in asteroids if alive(a)]

        # Zeichnen
        for a in asteroids:
            if 0 <= a['x'] < width:
                if a['h'] == 1:
                    stdscr.addstr(a['y'], a['x'], a['symbol'])
                else:
                    stdscr.addstr(a['y'],     a['x'], a['symbol_x'])
                    stdscr.addstr(a['y'] + 1, a['x'], a['symbol_y'])
        stdscr.addstr(spaceship_y, spaceship_x, SPACESHIP)

        # Kollision
        collision = False
        for a in asteroids:
            rows = ([(a['y'], a['symbol'])] if a['h'] == 1
                    else [(a['y'], a['symbol_x']), (a['y']+1, a['symbol_y'])])
            for ry, sym in rows:
                if ry != spaceship_y:
                    continue
                if not (a['x'] + len(sym) - 1 < spaceship_x
                        or a['x'] > spaceship_x + len(SPACESHIP) - 1):
                    collision = True
                    break
            if collision:
                break

        if collision:
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
