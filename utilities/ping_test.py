#!/usr/bin/env python3

import subprocess
import time
from datetime import datetime

# Serverliste
HOSTS = {
# =================IP====================
    "1.1.1.1": "Cloudflare DNS",
    "8.8.8.8": "Google DNS",
#    "88.88.88.88": "ServerVPN",
#    "88.88.88.1": "RouterHome",
#    "88.88.88.4": "Pi-hole DNS",
#    "88.88.88.5": "VPN Server",
#    "88.88.88.88": "cloud-server",
#    "88.88.88.88": "office server",
# =================Domain====================
    "domain123.com": "ServerVPN Domain",
#    "cloud.local": "cloud-domain2",
#    "nextcloud.local": "cloud-domain2",
#    "office.local": "office-domain1",
#    "onlyoffice.local": "office-domain2",
#    "officeserver.local": "office-domain3",
}

def log(msg: str):
    """Gibt msg mit Zeitstempel und 0,5 s Pause aus."""
    ts = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
    print(f"[{ts}] {msg}")
    time.sleep(0.5)

def ping_host(host: str) -> bool:
    try:
        subprocess.run(
            ["ping", "-c", "3", "-W", "2", host],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True,
        )
        return True
    except subprocess.CalledProcessError:
        return False

def main():
    log("==== Ping-Test starten ====")
    failed_hosts = []

    for host, desc in HOSTS.items():
        log(f"Pinge {host} ({desc})…")
        if ping_host(host):
            log(f"{host} ({desc}) ist erreichbar ✅")
        else:
            log(f"{host} ({desc}) ist nicht erreichbar ❌")
            failed_hosts.append(f"{host} ({desc})")

    log("==== Ping-Test abgeschlossen ====")
    if failed_hosts:
        log("==== Fehlgeschlagene Hosts ====")
        for f in failed_hosts:
            log(f)
    else:
        log("Alle Hosts sind erreichbar ✅")

    input("==== [Enter], um das Skript zu beenden ====\n")

if __name__ == "__main__":
    main()