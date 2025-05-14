# ServerHome

## Inhaltsverzeichnis

1. [Einführung](#einführung)
2. [Verzeichnisstruktur](#verzeichnisstruktur)
3. [Installation](#installation)
   - [Mit `curl`](#mit-curl)
   - [Mit `wget`](#mit-wget)
4. [Verwendung](#verwendung)
5. [Lizenz](#lizenz)

---

## Einführung

Dieses Repository enthält eine Sammlung von Server-Skripten und Hilfsprogrammen zur Automatisierung und Vereinfachung häufiger Verwaltungsaufgaben.

---

## Verzeichnisstruktur

```text
📂 ServerHome
├── 📝 InContent.txt
├── 📝 README.md
├── 📝 READMEDE.md
├── 📂 bin/
│   ├── 📄 cat.sh
│   ├── 📄 docker.sh
│   ├── 🐍 hosts.py
│   ├── 🐍 ping.py
│   └── 📄 urls.sh
├── 📂 inst/
│   └── 📄 install.sh
├── 📂 server-helb/
│   ├── 📄 help.sh
│   └── 📄 skripts.sh
└── 📂 server-management/
    ├── 📄 systemv.sh
    └── 📄 upgrade.sh
```

- **InContent.txt**
  Zusätzliche Dokumentation und Notizen.
- **README.md**
  Dieses Dokument.
- **server-helb/**
  Shell-Skripte für Hilfeseiten.
- **server-management/**
  Installationsskript `install.sh` für alle Management-Tools.
- **utilities/**
  Python-Skript `ping_test.py` für Ping-Tests.
- **webapp-install/**
  Installationsskripte für Webanwendungen.

---

## Installation
---
### komplettblock
```bash
sudo apt-get update
sudo apt-get install -y curl
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/inst/install.sh \
  -o /usr/local/bin/install.sh \
&& sudo chmod +x /usr/local/bin/install.sh
```
Führen Sie den folgenden Block aus, um das System zu aktualisieren, curl zu installieren, das Installationsskript herunterzuladen und ausführbar zu machen:
---
Führe einen der folgenden Befehle auf deinem Server aus:

### Mit `curl`

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/inst/install.sh \
  -o /usr/local/bin/install.sh \
&& sudo chmod +x /usr/local/bin/install.sh
```

### Mit `wget`

```bash
sudo wget -qO /usr/local/bin/install.sh \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/inst/install.sh \
&& sudo chmod +x /usr/local/bin/install.sh
```

---

## Verwendung

1. Installationsskript ausführen:

   ```bash
   sudo install.sh
   ```

2. Verfügbare Skripte auflisten:

   ```bash
   ls /usr/local/bin
   ```

3. Beispiel: Ping-Test (Python)

   ```bash
   ping_test.py
   ```
4. Hilfe seite Skripte:

   ```bash
   help_page.sh
   ```
---

## Lizenz

Dieses Projekt steht unter der MIT License. Siehe [LICENSE](LICENSE) für Details.
---

### Using curl help_page.sh

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/server-helb/help_page.sh \
  -o /usr/local/bin/help_page.sh \
&& sudo chmod +x /usr/local/bin/help_page.sh
```
---
