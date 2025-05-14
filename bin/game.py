#!/usr/bin/env python3
import curses
import random
import time

ASTEROID_SYMBOLS = ["####", "/()", "<*>", "++", "><"]
SPACESHIP = "===>"

def main(stdscr):
    curses.curs_set(0)
    stdscr.nodelay(True)      # Non-Blocking-Input
    height, width = stdscr.getmaxyx()
    spaceship_y = height // 2
    spaceship_x = width // 2 - len(SPACESHIP) // 2

    asteroids = []
    TARGET_FPS = 60
    TARGET_DT = 1.0 / TARGET_FPS
    prev_time = time.perf_counter()

    while True:
        now = time.perf_counter()
        dt = now - prev_time
        prev_time = now

        stdscr.clear()

        # Eingabe
        key = stdscr.getch()
        if key == curses.KEY_UP and spaceship_y > 0:
            spaceship_y -= 1
        elif key == curses.KEY_DOWN and spaceship_y < height - 1:
            spaceship_y += 1
        elif key == ord('q'):
            break

        # Neue Asteroiden
        if random.random() < 0.2:
            symbol = random.choice(ASTEROID_SYMBOLS)
            y = random.randint(0, height - 1)
            asteroids.append({'x': width - len(symbol) - 1, 'y': y, 'symbol': symbol})

        # Bewegung (optional mit dt skalieren)
        for a in asteroids:
            a['x'] -= 1  # Würdest du Geschwindigkeit variabel machen, dann a['x'] -= speed * dt

        # Zeichnen
        for a in asteroids:
            if 0 <= a['x'] < width:
                stdscr.addstr(a['y'], a['x'], a['symbol'])
        stdscr.addstr(spaceship_y, spaceship_x, SPACESHIP)

        # Kollision
        if any(a['x'] <= spaceship_x and a['y'] == spaceship_y for a in asteroids):
            stdscr.addstr(height//2, width//2 - 5, "BOOM!")
            stdscr.refresh()
            time.sleep(1)
            return

        stdscr.refresh()

        # Framerate-Kontrolle
        elapsed = time.perf_counter() - now
        to_sleep = TARGET_DT - elapsed
        if to_sleep > 0:
            time.sleep(to_sleep)
