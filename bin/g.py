#!/usr/bin/env python3
import curses
import random
import time

ASTEROID_SYMBOLS = ["####", "/()", "<*>", "++", "><"]
SPACESHIP = "===>"

def main(stdscr):
    curses.curs_set(0)  # Cursor ausblenden
    stdscr.nodelay(True)
    stdscr.timeout(1)

    height, width = stdscr.getmaxyx()
    spaceship_y = height // 2
    spaceship_x = width - len(SPACESHIP) - 1

    asteroids = []

    while True:
        stdscr.clear()

        # Eingabe verarbeiten
        key = stdscr.getch()
        if key == curses.KEY_UP and spaceship_y > 0:
            spaceship_y -= 1
        elif key == curses.KEY_DOWN and spaceship_y < height - 1:
            spaceship_y += 1
        elif key == ord('q'):
            break

        # Neue Asteroiden zufällig erzeugen
        if random.random() < 0.2:
            symbol = random.choice(ASTEROID_SYMBOLS)
            y = random.randint(0, height - 1)
            asteroids.append({'x': width - len(symbol) - 1, 'y': y, 'symbol': symbol})

        # Asteroiden bewegen
        for asteroid in asteroids:
            asteroid['x'] -= 1

        # Asteroiden zeichnen
        for asteroid in asteroids:
            if 0 <= asteroid['x'] < width:
                stdscr.addstr(asteroid['y'], asteroid['x'], asteroid['symbol'])

        # Kollision prüfen
        for asteroid in asteroids:
            if asteroid['x'] <= spaceship_x and asteroid['y'] == spaceship_y:
                stdscr.addstr(height//2, width//2 - 5, "BOOM!")
                stdscr.refresh()
                time.sleep(1)
                return

        # Raumschiff zeichnen
        stdscr.addstr(spaceship_y, spaceship_x, SPACESHIP)

        stdscr.refresh()
        time.sleep(0.1)

curses.wrapper(main)