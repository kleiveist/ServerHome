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
├── 📂 server-helb/
│   ├── 📄 help_page.sh
│   └── 📄 help_pageA.sh
├── 📂 server-management/
│   └── 📄 install.sh
├── 📂 utilities/
│   └── 🐍 ping_test.py
└── 📂 webapp-install/
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

### komplettblock
```bash
sudo apt-get update
sudo apt-get install -y curl
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/server-management/install.sh \
  -o /usr/local/bin/install.sh \
&& sudo chmod +x /usr/local/bin/install.sh
```

Führe einen der folgenden Befehle auf deinem Server aus:

### Mit `curl`

```bash
sudo curl -fsSL \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/server-management/install.sh \
  -o /usr/local/bin/install.sh \
&& sudo chmod +x /usr/local/bin/install.sh
```

### Mit `wget`

```bash
sudo wget -qO /usr/local/bin/install.sh \
  https://raw.githubusercontent.com/kleiveist/ServerHome/main/server-management/install.sh \
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

---

## Lizenz

Dieses Projekt steht unter der MIT License. Siehe [LICENSE](LICENSE) für Details.
